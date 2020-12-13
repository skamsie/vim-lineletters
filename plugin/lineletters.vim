let g:control_chars = [',', 'j', 'f']
let g:main_chars = filter(map(range(97, 97 + 25), 'nr2char(v:val)'),
      \ {idx, val -> index(g:control_chars, val) == -1})

function! Symbols()
  let l:symbols = copy(g:main_chars)
  for c in g:control_chars
    let l:symbols += map(copy(g:main_chars), {i, v -> c . v})
  endfor
  return l:symbols
endfunction

function! DefineSigns()
  for i in Symbols()
    call sign_define(i, {'text': len(i) == 1 ? ' ' . i : i, 'texthl': 'LineNr'})
  endfor
endfunction

function! PlaceSign()
  let l:counter = 0
  for i in range(line('w0'), line('w$'))
    call sign_place(i, 'lineletters', g:symbols[counter], expand('%'), {'lnum' : i})
    let l:counter += 1
  endfor
endfunction

function Setup()
  call DefineSigns()
  let g:symbols = Symbols()
  call PlaceSign()
endfunction

function! GoToSign()
  call Setup()
  redraw
  let l:signs = sign_getplaced(expand('%'), {'group' : 'lineletters'})[0]['signs']
  let l:first_char = nr2char(getchar())
  if index(g:control_chars, l:first_char) == -1
    let lx = filter(l:signs, { idx, val -> val['name'] == l:first_char })
    exec lx[0]['id']
  else
    let l:second_char = nr2char(getchar())
    let lx = filter(l:signs, { idx, val -> val['name'] == l:first_char . l:second_char })
    exec lx[0]['id']
  endif
  call sign_unplace('lineletters')
endfunction

"autocmd VimEnter * call DefineSigns()
"autocmd WinScrolled,BufEnter,InsertLeave * call PlaceSign()
"autocmd WinLeave,BufLeave * call sign_unplace('lineletters')

nnoremap <silent>, :call GoToSign()<CR>
