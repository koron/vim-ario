scriptencoding utf-8

let s:dir = expand('<sfile>:p:h')
let s:servers = {}

function! server#start(name, script)
  silent execute join([
        \ '!start',
        \ 'gvim',
        \ '-u', s:dir . '/server/vimrc.vim',
        \ '-U', s:dir . '/server/gvimrc.vim',
        \ '--noplugin',
        \ '--servername', a:name,
        \ '-S', a:script
        \ ])
  let s:servers[a:name] = 1
endfunction

function! server#stop(name)
  if has_key(a:name)
    silent! call remote_send(a:name, 'ZQ')
    call remove(s:servers, a:name)
  endif
endfunction

function! server#stop_all()
  for k in keys(s:servers)
    silent! call remote_send(k, 'ZQ')
  endfor
  let s:servers = {}
endfunction
