
//tile coords
var _tpos = PixelToIso(x, y);
tx = _tpos.x;
ty = _tpos.y;
tz = z / TILE_V;

depth = CharGetDepth(y, z);

context_i = -1;

switch(state){
	case ePlayerState.IDLE: case ePlayerState.SPINJUMP:
		PlayerTickIdle();
		PlayerTickPickupRes();
	break;
	case ePlayerState.ELEVATOR:
		PlayerTickElevator();
	break;
}