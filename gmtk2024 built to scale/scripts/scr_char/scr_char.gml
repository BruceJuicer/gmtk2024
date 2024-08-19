
///@desc takes pixel y & pixel z
function CharGetDepth(py, pz){
	return (-py - pz / 8) - 0.5;
}