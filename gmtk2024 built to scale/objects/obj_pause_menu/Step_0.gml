if (ButtonTick(but_continue, global.vieww/3 - 32, global.viewh/3, 64, 24)) {
	instance_destroy();	
} else if (ButtonTick(but_quit, global.vieww/3 - 32, global.viewh/3 + 30, 64, 24)) {
	room_goto(rm_menu);
}