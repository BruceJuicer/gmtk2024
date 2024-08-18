
#macro P_JETPACK_MAX 120

enum ePlayerState {
	IDLE,
	ELEVATOR,
	
}


///@self obj_player
function PlayerTickElevator(){
	var _m_up	 = keyboard_check(vk_up);
	var _m_down  = keyboard_check(vk_down);
	
	//put player in elevator
	var _ppos = IsoToPixel(0, 0, 0);
	obj_player.x = _ppos.x;
	obj_player.y = _ppos.y + 4;
	
	if (_m_down){
		if (obj_player.z > 0) obj_player.z -= 1;
		else obj_player.z = 0;
	}
	
	if (_m_up){
		if (obj_player.z < obj_level.tower_height * TILE_V) obj_player.z += 1;
		else obj_player.z = obj_level.tower_height * TILE_V;
	}	
	
	//leave
	if (keyboard_check_pressed(ord("Z"))){
		obj_player.state = ePlayerState.IDLE;
		
		//leave ele
		var _ppos = IsoToPixel(2, 2, 0);
		obj_player.x = _ppos.x;
		obj_player.y = _ppos.y + 4;	
		obj_player.hspd = 0;
		obj_player.vspd = 0.5;

		obj_player.z = floor(obj_player.z / TILE_V) * TILE_V;
	}	
}


///@self obj_player
function PlayerTickIdle(){
	depth = CharGetDepth(y, z);

	var _tile_z = floor(tz - 0.5);
	var _tile_at_feet =	TowerGetTileAt(tx, ty, _tile_z);

	//get the tile we're gonna build at	
	//tbuild_x = tx;
	//tbuild_y = ty;
	
	/*
	var _tpos_f = PixelToIsoSub(x + xdir * 2, y);
	
	if (floor(_tpos_f.x - 0.4) != tx)	   tbuild_x = floor(_tpos_f.x - 0.4);
	else if (floor(_tpos_f.x + 0.4) != tx) tbuild_x = floor(_tpos_f.x + 0.4);
	else if (floor(_tpos_f.y - 0.4) != ty) tbuild_y = floor(_tpos_f.y - 0.4);
	else if (floor(_tpos_f.y + 0.4) != ty) tbuild_y = floor(_tpos_f.y + 0.4);
	*/
	
	//temp, build
	if (keyboard_check_pressed(ord("X")) && build_in_tower_bounds){
		TowerSetTileAt(tbuild_x, tbuild_y, tz, obj_tile_test);
	}
	
	
	
	//are we within the towers bounds?
	in_tower_bounds = true;
	if (tx < 0 || tx >= TOWER_W || ty < 0 || ty >= TOWER_H) in_tower_bounds = false;

	//are we building within the towers bounds?
	build_in_tower_bounds = true;
	if (tbuild_x < 0 || tbuild_x >= TOWER_W || tbuild_y < 0 || tbuild_y >= TOWER_H) build_in_tower_bounds = false;


	if (in_tower_bounds){
		//entered a block?
		//if (onground && TowerGetTileAt(tx, ty, tz) != noone){
		//	state = ePlayerState.ELEVATOR;
		//}
		if (keyboard_check_pressed(ord("Z"))){
			state = ePlayerState.ELEVATOR;
		}
	}	
	
	//------------------------------------------------------------------------------------------------//
	// movement
	//----------------------------------------------------------------------------------------------//

	var _m_up	 = keyboard_check(vk_up);
	var _m_down  = keyboard_check(vk_down);
	var _m_left  = keyboard_check(vk_left);
	var _m_right = keyboard_check(vk_right);

	//var _maxspd = 1;
	var _move_acc = 0.25;
	var _fric = 0.8; //0.08;

	var _moveDirX = 0;
	var _moveDirY = 0;

	if (_m_left){
		_moveDirX += lengthdir_x(1,180);
		_moveDirY += lengthdir_y(1,180);
		xdir = -1;
	}
	if (_m_right){
		_moveDirX += lengthdir_x(1,0);
		_moveDirY += lengthdir_y(1,0);
		xdir = 1;
	}
	if (_m_up){
		_moveDirX += lengthdir_x(1,90);
		_moveDirY += lengthdir_y(1,90);
	}
	if (_m_down){
		_moveDirX += lengthdir_x(1,270);
		_moveDirY += lengthdir_y(1,270);
	}

	if (point_distance(0,0,_moveDirX,_moveDirY) > 0){
		var _dir = point_direction(0,0,_moveDirX,_moveDirY);
	
		hspd += lengthdir_x(_move_acc, _dir);
		vspd += lengthdir_y(_move_acc, _dir);
	}

	hspd *= _fric;
	vspd *= _fric;

	/*
	if (!_m_left && !_m_right){	
		if (hspd < -_fric) hspd += _fric;
		else if (hspd > _fric) hspd -= _fric;
		else hspd = 0;	
	
		//hspd *= 0.8;
	}

	if (!_m_down && !_m_up){	
		if (vspd < -_fric) vspd += _fric;
		else if (vspd > _fric) vspd -= _fric;
		else vspd = 0;
	
		//vspd *= 0.8;
	}
	*/

	//gravity & jetpack
	if (jetpack_fuel <= 0){
		if (zspd > -2) zspd -= 0.1;
	}

	if (!onground) jetpack_fuel --;
	else jetpack_fuel = P_JETPACK_MAX;


	//------------------------------------------------------------------------------------------------//
	// collision
	//----------------------------------------------------------------------------------------------//

	x += hspd;



	y += vspd;



	//get floor z
	floor_z = 0;
	if (_tile_at_feet != noone){
		floor_z = _tile_at_feet.dz + TILE_V;
	}


	//hit floor
	onground = false;

	if (zspd <= 0 && z + zspd <= floor_z){
		z = floor_z;
		zspd = 0;
	
		onground = true;
	}

	z += zspd;
}