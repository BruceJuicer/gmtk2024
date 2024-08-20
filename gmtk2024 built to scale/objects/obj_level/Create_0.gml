/// @description init

arr_tower_layers = array_create(TOWER_Z_MAX, []);
//objects on layers
arr_layer_enemies = array_create(TOWER_Z_MAX, []);
arr_layer_items = array_create(TOWER_Z_MAX, []);
arr_layer_wo = array_create(TOWER_Z_MAX, []);

tower_height = 0;
tower_win_height = 14;

no_gravity_height = 5;


//fill out tower
for (var i = 0; i < TOWER_Z_MAX; i++){
	arr_tower_layers[i] = array_create(TOWER_W * TOWER_H, noone);
	arr_layer_enemies[i] = array_create(0, noone);
	arr_layer_items[i] = array_create(0, noone);	
	arr_layer_wo[i] = array_create(0, noone);
}


//player res
arr_res = [ 0, 0, 3 ];


tower_collapsing = false;
tower_collapse_z = 0;
tower_collapse_timer = 0;

level_tick = 0;

tile_heal_i = 0;

//enemy waves
floor_wave = new WaveInfo(0, 0);	// these enemies shoot up to floor 2
sky_wave = new WaveInfo(3, 12);
space_wave = new WaveInfo(13, tower_win_height);


TowerSetTileAt(0, 0, 0, obj_tile_elevator);
//TowerSetTileAt(1, 0, 0);
//TowerSetTileAt(0, 1, 0);
//TowerSetTileAt(1, 1, 0);
//TowerSetTileAt(1, 0, 1);

depth = 80;


//let's add some trees
LevelAddWorldObj(0, -42, 0, obj_wo_tree);
LevelAddWorldObj(0, -42, 0, obj_wo_tree);
LevelAddWorldObj(-96, 8, 0, obj_wo_tree);
LevelAddWorldObj(56, 40, 0, obj_wo_tree);
LevelAddWorldObj(64,-12, 0, obj_wo_tree);

//stone
LevelAddWorldObj(-40, 32, 0, obj_wo_stone);
LevelAddWorldObj(40, 0, 0, obj_wo_stone);