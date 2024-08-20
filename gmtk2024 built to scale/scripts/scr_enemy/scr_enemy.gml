
//global enemy state used by all enemies since our enemies are pretty simple
enum eEnemyState {
	ENTER_LEVEL,
	WALK_TO_POS,
	WALK_AWAY,
	FIND_TARGET,
	PREP_ATTACK,
	ATTACK,
}

function EnemyWaveStart() {
	with (obj_wave_controller) {
		show_debug_message("[WAVE] EnemyWaveStart");
		wave++;
		enemies = [];
		var _enemies = difficulty * irandom_range(1, 3);
		var _spawndist = irandom_range(80, 120);
		var _spawnangle = random_range(0, 2*pi);
		var _spawnx = _spawndist * cos(_spawnangle);
		var _spawny = _spawndist * sin(_spawnangle);
		repeat(_enemies) {
			var _enemy = instance_create_layer(_spawnx + irandom_range(-6,6), _spawny + irandom_range(-6,6), "instances", obj_goblin);
			array_push(enemies, _enemy);
		}
	}
}

function MoveToTarget(_target_x, _target_y) {
	var _dx = target_obj.x - x;
	var _dy = target_obj.y - y;
	var _mag = sqrt(power(_dx, 2) + power(_dy, 2));
	x = x + spd * (_dx/_mag);
	y = y + spd * (_dy/_mag);	
}

///@self par_enemy
function EnemyFindRandomGoPos(){
	var _tpos_x = irandom_range(-LEVEL_R + 1, 1 + LEVEL_R);
	var _tpos_y = irandom_range(1, 1 + LEVEL_R);
	
	//we're on the right
	if (x > 0){
		var _prevx = _tpos_x;
		_tpos_x = _tpos_y;
		_tpos_y = _prevx;
	}
	
	//no good if within tower bounds
	if (_tpos_x > 0 && _tpos_x <= TOWER_W && _tpos_y > 0 && _tpos_y <= TOWER_H){
		_tpos_x ++;
		_tpos_y ++;
	}

	var _ppos = IsoToPixel(_tpos_x, _tpos_y, 0);
	go_x = _ppos.x;
	go_y = _ppos.y;
}

///@self par_enemy
function EnemyGetTarget(z) {
	if (z > obj_level.tower_height) return noone;
	
	//we wanna attack our side of the tower
	var _check_l = false;
	if (x < 0) _check_l = true;
	var _tile = noone;
	
	var _tcheck = choose(0, 1);
		
	if (_check_l) _tile = TowerGetTileAt(_tcheck, 1, z);
	else		  _tile = TowerGetTileAt(1, _tcheck, z);
	
	if (instance_exists(_tile)) return _tile;
	
	//oop, try the other tile...
	if (_tcheck == 0) _tcheck = 1;
	else _tcheck = 0;
		
	if (_check_l) _tile = TowerGetTileAt(_tcheck, 1, z);
	else		  _tile = TowerGetTileAt(1, _tcheck, z);
	
	return _tile;
	
	/*
	var _closest = noone;
	var _d = infinity;
	for (var i = 0; i < array_length(obj_level.arr_tower_layers[z]); i++) {
		var _dist = distance_to_object(obj_level.arr_tower_layers[z][i]);
		if (instance_exists(obj_level.arr_tower_layers[z][i]) && obj_level.arr_tower_layers[z][i].id != obj_tile_elevator) {
			if (_dist < _d) {
				_d = _dist; 
				_closest = obj_level.arr_tower_layers[z][i];
			}
		}
	}
	return _closest;
	*/
}


function EnemyHurt(enemy, dmg, attacker = noone){
	
	enemy.hp -= dmg;
	
	
	if (enemy.hp <= 0){
		instance_destroy(enemy);
	}
}


function ItemResSpawn(xx, yy, zz, type, amount){
	var _inst = instance_create_layer(xx, yy, "Instances", obj_res);
	_inst.z = zz;
	_inst.image_index = type;
	_inst.depth = CharGetDepth(yy, zz);
	_inst.amount = amount;
	
	_inst.hspd = random_range(-0.5, 0.5);
	_inst.vspd = random_range(-0.5, 0.5);
	_inst.zspd = random_range(1, 2);
	
	ItemAddToLayer(_inst);
	
	return _inst;
}


