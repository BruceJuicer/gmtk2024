/// @description draw

var _dx = x;

if (shake_amt > 0){
	_dx += random_range(-shake_amt, shake_amt);
	shake_amt -= 0.1;
}

draw_sprite_ext(sprite_index, image_index, _dx, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);