/// @description steppe

depth = CharGetDepth(y, z);

x = lerp(start_x, target_x, move_time);
y = lerp(start_y, target_y, move_time);
z = lerp(start_z, target_z, move_time);

move_time += 0.05;

if (instance_exists(target_obj)){	
	target_x = target_obj.x;
	target_y = target_obj.y;
	target_z = target_obj.z + 0.33;
	
	//miss randomly
	if (move_time >= 0.1 && miss){
		target_x += irandom_range(-16, 16);
		target_y += irandom_range(-16, 16);
		//target_z = 0;
		target_obj = noone;
	}
	
	if (move_time >= 0.9){
		EnemyHurt(target_obj, dmg);
		instance_destroy();
	}
} else {
	if (move_time >= 3 || z <= 0){
		instance_destroy();
	}
}




//x += hspd;
//y += vspd;
//z += zspd;