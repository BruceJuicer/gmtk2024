/// @description steppe

level_tick ++;


//spawn trees mb
if (level_tick % 900 == 860){
	if (instance_number(obj_wo_tree) < 4 + irandom(2)){
		var _rand_x = -LEVEL_R + irandom(LEVEL_R * 2);
		var _rand_y = -LEVEL_R + irandom(LEVEL_R * 2);
		
		if (_rand_x < 0 || _rand_x > TOWER_W || _rand_y < 0 || _rand_y > TOWER_H){
			var _ppos = IsoToPixel(_rand_x, _rand_y, 0);
			var _ntree = instance_nearest(_ppos.x, _ppos.y, par_wo);
			
			//don't be behind tower
			if (_ppos.y > TILE_H || _ppos.x < -TILE_W || _ppos.x > TILE_W){			
				if (!instance_exists(_ntree) || point_distance(_ppos.x, _ppos.y, _ntree.x, _ntree.y) > 16){
					var _tree = instance_create_layer(_ppos.x, _ppos.y + TILE_H/2, "Instances", obj_wo_tree);
					_tree.shake_amt = 2;
				}
			}
		}
		
	}
}


//waves
LevelTickWaves();


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