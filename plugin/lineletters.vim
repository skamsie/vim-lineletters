" Create the list of symbols to be used for the signs by combining the
" main chars with the control chars; characters that are included in both
" lists will automatically be excluded from main_chars.
" Example:
"   main_chars = ['a', 'b', 'c']
"   control_chars = [';', 'b']
"   => ['a', 'c', ';a', ';b', ';c', 'ba', 'bb', 'bc']
function! s:symbols(main_chars, control_chars)
  let l:symbols = filter(
        \ copy(a:main_chars),
        \ {idx, val -> index(g:ll_control_chars, val) == -1})
  for c in a:control_chars
    let l:symbols += map(copy(a:main_chars), {i, v -> c . v})
  endfor
  return l:symbols
endfunction

let s:group = 'lineletters'
let g:ll_control_chars = [',', 'j', 'f']
let g:ll_main_chars = map(range(97, 97 + 25), 'nr2char(v:val)') " a -> z
let g:ll_symbols = s:symbols(g:ll_main_chars, g:ll_control_chars)

function! s:define_signs()
  for i in g:ll_symbols
    call sign_define(i,
          \ {'text': len(i) == 1 ? ' ' . i : i, 'texthl': 'LineNr'})
  endfor
endfunction

" Place signs on all visible lines in the current window
function! s:place_sings()
  let l:counter = 0
  for i in range(line('w0'), line('w$'))
    call sign_place(i, s:group,
          \ g:ll_symbols[counter], expand('%'), {'lnum' : i})
    let l:counter += 1
  endfor
endfunction

function! s:go_to_sign()
  let l:signs = sign_getplaced(
        \ expand('%'),
        \ {'group' : 'lineletters'})[0]['signs']
  let l:first_char = nr2char(getchar())
  try
    if index(g:ll_control_chars, l:first_char) == -1
      let l:l = filter(l:signs,
            \ { idx, val -> val['name'] == l:first_char })
      exec 'normal! ' l:l[0]['id'] . 'gg'
    else
      let l:second_char = nr2char(getchar())
        let l:l = filter(l:signs,
              \ { idx, val -> val['name'] == l:first_char . l:second_char })
        exec 'normal! ' l:l[0]['id'] . 'gg'
    endif
  catch /E684/
  endtry
endfunction

function! s:line_letters()
  call s:place_sings()
  redraw
  call s:go_to_sign()
  call sign_unplace(s:group)
endfunction

autocmd VimEnter * call s:define_signs()
nnoremap <silent> <Plug>LineLetters :call <SID>line_letters()<CR>
