
#macro P_JETPACK_MAX 120

enum ePlayerState {
	FROZEN,
	IDLE,
	ELEVATOR,
	SPINJUMP,
}


///@self obj_player
function PlayerTickElevator(){
	var _m_up	 = keyboard_check(vk_up);
	var _m_down  = keyboard_check(vk_down);
	
	//put player in elevator
	var _ppos = IsoToPixel(0, 0, 0);
	x = _ppos.x;
	y = _ppos.y + 4;
	
	floor_z = tz;
	onground = true;
	
	if (_m_down){
		if (z > 0) z -= 2;
		else z = 0;
	}
	
	if (_m_up){
		if (z < obj_level.tower_height * TILE_V) z += 2;
		else z = obj_level.tower_height * TILE_V;
	}	
	
	//leave
	if (keyboard_check_pressed(ord("Z"))){
		state = ePlayerState.IDLE;

		y += 2;
		hspd = 0;
		vspd = 0;
		zspd = 0;
	}	
}


///@self obj_player
function PlayerTickIdle(){
	var _tile_z = floor(tz - 0.5);
	var _tile_at_feet =	noone;//TowerGetTileAt(tx, ty, _tile_z);
	
	//find the nearest tile under us
	for (var i = _tile_z; i >= 0; i--){
		_tile_at_feet = TowerGetTileAt(tx, ty, i);
		if (instance_exists(_tile_at_feet)) break;
	}
	
	//are we within the towers bounds?
	in_tower_bounds = true;
	if (tx < 0 || tx >= TOWER_W || ty < 0 || ty >= TOWER_H) in_tower_bounds = false;

	//are we building within the towers bounds?
	build_in_tower_bounds = true;
	if (tbuild_x < 0 || tbuild_x >= TOWER_W || tbuild_y < 0 || tbuild_y >= TOWER_H) build_in_tower_bounds = false;	
	
	image_speed = 0;

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
	
	//the tile we may be stood inside
	build_blocked = false;
	var _tile_at_body = TowerGetTileAt(tx, ty,  floor(tz + 0.25));
	if (instance_exists(_tile_at_body) || !onground || !build_in_tower_bounds) build_blocked = true;
	
	//build
	if (keyboard_check_pressed(ord("X"))){		
		if (!build_blocked){
			//TowerSetTileAt(tbuild_x, tbuild_y, floor(tz), obj_tile_test);
			state = ePlayerState.FROZEN;
			instance_create_layer(0, 0, "Instances", obj_ui_buildopts);
			//zspd = 2;
			//z += TILE_V;
		} else {
			//dmg tile (todo: and give refund after please)
			TileHurt(_tile_at_body, 2);
		}
	}
	
	//temp, destroy
	if (onground && keyboard_check_pressed(vk_delete) && build_in_tower_bounds){
		TowerSetTileAt(tbuild_x, tbuild_y, floor(tz), noone);
	}

	
	if (keyboard_check_pressed(ord("Z"))){
		if (in_tower_bounds){
			state = ePlayerState.ELEVATOR;
			//entered a block?
			//if (onground && TowerGetTileAt(tx, ty, tz) != noone){
			//	state = ePlayerState.ELEVATOR;
			//}
		} else {
			jetpack_fuel = 0;
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
		ydir = -1;
	}
	if (_m_down){
		_moveDirX += lengthdir_x(1,270);
		_moveDirY += lengthdir_y(1,270);
		ydir = 1;
	}
	
	var _mdist = point_distance(0,0,_moveDirX,_moveDirY);

	if (_mdist > 0){
		var _dir = point_direction(0,0,_moveDirX,_moveDirY);
	
		hspd += lengthdir_x(_move_acc, _dir);
		vspd += lengthdir_y(_move_acc, _dir);
	}

	hspd *= _fric;
	vspd *= _fric;
	
	if (_mdist <= 0 || !onground){
		image_index = 1-onground;
	} else {
		image_speed = 1;
	}

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


	var _use_jetpack = true;
	if (state == ePlayerState.SPINJUMP || in_tower_bounds) _use_jetpack = false;

	//gravity & jetpack
	if (jetpack_fuel <= 0 || !_use_jetpack){
		if (zspd > -2) zspd -= 0.1;
	}

	if (!onground && _use_jetpack){
		if (jetpack_fuel > 0){
			jetpack_fuel --;
			zspd = 0;
		}
	} else {
		jetpack_fuel = P_JETPACK_MAX;
	}


	//------------------------------------------------------------------------------------------------//
	// collision
	//----------------------------------------------------------------------------------------------//
	/*
	var _xcheck = x - 2;
	if (hspd > 0) _xcheck = x + 2;
	
	var _tsub = PixelToIsoSub(_xcheck + hspd, y);
	var _tcol = TowerGetTileAt(floor(_tsub.x), floor(_tsub.y), tz);
	
	if (instance_exists(_tcol) && (floor(_tsub.x) != tx || floor(_tsub.y) != ty)){
		var _sy = 1;
		if (y < _tcol.dy + TILE_H/2) _sy = -1;
		
		vspd += abs(hspd / 2) * _sy;
		
		hspd = 0;
	}
	*/
	
	x += hspd;

	/*
	var _ycheck = y - 2;
	if (vspd > 0) _ycheck = y + 2;

	_tsub = PixelToIsoSub(x, _ycheck + vspd);
	_tcol = TowerGetTileAt(floor(_tsub.x), floor(_tsub.y), tz);
	
	if (instance_exists(_tcol) && (floor(_tsub.x) != tx || floor(_tsub.y) != ty)){
		var _sx = 1;
		if (x < _tcol.dx) _sx = -1;
		
		hspd += abs(vspd) * _sx;

		vspd = 0;
	}
	*/

	y += vspd;



	//get floor z
	floor_z = 0;
	if (instance_exists(_tile_at_feet)){
		floor_z = _tile_at_feet.dz + TILE_V;
	}


	//hit floor
	onground = false;

	if (zspd <= 0 && z + zspd <= floor_z){
		z = floor_z;
		zspd = 0;
	
		onground = true;
		if (state == ePlayerState.SPINJUMP) state = ePlayerState.IDLE;
	}

	z += zspd;
}

function PickupRes() {
	var _res = instance_nearest(x, y, obj_res);
	if (_res != noone && distance_to_object(_res) < 2) {
		obj_level.arr_res[_res.image_index]++;
		instance_destroy(_res);
	}
}