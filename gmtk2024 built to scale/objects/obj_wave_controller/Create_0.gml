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