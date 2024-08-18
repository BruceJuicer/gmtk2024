/// @description Insert description here
// You can write your code in this editor









// Inherit the parent event
event_inherited();

switch(state) {
	case 1:
		if (instance_exists(target)) {
			if (state = 1) {
				if (!in_range) {
					if (distance_to_object(target) <= range) in_range = true;
					else {
						MoveToTarget(target.x, target.y);
					}
				} else {
					if (attack_cooldown <= 0) {
						instance_destroy();
						var _proj = instance_create_layer(x, y, "instances", obj_gob_proj, {instance_target: target, target: {x : target.x, y : target.y }});
						attack_cooldown = 120;
					} else attack_cooldown--;
				}
			}
		} else state = 0;
		break;
	case 0:
		target = {x: sign(x) * 200, y: sign(y) * 200};
		tick++;
		MoveToTarget(target.x, target.y);
		if (tick > 600) instance_destroy();
	break;
}