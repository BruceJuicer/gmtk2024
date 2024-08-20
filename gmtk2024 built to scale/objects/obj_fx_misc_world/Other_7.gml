/// @description destroy time

if (dest_time != FX_DEST_AFTER_ANIM) return;

if (fade_spd > 0) dest_time = 0;
else instance_destroy();

