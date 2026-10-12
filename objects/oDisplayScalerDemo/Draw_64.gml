/// @description GUI

draw_set_font(fntDefault);

var _gw = display_get_gui_width();
var _mx = display_mouse_gui_x();
var _my = display_mouse_gui_y();

// TITLE (wraps on narrow portrait screens):
//-----------------------------------------------------------------------------
var _tx = display_gui_anchor_x(BASE_WIDTH / 2, DisplayAnchor.TOPCENTER);
var _ty = display_gui_anchor_y(96, DisplayAnchor.TOPCENTER);
var _titleScale = 1.2;
var _subScale = 0.6;
var _wrap = min(_gw - 120, 1100);
var _title = "HTML5 Display Scaler";

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_text_ext_transformed(_tx, _ty, _title, -1, _wrap / _titleScale, _titleScale, _titleScale, 0);
_ty += string_height_ext(_title, -1, _wrap / _titleScale) * _titleScale + 6;
draw_set_colour(colMuted_);
draw_text_ext_transformed(_tx, _ty, "Resize the window - the layout adapts to any screen", -1, _wrap / _subScale, _subScale, _subScale, 0);

// ANCHOR MARKERS:
//-----------------------------------------------------------------------------
for (var i = 0; i < array_length(markers_); i++) {
	var _mk = markers_[i];
	draw_anchor_marker(_mk.guiX, _mk.guiY, _mk.anchor, colAccent_);
}

// STATUS LINE (above the buttons):
//-----------------------------------------------------------------------------
var _r0 = buttons_[0].rect;
var _cx = display_gui_anchor_x(BASE_WIDTH / 2, DisplayAnchor.BOTTOMCENTER);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_colour(colMuted_);
draw_text_transformed(_cx, _r0[1] - 16, statusText_, 0.55, 0.55, 0);

// BUTTONS:
//-----------------------------------------------------------------------------
draw_set_valign(fa_middle);
for (var i = 0; i < array_length(buttons_); i++) {
	var _r = buttons_[i].rect;
	var _hover = point_in_rectangle(_mx, _my, _r[0], _r[1], _r[2], _r[3]);

	draw_set_colour(_hover ? colAccent_ : colPanel_);
	draw_roundrect_ext(_r[0], _r[1], _r[2], _r[3], 16, 16, false);
	draw_set_colour(colAccent_);
	draw_roundrect_ext(_r[0], _r[1], _r[2], _r[3], 16, 16, true);
	draw_set_colour(_hover ? c_black : c_white);
	draw_text_transformed((_r[0] + _r[2]) / 2, (_r[1] + _r[3]) / 2, buttons_[i].label, 0.75, 0.75, 0);
}

// CONTROLS HINT (below the buttons):
//-----------------------------------------------------------------------------
draw_set_valign(fa_top);
draw_set_colour(colMuted_);
draw_text_ext_transformed(_cx, _r0[3] + 16, "Scroll to zoom   |   M  mode   |   I  details", -1, _wrap / 0.5, 0.5, 0.5, 0);

// CURSOR RING (shows the DPR-corrected GUI mouse lines up with the real cursor):
//-----------------------------------------------------------------------------
if (mouseSeen_) {
	draw_set_colour(colWarm_);
	draw_circle(_mx, _my, 14, true);
	draw_circle(_mx, _my, 15, true);
}

draw_set_colour(c_white);
