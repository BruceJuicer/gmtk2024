/// @description steppe

/*
var _mspd = 2;

if (keyboard_check(vk_left)){
	x -= _mspd;
}
if (keyboard_check(vk_up)){
	y -= _mspd;
}
if (keyboard_check(vk_down)){
	y += _mspd;
}
if (keyboard_check(vk_right)){
	x += _mspd;
}
*/

camera_set_view_pos(view_camera[0], x - global.vieww / 2, y - global.viewh / 2);