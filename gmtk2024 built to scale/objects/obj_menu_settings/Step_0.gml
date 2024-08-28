/// @description steppe

if (state == -1){
	fadein -= 0.25;
	if (fadein <= 0){
		if (instance_exists(obj_menu_pause)){
			obj_menu_pause.state = 0;
			obj_menu_pause.fadein = 0;
		} else {
			var _mm = instance_create_layer(0, 0, "Instances", obj_mm);
			_mm.opt_sel = 1;
		}
		instance_destroy();
	}
	
	return;
}

fadein = lerp(fadein, 1, 0.25);
opts_scroll_dy = lerp(opts_scroll_dy, opts_scroll_y, 0.2);


//don't run any input stuff for this time pls
if (ignore_until_key_release != 0){
	if (!keyboard_check(ignore_until_key_release)) ignore_until_key_release = 0;
	return;
}


if (!editing_bind){
	//nav
	opt_sel_last = opt_sel;
	opt_sel = OptDoNav(opt_sel, 0, array_length(arr_opts), true);	
	
	//skip labels
	if (arr_opts[opt_sel].type == eSettingOptType.LABEL){
		opt_sel	+= global.nav_last_dir;
	}
	
	//scroll
	if (global.nav_last_dir > 0 && opt_sel + opts_scroll_y >= 8) opts_scroll_y --;
	if (global.nav_last_dir < 0 && opt_sel + opts_scroll_y < 2) opts_scroll_y ++;
	
	//wrap scroll
	if (abs(opt_sel - opt_sel_last) > 3) opts_scroll_y = -(opt_sel - 6);
	
	opts_scroll_y = clamp(opts_scroll_y, -array_length(arr_opts), 0);
	
	//quit menu
	if (keyboard_check_pressed(vk_escape)){
		state = -1;
	}
	
	//Reset binds
	if (keyboard_check_pressed(vk_f2)){
		audio_play_sound(sfx_death, 1, false, 0.8, 0.1, 0.8);
		audio_play_sound(sfx_build, 1, false, 1, 0.03);
		InputSetDefaults();
		OptionsSet();
	}
	
} else {
	//we're editing binds!
	//escape!
	if (keyboard_check_pressed(vk_escape)){
		editing_bind = false;
		return;
	}
	
	if (keyboard_check_pressed(vk_anykey)){
		OptionsSetInput(opt_sel, keyboard_key);
		
		editing_bind = false;
		ignore_until_key_release = keyboard_key;
		return;
	}
}

//selecting opts
var _opt = arr_opts[opt_sel];

if (OptDoSelect()){
	if (_opt.type == eSettingOptType.BIND_CHANGE){
		editing_bind = !editing_bind;
	} else
	if (_opt.type == eSettingOptType.BUTTON){
		switch(opt_sel){
			case eSettingsOpts.BACK:
				state = -1;
			break;
			case eSettingsOpts.RESET_CONTROLS:
				InputSetDefaults();
				OptionsSet();
			break;
		}
	}
	
}

//sliders
if (_opt.type == eSettingOptType.SLIDER){
	var _slide_dir = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left);
	if (_slide_dir != 0){
		switch(opt_sel){
			case eSettingsOpts.AUDIO:
				var _gain = audio_get_master_gain(0) + _slide_dir * 0.1;
				_gain = clamp(_gain, 0, 2);
				audio_set_master_gain(0, _gain);
			
				_opt.value = string(round(_gain*100)) + "%";		
			break;
			case eSettingsOpts.ZOOM:
				var _zoom = global.s_zoom_scale + _slide_dir * 0.125;
				_zoom = clamp(_zoom, 1, 1.5);
				global.s_zoom_scale = _zoom;
				ScreenForceRefresh();
				
				_opt.value = string(200-round(global.s_zoom_scale*100)) + "%";
			break;
		}
	}
}
