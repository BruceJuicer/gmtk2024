/// @description Init

depth = -2050;

state = 0;
fadein = 0;

hov_opt = 0;
hov_opt_dx = 0;

width = 1024;
height = 0;

opts_spacing = 48;
opts_x = 0;

complain_timer = 0;

arr_build_opts = [
	eTileType.NONE,
	eTileType.WOOD_WALL,
	eTileType.WALL,
	eTileType.GUN,
];

audio_play_sound(sfx_menutoggle, 0, 0, 1, 0, 1);