function EnemyRemoveFromLayer(enemy){
	if (!instance_exists(enemy)) return;
	
	for (var i = array_length(obj_level.arr_layer_enemies[enemy.zlayer_i])-1; i >= 0; i--){
		//oops, we've trod on an item that doesn't exist?? remove
		if (!instance_exists(obj_level.arr_layer_enemies[enemy.zlayer_i][i])){
			array_delete(obj_level.arr_layer_enemies[enemy.zlayer_i], i, 1);
		}
		//we've found the guy! get rid...
		if (obj_level.arr_layer_enemies[enemy.zlayer_i][i].id == enemy.id) array_delete(obj_level.arr_layer_enemies[enemy.zlayer_i], i, 1);	
	}
	
	//invalidate my zlayer_i
	enemy.zlayer_i = -1;
}


function EnemyAddToLayer(enemy){
	if (!instance_exists(enemy)) return;
	var _layer_i = floor(enemy.tz);
	if (_layer_i < 0 || _layer_i > TOWER_Z_MAX) return;
	
	array_push(obj_level.arr_layer_enemies[_layer_i], enemy);
	
	enemy.zlayer_i = _layer_i;
}


function ItemRemoveFromLayer(item){
	if (!instance_exists(item)) return;
	
	for (var i = array_length(obj_level.arr_layer_items[item.zlayer_i])-1; i >= 0; i--){
		//oops, we've trod on an item that doesn't exist?? remove
		if (!instance_exists(obj_level.arr_layer_items[item.zlayer_i][i])){
			array_delete(obj_level.arr_layer_items[item.zlayer_i], i, 1);
		}
		//we've found the guy! get rid...
		if (obj_level.arr_layer_items[item.zlayer_i][i].id == item.id) array_delete(obj_level.arr_layer_items[item.zlayer_i], i, 1);	
	}
	
	//invalidate my zlayer_i
	item.zlayer_i = -1;
}


function ItemAddToLayer(item){
	if (!instance_exists(item)) return;
	var _layer_i = floor(item.z / TILE_V);
	if (_layer_i < 0 || _layer_i > TOWER_Z_MAX) return;
	
	array_push(obj_level.arr_layer_items[_layer_i], item);
	
	item.zlayer_i = _layer_i;
}


function WoRemoveFromLayer(worldobj){
	if (!instance_exists(worldobj)) return;
	
	for (var i = array_length(obj_level.arr_layer_wo[worldobj.zlayer_i])-1; i >= 0; i--){
		//oops, we've trod on an item that doesn't exist?? remove
		if (!instance_exists(obj_level.arr_layer_wo[worldobj.zlayer_i][i])){
			array_delete(obj_level.arr_layer_wo[worldobj.zlayer_i], i, 1);
		}
		//we've found the guy! get rid...
		if (obj_level.arr_layer_wo[worldobj.zlayer_i][i].id == worldobj.id) array_delete(obj_level.arr_layer_wo[worldobj.zlayer_i], i, 1);	
	}
	
	//invalidate my zlayer_i
	worldobj.zlayer_i = -1;
}


function WoAddToLayer(worldobj){
	if (!instance_exists(worldobj)) return;
	var _layer_i = floor(worldobj.tz);
	if (_layer_i < 0 || _layer_i > TOWER_Z_MAX) return;
	
	array_push(obj_level.arr_layer_wo[_layer_i], worldobj);
	
	worldobj.zlayer_i = _layer_i;
}


function ShootProj(obj_index, start_x, start_y, start_z, target_obj){
	//shoot bullet
	var _bullet = instance_create_layer(start_x, start_y, "Instances", obj_index);
	_bullet.z = start_z;
	_bullet.start_x = start_x;
	_bullet.start_y = start_y;
	_bullet.start_z = start_z;
	_bullet.target_obj = target_obj;
	
	return _bullet;
}