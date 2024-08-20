/// @description steppe

// Inherit the parent event
event_inherited();


switch(state){
	case eEnemyState.ENTER_LEVEL:
		state = eEnemyState.FIND_TARGET;
	break;
	case eEnemyState.WALK_TO_POS:	
		var _xdist = abs(x - go_x);
		var _ydist = abs(y - go_y);
	
		//we've arrived!
		if (_xdist < 4 && _ydist < 4){
			//wait a little bit
			substate --;
			
			if (substate <= 0){
				if (!instance_exists(target_obj)) state = eEnemyState.FIND_TARGET;
				else state = eEnemyState.PREP_ATTACK;	
			}
			break;
		}
	
		var _godir = point_direction(x, y, go_x, go_y);
	
		if (_xdist > 2) x += lengthdir_x(0.5, _godir);
		if (_ydist > 2) y += lengthdir_y(0.5, _godir);		
	break;
	case eEnemyState.WALK_AWAY:
		y ++;
		if (y >= 180) instance_destroy();
	break;
	case eEnemyState.FIND_TARGET:
		target_obj = EnemyGetTarget(z + irandom(2));
		
		//walk away if we can't find a target...
		if (!instance_exists(target_obj)){
			find_target_tries --;
			if (find_target_tries <= 0) state = eEnemyState.WALK_AWAY;
		} else {
			find_target_tries ++;
		}
			
		EnemyFindRandomGoPos();
		substate = 8 + irandom(40);
		state = eEnemyState.WALK_TO_POS;
	break;
	case eEnemyState.PREP_ATTACK:
		if (!instance_exists(target_obj)){
			state = eEnemyState.FIND_TARGET;
			break;
		}
		
		substate ++;
		if (substate >= 32){
			state = eEnemyState.ATTACK;
			substate = 0;
		}
	break;
	case eEnemyState.ATTACK:
		//attack
		if (substate == 0){
			ShootProj(obj_eproj_rock, x, y, z + 6, target_obj);
		}
		
		//wait
		substate ++;
		if (substate >= 24){
			substate = 8 + irandom(40);
			state = eEnemyState.WALK_TO_POS;
		}		
	break;
}