
switch (state) {
	case eWaveState.PEACE:
		if (cooldown <= 0) {
			state = eWaveState.FIGHT;
			EnemyWaveStart();
		}
		else cooldown--;
	break;
}