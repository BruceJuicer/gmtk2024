/// @description steppe

tick ++;

if (tick >= 180){
	//check for enemies in my sight
	for (var i = 0; i < instance_number(par_enemy); i++){
		var _enemy = instance_find(par_enemy, i);
		if (_enemy.z < z - 1 || _enemy.z > z + 1) continue;
		//guys gotta be in our quadrant
		if (_enemy.tx < -LEVEL_R + x * 4) continue;
		if (_enemy.ty < -LEVEL_R + y * 4) continue;
		if (_enemy.tx > x * 4) continue;
		if (_enemy.ty > y * 4) continue;
		
		ShootProj(obj_proj_gbeam, dx, dy, dz, _enemy);		
		audio_play_sound(sfx_arrow, 0, 0, random_range(0.7,0.9), 0, random_range(0.85,1.1));
		break;
	}
	
	
	tick -= 180;
}