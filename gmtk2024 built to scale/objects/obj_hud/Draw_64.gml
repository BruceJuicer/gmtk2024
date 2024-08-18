/// @description draw ui

//resources
for (var i = 0; i < array_length(obj_level.arr_res); i++){
	var _xx = 8 + i * 64;
	var _txt = global.arr_res_info[i].name + " " + string(obj_level.arr_res[i]);
	
	DrawTextColour(_xx + 1, 9, _txt, c_black, 1);
	DrawTextColour(_xx, 8, _txt, c_white, 1);
}


var _txt = "Fuel: " + string(obj_player.jetpack_fuel);
DrawTextColour(9, 25, _txt, c_black, 1);
DrawTextColour(8, 24, _txt, c_white, 1);


var _yy = global.viewh - 24;
DrawTextColourShadow(8, _yy, "Z: Get in/out of ele", c_white, 1);
_yy += 10;
DrawTextColourShadow(8, _yy, "X: Place tile...", c_white, 1);