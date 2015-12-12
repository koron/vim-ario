scriptencoding utf-8

let s:dir = expand('<sfile>:p:h:h')
let &rtp .= "," . s:dir

let s:state = {
      \ 'left': 0,
      \ 'right': 0,
      \ 'bottom': 0,
      \ 'up': 0,
      \ 'jump': 0,
      \ 'dash': 0,
      \ 'quit': 0,
      \ }

function! State()
  return string(s:state)
endfunction

function! s:show()
  " TODO: better view
  echo string(s:state)
endfunction

function! s:toggle(name)
  let s:state[a:name] = s:state[a:name] ? 0 : 1
endfunction

function! s:on_clear()
  for k in keys(s:state)
    let s:state[k] = 0
  endfor
  call s:show()
  return ''
endfunction

function! s:on_left()
  call s:toggle('left')
  let s:state['right'] = 0
  call s:show()
  return ''
endfunction

function! s:on_right()
  call s:toggle('right')
  let s:state['left'] = 0
  call s:show()
  return ''
endfunction

function! s:on_bottom()
  call s:toggle('bottom')
  let s:state['up'] = 0
  call s:show()
  return ''
endfunction

function! s:on_up()
  call s:toggle('up')
  let s:state['bottom'] = 0
  call s:show()
  return ''
endfunction

function! s:on_jump()
  call s:toggle('jump')
  call s:show()
  return ''
endfunction

function! s:on_dash()
  call s:toggle('dash')
  call s:show()
  return ''
endfunction

noremap <silent> <expr> <space> <SID>on_clear()
noremap <silent> <expr> h <SID>on_left()
noremap <silent> <expr> l <SID>on_right()
noremap <silent> <expr> j <SID>on_bottom()
noremap <silent> <expr> k <SID>on_up()
noremap <silent> <expr> f <SID>on_jump()
noremap <silent> <expr> d <SID>on_dash()
