depth = -y-z;

if (target != noone) {
	if (x >= target.x) x--;
	else x++;
	if (y > target.y) y--;
	else y++;
	
	if (abs(x - target.x) < 2 && abs(y - target.y) < 2) target = noone;
} else {
	x *= 1.015;
	y *= 1.015;
}



