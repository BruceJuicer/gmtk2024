/// @description draw

var _dx = x;

if (shake_amt > 0){
	_dx += random_range(-shake_amt, shake_amt);
	shake_amt -= 0.1;
}

if (tz != 0){
	image_alpha = 1;
	image_blend = c_white;
	
	if (tz > obj_player.tz) image_alpha = 0.5;
	else if (tz < obj_player.tz) image_blend = c_gray;
}

draw_sprite_ext(sprite_index, image_index, _dx, y - tz * TILE_V, image_xscale, image_yscale, image_angle, image_blend, image_alpha);