
MoveToTarget(target.x, target.y);
if (abs(target.x - x) < 2 || abs(target.y - y) < 2) {
	target.hp--;
	target.OnHPDown();
	instance_destroy();	
}