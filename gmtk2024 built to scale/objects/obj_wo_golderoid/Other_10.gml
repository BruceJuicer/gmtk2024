/// @description on hit

var _res = eRes.GOLD;
if (irandom(12) == 2) _res = eRes.STONE;

ItemResSpawn(x, y, tz * TILE_V, _res, 2);

hp --;

if (hp <= 0) instance_destroy();
shake_amt = 2;