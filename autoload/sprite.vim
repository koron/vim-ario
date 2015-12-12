scriptencoding utf-8

let s:chars = ['０','１','２','３','４','５','６','７','８','９','Ａ','Ｂ','Ｃ','Ｄ','Ｅ','Ｆ']

function! sprite#init(width, height)
  set nofoldenable
  set nonumber
  set noruler
  set noshowcmd
  set noshowmode
  set noswapfile
  set buftype=nofile
  set cmdheight=1
  set foldcolumn=0
  set laststatus=0
  set lazyredraw
  set linespace=0
  set scrolloff=0
  if has('kaoriya')
    set guioptions=C
  else
    set guioptions=
  endif
  if has('gui_running')
    set guifont=MS_Gothic:h3
  endif

  let &lines=a:height + 1
  let &columns=a:width * 2
  let s:height=a:height

  highlight Cursor guibg=NONE
  highlight CursorIM guibg=NONE
  highlight Normal guifg=#ffffff guibg=#000000
endfunction

function! sprite#load(fname, colors)
  silent execute "r ".a:fname
  silent 1d
  let i = 0
  while i < len(s:chars)
    execute printf('syntax match Char%d /%s/', i, s:chars[i])
    let i += 1
  endwhile
  let i = 0
  while i < len(a:colors)
    let c = a:colors[i]
    execute printf('highlight Char%d guibg=%s guifg=%s', i, c, c)
    let i += 1
  endwhile
endfunction

function! sprite#show(pnum)
  execute printf('normal! %dggzt', a:pnum * 16 + 1)
endfunction

function! sprite#install_keymap()
  let pnum = line('$') / s:height
  let i = 0
  while i < pnum
    execute printf('noremap g%02d %dggzt', i, i * 16 + 1)
    let i += 1
  endwhile
endfunction
