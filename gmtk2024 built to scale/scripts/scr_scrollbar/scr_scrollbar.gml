global.scrollbar_active = noone;

function ScrollBar(_scroll_max = 0, _scroll_interval = 100, _interactive = true) constructor {
	x = 0;
	y = 0;
	w = 0;
	h = 0;
	iw = 0;
	ih = 0;
	interactive = _interactive;
	initial_mouse_y = -1;
	sby = 0;
	tsby = 0;
	sbh = 0;
	tsbh = 0;
	scroll = 0;
	scroll_target = 0;
	scroll_max = _scroll_max;
	prev_max_scroll = 0;
	scroll_interval = _scroll_interval;
	hovering = false;
}

function ScrollBarSizeUpdate(_s, _new_scroll_max) {
	if (_new_scroll_max <= 0) {
		_s.tsbh = _s.h;
		_s.scroll_target = 0;
		return;
	}
	
	if (_new_scroll_max < _s.scroll_target) _s.scroll_target = _new_scroll_max;
	
	_s.tsbh = _s.h * (_s.h / (_s.h + _s.scroll_max));
}

function ScrollBarTick(_s, _max_scroll, _drx, _dry, _drw, _drh, _iaw = _drw, _iah = _drh, _iax = _drx, _iay = _dry) {
	_s.x = _drx;
	_s.y = _dry;
	_s.w = _drw;
	_s.h = _drh;
	_s.iw = _iaw;
	_s.ih = _iah;
	
	if (_s.sby < _s.y) _s.sby = _s.y;
	
	var _lspd = global.scrollbar_active == _s ? 0.9 : 0.2;
	_s.sbh = lerp(_s.sbh, _s.tsbh, _lspd);
	_s.sby = lerp(_s.sby, _s.tsby, _lspd);
	_s.scroll = lerp(_s.scroll, _s.scroll_target, _lspd);
	
	// use the draw area bounds for click'n'drag
	if (_s.interactive) {
		 
		//There's a couple pixels of leeway at each edge to click
		if (point_in_rectangle(mouse_x, mouse_y, _drx - 2, _dry - 2, _drx + _drw + 4, _dry + _drh + 4)) {
			if (mouse_check_button_pressed(mb_left)) {
				// Reset on mb release
				if (_s.initial_mouse_y == -1) _s.initial_mouse_y = mouse_y - _s.tsby;
			}
			_s.hovering = true;
			global.scrollbar_active = _s;
		} else _s.hovering = false;
		
		if (mouse_check_button(mb_left)) {
			if (_s.initial_mouse_y != -1) {
				// click and drag
				var _sf = _s.scroll_max / (_s.h - _s.tsbh);
				var _diff = (_s.initial_mouse_y - (mouse_y - _s.tsby)) * _sf; 
				if (_diff > 0) _s.scroll_target = max(0, _s.scroll_target - _diff);
				else if (_diff < 0) _s.scroll_target = min(_s.scroll_max, _s.scroll - _diff);
			}
		} 
		else {
			_s.initial_mouse_y = -1;
			global.scrollbar_active = noone;
		}
	}
	
	// general scroll area
	if (_s.initial_mouse_y == -1 && point_in_rectangle(mouse_x, mouse_y, _iax, _iay, _iax + _iaw, _iay + _iah)) {
		if (mouse_wheel_down()) {
			ScrollBarHandleMouseDown(_s);
		} else if (mouse_wheel_up()) {
			ScrollBarHandleMouseUp(_s);
		}
	}
	
	_s.scroll_max = _max_scroll;
	if (_s.scroll_max != _s.prev_max_scroll) {
		ScrollBarSizeUpdate(_s, _s.scroll_max);
		_s.prev_max_scroll = _s.scroll_max;
	}
	
	_s.tsby = _s.y + (_s.scroll_target / _s.h * _s.tsbh);
}

function ScrollBarHandleMouseDown(_s) {
	if (_s.scroll_target < _s.scroll_max) {
		_s.scroll_target = min(_s.scroll_target + _s.scroll_interval, _s.scroll_max);
	}	
}

function ScrollBarHandleMouseUp(_s) {
	if (_s.scroll_target > 0) {
		_s.scroll_target = max(0, _s.scroll_target - _s.scroll_interval);
	}
}


function ScrollBarDraw(_s, _bar_col = #2b6960, _handle_col = #b1b2a5, _hc = c_white, _alpha = 1, shadow_distance = 4) {
	
	if (_s.scroll_max <= 0) return;
	
	if (_s.hovering || global.scrollbar_active == _s) {
		_bar_col = merge_color(_bar_col, _hc, 0.15);	
		_handle_col = merge_color(_handle_col, _hc, 0.15);
		// By this being the active sb, assume the mouse is over the sb
		if (mouse_check_button(mb_left)) {
			_bar_col = merge_color(_bar_col, _hc, 0.3);	
			_handle_col = merge_color(_handle_col, _hc, 0.8);
		}
	}
	
	// hm
	if (shadow_distance == 4) {
		draw_sprite_stretched_ext(spr_ui_box_outline, 0, _s.x - 2, _s.y - 2, _s.w + 8, _s.h + 8, global.menubox.c_outline, _alpha);
		DrawRectCol(_s.x + shadow_distance, _s.y + shadow_distance, _s.w, _s.h, c_black, _alpha);
	} else {
		DrawRectCol(_s.x -2, _s.y -2, _s.w+4, _s.h+4, global.menubox.c_outline, _alpha);
		DrawRectCol(_s.x -1, _s.y -1, _s.w+2, _s.h+2, c_black, _alpha);
	}
	DrawRectCol(_s.x, _s.y, _s.w, _s.h, _bar_col, _alpha);
	DrawRectCol(_s.x+1, _s.sby, _s.w-2, _s.sbh, _handle_col, _alpha);
}