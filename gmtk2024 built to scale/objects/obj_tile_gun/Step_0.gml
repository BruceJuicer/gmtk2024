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
		
		//shoot bullet
		var _bullet = instance_create_layer(dx, dy, "Instances", obj_proj_gbeam);
		_bullet.z = dz;
		_bullet.start_x = x;
		_bullet.start_y = y;
		_bullet.start_z = _bullet.z;
		_bullet.target_obj = _enemy;
		break;
	}
	
	
	tick -= 180;
}