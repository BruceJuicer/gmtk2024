/// @description steppe

width = floor(global.vieww / 1.5);
height = floor(global.viewh / 2);
x = global.vieww / 2 - width / 2;
y = 24 - (1 - fadein) * height;

opts_x = x + (width / 2) - (array_length(arr_build_opts) / 2) * opts_spacing;


if (state == -1){
	fadein -= 0.15;
	if (fadein <= 0) instance_destroy();
	return;
}


fadein = lerp(fadein, 1, 0.33);


hov_opt_dx = lerp(hov_opt_dx, hov_opt, 0.33);


var _nav_l = keyboard_check_pressed(vk_left);
var _nav_r = keyboard_check_pressed(vk_right);
var _nav_sel = keyboard_check_pressed(ord("X"));
var _nav_close = keyboard_check_pressed(ord("Z"));


if (_nav_l){
	hov_opt --;
	if (hov_opt < 0){
		hov_opt = array_length(arr_build_opts)-1;
		hov_opt_dx = array_length(arr_build_opts) - 0.5;
	}
}

if (_nav_r){
	hov_opt ++;
	if (hov_opt >= array_length(arr_build_opts)){
		hov_opt = 0;
		hov_opt_dx = -0.5;
	}
}

if (_nav_sel){
	if (hov_opt == 0){
		obj_player.state = ePlayerState.IDLE;
		state = -1;
	} else {				
		if (ResCanAfford(arr_build_opts[hov_opt].arr_res_cost)){
			//buy tile
			for (var i = 0; i < array_length(arr_build_opts[hov_opt].arr_res_cost); i++){
				obj_level.arr_res[i] -= arr_build_opts[hov_opt].arr_res_cost[i];
			}
			
			//spawn tile
			TowerSetTileAt(obj_player.tbuild_x, obj_player.tbuild_y, floor(obj_player.tz), arr_build_opts[hov_opt].tile_obj);

			//player do jumpy
			obj_player.zspd = 2;
			obj_player.state = ePlayerState.SPINJUMP;
			
			state = -1;
		} else {
			//can't afford!!
			
		}
	}
}

if (_nav_close){
	obj_player.state = ePlayerState.IDLE;
	state = -1;
}