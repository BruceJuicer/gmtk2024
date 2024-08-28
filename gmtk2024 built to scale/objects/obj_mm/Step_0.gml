
var _camy = camera_get_view_y(view_camera[0]);

//closing menu
if (state == -1){	
	camera_set_view_pos(view_camera[0], 0, _camy + 6);
	
	fadein -= 0.033;
	if (fadein <= 0){
		room_goto(rm_game);
	}
	
	return;
}

camera_set_view_pos(view_camera[0], 0, lerp(_camy, 0, 0.15));
fadein = lerp(fadein, 1, 0.25);


var _bx = global.vieww/2;
var _bw = 68;
var _by = global.viewh/2;

if (info_typeout < string_length(arr_opts_info[opt_sel])) info_typeout ++;


var _sel_i = opt_sel;
opt_sel = OptDoNav(opt_sel, 0, array_length(arr_opts));
if (_sel_i != opt_sel){
	info_typeout = 0;
}


if (OptDoSelect()){
	switch(opt_sel){
		case 0:
			state = -1;
		break;
		case 1:
			instance_create_layer(x, y, "Instances", obj_menu_settings);
			instance_destroy();
		break;
		case 2:
			game_end();
		break;
	}
}



/*
if (ButtonTick(but_start, _bx - (_bw/2), _by, _bw, 24)) {
	state = -1;
}

_by += 32;
if (ButtonTick(but_quit, _bx - (_bw/2), _by, _bw, 24)) {
	game_end();
}
*/



//if (keyboard_check_pressed(vk_enter)) room_goto(rm_game);
//if (keyboard_check_pressed(vk_escape)) game_end();
