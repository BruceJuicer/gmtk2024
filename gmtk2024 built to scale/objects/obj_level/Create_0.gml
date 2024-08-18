/// @description init

arr_tower_layers = array_create(TOWER_Z_MAX, []);

tower_height = 0;

//fill out tower
for (var i = 0; i < TOWER_Z_MAX; i++){
	arr_tower_layers[i] = array_create(TOWER_W * TOWER_H, noone);
}


//player res
arr_res = [ 0, 0, 0 ];




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