/// @description Init

z = 0;

dx = x;
dy = y;
dz = z;

hp = 6;

function OnHPDown() {
	if (hp <= 0) instance_destroy();	
}