/// @description drawo

DrawRectCol(x, y, width, height, c_black, fadein * 0.6);


var _selector_c = #246852;
var _selector_a = 0.5;
if (complain_timer > 0){
	_selector_c = c_red;
	_selector_a = complain_timer;
	complain_timer -= 0.1;
}

//selector
DrawRectCol(1 + opts_x + hov_opt_dx * opts_spacing, y + 8, opts_spacing - 2, height - 16, _selector_c, _selector_a * 0.5);


//build options
for (var i = 0; i < array_length(arr_build_opts); i++){
	var _xx = opts_x + i * opts_spacing;
	var _yy = y + 8 + (1 - fadein) * 32;
	var _ww = opts_spacing;
	var _hh = height - 16;
	var _opt = global.arr_tileinfo[arr_build_opts[i]];
	
	var _c = c_gray;
	if (hov_opt == i) _c = c_white;
	
	//icon
	draw_sprite_ext(_opt.icon_spr, 0, _xx + _ww / 2, _yy + 16, 1, 1, 0, _c, fadein);
	
	//name
	draw_set_halign(fa_center);
	DrawTextColourShadow(_xx + _ww / 2, _yy + 28, _opt.name, _c, fadein);
	draw_set_halign(fa_left);
	
	//cost
	if (i == 0) continue;	
	for (var j = 0; j < array_length(_opt.arr_res_cost); j++){
		var _cy = _yy + _hh - 32 + j * 10;
		
		var _opt_c = _c;
		if (_opt.arr_res_cost[j] > obj_level.arr_res[j]) _opt_c = #B06060;
		
		draw_sprite_ext(spr_res_icons, j, _xx + 8, _cy + 10, 1, 1, 0, _c, fadein);	
		DrawTextColourShadow(_xx + 16, _cy, _opt.arr_res_cost[j], _opt_c, fadein);
	}
}


//desc box
var _desc_h = 48;
var _desc_y = global.viewh - _desc_h - 8;
_desc_y += (1 - fadein) * _desc_h;

DrawRectCol(x, _desc_y, width, _desc_h, c_black, fadein * 0.6);

var _txt = global.arr_tileinfo[arr_build_opts[hov_opt]].desc;
DrawTextColourExt(x + 9, _desc_y + 9, _txt, 10, width, c_black, fadein);
DrawTextColourExt(x + 8, _desc_y + 8, _txt, 10, width, c_ltgray, fadein);