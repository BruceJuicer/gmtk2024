/// @description draw ui

var _txt = "Fuel: " + string(obj_player.jetpack_fuel);
DrawTextColour(9, 9, _txt, c_black, 1);
DrawTextColour(8, 8, _txt, c_white, 1);


var _yy = global.viewh - 24;
DrawTextColourShadow(8, _yy, "Z: Get in/out of ele", c_white, 1);
_yy += 10;
DrawTextColourShadow(8, _yy, "X: Place tile...", c_white, 1);