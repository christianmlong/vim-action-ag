" vim-ack-anying.vim ack anything
" Maintainer:   Chun Yang <http://github.com/Chun-Yang>
" Version:      1.0

if exists("g:loaded_vim_action_ack") || &cp || v:version < 700
  finish
endif
let g:loaded_vim_action_ack = 1

" http://stackoverflow.com/questions/399078/what-special-characters-must-be-escaped-in-regular-expressions
let g:vim_action_ack_escape_chars = get(g:, 'vim_action_ack_escape_chars', '#%.^$*+?()[{\\|')

function! s:Ack(mode) abort
  " preserver @@ register
  let reg_save = @@

  " copy selected text to @@ register
  if a:mode ==# 'v' || a:mode ==# ''
    silent exe "normal! `<v`>y"
  elseif a:mode ==# 'char'
    silent exe "normal! `[v`]y"
  else
    return
  endif

  " prepare for search highlight
  let escaped_for_vim = escape(@@, '/\')
  exe ":let @/='\\V".escaped_for_vim."'"

  " escape special chars,
  " % is file name in vim we need to escape that first
  " # is secial in ack
  let escaped_for_ack = escape(@@, '%#')
  let escaped_for_ack = escape(escaped_for_ack, g:vim_action_ack_escape_chars)

  " execute Ack command
  " '!' is used to NOT jump to the first match
  exe ":Ack!" "'".escaped_for_ack."'"

  " go to the first search match
  normal! n

  " recover @@ register
  let @@ = reg_save
endfunction

" NOTE: set hlsearch does not work in a function
vnoremap <silent> <Plug>AckActionVisual :<C-U>call <SID>Ack(visualmode())<CR>
nnoremap <silent> <Plug>AckAction       :set hlsearch<CR>:<C-U>set opfunc=<SID>Ack<CR>g@
nnoremap <silent> <Plug>AckActionWord   :set hlsearch<CR>:<C-U>set opfunc=<SID>Ack<CR>g@iw

vmap gag <Plug>AckActionVisual
nmap gag <Plug>AckAction
