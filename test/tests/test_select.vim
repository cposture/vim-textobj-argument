function SetUp()
    let init_script = g:test_path . '/../support/test_init_plugin.vim'
    execute 'source ' . init_script
endfunction

let s:cases = [
            "\ 两边都是分隔符
            \ ["i(a, b, c)\<Esc>0fbdaa", "(a, c)"],
            \ ["i(a, b , c)\<Esc>0fbdaa", "(a, c)"],
            \ ["i(a, /*1*/b/*2*/, /*3*/c)\<Esc>0fbdaa", "(a, /*3*/c)"],
            \ ["i(a, /*1*/b/*2*/ , /*3*/c)\<Esc>0fbdaa", "(a, /*3*/c)"],
            \ ["i(a, /*1*/b/*2*/ , /*3*/c, d)\<Esc>0fbd2aa", "(a, d)"],
            \ ["i(a, b, c)\<Esc>0fbdia", "(a, , c)"],
            \ ["i(a, b , c)\<Esc>0fbdia", "(a,  , c)"],
            "\ 左边为分割符，右边为括号
            \ ["i(a, b, c)\<Esc>0fcdaa", "(a, b)"],
            \ ["i(a, b, c )\<Esc>0fcdaa", "(a, b)"],
            \ ["i(a, /*1*/b/*2*/, /*3*/c)\<Esc>0fcdaa", "(a, /*1*/b/*2*/)"],
            \ ["i(a, /*1*/b/*2*/ , /*3*/c)\<Esc>0fcdaa", "(a, /*1*/b/*2*/ )"],
            \ ["i(a, /*1*/b/*2*/ , /*3*/c)\<Esc>0fbd2aa", "(a)"],
            \ ["i(a, b, c )\<Esc>0fcdia", "(a, b,  )"],
            \ ["i(a, b, c)\<Esc>0fcdia", "(a, b, )"],
            \ ["i(a, b, c)\<Esc>0fbd2ia", "(a, )"],
            "\ 左边为括号，右边为分隔符
            \ ["i(a, b, c)\<Esc>0daa", "(b, c)"],
            \ ["i( a, b, c)\<Esc>0daa", "(b, c)"], 
            \ ["i (a, b, c)\<Esc>0daa", " (b, c)"],
            \ ["i(a, /*1*/b/*2*/, /*3*/c)\<Esc>0d2aa", "(/*3*/c)"],
            \ ["i(a, b , c)\<Esc>0d2ia", "( , c)"],
            \ ["i(/*1*/a/*2*/, /*3*/b, c)\<Esc>0daa", "(/*3*/b, c)"],
            \ ["i( /*1*/a/*2*/, /*3*/b, c)\<Esc>0daa", "(/*3*/b, c)"], 
            \ ["i (/*1*/a/*2*/, /*3*/b, c)\<Esc>0daa", " (/*3*/b, c)"],
            \ ["i(a, b, c)\<Esc>0dia", "(, b, c)"],
            \ ["i( a, b, c)\<Esc>0dia", "( , b, c)"], 
            \ ["i (a, b, c)\<Esc>0dia", " (, b, c)"],
            "\ 两边为括号
            \ ["i(a)\<Esc>0daa", "()"],
            \ ["i( a )\<Esc>0daa", "()"], 
            \ ["i( /*1*/a/*2*/ )\<Esc>0daa", "()"], 
            \ ["i( /*1*/a/*2*/, /*1*/a/*2*/)\<Esc>0d2aa", "()"], 
            \ ["i(a)\<Esc>0dia", "()"],
            \ ["i( a )\<Esc>0dia", "(  )"], 
            \ ["i( a, b )\<Esc>0d2ia", "(  )"], 
            \ ["i (a)\<Esc>0dia", " ()"],
            \ ]

function Test_Select()
    for idx in range(len(s:cases))
        let input = s:cases[idx][0]
        let expect = s:cases[idx][1]

        set ft=go
        execute "normal " . input
        call assert_equal(expect, getline(1), "index " . idx . " input '" . input . "' ")
        %bwipe!
    endfor
endfunction
