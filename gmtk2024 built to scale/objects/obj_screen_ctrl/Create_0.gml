#macro PREFERRED_W 640
#macro PREFERRED_H 400

global.vieww = PREFERRED_W;
global.viewh = PREFERRED_H;

global.screen_scale = floor((display_get_height() / 1.5) / global.viewh);

//global.ftick = 0;

last_window_w = 0;
last_window_h = 0;

window_set_size(global.vieww * global.screen_scale, global.viewh * global.screen_scale);

