
#macro P_JETPACK_MAX 200

enum ePlayerState {
	FROZEN,
	IDLE,
	ELEVATOR,
	SPINJUMP,
}


enum ePlayerContext {
	BUILD,
	MINE,
	DESTROY,
}


///@self obj_player
function PlayerTickElevator(){
	var _m_up	 = keyboard_check(vk_up);
	var _m_down  = keyboard_check(vk_down);

	//put player in elevator
	var _ppos = IsoToPixel(0, 0, 0);
	x = lerp(x, _ppos.x, 0.4);
	y = lerp(y, _ppos.y + 4, 0.4);

	floor_z = tz;
	onground = false;

	build_in_tower_bounds = false;

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

	var _k_use_p = keyboard_check_pressed(ord("Z"));
	var _k_use_h = keyboard_check(ord("Z"));
	var _k_act_p = keyboard_check_pressed(ord("X"));

	//find the nearest tile under us
	for (var i = _tile_z; i >= 0; i--){
		_tile_at_feet = TowerGetTileAt(tx, ty, i);
		if (instance_exists(_tile_at_feet)) break;
	}

	//are we within the towers bounds?
	in_tower_bounds = true;
	if (tx < 0 || tx >= TOWER_W || ty < 0 || ty >= TOWER_H) in_tower_bounds = false;


	tbuild_x = tx;
	tbuild_y = ty;

	//get the tile we're gonna build at	if outside tower
	if (!in_tower_bounds){
		var _tsub = PixelToIsoSub(x, y);

		if (_tsub.x > -0.6 && _tsub.y > -0.6 && _tsub.x < TOWER_W + 0.6 && _tsub.y < TOWER_H + 0.6){
			tbuild_x = floor(clamp(_tsub.x, 0, TOWER_W-1));
			tbuild_y = floor(clamp(_tsub.y, 0, TOWER_H-1));
		}

	}

	//are we building within the towers bounds?
	build_in_tower_bounds = true;
	if (tbuild_x < 0 || tbuild_x >= TOWER_W || tbuild_y < 0 || tbuild_y >= TOWER_H) build_in_tower_bounds = false;

	image_speed = 0;

	//the tile we may be stood inside
	build_blocked = false;
	var _tile_at_buildpos = TowerGetTileAt(tbuild_x, tbuild_y,  floor(tz + 0.25));
	if (instance_exists(_tile_at_buildpos) || !onground || !build_in_tower_bounds) build_blocked = true;


	//build
	if (!build_blocked){
		//build a tile
		context_i = ePlayerContext.BUILD;
		if (_k_act_p){
			state = ePlayerState.FROZEN;
			instance_create_layer(0, 0, "Instances", obj_ui_buildopts);
		}
	} else if (instance_exists(_tile_at_buildpos) && (tbuild_x != 0 || tbuild_y != 0)){
		if (_tile_at_buildpos.type != eTileType.BUILDSITE){
			//remove a tile
			context_i = ePlayerContext.MINE;
			if (_k_act_p){
				//dmg tile
				if (_tile_at_buildpos.hp > 1){
					TileHurt(_tile_at_buildpos, _tile_at_buildpos.hp - 1);
				} else {
					//refund player
					var _tileinfo = global.arr_tileinfo[_tile_at_buildpos.type];
					for (var i = 0; i < array_length(_tileinfo.arr_res_cost); i++){
						if (_tileinfo.arr_res_cost[i] <= 0) continue;
						var _inst = ItemResSpawn(_tile_at_buildpos.dx + irandom_range(-TILE_W, TILE_W)/2, _tile_at_buildpos.dy + TILE_H / 2, _tile_at_buildpos.dz, i, _tileinfo.arr_res_cost[i]);
						_inst.frozen = true;
					}
					TileHurt(_tile_at_buildpos, 1);
				}
			}
		}
	}


	//enter ele
	if (in_tower_bounds){
		if (_k_use_p){
			state = ePlayerState.ELEVATOR;
			//entered a block?
			//if (onground && TowerGetTileAt(tx, ty, tz) != noone){
			//	state = ePlayerState.ELEVATOR;
			//}
		}
	} else {
		//drop with jetpack
		if (_k_use_h){
			//jetpack_fuel = 0;
			z = floor(z - 1);
		}
	}

	//------------------------------------------------------------------------------------------------//
	// world objects
	//----------------------------------------------------------------------------------------------//
	var _wobj = WoGetInRange(x, y, tz, 12);

	if (instance_exists(_wobj)){
		context_i = ePlayerContext.MINE;

		if (_k_act_p){
			with(_wobj) event_user(0);
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
			if (!audio_is_playing(sfx_jetpack)) {
				var _p = random_range(0.9, 1.1) * (max(0.3, jetpack_fuel/P_JETPACK_MAX));
				audio_play_sound(sfx_jetpack, 0, 0, random_range(0.9,1.0), 0, _p);
			}

			//settle on layer
			if (z > floor(tz) * TILE_V){
				z -= 1;
			}

			if (jetpack_fuel % 8 == 0){
				var _fx = FxMisc(noone, x, y, z, depth + 2, 20, eFxFlags.POS_DEPTH);
				FxSetSpr(_fx, spr_proj_gbeam, 0, 1, 1, 1, #8080C0, 1);
				FxSetMotion(_fx, 0, 0, -1, 0.8, 0);
			}

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

	var _tsub = PixelToIsoSub(x, y);
	var _tile_l = (-LEVEL_R - _tsub.y) * (TILE_W / 2);
	var _tile_r = (TOWER_W + LEVEL_R - _tsub.y) * (TILE_W / 2);

	obj_player.x = clamp(obj_player.x, _tile_l, _tile_r);

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

	var _tile_t = (_tsub.x + -LEVEL_R) * (TILE_H / 2);
	var _tile_b = (_tsub.x + TOWER_H + LEVEL_R) * (TILE_H / 2);

	obj_player.y = clamp(obj_player.y, _tile_t, _tile_b);


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

function PlayerTickPickupRes() {
	var _layer_top = min(floor(obj_player.tz) + 1, TOWER_Z_MAX);
	var _layer_bot = max(floor(obj_player.tz) - 1, 0);

	//get all items on layers
	for (var i = _layer_bot; i < _layer_top; i++){
		for (var j = array_length(obj_level.arr_layer_items[i])-1; j >= 0; j--){
			var _item = obj_level.arr_layer_items[i][j];
			if (!instance_exists(_item)) continue;
			if (!_item.frozen) continue;

			if (_item.x < x - 8) continue;
			if (_item.y < y - 8) continue;
			if (_item.x > x + 8) continue;
			if (_item.y > y + 8) continue;

			//fx
			var _fx = FxMisc(noone, _item.x, _item.y, _item.z, -2048, 10, 0x00);
			FxSetSpr(_fx, spr_res_icons, _item.image_index, 0, 1, 1, #FFFF80, 0.8);
			FxSetMotion(_fx, 0, 0, 1.5, 0.9, 0);
			_fx.fade_spd = 0.1;

			obj_level.arr_res[_item.image_index] += _item.amount;
			instance_destroy(_item);
			audio_play_sound(sfx_resget, 0, 0, random_range(0.75,0.9), 0, random_range(0.8, 0.9));
		}
	}
}
