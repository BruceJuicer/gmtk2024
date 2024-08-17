
function EnemyGetTarget() {
	var _closest = noone;
	var _d = infinity;
	for (var i = 0; i < array_length(obj_level.arr_tower_layers[z]); i++) {
		var _dist = distance_to_object(obj_level.arr_tower_layers[z][i]);
		if (_dist < _d) {
			_d = _dist; 
			_closest = obj_level.arr_tower_layers[z][i];
		}
	}
	return _closest;
}