/*
for (var i = 0; i < array_length(obj_wave_controller.enemies); i++) {
	if (instance_exists(obj_wave_controller.enemies[i])) {
		if (obj_wave_controller.enemies[i].id == self.id) {
			array_delete(obj_wave_controller.enemies, i , 1);
			obj_wave_controller.OnEnemyDeath();
		}
	}
}

OnDeath();
*/


repeat(min(1 + irandom(1 + floor(tz/2)), 6)){
	ItemResSpawn(x, y, z, irandom(2), 1 + irandom(1));
}

EnemyRemoveFromLayer(id);