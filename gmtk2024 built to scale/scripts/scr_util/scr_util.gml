
/// @description draws a rectangle with the given colour
function DrawRectCol(xx, yy, width, height, colour, alpha = 1){
	//draw_rectangle_colour(xx, yy, xx + width, yy + height, colour, colour, colour, colour, false);
	draw_sprite_ext(spr_pix, 0, xx, yy, width, height, 0, colour, alpha);
}


/// @description draws a rectangle with the given colour
function DrawRectCols(xx, yy, width, height, colour1, colour2, colour3, colour4){
	draw_rectangle_colour(xx, yy, xx + width, yy + height, colour1, colour2, colour3, colour4, false);
}


/// @description draws text using the given colour without having to specify it 4 times
function DrawTextColour(xx, yy, str, colour, alpha){
	var _scale = scale_text_for_font(1);
	draw_text_transformed_color(xx, yy, str, _scale, _scale, 0, colour, colour, colour, colour, alpha)
}

/// @description draws text like DrawTextColour but automatically also draws the text's shadow too
function DrawTextColourShadow(xx, yy, str, colour, alpha, xoff = 1, yoff = 1, shadow_colour = c_black) {
	draw_text_colour(xx + xoff, yy + yoff, str, shadow_colour, shadow_colour, shadow_colour, shadow_colour, alpha);
	draw_text_colour(xx, yy, str, colour, colour, colour, colour, alpha);
}

/// @description draws text like DrawTextColour but automatically also draws the text's shadow too
function DrawTextColourShadowTransform_Ext(xx, yy, str, colour, alpha, xoff = 1, yoff = 1, shadow_colour = c_black, xscale = 1, yscale = 1, angle = 0) {
	DrawTextTransColour(xx + xoff, yy + yoff, str, xscale, yscale, angle, shadow_colour, alpha);
	DrawTextTransColour(xx, yy, str, xscale, yscale, angle, colour, alpha);
}

/// @description draws text using the given colour without having to specify it 4 times
function DrawTextShadowColour(xx, yy, str, colour, shadow_colour, alpha){
	DrawTextColour(xx + 1, yy + 1, str, shadow_colour, alpha);
	DrawTextColour(xx, yy, str, colour, alpha);
}

/// @description draws text using the given colour without having to specify it 4 times, EXT edition
function DrawTextColourExt(xx, yy, str, sep, max_w, colour, alpha){
	var _scale = scale_text_for_font(1);
	draw_text_ext_transformed_color(xx, yy, str, sep, max_w, _scale, _scale, 0, colour, colour, colour, colour, alpha)
}

/// @description draws text using the given colour without having to specify it 4 times, EXT edition
function DrawTextColourShadowTrans_Ext(xx, yy, str, sep, max_w, colour, shadow_colour = c_black, alpha = 1, scale = 1, xoff = 1, yoff = 1){
	max_w /= scale;
	scale = scale_text_for_font(scale);
	xoff *= scale;
	yoff *= scale;
	draw_text_ext_transformed_color(xx + xoff, yy + yoff, str, sep, max_w, scale, scale, 0, shadow_colour, shadow_colour, shadow_colour, shadow_colour, alpha)
	draw_text_ext_transformed_color(xx, yy, str, sep, max_w, scale, scale, 0, colour, colour, colour, colour, alpha)
}


/// @description draws text using the given colour without having to specify it 4 times, scaled edition
function DrawTextTransColour(xx, yy, str, xscale, yscale, angle, colour, alpha){
	draw_text_transformed_colour(xx, yy, str, scale_text_for_font(xscale), scale_text_for_font(yscale), angle, colour, colour, colour, colour, alpha);
}


/// @description draws text using the given colour without having to specify it 4 times, draw_text_ext_transformed_colour() wrapper.
function DrawTextExtTransColour(xx, yy, str, sep, max_w, xscale, yscale, angle, colour, alpha){
	draw_text_ext_transformed_colour(xx, yy, str, sep, max_w, xscale, yscale, angle, colour, colour, colour, colour, alpha);
}

///@desc									returns an array of all the files found in the given path/directory
///@param { String }	path				the path of the directory you want to search within
///@param { String }	filetypes			/* followed by the file extensions you want to include in your search, '/*' will return any files
///@param { any }		file_attrib			(fa_...)
///@param { bool }		include_path		includes the path in the file name list
///@param { bool }		remove_extension	removes the .extension of the filename
function FileFindAllInDir(path, filetypes = "/*", file_attrib = fa_none, include_path = false, remove_extension = false){
	var _fname = file_find_first(path + filetypes, file_attrib);
	var _arr_rfiles = [];
	
	while (_fname != ""){
		if (file_attrib != fa_directory || directory_exists(path + "/" + _fname)) {
			
			if (remove_extension){
				var _extdot = string_last_pos(".", _fname);
				_fname = string_delete(_fname, _extdot, 1 + string_length(_fname) - _extdot);
			}
			
			if (include_path) _fname = string_insert(path + "/", _fname, 0);
		
			array_push(_arr_rfiles, _fname);
		}
		_fname = file_find_next();
	}

	file_find_close();
	
	return _arr_rfiles;
}


///@desc						finds & imports the given json file then returns the struct. Returns 'undefined' otherwise
///@param {String} filepath		path of the file you want to open
function ImportJson(filepath) {
	if(!file_exists(filepath)) return undefined;
	
	var _file = file_text_open_read(filepath);
	var _json_str = "";
	
	while(!file_text_eof(_file)) {
		_json_str += file_text_read_string(_file);
		file_text_readln(_file);
	}
	
	file_text_close(_file);
	try 
	{
		return json_parse(_json_str);	
	} 
	catch(ex) 
	{
		return undefined;	
	}
}

function CopyArray(dest_arr, src_arr, clear_dest_first = true, copy_internal_structs = true) {
	array_delete(dest_arr,0,array_length(dest_arr));
	array_copy(dest_arr, 0, src_arr, 0, array_length(src_arr));
	if (copy_internal_structs = true) {
		for (var i = 0; i < array_length(dest_arr); i++) {
			if (is_struct(dest_arr[i]))
			{
				dest_arr[i] = CopyStruct(src_arr[i]);
			}
		}
	}
}

function CopyStruct(struct, recursive_copy = true){
	var _arr_struct_vars = struct_get_names(struct);
	var _rstruct = {};
	for (var i = 0; i < array_length(_arr_struct_vars); i++){		
		var _val = struct_get(struct, _arr_struct_vars[i]);	
		if (recursive_copy){
			if (is_struct(_val)){
				_val = CopyStruct(_val, true);
			} else if (is_array(_val)) {
				var _arr = [];
				CopyArray(_arr, _val, false, true);
				_val = _arr;
			}
		}
		struct_set(_rstruct, _arr_struct_vars[i], _val);
	}	
	return _rstruct;
}