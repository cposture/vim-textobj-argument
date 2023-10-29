# Introduction

This plugin adds text object support for separated arguments enclosed by brackets.

# Installation

You can install it using your favorite plugin manager. Here's an example using [vim-plug](https://github.com/junegunn/vim-plug)

```
Plug 'kana/vim-textobj-user'
Plug 'cposture/vim-textobj-argument'
```

Dependent on another plugin [kana/vim-textobj-user](https://github.com/kana/vim-textobj-user), a Vim plugin to create your own text objects without pain

# Examples

```
function(a, /*comment*/ b, c)
```

- With the cursor on the character 'b', typing `daa`, would get `function(a, c)`, typing `dia` would get `function(a, /*comment*/ , c)`
- Counts are supported. With the cursor on the character 'a' or before it for example character 'f', typing `d2aa` or `2daa`  would get `function(c)`
- Move to start of next argument, with the cursor on the character 'a', typing `]a`, the cursor will move to the 'b' parameter.

# Configuration

Customize the separator, which is `,` by default, in regular expression format, refer to `:help pattern`:
```
let g:argument_separator = ','
```

Customize the left bracket, which is `([` by default, in regular expression format, refer to `:help pattern`:
```
let g:argument_left_bracket = '[([]'
```

Customize the right bracket, which is `)]` by default, in regular expression format, refer to `:help pattern`:
```
let g:argument_right_bracket = '[)]]'
```

Customize motion mappings, default mappings are described in the following section "Motion commands":

```
let g:argument_mapping_select_around = 'aa'
let g:argument_mapping_select_inside = 'ia'
let g:argument_mapping_move_previous = '[a'
let g:argument_mapping_move_start = '[A'
let g:argument_mapping_move_next = ']a'
let g:argument_mapping_move_end = ']A'
```

# Motion commands

Motion commands on text objects are a powerful feature of Vim.

`aa` - select 'around' argument with separator and comment

`ia` - select ‘inside’ argument without separator and comment

`[a` - move to start of previous argument

`]a` - move to start of next argument

`[A` - move to first argument

`]A` - move to last argument

# Inspiration

- [vim-angry](https://github.com/b4winckler/vim-angry)
- [vim-textobj-sentence](https://github.com/preservim/vim-textobj-sentence)
