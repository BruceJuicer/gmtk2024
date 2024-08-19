/// @description drawo

//tile floor highlight
//if (obj_player.tx < 0 || obj_player.tx >= TOWER_W || obj_player.ty < 0 || obj_player.ty >= TOWER_H) return;

//var _ppos = IsoToPixel(obj_player.tx, obj_player.ty, obj_player.tz);
//gpu_set_blendmode(bm_add);
//draw_sprite_ext(spr_fx_build_highlight, 0, _ppos.x, _ppos.y, 1, 1, 0, c_white, 0.8 + sin(current_time/200) * 0.1);
//gpu_set_blendmode(bm_normal);


//make sure we know where player is if inside wall

var _tpos = PixelToIso(obj_player.x, obj_player.y + 3);

var _tile_at_body = TowerGetTileAt(_tpos.x, _tpos.y, floor(obj_player.tz + 0.25));

if (_tile_at_body){
	gpu_set_blendmode(bm_add);
	//floor we're on
	if (obj_player.in_tower_bounds){
		var _fl_pos = IsoToPixel(obj_player.tx, obj_player.ty, obj_player.tz);
		draw_sprite_ext(spr_tile_floor_white, 0, _fl_pos.x, _fl_pos.y, 1, 1, 0, #246852, 0.6 + sin(current_time/400) * 0.2);
	}
	//player
	with(obj_player) event_perform(ev_draw, ev_draw_normal);
	gpu_set_blendmode(bm_normal);
}