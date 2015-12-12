scriptencoding utf-8

let s:dir = expand('<sfile>:p:h:h')
let &rtp .= "," . s:dir

call sprite#init(16, 16)
call sprite#load('sprite/ario.txt', ['#000000','#b13425','#6a6b04','#e39d25'])
call sprite#install_keymap()
