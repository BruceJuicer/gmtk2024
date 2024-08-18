/// @description steppe


//see if we need to increase tower size
var _layer_full = true;
for (var i = 0; i < TOWER_W * TOWER_H; i++){
	if (!instance_exists(arr_tower_layers[tower_height][i])){
		_layer_full = false;
		break;
	}
}

if (_layer_full){
	tower_height ++;
	TowerSetTileAt(0, 0, tower_height, obj_tile_elevator);
}