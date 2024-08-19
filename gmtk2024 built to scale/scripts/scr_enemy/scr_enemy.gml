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
	var _dx = target.x - x;
	var _dy = target.y - y;
	var _mag = sqrt(power(_dx, 2) + power(_dy, 2));
	x = x + spd * (_dx/_mag);
	y = y + spd * (_dy/_mag);	
}

function EnemyGetTarget() {
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
}


function EnemyHurt(enemy, dmg, attacker = noone){
	
	enemy.hp -= dmg;
	
	
	if (enemy.hp <= 0){
		instance_destroy(enemy);
	}
}