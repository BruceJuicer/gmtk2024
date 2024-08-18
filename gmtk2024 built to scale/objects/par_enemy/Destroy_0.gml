for (var i = 0; i < array_length(obj_wave_controller.enemies); i++) {
	if (instance_exists(obj_wave_controller.enemies[i])) {
		if (obj_wave_controller.enemies[i].id == self.id) {
			array_delete(obj_wave_controller.enemies, i , 1);
			obj_wave_controller.OnEnemyDeath();
		}
	}
}

OnDeath();