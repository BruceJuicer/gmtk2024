//struct ref to the button we're currently interacting with
global.button_active = -1;
//iterator for providing buttons unique ids
global.button_id_iterator = -1;
//so we can avoid same-frame tab issues
global.__button_tab_frame = 0;
//so we can ignore mouse inputs from overlaid buttons until the button is released first
global.button_ignore_mouse = 0;
//determines if you can interact with buttons or not, reset back to true at the end of every frame
global.buttons_caninteract = true;


enum eButtonState {
	IDLE,
	HOVERED,
	PUSHED_IN,
	INACTIVE,
	INACTIVE_SELECTED,
	ACTIVE,
}

enum eButtonType {
	BUTTON,
	TEXT_INPUT,
	NUM_INPUT,
	SLIDER,
	RADIO,
	COMBOX,
	LABEL,
	CHECKBOX
}

function CreateGroupedButton(arr_struct_group, _type = eButtonType.BUTTON) {
	array_push(arr_struct_group, new ButtonStruct(_type));
	return array_last(arr_struct_group);
}

/// @desc creates generic button struct & returns it
/// @param {real} _type
/// @param {bool} _ui
function ButtonStruct(_type = eButtonType.BUTTON, _ui = true) constructor {
	global.button_id_iterator ++;
	x = -2048;
	y = -2048;
	w = 0;
	h = 0;
	ui = _ui; // this button is rendered on gui layer
	
	//TextLookup = txt;
	text = "";//GetLocalString(txt);
	state = eButtonState.IDLE;
	prev_state = eButtonState.IDLE;
	flags = 0x00;
	type = _type;
	ref_id = global.button_id_iterator;  // for referencing during button interaction
	
	//gfx stuff
	select_f = 0;
	//rtick = 0;			//render tick, not to be used by button itself, but can be used by stuff doing extra fx on top of the button
	
	//text input stuff
	edit_pos = 0;
	max_chars = -1;
	
	//slider stuff
	val_min = 0;
	val_max = 1;
	val_inc = 0.1;
		
	//combox stuff
	options = [];
	selected_op = 0;
	hovered_op = -1;
	
	//checkbox stuff
	checked = false;
	
	//tabbing
	tab_next = undefined;
	tab_prev = undefined;
		
	//customisation
	c_bg = c_ltgrey;
	c_txt = c_white;
	bg_spr = spr_pix;
	bg_spr_ii = 0;
	bg_a_override = 0;
	shadow_dist = 4;
	//c_outline = c_black; // if set to black, this won't be shown
	img_spr = undefined;
	img_spr_i = 0;
	img_spr_w = img_spr == undefined ? 0 : sprite_get_width(img_spr);
	img_spr_h = img_spr == undefined ? 0 : sprite_get_height(img_spr);
	
	return self;
}

///@desc sets the buttons info for use as a slider
function ButtonSetSliderInfo(button_struct, value, slider_min, slider_max, slider_increment){
	button_struct.val_min = slider_min;
	button_struct.val_max = slider_max;
	button_struct.val_inc = slider_increment;
	button_struct.edit_pos = value;
}

///@desc sets the buttons info for use as a slider
function ButtonSetBaseSpr(button_struct, spr_index, spr_subimg, colour, alpha_override = 0){
	button_struct.bg_spr = spr_index;
	button_struct.bg_spr_ii = spr_subimg;
	button_struct.c_bg = colour;
	button_struct.bg_a_override = alpha_override;
}

///@desc updates the button text in a translation supported way
function ButtonSetText(button_struct, text_key){
	button_struct.TextLookup = text_key;
	button_struct.text = GetLocalString(text_key);
}


