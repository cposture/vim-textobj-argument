let &rtp .= ',' .expand( "<sfile>:p:h:h:h" )
let &rtp .= ',vim-textobj-user' 

syntax enable

source plugin/textobj/argument.vim