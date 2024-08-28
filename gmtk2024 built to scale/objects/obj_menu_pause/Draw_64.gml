var _ww = 0;
var _hh = 0;
var _xx = 0;
var _yy = 0;

//surf
if (surface_exists(surf_bg)) draw_surface_stretched(surf_bg, 0, 0, global.vieww, global.viewh);
else DrawRectCol(0, 0, global.vieww + 2, global.viewh + 2, #5B56FF, 1);

//bg fade
DrawRectCol(0, 0, global.vieww + 2, global.viewh + 2, c_black, fadein * 0.3);

//paused
_yy = 32 - (1 - fadein) * 8;
draw_set_halign(fa_center);
DrawTextTransColour(global.vieww / 2 + 1, _yy + 1, "PAUSED!", 2, 2, 0, c_black, fadein);
DrawTextTransColour(global.vieww / 2, _yy, "PAUSED!", 2, 2, 0, #FFDDA0, fadein);
draw_set_halign(fa_left);

if (state == -2) return;

//opts
_ww = 60;
_yy = 84 + (1 - fadein) * 8;
_xx = global.vieww / 2 - _ww / 2;

for (var i = 0; i < array_length(arr_opts); i++){	
	OptDraw(_xx, _yy + i * 22, _ww, 20, arr_opts[i], opt_sel == i, fadein);
}

OptSelectorDraw();

//DrawTextColour(global.vieww / 2, global.viewh/2, "Enter: Resume\nEsc: Quit", c_white, 1);