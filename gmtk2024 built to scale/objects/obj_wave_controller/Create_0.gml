enum eWaveState {
	PEACE,
	FIGHT
}

wave = 0;
difficulty = 1;
tick = 0;
state = eWaveState.PEACE;
cooldown = 300;
enemies = [];

function OnEnemyDeath() {
	if (array_length(enemies) <= 0) {
		cooldown = 600;
		difficulty++;
		state = eWaveState.PEACE;
	}
}