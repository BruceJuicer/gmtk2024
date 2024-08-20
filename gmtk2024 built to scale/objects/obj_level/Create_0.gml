/// @description init

arr_tower_layers = array_create(TOWER_Z_MAX, []);
//objects on layers
arr_layer_enemies = array_create(TOWER_Z_MAX, []);
arr_layer_items = array_create(TOWER_Z_MAX, []);

tower_height = 0;
tower_win_height = 14;

no_gravity_height = 6;

//fill out tower
for (var i = 0; i < TOWER_Z_MAX; i++){
	arr_tower_layers[i] = array_create(TOWER_W * TOWER_H, noone);
	arr_layer_enemies[i] = array_create(0, noone);
	arr_layer_items[i] = array_create(0, noone);
}


//player res
arr_res = [ 0, 0, 5 ];


tower_collapsing = false;
tower_collapse_z = 0;
tower_collapse_timer = 0;

level_tick = 0;


//enemy waves
floor_wave = new WaveInfo(0, 0);	// these enemies shoot up to floor 2
air1_wave = new WaveInfo(3, 12);
air2_wave = new WaveInfo(13, tower_win_height);


TowerSetTileAt(0, 0, 0, obj_tile_elevator);
//TowerSetTileAt(1, 0, 0);
//TowerSetTileAt(0, 1, 0);
//TowerSetTileAt(1, 1, 0);
//TowerSetTileAt(1, 0, 1);

depth = 80;

//repeat(irandom(10)) {
//	instance_create_layer(irandom_range(-200, 200), irandom_range(-200, 200), "instances", obj_goblin);	
//}



//let's add some trees
instance_create_layer(0, -42, "Instances", obj_wo_tree);
instance_create_layer(-96, 8, "Instances", obj_wo_tree);
instance_create_layer(56, 40, "Instances", obj_wo_tree);
instance_create_layer(64,-12, "Instances", obj_wo_tree);

//stone
instance_create_layer(-40, 32, "Instances", obj_wo_stone);
instance_create_layer(40, 0, "Instances", obj_wo_stone);