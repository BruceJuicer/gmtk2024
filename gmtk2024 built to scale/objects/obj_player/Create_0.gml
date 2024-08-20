
state = ePlayerState.IDLE;

hspd = 0;
vspd = 0;
zspd = 0;

z = 0;

tx = 0;
ty = 0;
tz = 0;

//sub pixel tile positions
txf = 0;
tyf = 0;
tzf = 0;

//the tile we're looking at, to build
tbuild_x = 0;
tbuild_y = 0;

xdir = 1;
ydir = 1;

jetpack_fuel = P_JETPACK_MAX;

floor_z = 0;
onground = false;

in_tower_bounds = false;
build_in_tower_bounds = false;
build_blocked = false;

context_i = -1;

//jet_drop_spd = 0;