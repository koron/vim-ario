scriptencoding utf-8

let &rtp.=",".expand('<sfile>:p:h')

call sprite#init(16, 16)
call sprite#load('sprite/mario.txt', ['#000000','#b13425','#6a6b04','#e39d25'])
call sprite#install_keymap()
