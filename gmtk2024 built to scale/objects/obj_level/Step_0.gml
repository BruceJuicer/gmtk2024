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




//tower is collasping!
if (tower_collapsing){
	tower_collapse_timer += 0.1;		
	
	for (var i = tower_collapse_z+1; i <= tower_height; i++){
		for (var j = 0; j < TOWER_W * TOWER_H; j++){
			var _tile = arr_tower_layers[i][j];
			if (!instance_exists(_tile)) continue;
			
			if (tower_collapse_timer >= 1){
				_tile.z = floor(_tile.z);
			} else {
				_tile.z -= 0.1;
			}
			
			_tile.dz = _tile.z * TILE_V;
			//_tile.depth = -(_tile.dy + 4) - _tile.z;
			_tile.depth = TileGetDepth(_tile.dy, _tile.dz);
		}
	}
	

	if (tower_collapse_timer >= 1){
		array_delete(arr_tower_layers, tower_collapse_z, 1);
		array_push(arr_tower_layers, array_create(TOWER_W * TOWER_H, noone));
		
		tower_height --;
		tower_collapsing = false;
	}
}