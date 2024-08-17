
//tile coords
var _tpos = PixelToIso(x, y);
tx = _tpos.x;
ty = _tpos.y;
tz = z / TILE_V;

depth = -y + 4 - z;



//gravity
if (zspd > -2) z -= 0.1;


x += hspd;



y += vspd;



z += zspd;




var _mspd = 1.0;

if (keyboard_check(vk_left)){
	x -= _mspd;
} else
if (keyboard_check(vk_right)){
	x += _mspd;
}
if (keyboard_check(vk_up)){
	y -= _mspd;
} else
if (keyboard_check(vk_down)){
	y += _mspd;
}