///@description ticks the button and checks input, returns true if clicked
///@param {Struct} button			the button struct you want to tick
///@param {real} xx 
///@param {real} yy 
///@param {real} ww 
///@param {real} hh 
function ButtonTick(button, xx, yy, ww, hh, allow_interaction = true){	
	button.x = xx;
	button.y = yy;
	button.w = ww;
	button.h = hh;
	//var _prevstate = button.state;
	
	if (button.state == eButtonState.INACTIVE || button.state == eButtonState.INACTIVE_SELECTED) return false;
	if (button.state != eButtonState.ACTIVE) button.select_f = lerp(button.select_f, 0, 0.2);
	button.prev_state = button.state;
	button.state = eButtonState.IDLE;
	
	if (!global.buttons_caninteract || !allow_interaction) return false;
	
	var _mx = mouse_x;
	var _my = mouse_y;
	if (button.ui){
		_mx = device_mouse_x_to_gui(0);
		_my = device_mouse_y_to_gui(0);
	}
	
	var _just_released = false;
	
	//button is active!
	if (global.button_active != -1) {
		if (global.button_active.ref_id == button.ref_id){
			button.state = eButtonState.ACTIVE;	
			button.select_f = lerp(button.select_f, 1, 0.2);
			
			if (mouse_check_button_pressed(mb_left)){			
				//special height case for comboxes
				var _buth = hh;
				if (button.type == eButtonType.COMBOX){
					_buth += (16 * array_length(button.options));
										
					//var _snd = PlaySound(sfx_tabclose, 1.5, false, 0.6);
					//audio_sound_set_track_position(_snd, 0.0625);
				}
					
				//click out of button			
				if (_mx < xx || _mx > xx + ww || _my < yy || _my > yy + _buth){
									
					global.button_active = -1;
				
					//consider it a successful use if we're text input
					if (button.type == eButtonType.TEXT_INPUT || button.type == eButtonType.NUM_INPUT){
						return true;
					}
				 
					return false;
				}
			}
		
			//tab from button
			if (keyboard_check_pressed(vk_tab) && global.__button_tab_frame < current_time){	
				global.button_active = -1;
				global.__button_tab_frame = current_time;
			
				//prev
				if (keyboard_check(vk_shift)){
					if (is_struct(button.tab_prev)) global.button_active = button.tab_prev;
					return true;
				}
			
				//next
				if (is_struct(button.tab_next)) global.button_active = button.tab_next;
				return true;
			}
		
			//text input
			if (button.type == eButtonType.TEXT_INPUT || button.type == eButtonType.NUM_INPUT){
				return _ButtonHandleTextInput(button);
			}
		
			//slider
			if (button.type == eButtonType.SLIDER){
				button.edit_pos = lerp(button.val_min, button.val_max, (_mx - button.x) / (button.w - 2));		
				button.edit_pos = clamp(button.edit_pos, button.val_min, button.val_max);
			
				//release outside of slider, no more slidey
				if (!mouse_check_button(mb_left)){
					global.button_active = -1;
					global.button_ignore_mouse = current_time;
					return false;
				}	
			
				return true;
			}	
				
			if (button.type == eButtonType.COMBOX) {			
				var _p = _my - yy - hh;
				
				if (_mx > xx && _mx < xx + ww && _my > yy + hh && _my < yy + hh + (16 * array_length(button.options))) {
					//check if they've picked one of the listed options
					button.hovered_op = floor(_p/16);
				} else {
					button.hovered_op = -1;
				}
				
				//select an opt
				if (mouse_check_button_released(mb_left)){
					var _hop = floor(_p / 16);		
									
					global.button_active = -1;
					
					//var _snd = PlaySound(sfx_tabopen, 1, false, 0.6);
					//audio_sound_set_track_position(_snd, 0.064);
					
					if (_hop >= 0 && _hop < array_length(button.options)){
						global.button_ignore_mouse = current_time;
						button.selected_op = _hop;
						return true;
					}

					return false;
				}			
			}
			
			return false;
			
		} else {
			if (global.button_active.type == eButtonType.COMBOX) {
				return false;
			}
		}
	}
	
	if (_mx < xx || _my < yy) return false;
	if (_mx > xx + ww || _my > yy + hh) return false;
	
	//we're ignoring this frame
	if (global.button_ignore_mouse == current_time) return;	
	
	//hovered
	button.state = eButtonState.HOVERED;	
	
	//clicked-in
	if (mouse_check_button(mb_left)){
		button.state = eButtonState.PUSHED_IN;
		
		//sfx on click in
		/*
		if (button.prev_state != button.state){
			var _snd = PlaySound(sfx_tabclose, 1, false, 0.6);
			audio_sound_set_track_position(_snd, 0.0625);
		}
		*/
		
		//slider
		if (button.type == eButtonType.SLIDER && global.button_active == -1){
			global.button_active = button;
			button.state = eButtonState.ACTIVE;
		}
	}
	
	//released on, click finished
	if (!_just_released && mouse_check_button_released(mb_left)){		
		//sfx on release
		/*
		if (button.prev_state != button.state){
			var _snd = PlaySound(sfx_tabopen, 1, false, 0.6);
			audio_sound_set_track_position(_snd, 0.064);
		}
		*/
		
		//start interaction
		if (button.type == eButtonType.TEXT_INPUT || button.type == eButtonType.NUM_INPUT){
			global.button_active = button;
			button.edit_pos = string_length(button.text);
			keyboard_string = "";
			button.state = eButtonState.ACTIVE;
		}
		
		if (button.type == eButtonType.COMBOX){
			global.button_active = button;
			button.state = eButtonState.ACTIVE;
			return false;
		}
		
		if (button.type == eButtonType.CHECKBOX) {
			button.checked = !button.checked;
		}
		
		return true;
	}
	
	return false;
}

