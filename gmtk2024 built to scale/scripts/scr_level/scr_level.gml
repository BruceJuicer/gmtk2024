
//#macro LEVEL_W 10
//#macro LEVEL_H 10

//'radius' of level (distance from tower in all directions, square not actually circular)
#macro LEVEL_R 4

#macro TOWER_W 2
#macro TOWER_H 2
#macro TOWER_Z_MAX 64

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
		//check for integrity
		TowerCheckIntegrity(zz);
		
		obj_level.arr_tower_layers[zz][xx + yy * TOWER_W] = noone;
		return noone;
	}
	
	//assigning new tile inst
	var _inst = instance_create_layer(xx, yy, "Instances", obj_index);
	_inst.z = zz;
	
	var _ppos = IsoToPixel(xx, yy, 0);
	_inst.dx = _ppos.x;
	_inst.dy = _ppos.y;
	_inst.dz = zz * TILE_V;
	
	//_inst.depth = -(_ppos.y + 4) - zz;
	_inst.depth = TileGetDepth(_inst.dy, _inst.dz);
	
	obj_level.arr_tower_layers[zz][xx + yy * TOWER_W] = _inst;
	
	return _inst;
}


function TowerCheckIntegrity(zz){
	if (obj_level.tower_height <= zz) return;
	
	var _integrity = 0;
	
	for (var i = 0; i < TOWER_W * TOWER_H; i++){
		if (instance_exists(obj_level.arr_tower_layers[zz][i])) _integrity ++;
	}
	
	if (_integrity > 1) return;
	
	//uh oh!
	
	//make sure there are no tiles on this layer anymore
	for (var i = 0; i < TOWER_W * TOWER_H; i++){
		if (instance_exists(obj_level.arr_tower_layers[zz][i])){
			instance_destroy(obj_level.arr_tower_layers[zz][i]);
			obj_level.arr_tower_layers[zz][i] = noone;
		}
	}
	
	obj_level.tower_collapsing = true;
	obj_level.tower_collapse_timer = 0;
	obj_level.tower_collapse_z = zz;	
}


///@self obj_level
function LevelAddWorldObj(px, py, tz, _obj_index){
	var _inst = instance_create_layer(px, py, "Instances", _obj_index);
	_inst.tz = tz;
	WoAddToLayer(_inst);
	return _inst;
}


///@self obj_level
function LevelTrySpawnWorldObj(worldobj, tz, max_layer_wo = 4){	
	var _wo_amt = array_length(arr_layer_wo[tz]);
	
	if (_wo_amt > max_layer_wo = irandom(2)) return;
	
	var _rand_x = -LEVEL_R + irandom(LEVEL_R * 2);
	var _rand_y = -LEVEL_R + irandom(LEVEL_R * 2);
		
	if (_rand_x < 0 || _rand_x > TOWER_W || _rand_y < 0 || _rand_y > TOWER_H){
		var _ppos = IsoToPixel(_rand_x, _rand_y, 0);
		//don't be behind tower
		if (_ppos.y > TILE_H || _ppos.x < -TILE_W || _ppos.x > TILE_W){			
			var _nobj = WoGetInRange(_ppos.x, _ppos.y, tz, 16);		
			if (instance_exists(_nobj)) return noone;
			
			var _wobj = LevelAddWorldObj(_ppos.x, _ppos.y + TILE_H/2, tz, worldobj);
			_wobj.shake_amt = 2;
			return _wobj;
		}
	}
}


function WoGetInRange(xx, yy, tz, dist) {	
	var _arr_wobjs = obj_level.arr_layer_wo[floor(tz)];
	
	for (var i = 0; i < array_length(_arr_wobjs); i++){
		if (!instance_exists(_arr_wobjs[i])) continue;
		if (abs(_arr_wobjs[i].x - xx) > dist || abs(_arr_wobjs[i].y - yy) > dist) continue;
		return _arr_wobjs[i];
	}
	
	return noone;
}