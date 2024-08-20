/// @description drawo

var _camx = camera_get_view_x(view_camera[0]);
var _camy = camera_get_view_y(view_camera[0]);

//sky
var _sky_a = clamp(1.25 - obj_player.tz / 12, 0, 1);
DrawRectCol(_camx, _camy, global.vieww + 2, global.viewh + 2, #5B56FF, _sky_a);

//ground
draw_sprite(spr_ground, 0, 0, 0);