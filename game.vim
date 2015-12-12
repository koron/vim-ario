scriptencoding utf-8

let s:dir = expand('<sfile>:p:h')
let &rtp .= "," . s:dir

"stop

call server#start('ario', s:dir . '/proc/ario.vim')
sleep 500m
call remote_foreground('ario')

call server#start('joypad', s:dir . '/proc/joypad.vim')
sleep 500m
call remote_foreground('joypad')
