
enum eFxFlags {
	POS_DEPTH = 0x01,
	HAS_SHADOW = 0x02,
	// = 0x04,
	// = 0x08,
	// = 0x10,
	// = 0x20,
	// = 0x40,
	// = 0x80,
};

#macro FX_DEST_AFTER_ANIM -2

function FxMisc(parentobj, xx, yy, zz, _depth, destroy_time, flags = 0x00){
	var _fx = instance_create_layer(xx, yy, "Instances", obj_fx_misc_world);
	_fx.z = zz;
	
	_fx.parent_obj = parentobj;
	if (instance_exists(parentobj)){
		_fx.x = parentobj.x + xx;
		_fx.y = parentobj.y + yy;
	} else {
		_fx.parent_obj = noone;
	}
	
	_fx.rel_x = xx;
	_fx.rel_y = yy;
	_fx.rel_z = zz;
	
	_fx.depth = _depth;
	
	if (destroy_time > 0) _fx.alarm[0] = destroy_time;
	
	_fx.flags = flags;
	
	return _fx;
}


function FxSetSpr(fxobj, spr, ii, spd, xscale, yscale, blend, alpha){
	fxobj.sprite_index = spr;
	fxobj.image_index = ii;
	fxobj.image_speed = spd;
	fxobj.image_xscale = xscale;
	fxobj.image_yscale = yscale;
	fxobj.image_blend = blend;
	fxobj.image_alpha = alpha;
}


function FxSetMotion(fxobj, hspd, vspd, zspd, fric, grav){
	fxobj.hspd = hspd;
	fxobj.vspd = vspd;
	fxobj.zspd = zspd;
	fxobj.fric = fric;
	fxobj.grav = grav;
}
