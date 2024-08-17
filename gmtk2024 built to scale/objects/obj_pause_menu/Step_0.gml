if (ButtonTick(but_continue, global.vieww/2 - 32, global.viewh/2, 64, 24)) {
	instance_destroy();	
} else if (ButtonTick(but_quit, global.vieww/2 - 32, global.viewh/2 + 30, 64, 24)) {
	room_goto(rm_menu);
}