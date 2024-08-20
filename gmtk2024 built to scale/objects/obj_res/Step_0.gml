/// @description steppe

if (frozen) return;

depth = CharGetDepth(y, z);

if (zspd > -1) zspd -= 0.1;

//hit floor
if (z + zspd <= 0){
	zspd = 0;
	z = 0;
	frozen = true;
}


//stay in bounds
var _isopos = PixelToIsoSub(x, y);

if (_isopos.x < -LEVEL_R || _isopos.x > TOWER_W + LEVEL_R || _isopos.y < -LEVEL_R || _isopos.y > TOWER_H + LEVEL_R) {
	hspd = 0;
	vspd = 0;
}

x += hspd;
y += vspd;

if (z < obj_level.no_gravity_height * TILE_V){
	z += zspd;
} else {
	//no grav!
	hspd *= 0.95;
	vspd *= 0.95;
	if (abs(hspd) <= 0.05 && abs(vspd) <= 0.05) frozen = true;
}


//sort into correct layer
if (zlayer_i != floor(z / TILE_V)){
	ItemRemoveFromLayer(id);
	ItemAddToLayer(id);
}
