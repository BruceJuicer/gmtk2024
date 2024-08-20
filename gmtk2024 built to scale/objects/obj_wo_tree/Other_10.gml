/// @description on hit

ItemResSpawn(x, y, 12 + irandom(7), eRes.WOOD, 1);

audio_play_sound(sfx_wood, 0, 0, random_range(0.85,1.0), 0, random_range(0.85,1.15));	

hp --;

if (hp <= 0){
	instance_destroy();
}

shake_amt = 2;