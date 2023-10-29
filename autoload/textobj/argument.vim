function! textobj#argument#select_a()
    return s:Select(g:argument_separator, 1, v:count1, visualmode())
endfunction

function! textobj#argument#select_i()
    return s:Select(g:argument_separator, 0, v:count1, visualmode())
endfunction

function! textobj#argument#select_I()
    return s:Select(g:argument_separator, 0, v:count1, visualmode())
endfunction

function! textobj#argument#move_n()
    return s:Move(g:argument_separator, 1, v:count1, 0, visualmode())
endfunction

function! textobj#argument#move_N()
    return s:Move(g:argument_separator, 1, v:count1, 1, visualmode())
endfunction

function! textobj#argument#move_p()
    return s:Move(g:argument_separator, 0, v:count1, 0, visualmode())
endfunction

function! textobj#argument#move_P()
    return s:Move(g:argument_separator, 0, v:count1, 1, visualmode())
endfunction

"
" 移动列表中的参数
"
" 列表使用括号括起来 (i.e. '()', '[]', or '{}').
" 参数使用 a:sep 分隔(e.g. ',')
"
" 如果 a:direction 大于 0 则向右移动，否则向左移动
" 如果设置了 a:to_end，则支持一键移动到最左端最右端的参数 
"
function! s:Move(sep, direction, times, to_end, ...)
    let lbracket = g:argument_left_bracket
    let rbracket = g:argument_right_bracket
    let save_unnamed = @"
    let save_ic = &ic
    let &ic = 0

    " 记录起始光标字符，用于判断是不是括号
    " 如果是括号，则 last 的跳数需要减一，用于跳到括号附近的参数
    exe "keepjumps normal! vy"
    let oristart = @"

    try
        " 向后搜索且到不使用文件环绕，
        " 如果 direction 为 true 多了个 flag c，差别：
        " 1. 如果停留在{start}上，那当前光标会作为结果，没有flag会返回0
        " 2. 如果停留在 {end} 上，那会被认为是嵌套组，返回 0，没有flag会跳到分割符
        " 3. 如果停留在分割符上，那当前光标会作为结果，没有flag会返回上个分割符
        " 4. 如果停留在分割符右边，那上个分割会作为结果，没有flag也一样
        "
        " 总结意图：向后搜索匹配的分割符或左括号
        " 正向搜索且起始位置位于 {start} 需要接受光标下的左括号，所以需要flag c
        let flags = a:direction ? 'bcW' : 'bW'
        if searchpair(lbracket, a:sep, rbracket, flags,
                    \ 's:IsCursorOnStringOrComment()') <= 0
            " 不在列表内，则向前搜索是不是右左括号
            " 用于列表外能直接跳转到参数列表内
            let flags = a:direction ? 'W' : 'bW'
            if search(lbracket, flags, line('.')) <= 0
                return
            endif
            " 重新定位起始光标字符
            exe "keepjumps normal! vy"
            let oristart = @"
        endif
        " 经过 searchpair 此时光标会移动到左括号或分割符上
        " 获取当前光标字符
        exe "keepjumps normal! yl"
        let first = @"

        " times 支持多跳
        let times = a:times
        " 如果起始位置是括号，为了能指向括号的下个参数，跳数减一
        if (a:direction && oristart =~ lbracket) || (!a:direction && oristart =~ rbracket)
            let times = times - 1
        endif
        " 根据 direction 确定是向前确定还是向后确定右边界
        " 搜索分割符或括号
        " 因为没有 flag c，所以即使当前光标为分割符也会跳过当前的
        let flags = a:direction ? 'W' : 'bW'
        " 如果是到最端，则不受 times 限制
        while (times > 0 || a:to_end) && 
                    \ (@" =~ a:sep || (a:direction && @" =~ lbracket) || (!a:direction && @" =~ rbracket)) 
                    \ && searchpair(lbracket, a:sep, rbracket, flags, 's:IsCursorOnStringOrComment()') > 0
            let times -= 1
            exe "keepjumps normal! yl"
        endwhile
        " 记录最后一跳后，当前光标下的字符，可能是左右括号或分割符
        let last = @"

        if a:sep =~ first && a:sep =~ last
            " 左右两边为分割符
            " (a, b /**/, c /* */, d
            "             ·       
            " 正向搜索
            " (a, b /**/, c /* */, d
            "           ↑        ↑ ·
            " 反向搜索
            " (a, b /**/, c /* */, d
            "   ↑ ·     ↑        
            " 将右边界向右移动到下个参数，忽略注释
            call searchpair('\%0l', '', '\S', 'W', 's:IsCursorOnComment()')
        elseif a:sep =~ first
            " 左边为分割符，右边为括号
            " a, b /**/, c , d/* */)
            "            ·         
            if a:direction
                " 正向搜索
                " a, b /**/, c , d/* */)
                "          ↑     ·     ↑
                " 向后搜索匹配的分割符或左括号
                call searchpair(lbracket, a:sep, rbracket, 'bW', 's:IsCursorOnStringOrComment()')
                " 将右边界向右移动到下个参数，忽略注释
                call searchpair('\%0l', '', '\S', 'W', 's:IsCursorOnComment()')
            else
                " 反向搜索
                " (a, b /**/, c , d/* */)
                " ↑·        ↑ ·         
                " 将右边界向右移动到下个参数，忽略注释
                call searchpair('\%0l', '', '\S', 'W', 's:IsCursorOnComment()')
            endif
        elseif a:sep =~ last
            " 左边为括号，右边为分割符
            " 正向搜索
            " (a, b , c /**/, d)
            " ↑·            ↑ 
            " (a, b , c /**/, d)
            " ↑·            ↑ ·
            " 反向搜索
            " 左边为括号，右边肯定也是括号
            " 将右边界向右移动到下个参数，忽略注释
            call searchpair('\%0l', '', '\S', 'W', 's:IsCursorOnComment()')
        else
            " 两边为括号
            if lbracket =~ first && lbracket =~ last
                " (a, b , c , d)
                " ↑           
                " ↑           
                " ·           
                " (a, b , c , d)
                " ↑           
                " ↑           
                " ··           
                " 将右边界向右移动到下个参数，忽略注释
                call searchpair('\%0l', '', '\S', 'W', 's:IsCursorOnComment()')
            elseif rbracket =~ first && rbracket =~ last
                " (a, b , c , d)
                "              ↑           
                "              ↑           
                "              ·           
                " (a, b , c , d)
                "              ↑           
                "              ↑           
                "             ··           
                call searchpair(lbracket, a:sep, rbracket, 'bW', 's:IsCursorOnStringOrComment()')
                " 将右边界向右移动到下个参数，忽略注释
                call searchpair('\%0l', '', '\S', 'W', 's:IsCursorOnComment()')
            elseif a:direction
                " (a, b , c , d)
                " ↑·           ↑
                " (a, b , c , d)
                " ↑·          ·↑
                call searchpair(lbracket, a:sep, rbracket, 'bW', 's:IsCursorOnStringOrComment()')
                " 将右边界向右移动到下个参数，忽略注释
                call searchpair('\%0l', '', '\S', 'W', 's:IsCursorOnComment()')
            else
                " (a, b , c , d)
                " ↑           ·↑
                " (a, b , c , d)
                " ↑·          ·↑
                " 将右边界向右移动到下个参数，忽略注释
                call searchpair('\%0l', '', '\S', 'W', 's:IsCursorOnComment()')
            endif
        endif

        return ['v', getpos('.'), 0]

    finally
        let @" = save_unnamed
        let &ic = save_ic
    endtry
endfunction

"
" 选择列表中的参数
"
" 列表使用括号括起来 (i.e. '()', '[]', or '{}').
" 参数使用 a:sep 分隔(e.g. ',')
"
" 如果设置了 a:outer，则不止选择参数本身，还包括注释和分隔符
"
function! s:Select(sep, outer, times, ...)
    let lbracket = g:argument_left_bracket
    let rbracket = g:argument_right_bracket
    let save_mb = getpos("'b")
    let save_me = getpos("'e")
    let save_unnamed = @"
    let save_ic = &ic
    let &ic = 0
    let save_ww = &ww
    let &ww = '<,>'

    try
        if searchpair(lbracket, a:sep, rbracket, 'bcW',
                    \ 's:IsCursorOnStringOrComment()') <= 0
            if search(lbracket, 'W', line('.')) <= 0
                return
            endif
        endif

        exe "keepjumps normal! ylmb"
        let first = @"

        let times = a:times
        while times > 0 && (@" =~ a:sep || @" =~ lbracket) && searchpair(lbracket, a:sep, rbracket,
                    \ 'W', 's:IsCursorOnStringOrComment()') > 0
            let times -= 1
            exe "keepjumps normal! yl"
        endwhile

        let last = @"

        " 只选择参数本身，忽略注释
        if !a:outer
            call search('\S', 'bW', '', '', 's:IsCursorOnComment()')
            exe "keepjumps normal! me`b"
            call search('\S', 'W', '', '',  's:IsCursorOnComment()')
        else
            " 在 outer 下，左右两边都是分割符的情况
            if a:sep =~ first && a:sep =~ last
                exe "keepjumps normal! \<Left>"
                exe "keepjumps normal! me`b"
            elseif a:sep =~ first
                " 左边为分割符，右边为括号
                exe "keepjumps normal! \<Left>"
                exe "keepjumps normal! me`b"
            elseif a:sep =~ last
                " 左边为括号，右边为分割符
                "
                call search('\S', 'W')
                exe "keepjumps normal! \<Left>"
                exe "keepjumps normal! me`b"
                exe "keepjumps normal! \<Right>"
            else
                " 两边为括号
                exe "keepjumps normal! me`b"
                exe "keepjumps normal! \<Right>"
                exe "keepjumps normal! mb`e"
                exe "keepjumps normal! \<Left>"
                exe "keepjumps normal! me`b"
            endif
        endif

        let head = getpos('.')

        exe "keepjumps normal! `e"

        " selection options 的值为 exclusive/inclusive
        " exclusive 模式意味着选择区的最后一个字符不包括在操作范围内，非闭区间
        " 所以用 <Space> 将右边界向右移动一个字符
        " 请注意，如果光标位于行尾，则 <space> 可以转到下一行，而 'l' 则不能
        if &sel == "exclusive"
            exe "keepjumps normal! \<Right>"
        endif

        exe "keepjumps normal! \<Esc>"

        return ['v', head, getpos('.')]

    finally
        call setpos("'b", save_mb)
        call setpos("'e", save_me)
        let @" = save_unnamed
        let &ic = save_ic
        let &ww = save_ww
    endtry
endfunction

" 判断当前光标下的文字是不是注释
function! s:IsCursorOnComment()
    " synID 返回位置文本的语法 ID，再用 syncIDattr 根据语法 ID 获取语法信息
    " 最后根据 name 是否包含 comment 关键词判断是否为注释
    " 这种方式有点取巧，这个取决于是否有语法信息以及定义的语法信息名字是否为
    " comment
    return synIDattr(synID(line("."), col("."), 0), "name") =~? "comment"
endfunction

function! s:IsCursorOnStringOrComment()
    let syn = synIDattr(synID(line("."), col("."), 0), "name")
    return syn =~? "string" || syn =~? "comment"
endfunction
