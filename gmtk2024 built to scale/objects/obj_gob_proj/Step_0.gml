MoveToTarget(target_obj.x, target_obj.y);
if (abs(target_obj.x - x) < 2 || abs(target_obj.y - y) < 2) {
	if (instance_exists(instance_target)) {
		TileHurt(instance_target, 1);
	}
	instance_destroy();	
}