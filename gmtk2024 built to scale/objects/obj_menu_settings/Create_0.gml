/// @description Init

function OptionsSet(){
	arr_opts = [
		{ text: "Back",						value: "",													type: eSettingOptType.BUTTON,},
		{ text: "Game",						value: "",													type: eSettingOptType.LABEL, },
		{ text: "Audio",					value: string(round(audio_get_master_gain(0)*100)) + "%",	type: eSettingOptType.SLIDER, },
		{ text: "Zoom",						value: string(200-round(global.s_zoom_scale*100)) + "%",	type: eSettingOptType.SLIDER, },
		{ text: "Controls",					value: "",													type: eSettingOptType.LABEL, },
		{ text: "Reset Controls",			value: "(F2)",												type: eSettingOptType.BUTTON, },
		{ text: "Move Up",					value: GetKeyName(global.k_move_u),							type: eSettingOptType.BIND_CHANGE, },
		{ text: "Move Down",				value: GetKeyName(global.k_move_d),							type: eSettingOptType.BIND_CHANGE, },
		{ text: "Move Left",				value: GetKeyName(global.k_move_l),							type: eSettingOptType.BIND_CHANGE, },
		{ text: "Move Right",				value: GetKeyName(global.k_move_r),							type: eSettingOptType.BIND_CHANGE, },
		{ text: "Use",						value: GetKeyName(global.k_use),							type: eSettingOptType.BIND_CHANGE, },
		{ text: "Action",					value: GetKeyName(global.k_action),							type: eSettingOptType.BIND_CHANGE, },
	];
}


function OptionsSetInput(opt_i, key){
	var _arr_illegal_keys = [vk_enter, vk_escape, 91, vk_f2];
	
	show_debug_message(key);
	
	for (var i = 0; i < array_length(_arr_illegal_keys); i++){
		if (_arr_illegal_keys[i] == key){
			editing_bind = false;
			return;
		}
	}
	
	switch(opt_i){
		case eSettingsOpts.K_M_UP:		global.k_move_u = key;	break;
		case eSettingsOpts.K_M_DOWN:	global.k_move_d = key;	break;
		case eSettingsOpts.K_M_LEFT:	global.k_move_l = key;	break;
		case eSettingsOpts.K_M_RIGHT:	global.k_move_r = key;	break;
		case eSettingsOpts.K_USE:		global.k_use = key;		break;
		case eSettingsOpts.K_ACTION:	global.k_action = key;	break;
	}
	
	OptionsSet();
}


enum eSettingOptType {
	BUTTON,
	SLIDER,
	BIND_CHANGE,
	LABEL,
};

enum eSettingsOpts {
	BACK,
	LBL_GAME,
	AUDIO,
	ZOOM,
	LBL_CONTROLS,
	RESET_CONTROLS,
	K_M_UP,
	K_M_DOWN,
	K_M_LEFT,
	K_M_RIGHT,
	K_USE,
	K_ACTION
}

event_inherited();

depth = -2050;

arr_opts = [];
OptionsSet();

editing_bind = false;
opt_sel_last = opt_sel;

opts_scroll_y = 0;
opts_scroll_dy = 0;

ignore_until_key_release = 0;