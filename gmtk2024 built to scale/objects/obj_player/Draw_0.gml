
//shadow
if (z > floor_z) draw_sprite(spr_shadow, 0, x, y - floor_z);

var _draw_fhighlight = true;
if (!onground || !build_in_tower_bounds) _draw_fhighlight = false;

//hover
if (_draw_fhighlight){
	var _th_pos = IsoToPixel(tbuild_x, tbuild_y, tz);
	gpu_set_blendmode(bm_add);
	draw_sprite_ext(spr_tile_floor_white, 0, _th_pos.x, _th_pos.y, 1, 1, 0, c_white, 0.7 + sin(current_time/400) * 0.1);
	gpu_set_blendmode(bm_normal);
}


var _ii = 0;
if (xdir == -1) _ii = 1;

draw_sprite_ext(sprite_index, _ii, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);