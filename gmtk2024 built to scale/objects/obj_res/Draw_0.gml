/// @description draw me

if (!frozen) {
	draw_sprite_ext(spr_shadow, 0, x, y, image_xscale, image_yscale, image_angle, c_black, 1);
}

draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);