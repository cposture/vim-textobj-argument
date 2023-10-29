function SetUp()
    let init_script = g:test_path . '/../support/test_init_plugin.vim'
    execute 'source ' . init_script
endfunction

let s:cases = [
            "\ 两边都是分隔符
            \ ["i(a, b, c)\<Esc>0fb", "]a", 8],
            \ ["i(a, b, c)\<Esc>0fb", "]A", 8],
            \ ["i(a, b , c)\<Esc>0fb", "]a", 9],
            \ ["i(a, b , c)\<Esc>0fb", "]A", 9],
            \ ["i(a, b, c)\<Esc>0fb", "[a", 2],
            \ ["i(a, b, c)\<Esc>0fb", "[A", 2],
            \ ["i(a, /*1*/b/*2*/, /*3*/c)\<Esc>0fb", "]a", 23],
            \ ["i(a, /*1*/b/*2*/, /*3*/c)\<Esc>0fb", "]A", 23],
            \ ["i(a, /*1*/b/*2*/, /*3*/c )\<Esc>0fb", "]a", 23],
            \ ["i(a, /*1*/b/*2*/, /*3*/c )\<Esc>0fb", "]A", 23],
            \ ["i(a, /*1*/b/*2*/, /*3*/c )\<Esc>0fb", "[a", 2],
            \ ["i(a, /*1*/b/*2*/, /*3*/c )\<Esc>0fb", "[A", 2],
            \ ["i(a, /*1*/b/*2*/ , /*3*/c, d)\<Esc>0fb", "2]a", 27],
            \ ["i(a, /*1*/b/*2*/ , /*3*/c, d)\<Esc>0fb", "2[a", 2],
            "\ 左边为分割符，右边为括号
            \ ["i(a, b, c)\<Esc>0fc", "]a", 8],
            \ ["i(a, b, c)\<Esc>0fc", "]A", 8],
            \ ["i(a, b, c )\<Esc>0fc", "]a", 8],
            \ ["i(a, b, c )\<Esc>0fc", "]A", 8],
            \ ["i(a, b, c)\<Esc>0fc", "[a", 5],
            \ ["i(a, b, c)\<Esc>0fc", "[A", 2],
            \ ["i(a, /*1*/b/*2*/, /*3*/c)\<Esc>0fc", "]a", 23],
            \ ["i(a, /*1*/b/*2*/, /*3*/c)\<Esc>0fc", "]A", 23],
            \ ["i(a, /*1*/b/*2*/, /*3*/c)\<Esc>0fc", "[A", 2],
            \ ["i(a, /*1*/b/*2*/, /*3*/c )\<Esc>0fc", "]a", 23],
            \ ["i(a, /*1*/b/*2*/, /*3*/c )\<Esc>0fc", "]A", 23],
            \ ["i(a, /*1*/b/*2*/, /*3*/c, d)\<Esc>0fb", "2]a", 26],
            \ ["i(a, /*1*/b/*2*/, /*3*/c)\<Esc>0fc", "2[a", 2],
            "\ 左边为括号，右边为分隔符
            \ ["i(a, b, c)\<Esc>0", "]a", 2],
            \ ["i(a, b, c)\<Esc>0", "]A", 8],
            \ ["i(a, b, c)\<Esc>0", "[A", 1],
            \ ["i( a, b, c)\<Esc>0", "]a", 3], 
            \ ["i( a, b, c)\<Esc>0", "]A", 9], 
            \ ["i( a, b, c)\<Esc>0", "[A", 1], 
            \ ["i (a, b, c)\<Esc>0", "]a", 3],
            \ ["i (a, b, c)\<Esc>0", "]A", 9],
            \ ["i (a, b, c)\<Esc>0", "[A", 1],
            \ ["i(a, b, c)\<Esc>0fa", "]a", 5],
            \ ["i(a, b, c)\<Esc>0fa", "]A", 8],
            \ ["i(a, b, c)\<Esc>0fa", "[A", 2],
            \ ["i( a, b, c)\<Esc>0f ", "]a", 6], 
            \ ["i( a, b, c)\<Esc>0f ", "]A", 9], 
            \ ["i(a, b, c)\<Esc>0fa", "[a", 2],
            \ ["i( a, b, c)\<Esc>0f ", "2]a", 9], 
            \ ["i(a, /*1*/b/*2*/, /*3*/c)\<Esc>0", "2]a", 10],
            \ ["i(a, b , c)\<Esc>0", "2]a", 5],
            \ ["i(a, b , c)\<Esc>0fa", "2]a", 9],
            \ ["i(/*1*/a/*2*/, /*3*/b, c)\<Esc>0", "]a", 7],
            \ ["i(/*1*/a/*2*/, /*3*/b, c)\<Esc>0", "]A", 23],
            \ ["i( /*1*/a/*2*/, /*3*/b, c)\<Esc>0", "]a", 8], 
            \ ["i( /*1*/a/*2*/, /*3*/b, c)\<Esc>0", "]A", 24], 
            \ ["i( /*1*/a/*2*/, /*3*/b, c)\<Esc>0", "2]a", 21], 
            "\ 两边为括号
            \ ["i(a)\<Esc>0", "]a", 2],
            \ ["i(a)\<Esc>0", "]A", 2],
            \ ["i(a)\<Esc>0f)", "[a", 2],
            \ ["i(a)\<Esc>0f)", "[A", 2],
            \ ["i(a)\<Esc>0fa", "]a", 2],
            \ ["i(a)\<Esc>0fa", "]A", 2],
            \ ["i(a)\<Esc>0fa", "[a", 2],
            \ ["i(a)\<Esc>0fa", "[A", 2],
            \ ["i(a)\<Esc>0f)", "]a", 3],
            \ ["i(a)\<Esc>0f)", "]A", 3],
            \ ["i(a)\<Esc>0f)", "[a", 2],
            \ ["i(a)\<Esc>0f)", "[A", 2],
            \ ["i(a)\<Esc>0fa", "[a", 2],
            \ ["i( /*1*/a/*2*/ )\<Esc>0f/", "]a", 8], 
            \ ["i( /*1*/a/*2*/ )\<Esc>0f/", "]A", 8], 
            \ ["i( /*1*/a/*2*/ )\<Esc>0f/", "[a", 8], 
            \ ["i( /*1*/a/*2*/ )\<Esc>0f/", "[A", 8], 
            \ ["i( /*1*/a/*2*/, /*1*/a/*2*/)\<Esc>0", "2]a", 21], 
            \ ["i( /*1*/a/*2*/, /*1*/a/*2*/)\<Esc>0f)", "2[a", 8], 
            \ ]

function Test_Move()
    for idx in range(len(s:cases))
        let input = s:cases[idx][0]
        let cmd = s:cases[idx][1]
        let expect = s:cases[idx][2]

        set ft=go
        execute "normal " . input
        execute "normal " . cmd
        call assert_equal(expect, getpos('.')[2],  "index " . idx . " input '" . input . "' cmd '" . cmd . "'")
        %bwipe!
    endfor
endfunction
