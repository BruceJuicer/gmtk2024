
hp = 0;
dmg = 0;
//spd = 1;
target_obj = noone;
//range = 6;
in_range = false;

state = 0;
substate = 0;

z = 0;

tx = 0;
ty = 0;
tz = 0;

//walk to here please
go_x = 0;
go_y = 0;

attack_cooldown = 120;

//amount of times the enemy will try to find a target before leaving
find_target_tries = 5;

//our layer index for the level
zlayer_i = 0;

function OnDeath() {
	ItemResSpawn(x, y, z, irandom(2), 1);
}