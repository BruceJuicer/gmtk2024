

var _ww = 64;
var _xx = global.vieww/2 - _ww / 2;


if (ButtonTick(but_continue, _xx, global.viewh/3, _ww, 24)) {
	instance_destroy();	
}
if (ButtonTick(but_quit, _xx, global.viewh/3 + 32, _ww, 24)) {
	room_goto(rm_menu);
}



//if (keyboard_check_pressed(vk_enter)) instance_destroy();	
//if (keyboard_check_pressed(vk_escape)) room_goto(rm_menu);
