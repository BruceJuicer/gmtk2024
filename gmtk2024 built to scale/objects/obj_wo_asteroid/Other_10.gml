/// @description on hit

var _res = eRes.STONE;
if (irandom(12) == 2) _res = eRes.GOLD;

ItemResSpawn(x, y, tz * TILE_V, _res, 4);

hp --;

if (hp <= 0) instance_destroy();
shake_amt = 2;