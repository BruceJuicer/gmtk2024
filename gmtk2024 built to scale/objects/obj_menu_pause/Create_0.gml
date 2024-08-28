
state = 0;
fadein = 0;

arr_opts = [
	"Resume",
	"Settings",
	"End Game"
];

opt_sel = 0;


depth = -2048;


surf_bg = surface_create(surface_get_width(application_surface), surface_get_height(application_surface));
surface_copy(surf_bg, 0, 0, application_surface);

instance_deactivate_all(true);
instance_activate_object(obj_screen_ctrl);
