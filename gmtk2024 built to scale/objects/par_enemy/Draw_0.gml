
//shadow
if (z > 0) draw_sprite(spr_shadow, 0, x, y);


if (tz != 0){
	image_alpha = 1;
	image_blend = c_white;
	
	if (tz > floor(obj_player.tz)) image_alpha = 0.5;
	else if (tz < floor(obj_player.tz)) image_blend = c_gray;
}

draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);