
global.opt_selector = {
	x:		0,
	y:		0,
	x2:		0,
	y2:		0,
	
	dx:		0,
	dy:		0,
	dx2:	0,
	dy2:	0,
};

global.nav_last_dir = 0;


function OptDraw(xx, yy, ww, hh, text, selected, fade){	
	//shadder
	DrawRectCol(xx + 2, yy + 2, ww, hh, c_black, fade);
	
	var _c_bg = #9AAAC1;
	if (selected){
		_c_bg = #9FD6DF;
		
		//push in
		if (keyboard_check(vk_enter) || keyboard_check(global.k_action)){
			xx ++;
			yy ++;
			_c_bg = #828DB3;
		}
		
		OptSelectorSetPos(xx, yy, xx + ww, yy + hh);
	}
	
	//box
	DrawRectCol(xx, yy, ww, hh, _c_bg, fade);
	//txt
	draw_set_halign(fa_center);
	DrawTextColourShadow(xx + ww / 2, yy + hh / 2 - 7, text, c_white, fade);
	draw_set_halign(fa_left);
}


function OptSelectorSetPos(x1, y1, x2, y2){
	global.opt_selector.x = x1;
	global.opt_selector.y = y1;
	global.opt_selector.x2 = x2;
	global.opt_selector.y2 = y2;
}


function OptSelectorDraw(){
	//selector
	var _wobble = sin(current_time / 180) / 2;
	draw_sprite(spr_ui_selector, 0, global.opt_selector.dx  + _wobble,	global.opt_selector.dy  + _wobble);
	draw_sprite(spr_ui_selector, 1, global.opt_selector.dx2 - _wobble,	global.opt_selector.dy  + _wobble);
	draw_sprite(spr_ui_selector, 2, global.opt_selector.dx  + _wobble,	global.opt_selector.dy2 - _wobble);
	draw_sprite(spr_ui_selector, 3, global.opt_selector.dx2 - _wobble,	global.opt_selector.dy2 - _wobble);
	
	global.opt_selector.dx = lerp(global.opt_selector.dx,	global.opt_selector.x, 0.25);
	global.opt_selector.dy = lerp(global.opt_selector.dy,	global.opt_selector.y, 0.25);
	global.opt_selector.dx2 = lerp(global.opt_selector.dx2, global.opt_selector.x2, 0.25);
	global.opt_selector.dy2 = lerp(global.opt_selector.dy2,	global.opt_selector.y2, 0.25);
}


function OptDoNav(sel_i, sel_min, sel_max, loop = false){	
	//no nav if selecting
	//if (keyboard_check(vk_enter) || keyboard_check(global.k_action)) return sel_i;
	
	var _sel_start = sel_i;
	
	if (keyboard_check_pressed(vk_up)){
		if (sel_i > sel_min){
			sel_i --;
		} else if (loop) {
			sel_i = sel_max-1;
		}
		global.nav_last_dir = -1;
	} else
	if (keyboard_check_pressed(vk_down)){
		if (sel_i < sel_max-1){
			sel_i ++;
		} else if (loop) {
			sel_i = sel_min;
		}
		global.nav_last_dir = 1;
	}
	
	if (_sel_start != sel_i){
		var _snd = audio_play_sound(sfx_menunav, 1, false, 2, 0, 1.3);
		audio_sound_set_track_position(_snd, 0.15);
	}	
	
	return sel_i;
}


function OptDoSelect(){
	if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(global.k_action)){
		var _snd = audio_play_sound(sfx_resget, 1, false, 0.4, 0, 0.4);
		audio_sound_set_track_position(_snd, 0.087);
	}
	
	if (keyboard_check_released(vk_enter) || keyboard_check_released(global.k_action)){
		var _snd = audio_play_sound(sfx_resget, 1, false, 0.4, 0, 0.6);
		audio_sound_set_track_position(_snd, 0.077);
		return true;
	}
	
	return false;
}