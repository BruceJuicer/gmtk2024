var _tpos = PixelToIso(x, y);
tx = _tpos.x;
ty = _tpos.y;
tz = z / TILE_V;

draw_sprite(self.sprite_index, -1, x, y);