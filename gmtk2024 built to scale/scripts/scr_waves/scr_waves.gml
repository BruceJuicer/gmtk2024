
function WaveInfo(_min_z, _max_z) constructor {
	timer = 0;
	min_z = _min_z;
	max_z = _max_z;
}


///@self obj_level
function LevelTickWaves(){
	if (tower_height <= 0) return;
	
	floor_wave.timer --;
	if (tower_height >= air1_wave.min_z) air1_wave.timer --;
	if (tower_height >= air2_wave.min_z) air2_wave.timer --;
	
	
	
	//temp, spawn enemies on left for testing
	if (floor_wave.timer <= 0){
		show_debug_message("SPAWN growblin");
		var _enemy = instance_create_layer(-80, 40, "Instances", obj_e_gob_tosser);
		EnemyAddToLayer(_enemy);
		
		floor_wave.timer += 800;
	}
	
	
	
}