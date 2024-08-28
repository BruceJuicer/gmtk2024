var _xx = 0;
var _yy = 0;
var _ww = 0;
var _hh = 0;
var _txt = "";

var _camx = camera_get_view_x(view_camera[0]);
var _camy = camera_get_view_y(view_camera[0]);

//stars
draw_sprite_tiled(spr_bg_stars, 0, 0, 0);

//sky
DrawRectCol(_camx, _camy, global.vieww + 2, global.viewh + 2, #5B56FF, 0.8 + (1 - fadein) * 0.2);

//title
var _title_l = sprite_get_number(spr_mm_title);
var _spacing = 26;
_xx = global.vieww / 2 - (_title_l / 2) * _spacing;
for (var i = 0; i < _title_l; i++){
	draw_sprite(spr_mm_title, i, _xx + i * _spacing, 24 + sin((i * 0.75) + current_time/400) * 2);
}

//credits
DrawTextColourShadow(4, _camy + global.viewh - 14, "By Robin Field, Billy Hobson & Alasdair Reavey", #9AAAC1, fadein);
draw_set_halign(fa_right);
DrawTextColourShadow(global.vieww - 4, _camy + global.viewh - 14, "Post Jam v1", #9AAAC1, fadein);
draw_set_halign(fa_left);

//options
_yy = floor(global.viewh / 2.15); //84;
_xx = floor((global.vieww / 2) - 79);
_ww = 60;

for (var i = 0; i < array_length(arr_opts); i++){	
	OptDraw(_xx, _yy + i * 22, _ww, 20, arr_opts[i], opt_sel == i, 1);
}

//info box mate
_xx += _ww + 2;
_ww = 96;
_hh = (array_length(arr_opts) * 22) - 2;

DrawRectCol(_xx + 2, _yy + 2, _ww, _hh, c_black, 1);
DrawRectCol(_xx, _yy, _ww, _hh, #9AAAC1, 1);
_txt = string_copy(arr_opts_info[opt_sel], 0, info_typeout);
DrawTextColourExt(_xx + 2, _yy - 1, _txt, 12, _ww - 4, c_black, 1);


OptSelectorDraw();


/*
ButtonDraw(but_start, "GO");
ButtonDraw(but_quit, "QUIT");
*/


//DrawTextColour(global.vieww / 2, global.viewh/2, "Enter: Play\nEsc: Quit", c_white, 1);
