
if (keyboard_check(vk_left)) {
	hspd -= 0.1;
} 

if (keyboard_check(vk_right)) {
	hspd += 0.1;
}

event_inherited();