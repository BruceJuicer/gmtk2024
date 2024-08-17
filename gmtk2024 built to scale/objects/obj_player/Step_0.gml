
//tile coords
var _tpos = PixelToIso(x, y);
tx = _tpos.x;
ty = _tpos.y;
tz = z / TILE_V;

depth = -y + 4 - z;

var _tile_z = floor(tz);
var _tile_at_feet =	TowerGetTileAt(floor(tx), floor(ty), _tile_z - 1);



//gravity
if (zspd > -2) z -= 0.25;


x += hspd;



y += vspd;



if (z + zspd <= 0){
	z = 0;
	zspd = 0;
}

if (_tile_at_feet != noone){
	if (z <= _tile_at_feet.z){
		z = _tile_at_feet.z;
		zspd = 0;
	}
}


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

if (keyboard_check(ord("X"))){
	z += 2;
}
