scriptencoding utf-8

let s:dir = expand('<sfile>:p:h')
let &rtp .= "," . s:dir

let s:debug = 0

if !s:debug
  stop
endif

call server#start('ario', s:dir . '/proc/ario.vim')
sleep 500m
call remote_foreground('ario')

call server#start('joypad', s:dir . '/proc/joypad.vim')
sleep 500m
call remote_foreground('joypad')

function! s:getpad()
  return eval(remote_expr('joypad', 'State()'))
endfunction

function! s:ario_set(x, y, p)
  call remote_expr('ario', printf('sprite#update(%d,%d,%d)', a:x, a:y, a:p))
endfunction

let s:grand_y = 700
let s:accel_walk = 1
let s:accel_gravity = 2
let s:jump_power = 24
let s:jump_frames = 8
let s:dumper = 1
let s:velocity_horz_max = 10

let s:game = {
      \   'ario': {
      \     'x': 240, 'y': s:grand_y, 'p': 1,
      \     'v': 0, 'w': 0, 'q': 0,
      \     'prev_jump': 0, 'j': 0,
      \     'jump': {
      \       'jumping': 0,
      \       'frame': 0,
      \       'prev_button': 0,
      \     },
      \   },
      \ }

while 1
  let pad = s:getpad()
  if pad['quit']
    break
  endif
  let ario = s:game.ario

  " left/right move.
  if pad['left']
    let ario.v -= s:accel_walk
    if ario.v < -s:velocity_horz_max
      let ario.v = -s:velocity_horz_max
    endif
  elseif pad['right']
    let ario.v += s:accel_walk
    if ario.v > s:velocity_horz_max
      let ario.v = s:velocity_horz_max
    endif
  else
    if ario.v > 0
      let ario.v -= s:dumper
      if ario.v <= 0
        let ario.v = 0
      endif
    elseif ario.v < 0
      let ario.v += s:dumper
      if ario.v >= 0
        let ario.v = 0
      endif
    endif
  endif

  " jump
  if pad['jump']
    if !ario.jump.jumping && !ario.jump.prev_button
      let ario.jump.frame = 0
      let ario.jump.jumping = 1
    endif
  else
    if !ario.jump.jumping
      let ario.jump.frame = 0
    endif
  endif
  let ario.jump.prev_button = pad['jump']
  if ario.jump.jumping
    if ario.jump.frame <= s:jump_frames
      let ario.w = -s:jump_power
    else
      let ario.w += s:accel_gravity
    endif
    let ario.jump.frame += 1
  endif

  let ario.x += ario.v
  if ario.x < 0
    let ario.x = 0
  endif
  if ario.x > 1800
    let ario.x = 1800
  endif

  let ario.y += ario.w
  if ario.y < 0
    let ario.y = 0
  endif
  if ario.y > s:grand_y
    let ario.y = s:grand_y
    let ario.jump.jumping = 0
  endif

  " select pattern
  if ario.jump.jumping
    let ario.p = ario.p <= 6 ? 6 : 12
  elseif ario.v > 0
    if pad['left']
      let ario.p = 11
    else
      let ario.p = (ario.q / 4) + 2
      let ario.q = (ario.q + 1) % 12
    endif
  elseif ario.v < 0
    if pad['right']
      let ario.p = 5
    else
      let ario.p = (ario.q / 4) + 8
      let ario.q = (ario.q + 1) % 12
    endif
  else
    let ario.p = ario.p >= 7 ? 7 : 1
    let ario.u = 0
  endif

  " TODO: update s:game
  call s:ario_set(s:game.ario.x, s:game.ario.y, s:game.ario.p)
  sleep 16m
endwhile

if !s:debug
  call server#stop_all()
  qa!
endif
