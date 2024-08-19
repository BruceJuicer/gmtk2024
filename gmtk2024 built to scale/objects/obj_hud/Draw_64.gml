/// @description draw ui

var _txt = "Fuel: " + string(obj_player.jetpack_fuel);
DrawTextColourShadow(8, 80, _txt, c_white, 1);


var _yy = global.viewh - 24;
DrawTextColourShadow(8, _yy, "Z: Get in/out of ele", c_white, 1);
_yy += 10;
DrawTextColourShadow(8, _yy, "X: Place tile...", c_white, 1);


//resources
draw_set_halign(fa_right);
var _yy = global.viewh - 15;
for (var i = array_length(obj_level.arr_res)-1; i >= 0; i--){	
	DrawTextColourShadow(global.vieww - 15, _yy, obj_level.arr_res[i], #CCCCEA, 1);
	draw_sprite(spr_res_icons, i, global.vieww - 8, _yy + 10);
	_yy -= 10;
}
draw_set_halign(fa_left);


//height
DrawTextColourShadow(17, 6, "Height", c_white, 1);
DrawTextColourShadow(17, 17, obj_level.tower_height, c_white, 1);
