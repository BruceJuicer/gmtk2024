
draw_sprite_ext(spr_pix, 0, x, y, w, h, angle, colour, 1);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
DrawTextColourShadowTransform_Ext(x + w/2, y + h/2, text, c_white, 1, undefined, undefined, undefined, undefined, undefined, angle);
draw_set_halign(fa_left);
draw_set_valign(fa_top);