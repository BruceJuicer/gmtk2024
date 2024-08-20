/// @description steppe

if (flags & eFxFlags.POS_DEPTH) depth = CharGetDepth(y, z);

if (dest_time == 0){
	//fade out
	if (fade_spd > 0){
		image_alpha -= fade_spd;
		if (image_alpha <= 0) instance_destroy();
	} else {
		instance_destroy();
	}
}

//parent obj
if (parent_obj != noone){
	if (!instance_exists(parent_obj)){
		instance_destroy();
		return;
	}
	
	x = parent_obj.x + rel_x;
	y = parent_obj.y + rel_y;
	z = parent_obj.z + rel_z;
} else {
	x = rel_x;
	y = rel_y;
	z = rel_z;
}


//floor for shadow
if (flags & eFxFlags.HAS_SHADOW || grav != 0){
	floor_z = 0;
	
	var _tile_under = noone;
	var _isopos = PixelToIso(x, y);
	
	if (_isopos.x >= 0 && _isopos.x < TOWER_W && _isopos.y >= 0 && _isopos.y < TOWER_H){	
		//find the nearest tile under us
		for (var i = floor((z - 0.25) / TILE_V); i >= 0; i--){
			_tile_under = TowerGetTileAt(_isopos.x, _isopos.y, i);
			if (instance_exists(_tile_under)){
				floor_z = _tile_under.dz + TILE_V;
				break;
			}
		}
	}
}

//fall and bounce
if (grav != 0){	
	if (z + zspd <= floor_z){
		z = floor_z;
		zspd = -zspd / 2;
		hspd *= 0.9;
		vspd *= 0.9;
	}
	
	zspd += grav;
}

if (fric != 1){
	hspd *= fric;
	vspd *= fric;
	zspd *= fric;
}

rel_x += hspd;
rel_y += vspd;
rel_z += zspd;