/// @desc			Draws the button struct
/// @param {Struct} _b				button_struct
/// @param {Any}	_text			button's display text- its a string really
/// @param {real}	drawoffset_x	offset for if you're drawing relative to a surface or something, x
/// @param {real}	drawoffset_y	offset for if you're drawing relative to a surface or something, y
function ButtonDraw(_b, _text = undefined, drawoffset_x = 0, drawoffset_y = 0, alpha = 1){
	var _bg_a = 1;
	var _txt_c = _b.c_txt;
	
	var _bg_ii = _b.bg_spr_ii;
	
	var _butoff_x = 0;
	var _butoff_y = 0;
	
	var _bg_c = _b.c_bg;
	
	//determine if this is an input button
	var _is_textinput = false;
	if (_b.type >= eButtonType.TEXT_INPUT && _b.type <= eButtonType.NUM_INPUT) _is_textinput = true;
	
	switch(_b.state){
		case eButtonState.HOVERED:
			//_butoff_x = 1;
			//_butoff_y = 1;
			_txt_c = _b.c_txt;
		break;
		case eButtonState.PUSHED_IN:
			_butoff_x = 1;
			_butoff_y = 1;
			_txt_c = c_ltgray;
			_bg_c = #404040;
		break;
		case eButtonState.INACTIVE:
			_txt_c = c_gray;
			_bg_ii = 2;
			_bg_c = #404040;
		break;
		case eButtonState.INACTIVE_SELECTED:
			_butoff_x = 2;
			_butoff_y = 2;
			_txt_c = c_ltgray;
			_bg_c = #404040;		
		break;
		case eButtonState.ACTIVE:
			_txt_c = c_ltgray;
			_bg_c = #404040;		
		break;
	}
	
	if (_b.bg_a_override != 0) _bg_a = _b.bg_a_override;
	
	var _dx = _b.x + drawoffset_x;
	var _dy = _b.y + drawoffset_y;
	
	//bg shadow
	draw_sprite_stretched_ext(_b.bg_spr, _bg_ii, _dx + _b.shadow_dist, _dy + _b.shadow_dist, _b.w, _b.h, c_black, _bg_a * alpha);
	
	//everything is now relative to button offset
	_dx += _butoff_x;
	_dy += _butoff_y;
	
	//outline
	//if (_b.c_outline != c_black){
	//	draw_sprite_stretched_ext(spr_ui_box_outline, 0, _dx - 2, _dy - 2, _b.w - _butoff_x + 8, _b.h - _butoff_y + 8, _b.c_outline, alpha);
	//}
	
	//button face
	draw_sprite_stretched_ext(_b.bg_spr, _bg_ii, _dx, _dy, _b.w, _b.h, _bg_c, _bg_a * alpha);
	
	//align text
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	var _txt_x = _dx + _b.w/2;
	
	//text is rendered from left if this is a text box
	if (_b.type == eButtonType.TEXT_INPUT || _b.type == eButtonType.NUM_INPUT || _b.type == eButtonType.COMBOX){
		_txt_x = _dx + 2;
		draw_set_halign(fa_left);
	}
	
	//slider background
	if (_b.type == eButtonType.SLIDER){
		_txt_x = _dx + 2;	
		//bg #00A2EE
		draw_sprite_stretched_ext(_b.bg_spr, _bg_ii, _dx, _dy, (_b.edit_pos / _b.val_max) * _b.w, _b.h, #8B8B8D, 1 * alpha);
		//DrawRectCol(_dx, _dy, (_b.edit_pos / _b.val_max) * _b.w, _b.h, #00A2EE, 0.6 * alpha);
		//nib
		//DrawRectCol(_dx + (_b.edit_pos / _b.val_max) * (_b.w - 2), _dy, 2, _b.h + 1, #22E0EE, 0.9 * alpha);
		
		//value
		draw_set_halign(fa_right);
		var _vtxt_x = _dx + _b.w - 2;
		var _vtxt_y = _dy + (_b.h / 2);
		var _vtxt = string(floor(_b.edit_pos)) + "%";
		
		//shadow
		if (_txt_c == c_white){
			DrawTextColour(_vtxt_x + 1, _vtxt_y + 1, _vtxt, c_black, alpha);
			DrawTextColour(_vtxt_x + 1, _vtxt_y + 1, _vtxt, c_black, 0.25 * alpha);
		}
		//txt
		DrawTextColour(_vtxt_x, _vtxt_y, _vtxt, _txt_c, alpha);
		draw_set_halign(fa_left);
	}	
	
	if (_b.type == eButtonType.BUTTON) {
		if (_b.img_spr != undefined) {
			draw_sprite_ext(_b.img_spr, _b.img_spr_i, _dx + _b.img_spr_w/2 + _butoff_x, _dy + _b.img_spr_h/2 + _butoff_y, 1, 1, 0, c_white, alpha);
		}
	}
	
	if (_b.type == eButtonType.COMBOX){
		//value
		draw_set_halign(fa_right);
		var _vtxt_x = _dx + _b.w - 4;
		var _vtxt_y = _dy + (_b.h / 2);
		var _vtxt = _b.options[_b.selected_op];
		
		//shadow
		if (_txt_c == c_white){
			//txt shadow
			DrawTextColour(_vtxt_x + 1, _vtxt_y + 1, _vtxt, c_black, alpha);
			DrawTextColour(_vtxt_x + 1, _vtxt_y, _vtxt, c_black, 0.25 * alpha);
			//dd icon shadow
			//draw_sprite_ext(spr_ui_but_combox_arrow, 0, _dx + _b.w - 8, _vtxt_y + 1, 1, 1, _b.select_f * 180, c_black, alpha);
		}
		
		//drop down icon		
		//draw_sprite_ext(spr_ui_but_combox_arrow, 0, _dx + _b.w - 9, _vtxt_y, 1, 1, _b.select_f * 180, _txt_c, alpha);
		
		//txt
		DrawTextColour(_vtxt_x, _vtxt_y, _vtxt, _txt_c, 1);
		
		if (_b.state == eButtonState.ACTIVE) {
			// draw all the options available. lord forgive me for i am a sinner. You have been absolved my child	
			var _opty = _dy;
			
			for (var i = 0; i < array_length(_b.options); i++) {
				_opty = _dy + _b.h + (16 * i);
				var _opt_txt_yoff = 0;
				
				var _op_c = #555555;
				var _op_txt_c = c_white;
				
				if (_b.hovered_op == i){
					_op_c = c_ltgrey;
					 _op_txt_c = c_black;
					 
					 if (mouse_check_button(mb_left)){
						 _op_c = #A0A0A0;
						 _opt_txt_yoff = 1;
					 }
				}
				
				draw_sprite_stretched_ext(_b.bg_spr, _bg_ii, _dx, _opty, _b.w, _b.h, _op_c, alpha);
				//DrawRectCol(_dx, _opty, _b.w, 16, _op_c, alpha);
				DrawTextColour(_dx + _b.w - 4, _opty + 9 + _opt_txt_yoff, _b.options[i], _op_txt_c, alpha * _b.select_f);
				draw_sprite(spr_ui_combox_arrow, 0, _dx, _opty);
				//DrawRectCol(_dx, _opty + 1, _b.w, 1, _op_txt_c, alpha);
			}
			
			//draw shadow
			DrawRectCol(_dx + _b.w, _dy + 16, _b.shadow_dist, _opty - _dy + _b.shadow_dist, c_black, alpha);
			DrawRectCol(_dx + 4, _opty + 16, _b.w - 4, _b.shadow_dist, c_black, alpha);
			
		}
		
		draw_set_halign(fa_left);
	}
	
	//if we're text input, show the inputted text if there is any, otherwise show the func defined text
	if (_is_textinput){
		if (_b.text != "") _text = _b.text;
		else _txt_c = c_ltgray;
	}
	
	//draw text
	//scribble(_text).align(fa_center, fa_middle).blend(_txt_c,alpha).draw(_txt_x, _dy);
	if (_text != undefined) DrawTextShadowColour(_txt_x, _dy + (_b.h / 2), _text, _txt_c, c_black, alpha);	
	draw_set_halign(fa_left);
	
	//text input cursor
	if (_b.state == eButtonState.ACTIVE && _is_textinput){
		DrawTextColour(_txt_x + string_width(string_copy(_text, 0, _b.edit_pos)), _dy + (_b.h / 2), "|", $EEA200, (0.6 + sin(current_time*0.01) * 0.4) * alpha);
	}
	
	draw_set_valign(fa_top);
	
	//hovered
	if (_b.state == eButtonState.HOVERED || _b.state == eButtonState.PUSHED_IN){
		gpu_set_blendmode(bm_add);
		draw_sprite_stretched_ext(_b.bg_spr, _b.bg_spr_ii, _dx, _dy, _b.w, _b.h, c_white, 0.2 * alpha);
		gpu_set_blendmode(bm_normal);
	}
}


///@ignore
///@desc used internally by button only
function _ButtonHandleTextInput(btn){
	//exit with enter key
	if (keyboard_check_pressed(vk_enter)){
		global.button_active = -1;
		return true;
	}
	
	//control commands
	if (keyboard_check(vk_control)){
		//paste
		if (keyboard_check_pressed(ord("V"))){
			btn.text = string_insert(clipboard_get_text(), btn.text, btn.edit_pos + 1);
		}
	}
	

	//todo: handle clicking to change cursor pos?

	//handle text modification
	var _rkey = InputKeyGetRepeated();
	
	//nav cursor
	if (_rkey == vk_left){
		if (btn.edit_pos > 0) btn.edit_pos --;
	}
	if (_rkey == vk_right){
		if (btn.edit_pos < string_length(btn.text)) btn.edit_pos ++;
	}
	//remove char behind cursor
	if (_rkey == vk_backspace && btn.edit_pos > 0){
		btn.text = string_delete(btn.text, btn.edit_pos, 1);
		btn.edit_pos --;
	}	
	//remove char ahead of cursor
	if (_rkey == vk_delete){
		btn.text = string_delete(btn.text, btn.edit_pos + 1, 1);
	}
	
	//input text
	if (btn.type == eButtonType.TEXT_INPUT){
		if (keyboard_string != ""){	
			btn.text = string_insert(keyboard_string, btn.text, btn.edit_pos + 1);
			btn.edit_pos += string_length(keyboard_string);
			keyboard_string = "";
		}
	}
	
	if (btn.type == eButtonType.NUM_INPUT){
		if (keyboard_key >= ord("0") && keyboard_key <= ord("9")){
			btn.text = string_insert(chr(keyboard_key), btn.text, btn.edit_pos + 1);
			btn.edit_pos += string_length(chr(keyboard_key));
		}
		if (keyboard_key >= vk_numpad0 && keyboard_key <= vk_numpad9){
			
			var _kcode = (keyboard_key - vk_numpad0) + ord("0");
			
			btn.text = string_insert(chr(_kcode), btn.text, btn.edit_pos + 1);
			btn.edit_pos += 1;
		}		
	}
	
	if (btn.max_chars > -1 && string_length(btn.text) > btn.max_chars) {
		btn.text = string_copy(btn.text, 1, btn.max_chars);	
	}
	
	return false;
}