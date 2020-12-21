# vim-lineletters

Jump to any visible line in the buffer by using letters instead of numbers. Works in normal and visual modes.

**Why?** Because letters are much easier to touch type than numbers (๑˃̵ᴗ˂̵)و

<img src="https://user-images.githubusercontent.com/7014744/102135236-f77a5b00-3e57-11eb-81d3-d93689fbe853.gif" width="732"/>

## Install

Use your favorite plugin manager

```vim
Plug 'skamsie/vim-lineletters'
```

## How to use

By default there is no key mapping, to create one, add this in your `.vimrc` and replace `,` with whatever you like (even though `,` is a good choice if you don't normall use it). Ideally it should be a one character mapping.

```vim
map <silent>, <Plug>LineLetters
```

Use the mapping you chose to show signs on each of the visible lines in the buffer. 
Type the character(s) you see in the sign column to jump to that line.  

You can check the documentation at any time with `:help lineletters`

## Settings

By default you don't need to configure anything, but if you want to change the defaults, you can do it via the `g:lineletters_settings` dictionary. For example you can add something like this to your `.vimrc`:

```vim
let g:lineletters_settings = {
      \ 'main_chars': map(range(100, 120), 'nr2char(v:val)'),
      \ 'prefix_chars': [',', ';', 'j'],
      \ 'highlight_group': 'MoreMsg',
      \ 'after_jump_do': '0'
      \ }
      
" map(range(100, 120), 'nr2char(v:val)') -> will generate a list with letters from 'd' to 'x'
```

### Config Options
```
+--------------------+-------------------+--------------------------------------------+
| Option             | Default           | Description                                |
|--------------------|-------------------|--------------------------------------------|
| main_chars         | ['a', ..., 'z']   | main characters used for the signs column  |
|--------------------|-------------------|--------------------------------------------|
| prefix_chars       | [',', 'j', 'f']   | characters used to prefix main_chars after |                                           
|                    |                   | they are consumed                          |                                          
|--------------------|-------------------|--------------------------------------------|
| highlight_group    | 'LineNr'          | highlight group used to colorize the signs |
|--------------------|-------------------|--------------------------------------------|
| after_jump_do      | '^'               | command to be executed after               |
|                    |                   | jumping to line (only in normal mode)      |
+--------------------+-------------------+--------------------------------------------+
```
