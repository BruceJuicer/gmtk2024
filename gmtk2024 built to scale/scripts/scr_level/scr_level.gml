
//#macro LEVEL_W 10
//#macro LEVEL_H 10

#macro TOWER_W 2
#macro TOWER_H 2
#macro TOWER_Z_MAX 80

//global.game_pause = false;


enum eRes {
	WOOD,
	STONE,
	GOLD,
};


global.arr_res_info = [
	{
		name: "Wood",
	},
	{
		name: "Stone",
	},
	{
		name: "Gold",
	},
];




///@desc convers pixel coords to iso coords (floors to int) returns { x, y }
function PixelToIso(xx, yy){	
	return {
		x: floor(xx / TILE_W + yy / TILE_H), 
		y: floor(yy / TILE_H - xx / TILE_W)
	};
}

///@desc convers pixel coords to iso coords (does not floor to int) returns { x, y }
function PixelToIsoSub(xx, yy){	
	return {
		x: xx / TILE_W + yy / TILE_H, 
		y: yy / TILE_H - xx / TILE_W
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


///@desc also returns the created instance, use noone to set a tile to nothing
///@param {real} xx
///@param {real} yy
///@param {real} zz
///@param {Asset.GMObject} obj_index
function TowerSetTileAt(xx, yy, zz, obj_index){
	if (xx < 0 || xx >= TOWER_W)	 return noone;
	if (yy < 0 || yy >= TOWER_H)	 return noone;
	if (zz < 0 || zz >= TOWER_Z_MAX) return noone;
	
	//remove old inst if one exists
	if (instance_exists(obj_level.arr_tower_layers[zz][xx + yy * TOWER_W])) instance_destroy(obj_level.arr_tower_layers[zz][xx + yy * TOWER_W]);
	
	//setting to noone
	if (obj_index == noone){
		obj_level.arr_tower_layers[zz][xx + yy * TOWER_W] = noone;
		return noone;
	}
	
	//assigning new tile inst
	var _inst = instance_create_layer(xx, yy, "Instances", obj_index);
	_inst.z = zz;
	
	var _ppos = IsoToPixel(xx, yy, 0);
	_inst.dx = _ppos.x;
	_inst.dy = _ppos.y - zz * TILE_V;
	_inst.dz = zz * TILE_V;
	
	_inst.depth = -(_ppos.y + 4) - zz;
	
	obj_level.arr_tower_layers[zz][xx + yy * TOWER_W] = _inst;
	
	return _inst;
}