/// @description draw me

if (!frozen) {
	draw_sprite_ext(spr_shadow, 0, x, y, image_xscale, image_yscale, image_angle, c_black, 1);
} else {
	//blend based on relative pos to player
	image_alpha = 1;
	image_blend = c_white;
	
	if (zlayer_i > obj_player.tz + 1){
		image_alpha = 0.4;
		if (zlayer_i > obj_player.tz + 3) return;
	}
	else if (zlayer_i < obj_player.tz) image_blend = c_gray;
}

draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);