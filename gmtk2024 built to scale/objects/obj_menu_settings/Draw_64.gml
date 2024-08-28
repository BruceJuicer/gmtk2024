/// @description drawo

var _ww = 0;
var _hh = 0;
var _xx = 0;
var _yy = 0;

//sky
DrawRectCol(0, 0, global.vieww + 2, global.viewh + 2, #5B56FF, 1);

_ww = 180;
_xx = floor(global.vieww / 2 - _ww / 2);
_yy = 24;
_hh = 16;

//title
draw_set_halign(fa_center);
DrawTextColourShadow(_xx + _ww / 2, _yy / 2 - 6, "SETTINGS", c_white, 1);
draw_set_halign(fa_left);

//main opts
for (var i = 0; i < array_length(arr_opts); i++){		
	var _opt = arr_opts[i];
	var _selected = opt_sel == i;
	
	var _dy = _yy + (opts_scroll_dy + i) * (_hh + 2);
	
	//don't render if unseen
	if (_dy < _yy - 8) continue;
	if (_dy > global.viewh) break;
	
	var _c_bg = #9AAAC1;
	var _txt_val = string(_opt.value);
	
	//just a label
	if (_opt.type == eSettingOptType.LABEL) {
		draw_set_halign(fa_center);
		DrawTextColourShadow(_xx + _ww / 2, _dy + _hh / 2 - 7, _opt.text, c_white, fadein);
		draw_set_halign(fa_left);
		continue;
	}
	
	if (_selected){
		_c_bg = #9FD6DF;
		
		if (editing_bind){
			_c_bg = make_color_hsv(188, 72 + sin(current_time / 300) * 20, 222);
			if (sin(current_time/140) > 0) _txt_val = "Press any key!";
		}
		
		//we've wrapped!
		if (abs(opt_sel_last - opt_sel) > 2) {
			var _offset = global.nav_last_dir * 7;
			global.opt_selector.dy = _dy + _offset;
			global.opt_selector.dy2 = _dy + _hh + _offset;
		}
		
		if (keyboard_check(vk_enter) || keyboard_check(global.k_action)) _dy ++;
		
		OptSelectorSetPos(_xx, _dy, _xx + _ww, _dy + _hh);
	}
	
	//shadder
	DrawRectCol(_xx + 2, _dy + 2, _ww, _hh, c_black, fadein);
	//body
	DrawRectCol(_xx, _dy, _ww, _hh, _c_bg, fadein);

	//main txt
	DrawTextColourShadow(_xx + 8, _dy + _hh / 2 - 7, _opt.text, c_white, fadein);
	//value
	draw_set_halign(fa_right);
	DrawTextColourShadow(_xx + _ww - 8, _dy + _hh / 2 - 7, _txt_val, c_white, fadein);
	draw_set_halign(fa_left);
	
	if (_opt.type == eSettingOptType.SLIDER && _selected) {
		draw_sprite(spr_ui_arrows, 2, _xx + _ww/2 - 8 + sin(current_time/200), _dy + _hh / 2);
		draw_sprite(spr_ui_arrows, 3, _xx + _ww/2 + 8 - sin(current_time/200), _dy + _hh / 2);
	}
	
}


OptSelectorDraw();