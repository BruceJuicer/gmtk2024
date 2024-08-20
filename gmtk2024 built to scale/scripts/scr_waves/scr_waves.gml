
function WaveInfo(_min_z, _max_z) constructor {
	timer = 96;
	waves_spawned = 0;
	min_z = _min_z;
	max_z = _max_z;
}


///@self obj_level
function LevelTickWaves(){
	if (tower_height <= 0) return;
	
	floor_wave.timer --;
	if (tower_height >= sky_wave.min_z) sky_wave.timer --;
	if (tower_height >= space_wave.min_z) space_wave.timer --;

	
	if (floor_wave.timer <= 0) LevelSpawnWaveFloor();
	
	
	
}

///@self obj_level
function LevelSpawnWaveSky(){
	
}



///@self obj_level
function LevelSpawnWaveFloor(){	
	var _enemy_count = LevelWaveGetEnemyCount(floor_wave.min_z, floor_wave.max_z);
	
	var _max_enemies = 2;
	if (tower_height >= 3) _max_enemies += 2;
	if (tower_height >= 5) _max_enemies += 2;
	
	//too many enemies!
	if (_enemy_count > _max_enemies) {
		floor_wave.timer += 200;
		return;
	}
	
	var _spawn_amt = irandom(_max_enemies);
		
	for (var i = 0; i < _spawn_amt; i++){
		var _spos = WaveGetSpawnPos();
		
		var _enemy = instance_create_layer(_spos.x, _spos.y, "Instances", obj_e_gob_tosser);
		EnemyAddToLayer(_enemy);
	}
		
	floor_wave.timer += irandom_range(740, 920);
	floor_wave.waves_spawned ++;
}


///@self obj_level
function LevelWaveGetEnemyCount(z_min, z_max){
	var _amt = 0;
	for (var i = z_min; i < z_max; i++){
		_amt += array_length(arr_layer_enemies[i]);
	}
	return _amt;
}


function WaveGetSpawnPos(){
	var _spawn_angle = -irandom(180);
		
	var _dist = irandom_range(80, 96);
	var _spawn_x = lengthdir_x(_dist, _spawn_angle);
	var _spawn_y = lengthdir_y(_dist, _spawn_angle);
	
	return { x: _spawn_x, y: _spawn_y };
}