MoveToTarget(target.x, target.y);
if (abs(target.x - x) < 2 || abs(target.y - y) < 2) {
	if (instance_exists(instance_target)) {
		instance_target.hp--;
		instance_target.OnHPDown();
	}
	instance_destroy();	
}