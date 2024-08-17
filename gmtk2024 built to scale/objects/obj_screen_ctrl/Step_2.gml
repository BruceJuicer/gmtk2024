/// @description check for window changes

//update screen on resize
if (last_window_w != window_get_width() || last_window_h != window_get_height()){
	if (window_get_width() <= 0) return;
	
	//make sure window aspect ratio isn't weird
	if (window_get_width() < window_get_height() * 1.3){
		window_set_size(floor(window_get_height() * 1.3), window_get_height());
	}
	
	//keep the window at an even number
	if (window_get_width() % 2 == 1) window_set_size(window_get_width()+1, window_get_height());
	if (window_get_height() % 2 == 1) window_set_size(window_get_width(), window_get_height()+1);
	
	//try to scale the screen to a reasonable size
	var _minscl = min(window_get_width() / PREFERRED_W, window_get_height() / PREFERRED_H);
	//global.screen_scale = _minscl;
	global.screen_scale = round(_minscl);

	global.vieww = floor(window_get_width()  / global.screen_scale);
	global.viewh = floor(window_get_height() / global.screen_scale);
	
	//view width ended up being uneaven, let's call the cops
	if (global.viewh % 2 == 1){
		show_debug_message("ODD HEIGHT");
		global.viewh -= 1;
		window_set_size(window_get_width(), global.viewh * global.screen_scale);
	}
	
	//display_set_gui_size(global.vieww, global.viewh);
	display_set_gui_size(global.vieww, global.viewh);
	
	surface_resize(application_surface, window_get_width(), window_get_height());
	
	camera_set_view_size(view_camera[0], global.vieww, global.viewh);
	
	view_set_wport(0, global.vieww);
	view_set_hport(0, global.viewh);

	last_window_w = window_get_width();
	last_window_h = window_get_height();
	
	show_debug_message("Window Resized!");
	show_debug_message("Scale: " + string(global.screen_scale));
	
	show_debug_message("Width: " + string(window_get_width()) + "  View: " + string(global.vieww));
	show_debug_message("Height: " + string(window_get_height()) + "  View: " + string(global.viewh));
}


//re-enable button interaction
global.buttons_caninteract = true;

//global.ftick ++;

Input_Tick();

//debug buts
if (DEV_MODE && keyboard_check(vk_control)){
	if (keyboard_check_pressed(ord("P"))){
		show_debug_overlay(!is_debug_overlay_open());
	}
	if (keyboard_check_pressed(ord("R"))){
		game_restart();
	}
}

