/// @description draw ui

var _camx = camera_get_view_x(view_camera[0]);
var _camy = camera_get_view_y(view_camera[0]);
var _xx = 0;
var _yy = 0;

//context
if (p_context_fadein > 0){
	_xx = obj_player.x - _camx;
	_yy = obj_player.y - obj_player.z - 16 - _camy + (1 - p_context_fadein) * 8;
	draw_sprite_ext(spr_ui_context, p_context_i, _xx, _yy, 1, 1, 0, c_white, p_context_fadein);		
}


if (!instance_exists(obj_ui_buildopts)){
	_yy = global.viewh - 40;

	var _txt = "Jet: " + string(obj_player.jetpack_fuel);
	DrawTextColourShadow(8, _yy, _txt, c_white, 1);

	_yy += 16;

	var _txt_ii = 0;
	if (obj_player.state == ePlayerState.ELEVATOR) _txt_ii = 3;
	else if (obj_player.in_tower_bounds) _txt_ii = 1;
	else if (obj_player.onground == false && obj_player.state == ePlayerState.IDLE) _txt_ii = 2;

	DrawTextColourShadow(8, _yy, string(chr(global.k_use)) + ": " + string(arr_use_txt[_txt_ii]), c_white, 1);
	_yy += 10;
	DrawTextColourShadow(8, _yy, string(chr(global.k_action)) + ": " + string(arr_context_txt[obj_player.context_i + 1]), c_white, 1);
}


//resources
draw_set_halign(fa_right);
_yy = global.viewh - 15;
for (var i = array_length(obj_level.arr_res)-1; i >= 0; i--){	
	DrawTextColourShadow(global.vieww - 15, _yy, obj_level.arr_res[i], #CCCCEA, 1);
	draw_sprite(spr_res_icons, i, global.vieww - 8, _yy + 10);
	_yy -= 10;
}
draw_set_halign(fa_left);


//height
DrawTextColourShadow(17, 3, "Height", c_white, 1);
DrawTextColourShadow(17, 14, obj_level.tower_height, c_white, 1);

//height prog
var _progbar_y = 6;
var _progbar_h = 70;

//base
draw_sprite(spr_ui_prog_base, 0, 2, _progbar_y + _progbar_h);

//bar
var _hh = (obj_level.tower_height / obj_level.tower_win_height) * _progbar_h;
_yy = _progbar_h - _hh;
draw_sprite_part(spr_ui_prog_tower, 0, 0, _yy, 16, _hh, 3, _progbar_y + 5 + _yy);

//star
draw_sprite(spr_ui_prog_star, 0, 2, _progbar_y);


//elevator arrows
if (obj_player.state == ePlayerState.ELEVATOR){	
	_xx = global.vieww / 2 + TILE_W + 12;
	
	draw_sprite(spr_ui_arrows, 0, _xx, global.viewh/2 - 12 + sin(current_time/200));
	
	draw_set_halign(fa_center);
	DrawTextColourShadow(_xx, global.viewh/2 - 6, string(max(floor(obj_player.tz), 0)), c_white, 1);
	draw_set_halign(fa_left);
	
	draw_sprite(spr_ui_arrows, 1, _xx, global.viewh/2 + 12 - sin(current_time/200));
}


