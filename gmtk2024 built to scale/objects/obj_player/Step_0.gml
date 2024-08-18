
//tile coords
var _tpos = PixelToIso(x, y);
tx = _tpos.x;
ty = _tpos.y;
tz = z / TILE_V;

tbuild_x = tx;
tbuild_y = ty;

switch(state){
	case ePlayerState.IDLE: case ePlayerState.SPINJUMP:
		PlayerTickIdle();
	break;
	case ePlayerState.ELEVATOR:
		PlayerTickElevator();
	break;
}