/// @description init

arr_tower_layers = array_create(1, array_create(TOWER_W * TOWER_H, TOWER_Z_MAX));

//reset tower tiles
//for (var i = 0; i < array_length(arr_tower_tiles); i++){
//	arr_tower_tiles[i] = new Tile();
//}

TowerSetTileAt(0, 0, 0);
TowerSetTileAt(1, 0, 0);
TowerSetTileAt(0, 1, 0);
TowerSetTileAt(1, 1, 0);
TowerSetTileAt(1, 0, 1);

depth = 80;

repeat(irandom(10)) {
	instance_create_layer(irandom_range(-200, 200), irandom_range(-200, 200), "instances", obj_goblin);	
}