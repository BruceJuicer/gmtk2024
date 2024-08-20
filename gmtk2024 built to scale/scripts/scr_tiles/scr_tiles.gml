
#macro TILE_W 24
#macro TILE_H 12 
#macro TILE_V 13

enum eTileType {
	NONE,
	ELEVATOR,
	WALL,
	WOOD_WALL,
	GUN,
	HEAVY_GUN,
	HEAVY_WALL,
	BUILDSITE,
}


///@param {real} wood
///@param {real} stone
///@param {real} gold
function ResCost(wood, stone, gold){
	return [ wood, stone, gold ];
}


global.arr_tileinfo = [
	{
		tile_obj: noone,
		icon_spr: spr_opt_close,
		name: "Close",
		desc: "Changed your mind?\n\nYou can also press Z",
		arr_res_cost: ResCost( 0, 0, 0 ),
	},
	{
		tile_obj: obj_tile_elevator,
		icon_spr: spr_tile_elevator,
		name: "Elevator",
		desc: "",
		arr_res_cost: ResCost( 0, 0, 0 ),
	},
	{
		tile_obj: obj_tile_test,
		icon_spr: spr_tile_test,
		name: "Stone Wall",
		desc: "Solid, tough wall tile.",
		arr_res_cost: ResCost( 0, 6, 0 ),
	},
	{
		tile_obj: obj_tile_wood,
		icon_spr: spr_tile_wood,
		name: "Wood Wall",
		desc: "Defensive wall tile.",
		arr_res_cost: ResCost( 4, 0, 0 ),
	},
	{
		tile_obj: obj_tile_gun,
		icon_spr: spr_tile_gun,
		name: "Turret",
		desc: "Periodically shoots at enemies within its vision.\n\nCan shoot one layer above & below.",
		arr_res_cost: ResCost( 2, 2, 1 ),
	},
	{
		tile_obj: obj_tile_gun_heavy,
		icon_spr: spr_tile_heavy_gun,
		name: "Heavy Gun",
		desc: "Rapidly shoots at enemies within its vision.\n\nCan shoot one layer above & below.",
		arr_res_cost: ResCost( 2, 4, 6 ),
	},
	{
		tile_obj: obj_tile_alloy,
		icon_spr: spr_tile_alloy_wall,
		name: "Alloy Wall",
		desc: "Phew! Strong stuff...",
		arr_res_cost: ResCost( 0, 8, 2 ),
	},
	{
		tile_obj: obj_tile_buildsite,
		icon_spr: spr_tile_white,
		name: "Build Site",
		desc: "",
		arr_res_cost: ResCost( 0, 0, 0 ),
	},
];





///@desc returns true or false depending on if the thing can be afforded
function ResCanAfford(arr_res){
	for (var i = 0; i < array_length(arr_res); i++){
		if (obj_level.arr_res[i] < arr_res[i]) return false;
	}
	
	return true;
}



function TileHurt(tile, dmg){
	if (obj_level.tower_collapsing) return;
	if (!instance_exists(tile)) return;
	
	tile.hp -= dmg;
	
	if (tile.hp <= 0){
		TowerSetTileAt(tile.x, tile.y, tile.z, noone);
	}	
}


function TileGetDepth(py, pz){
	return (-py - pz / 8) - 2;
}