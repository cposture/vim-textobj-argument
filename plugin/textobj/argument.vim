if exists("g:loaded_textobj_argument") || &cp || v:version < 700 
    finish 
endif

let g:loaded_textobj_argument = 1

if !exists('g:argument_separator')
    let g:argument_separator = ','
endif

if !exists('g:argument_left_bracket')
    let g:argument_left_bracket = '[[(]'
endif

if !exists('g:argument_right_bracket')
    let g:argument_right_bracket = '[])]'
endif

call textobj#user#plugin('argument', {
            \      '-': {
            \        'select-a': 'aa', 'select-a-function': 'textobj#argument#select_a',
            \        'select-i': 'ia', 'select-i-function': 'textobj#argument#select_i',
            \        'move-n': ']a', 'move-n-function': 'textobj#argument#move_n',
            \        'move-N': ']A', 'move-N-function': 'textobj#argument#move_N',
            \        'move-p': '[a', 'move-p-function': 'textobj#argument#move_p',
            \        'move-P': '[A', 'move-P-function': 'textobj#argument#move_P',
            \        'sfile': expand('<sfile>:p'),
            \      },
            \    })
