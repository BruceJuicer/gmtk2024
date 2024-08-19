MoveToTarget(target.x, target.y);
if (abs(target.x - x) < 2 || abs(target.y - y) < 2) {
	if (instance_exists(instance_target)) {
		TileHurt(instance_target, 1);
	}
	instance_destroy();	
}