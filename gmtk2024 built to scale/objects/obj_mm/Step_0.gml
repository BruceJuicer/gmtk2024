
var _bx = global.vieww/2;
var _bw = 68;
var _by = global.viewh/2;


if (ButtonTick(but_start, _bx - (_bw/2), _by, _bw, 24)) {
	room_goto(rm_game);	
}

_by += 32;
if (ButtonTick(but_quit, _bx - (_bw/2), _by, _bw, 24)) {
	game_end();
}




if (keyboard_check_pressed(vk_enter)) room_goto(rm_game);
if (keyboard_check_pressed(vk_escape)) game_end();
