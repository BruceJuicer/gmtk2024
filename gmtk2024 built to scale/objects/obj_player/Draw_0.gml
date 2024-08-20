
//shadow
if (z > floor_z) draw_sprite(spr_shadow, 0, x, y - floor_z);

//hover
if (build_in_tower_bounds){
	if (!build_blocked){
		//build on floor
		var _th_pos = IsoToPixel(tbuild_x, tbuild_y, tz);
		gpu_set_blendmode(bm_add);
		draw_sprite_ext(spr_tile_floor_white, 0, _th_pos.x, _th_pos.y, 1, 1, 0, c_white, 0.7 + sin(current_time/400) * 0.1);
		gpu_set_blendmode(bm_normal);
	} else if (tbuild_x != 0 || tbuild_y != 0) {
		if (!in_tower_bounds && instance_exists(TowerGetTileAt(tbuild_x, tbuild_y, floor(tz)))){
			//destroy tile?
			var _th_pos = IsoToPixel(tbuild_x, tbuild_y, floor(tz));			
			var _ii = 1;
			if (x > _th_pos.x) _ii = 2;		
			draw_sprite_ext(spr_tile_white, _ii, _th_pos.x, _th_pos.y, 1, 1, 0, c_red, 0.3 + sin(current_time/400) * 0.1);
		}
	}
}



sprite_index = spr_player_r;
if (xdir == -1) sprite_index = spr_player_l;

draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);