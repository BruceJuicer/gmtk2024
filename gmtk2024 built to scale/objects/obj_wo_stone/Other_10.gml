/// @description on hit

ItemResSpawn(x, y, 12 + irandom(7), eRes.STONE, 1);

hp --;

if (hp <= 0){
	instance_destroy();
}

shake_amt = 2;