# vim-lineletters

Jump to any visible line in the buffer by using letters instead of numbers.

<img src="https://user-images.githubusercontent.com/7014744/102135236-f77a5b00-3e57-11eb-81d3-d93689fbe853.gif" width="732"/>

## Install

Use your favorite plugin manager

```vim
Plug 'skamsie/vim-lineletters'
```

## How to use

Use `<Plug>LineLetters` to show signs on each of the visible lines in the buffer. Type the letter(s) to jump to that line.  
**Why?** Because letters are much easier to touch type than numbers (๑˃̵ᴗ˂̵)و

By default there is no key mapping, to create one, add this in your `.vimrc` and replace `,` with whatever you like (even though `,` is a good candidate if you don't normall use it). Ideally it should be a one letter mapping.

```vim
nmap <silent>, <Plug>LineLetters
```

## Settings

Add this to your `.vimrc` and change the values to your liking (showing defaults)

```vim
let g:lineletters_settings = {
      \ 'prefix_chars': [',', 'j', 'f'],
      \ 'highlight_group': 'LineNr',
      \ 'after_jump_do': '^'
      \ }
      
 " prefix_chars -> characters used as prefix after the single alphanumeric chars are consumed
 " highligh_group -> use a highlight group to colorize the signs
 "  (for ex. change to 'MoreMsg')
 " after_jump_do: -> add normal command to be executed after jumping to line
 "  (for ex. '0' will jump to first char of the line)
```
