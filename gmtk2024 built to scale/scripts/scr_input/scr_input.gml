#macro KEY_REPEAT_INITIAL_WAIT 18
#macro KEY_REPEAT_TIME 2

global.input_keyrep = 0;

global.k_move_l = vk_left;
global.k_move_r = vk_right;
global.k_move_u = vk_up;
global.k_move_d = vk_down;
global.k_use	= ord("Z");
global.k_action = ord("X");


function InputSetDefaults(){
	global.k_move_l = vk_left;
	global.k_move_r = vk_right;
	global.k_move_u = vk_up;
	global.k_move_d = vk_down;
	global.k_use	= ord("Z");
	global.k_action = ord("X");
}



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


function GetKeyName(key){
	switch(key){
		default: if (key < 100) return string(chr(key));
				 else return string(key);
		case 8:				return "BACKSPACE";
		case 13:			return "ENTER";
		case 20:			return "CAPSLOCK";
		case 33:			return "PAGE UP";
		case 34:			return "PAGE DOWN";
		case 35:			return "END";
		case 36:			return "HOME";
		case 45:			return "INSERT";
		case 46:			return "DELETE";
		case vk_left:		return "LEFT";
		case vk_right:		return "RIGHT";
		case vk_up:			return "UP";
		case vk_down:		return "DOWN";
		case vk_control:	return "CONTROL";
		case vk_shift:		return "SHIFT";
		case vk_space:		return "SPACE";
		case vk_tab:		return "TAB";
		case 107:			return "+";
		case vk_f1:			return "F1";
		case vk_f2:			return "F2";
		case vk_f3:			return "F3";
		case vk_f4:			return "F4";
		case vk_f5:			return "F5";
		case vk_f6:			return "F6";
		case vk_f7:			return "F7";
		case vk_f8:			return "F8";
		case vk_f9:			return "F9";
		case vk_f10:		return "F10";
		case vk_f11:		return "F11";
		case vk_f12:		return "F12";
		case 144:			return "NUMLOCK";
		case 162:			return "L CONTROL";
		case 163:			return "R CONTROL";
		case 164:			return "L ALT";
		case 165:			return "R ALT";
		case 186:			return ";";
		case 187:			return "=";
		case 188:			return ",";
		case 189:			return "-";
		case 190:			return ".";
		case 191:			return "/";
		case 192:			return "'";
		case 219:			return "[";
		case 220:			return "\\";
		case 221:			return "]";
		case 222:			return "#";
		case 223:			return "GUN";
	}
}