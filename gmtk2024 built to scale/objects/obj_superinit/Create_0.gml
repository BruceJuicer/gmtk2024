/// @description Init

if (!instance_exists(obj_screen_ctrl)) instance_create_layer(0, 0, "Instances", obj_screen_ctrl);

draw_set_font(fnt_base);

alarm[0] = 1;

//gc_target_frame_time(200);
//gc_collect();

randomise();