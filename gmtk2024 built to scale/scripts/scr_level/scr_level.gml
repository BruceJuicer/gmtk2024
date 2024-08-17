
//#macro LEVEL_W 10
//#macro LEVEL_H 10

#macro TOWER_W 2
#macro TOWER_H 2
#macro TOWER_Z_MAX 80




///@desc convers pixel coords to iso coords (floors to int) returns { x, y }
function PixelToIso(xx, yy){	
	return {
		x: floor(xx / TILE_W + yy / TILE_H), 
		y: floor(yy / TILE_H - xx / TILE_W)
	};
}


///@desc convers iso coords to pixel coords, returns { x, y }
function IsoToPixel(xx, yy, zz){
	return {
		x: (xx - yy) * (TILE_W / 2),
		y: (xx + yy) * (TILE_H / 2) - zz * TILE_V
	};
}



function TowerGetTileAt(xx, yy, zz){
	if (xx < 0 || xx >= TOWER_W)	 return noone;
	if (yy < 0 || yy >= TOWER_H)	 return noone;
	if (zz < 0 || zz >= TOWER_Z_MAX) return noone;
	
	return obj_level.arr_tower_layers[zz][xx + yy * TOWER_W];
}



function TowerSetTileAt(xx, yy, zz){
	var _inst = instance_create_layer(xx, yy, "Instances", obj_tile_test);
	_inst.z = zz;
	
	var _ppos = IsoToPixel(xx, yy, 0);
	_inst.dx = _ppos.x;
	_inst.dy = _ppos.y - zz * TILE_V;
	_inst.dz = zz * TILE_V;
	
	_inst.depth = (-_ppos.y) - zz;
	
	obj_level.arr_tower_layers[zz][xx + yy * TOWER_W] = _inst;
}