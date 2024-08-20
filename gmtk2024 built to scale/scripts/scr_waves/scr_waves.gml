
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
	if (tower_height >= sky_wave.min_z + 1) sky_wave.timer --;
	if (tower_height >= space_wave.min_z + 2) space_wave.timer --;

	
	if (floor_wave.timer <= 0)		LevelSpawnWaveFloor();
	if (sky_wave.timer <= 0)		LevelSpawnWaveSky(sky_wave);
	if (space_wave.timer <= 0)		LevelSpawnWaveSky(space_wave);
	
	
	
}

///@self obj_level
function LevelSpawnWaveSky(wave_obj){
	var _enemy_count = LevelWaveGetEnemyCount(wave_obj.min_z, wave_obj.max_z);
	
	var _max_enemies = 2;
	if (tower_height >= wave_obj.max_z - 3) _max_enemies += 2;
		
	//too many enemies!
	if (_enemy_count > _max_enemies) {
		wave_obj.timer += 200;
		return;
	}
	
	var _spawn_amt = irandom(_max_enemies);
		
	for (var i = 0; i < _spawn_amt; i++){
		var _spos = WaveGetSpawnPos();		
		var _z = min(irandom_range(wave_obj.min_z, wave_obj.max_z), tower_height-1);
		
		var _enemy = instance_create_layer(_spos.x, _spos.y, "Instances", obj_e_gob_tosser);
		_enemy.tz = _z;
		_enemy.z = _z * TILE_V;
		EnemyAddToLayer(_enemy);
	}
	
	wave_obj.timer += irandom_range(800, 1200);
	wave_obj.waves_spawned ++;
}



///@self obj_level
function LevelSpawnWaveFloor(){	
	var _enemy_count = LevelWaveGetEnemyCount(0, 1);
	
	var _max_enemies = 1;
	if (tower_height >= 3) _max_enemies += 2;
	if (tower_height >= 5) _max_enemies += 1;
	
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
	
	if (sky_wave.timer <= 20) sky_wave.timer += 24;
	if (space_wave.timer <= 20) space_wave.timer += 32;
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