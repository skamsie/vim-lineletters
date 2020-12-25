if exists('g:loaded_lineletters')
  finish
endif
let g:loaded_lineletters = 1

" Create the list of symbols to be used for the signs by combining the
" main chars with the prefix chars; characters that are included in both
" lists will automatically be excluded from main chars.
" Example:
"   main_chars = ['a', 'b', 'c']
"   prefix_chars = [';', 'b']
" Returns: ['a', 'c', ';a', ';b', ';c', 'ba', 'bb', 'bc']
function! s:symbols(main_chars, prefix_chars)
  let l:symbols = copy(a:main_chars)
  for c in a:prefix_chars
    let l:symbols += map(copy(a:main_chars), {i, v -> c . v})
  endfor
  return l:symbols
endfunction

" Settings
let g:lineletters_settings = get(g:, 'lineletters_settings', {})
let s:group = 'LineLetters'
let s:priority = 100
let s:main_chars = get(g:lineletters_settings,
      \ 'main_chars', map(range(97, 97 + 25), 'nr2char(v:val)'))
let s:highlight_group =
      \ get(g:lineletters_settings,
      \ 'highlight_group', 'LineNr')
let s:after_jump_do =
      \ get(g:lineletters_settings,
      \ 'after_jump_do', '^')
let s:prefix_chars =
      \ get(g:lineletters_settings,
      \ 'prefix_chars', [',', 'j', 'f'])
let s:possible_signs = s:symbols(s:main_chars, s:prefix_chars)

if s:main_chars == []
  finish
endif

" Get all unfolded lines between 'w0' and 'w$'
function! s:visible_lines()
  let l:visible = []
  for l in range(line('w0'), line('w$'))
    let l:fc = foldclosed(l)
    if l:fc == -1 || index(l:visible, l:fc) == -1
      call add(l:visible, l)
    endif
  endfor

  return l:visible
endfunction

" Example:
"   {'name': 'LineLetterss', 'texthl': 'LineNr', 'text': ' s'}
function! s:define_signs()
  for i in s:possible_signs
    call sign_define(s:group . i,
          \ {'text': len(i) == 1 ? ' ' . i : i,
          \'texthl': s:highlight_group})
  endfor
endfunction

function s:signs(vl)
  let l:div2i = len(a:vl) / len(s:main_chars)
  let l:div2f = len(a:vl) / str2float(len(s:main_chars) . '.0')
  let l:idx = l:div2i == l:div2f ? l:div2i - 2 : l:div2i -1

  " remove clashing symbols depending on the number of visible lines
  " ex: if 'ja' exists, 'j' has to be removed
  let l:signs =
        \ l:idx == -1 ? s:possible_signs :
        \ filter(copy(s:possible_signs),
        \ { i, v -> index(s:prefix_chars[0:l:idx], v) == -1 })
  return l:signs[:len(a:vl) -1]
endfunction

" Place signs on the visible lines in the current window
function! s:place_sings(vl)
  let l:signs = s:signs(a:vl)
  let l:counter = 0

  for i in a:vl[:len(l:signs) -1]
    call sign_place(
          \ i, s:group,
          \ s:group . l:signs[counter], expand('%'),
          \ {'lnum': i, 'priority': s:priority})
    let l:counter += 1
  endfor
endfunction

" Return the line based on sign selected by the user
function! s:line(vl)
  let l:signs = s:signs(a:vl)
  let l:placed_sings =
        \ sign_getplaced(expand('%'), { 'group': s:group })[0]['signs']
  let l:signs_in_main = filter(
        \ copy(l:signs), { i, v -> index(s:main_chars, v) != -1 })
  let l:first_char = nr2char(getchar())

  if index(map(copy(l:signs), { i, v -> v[0] }), l:first_char) == -1
    return 0
  endif

  try
    if index(l:signs_in_main, l:first_char) != -1
      let l:sign = s:group . l:first_char
    else
      let l:second_char = nr2char(getchar())
      let l:sign = s:group . l:first_char . l:second_char
    endif
    let l:line = filter(
          \ l:placed_sings, { i, v -> v['name'] == l:sign })[0]['id']
  " E684: list index out of range
  catch /E684/
    let l:line = 0
  endtry

  return l:line
endfunction

call s:define_signs()

function! s:lineletters()
  let l:after_jump = mode() == 'n' ? s:after_jump_do : ''
  let l:vl = s:visible_lines()
  call s:place_sings(l:vl)
  redraw
  let l:l = s:line(l:vl)
  call sign_unplace(s:group)
  if l:l == 0
    return
  endif

  return l:l . 'gg' . l:after_jump
endfunction

nnoremap <expr> <Plug>LineLetters <SID>lineletters()
vnoremap <expr> <Plug>LineLetters <SID>lineletters()
