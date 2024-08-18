
#macro TILE_W 24
#macro TILE_H 12 
#macro TILE_V 13

/*
enum eTileType {
	NONE,
	
}

function Tile() constructor {
	type = eTileType.NONE;
	
}
*/



///@desc returns true or false depending on if the thing can be afforded
function ResCanAfford(arr_res){
	for (var i = 0; i < array_length(arr_res); i++){
		if (obj_level.arr_res[i] < arr_res[i]) return false;
	}
	
	return true;
}