
if (state == -2) return;

if (state == -1) {
	fadein -= 0.25;
	if (fadein <= 0){
		instance_destroy();
	}
	return;
}

fadein = lerp(fadein, 1, 0.25);


//if (keyboard_check_pressed(vk_enter)) instance_destroy();	
if (keyboard_check_pressed(vk_escape)) state = -1;


opt_sel = OptDoNav(opt_sel, 0, array_length(arr_opts));

if (OptDoSelect()){
	switch(opt_sel){
		case 0: // resume
			state = -1;
		break;
		case 1: // options
			instance_create_layer(x, y, "Instances", obj_menu_settings);
			state = -2;
		break;
		case 2: // quit to title
			room_goto(rm_menu);
		break;
	}
}
