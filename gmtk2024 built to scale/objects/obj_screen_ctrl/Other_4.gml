/// @description setup views

view_enabled = true;
view_set_visible(0, true);

view_set_wport(0, global.vieww);
view_set_hport(0, global.viewh);

display_set_gui_size(global.vieww, global.viewh);

var _camera = camera_create_view(0, 0, global.vieww, global.viewh, 0, -1, -1, -1, 0, 0);
view_set_camera(0, _camera);