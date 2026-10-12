/// @description Init
//-----------------------------------------------------------------------------
//	Showcase for oDisplayScaler:
//		- World: the BASE_WIDTH x BASE_HEIGHT safe area plus the bleed area that
//		  appears around it. Zoom only affects this layer.
//		- GUI: markers authored in BASE space and re-anchored to the screen's
//		  corners and edges, a status line and a row of buttons.
//		- Cursor ring: follows the DPR-corrected GUI mouse position.
//
//	Layout is recalculated only when the scaler fires DisplayScalerEvent.RESIZE,
//	and the status line only on DisplayScalerEvent.CAMERA. That's how an
//	external system (e.g. a GUI system) should hook in.
//-----------------------------------------------------------------------------

time_ = 0;

colAccent_	= make_colour_rgb(63, 169, 245);
colWarm_	= make_colour_rgb(255, 196, 61);
colMuted_	= make_colour_rgb(120, 130, 145);
colGrid_	= make_colour_rgb(30, 34, 43);
colSafe_	= make_colour_rgb(18, 30, 46);
colPanel_	= make_colour_rgb(24, 30, 40);

// ANCHOR MARKERS (authored in BASE_WIDTH x BASE_HEIGHT space):
//-----------------------------------------------------------------------------
var _m = 32;
markers_ = [
	{ x: _m,					y: _m,					anchor: DisplayAnchor.TOPLEFT },
	{ x: BASE_WIDTH / 2,		y: _m,					anchor: DisplayAnchor.TOPCENTER },
	{ x: BASE_WIDTH - _m,		y: _m,					anchor: DisplayAnchor.TOPRIGHT },
	{ x: _m,					y: BASE_HEIGHT / 2,		anchor: DisplayAnchor.MIDDLELEFT },
	{ x: BASE_WIDTH - _m,		y: BASE_HEIGHT / 2,		anchor: DisplayAnchor.MIDDLERIGHT },
	{ x: _m,					y: BASE_HEIGHT - _m,	anchor: DisplayAnchor.BOTTOMLEFT },
	{ x: BASE_WIDTH / 2,		y: BASE_HEIGHT - _m,	anchor: DisplayAnchor.BOTTOMCENTER },
	{ x: BASE_WIDTH - _m,		y: BASE_HEIGHT - _m,	anchor: DisplayAnchor.BOTTOMRIGHT },
];

// BUTTONS (bottom-centre anchored, laid out left to right):
//-----------------------------------------------------------------------------
buttonHeight_ = 60;
buttonGap_ = 12;
buttonY_ = BASE_HEIGHT - 110 - buttonHeight_;
buttons_ = [
	{ label: "-",		width: 64,	action: function() { display_scaler_set_zoom(display_scaler_get_zoom() - 0.25); } },
	{ label: "+",		width: 64,	action: function() { display_scaler_set_zoom(display_scaler_get_zoom() + 0.25); } },
	{ label: "1x",		width: 64,	action: function() { display_scaler_set_zoom(1); } },
	{ label: "Mode",	width: 110,	action: method(id, function() { cycle_mode(); }) },
	{ label: "Info",	width: 96,	action: function() { display_scaler_show_overlay(!oDisplayScaler.showOverlay_); } },
];

statusText_ = "";
mouseSeen_ = false;		// Hide the cursor ring until the pointer has been over the game

#region METHODS

/// Cycles through the built-in scale modes
cycle_mode = function() {
	var _mode = display_scaler_get_mode();
	_mode = is_numeric(_mode) ? (_mode + 1) mod DisplayScaleMode.__COUNT : 0;
	display_scaler_set_mode(_mode);
}

/// Re-anchors every marker and button. Runs on DisplayScalerEvent.RESIZE only,
/// so Draw GUI and Step just read cached positions.
layout = function(_info) {
	for (var i = 0; i < array_length(markers_); i++) {
		var _mk = markers_[i];
		_mk.guiX = display_gui_anchor_x(_mk.x, _mk.anchor);
		_mk.guiY = display_gui_anchor_y(_mk.y, _mk.anchor);
	}

	var _total = (array_length(buttons_) - 1) * buttonGap_;
	for (var i = 0; i < array_length(buttons_); i++) _total += buttons_[i].width;

	var _x = (BASE_WIDTH / 2) - (_total / 2);
	var _y1 = display_gui_anchor_y(buttonY_, DisplayAnchor.BOTTOMCENTER);
	for (var i = 0; i < array_length(buttons_); i++) {
		var _btn = buttons_[i];
		var _x1 = display_gui_anchor_x(_x, DisplayAnchor.BOTTOMCENTER);
		_btn.rect = [_x1, _y1, _x1 + _btn.width, _y1 + buttonHeight_];
		_x += _btn.width + buttonGap_;
	}
}

/// Rebuilds the one-line status text. Runs on DisplayScalerEvent.CAMERA
/// (which also fires on every resize and mode change).
update_status = function(_info) {
	_info ??= display_scaler_get_info();
	if (is_undefined(_info)) return;
	statusText_ = _info.modeName + "   |   "
				+ string(_info.viewWidth) + " x " + string(_info.viewHeight) + "   |   "
				+ "Zoom " + string_format(_info.zoom, 1, 2) + "x";
}

/// Draws a corner bracket or edge tick that points into the screen
draw_anchor_marker = function(_x, _y, _anchor, _col) {
	var _len = 36;
	var _w = 4;
	var _dx = 1 - (_anchor mod 3);	// Left: 1, centre: 0, right: -1
	var _dy = 1 - (_anchor div 3);	// Top: 1, middle: 0, bottom: -1

	draw_set_colour(_col);
	if (_dx != 0 && _dy != 0) {
		// Corner: L-shaped bracket
		draw_line_width(_x, _y, _x + _dx * _len, _y, _w);
		draw_line_width(_x, _y, _x, _y + _dy * _len, _w);
	}
	else if (_dx == 0) {
		// Top/bottom edge: horizontal tick
		draw_line_width(_x - _len / 2, _y, _x + _len / 2, _y, _w);
	}
	else {
		// Left/right edge: vertical tick
		draw_line_width(_x, _y - _len / 2, _x, _y + _len / 2, _w);
	}
}

#endregion

// HOOK INTO THE SCALER:
//-----------------------------------------------------------------------------
// Both run now (the scaler is already running) and again whenever their event fires
layout();
update_status();
resizeHandle_ = display_scaler_subscribe(DisplayScalerEvent.RESIZE, layout, false);
cameraHandle_ = display_scaler_subscribe(DisplayScalerEvent.CAMERA, update_status, false);
