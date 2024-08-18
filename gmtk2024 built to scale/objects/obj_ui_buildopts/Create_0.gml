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

arr_build_opts = [
	{
		tile_obj: noone,
		icon_spr: spr_opt_close,
		name: "Close",
		desc: "Changed your mind?",
		arr_res_cost: [ 0, 0, 0 ],
	},
	{
		tile_obj: obj_tile_test,
		icon_spr: spr_tile_test,
		name: "Wall",
		desc: "Solid, tough wall tile.",
		arr_res_cost: [ 0, 0, 0 ],
	},
	{
		tile_obj: obj_tile_gun,
		icon_spr: spr_tile_gun,
		name: "Turret",
		desc: "Periodically shoots at enemies within its vision.",
		arr_res_cost: [ 0, 0, 0 ],
	},
];