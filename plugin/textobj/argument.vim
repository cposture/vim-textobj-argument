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

if !exists('g:argument_mapping_select_around')
    let g:argument_mapping_select_around = 'aa'
endif

if !exists('g:argument_mapping_select_inside')
    let g:argument_mapping_select_inside = 'ia'
endif

if !exists('g:argument_mapping_move_previous')
    let g:argument_mapping_move_previous = '[a'
endif

if !exists('g:argument_mapping_move_start')
    let g:argument_mapping_move_start = '[A'
endif

if !exists('g:argument_mapping_move_next')
    let g:argument_mapping_move_next = ']a'
endif

if !exists('g:argument_mapping_move_end')
    let g:argument_mapping_move_end = ']A'
endif


call textobj#user#plugin('argument', {
            \      '-': {
            \        'select-a': g:argument_mapping_select_around, 'select-a-function': 'textobj#argument#select_a',
            \        'select-i': g:argument_mapping_select_inside, 'select-i-function': 'textobj#argument#select_i',
            \        'move-n': g:argument_mapping_move_next, 'move-n-function': 'textobj#argument#move_n',
            \        'move-N': g:argument_mapping_move_end, 'move-N-function': 'textobj#argument#move_N',
            \        'move-p': g:argument_mapping_move_previous, 'move-p-function': 'textobj#argument#move_p',
            \        'move-P': g:argument_mapping_move_start, 'move-P-function': 'textobj#argument#move_P',
            \        'sfile': expand('<sfile>:p'),
            \      },
            \    })
