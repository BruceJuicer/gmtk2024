/// @description pauze

if (keyboard_check_pressed(vk_escape)) {
	instance_create_layer(0,0,"instances", obj_pause_menu);	
}


if (obj_player.context_i != -1){
	p_context_i = obj_player.context_i;
	p_context_fadein = lerp(p_context_fadein, 1, 0.2);
} else {
	if (p_context_fadein > 0) p_context_fadein -= 0.15;
}