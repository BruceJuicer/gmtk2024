#macro KEY_REPEAT_INITIAL_WAIT 18
#macro KEY_REPEAT_TIME 2

global.input_keyrep = 0;


function Input_Tick(){	
	//update key-repeat
	if (keyboard_key != vk_nokey && keyboard_key == keyboard_lastkey){
		global.input_keyrep += delta_time;
		if (global.input_keyrep > KEY_REPEAT_INITIAL_WAIT + KEY_REPEAT_TIME) global.input_keyrep = KEY_REPEAT_INITIAL_WAIT;
	} else {
		global.input_keyrep = 0;
	}
	
	keyboard_lastkey = keyboard_key;
}



///@desc returns the keyboard key currently being repeated, otherwise returns vk_nokey
function InputKeyGetRepeated(){
	if (global.input_keyrep == 0 || global.input_keyrep == KEY_REPEAT_INITIAL_WAIT) return keyboard_key;
	return vk_nokey;
}


