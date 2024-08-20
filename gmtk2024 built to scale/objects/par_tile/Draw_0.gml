/// @description drawo

if (z < obj_player.tz) image_blend = c_ltgray;
else image_blend = c_white;

draw_sprite_ext(sprite_index, image_index, dx, dy - dz, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

if (hp < hp_max){
	draw_sprite_ext(spr_tile_dmg, 0, dx, dy - dz, 1, 1, 0, c_red, 1 - hp / hp_max);
}