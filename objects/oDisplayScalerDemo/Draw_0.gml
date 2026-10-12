/// @description World

draw_set_font(fntDefault);

// BLEED GRID (visible wherever the screen shows more than the safe area):
//-----------------------------------------------------------------------------
var _cell = 120;
var _x1 = -BASE_WIDTH * 2;
var _x2 = BASE_WIDTH * 3;
var _y1 = -BASE_HEIGHT * 2;
var _y2 = BASE_HEIGHT * 3;

draw_set_colour(colGrid_);
for (var _x = _x1; _x <= _x2; _x += _cell) draw_line(_x, _y1, _x, _y2);
for (var _y = _y1; _y <= _y2; _y += _cell) draw_line(_x1, _y, _x2, _y);

// SAFE AREA (in EXPAND mode it is always fully visible at zoom 1):
//-----------------------------------------------------------------------------
draw_set_colour(colSafe_);
draw_rectangle(0, 0, BASE_WIDTH, BASE_HEIGHT, false);
draw_set_colour(colAccent_);
for (var i = 0; i < 3; i++) draw_rectangle(i, i, BASE_WIDTH - i, BASE_HEIGHT - i, true);

// WORLD CONTENT (scales with zoom, unlike the GUI):
//-----------------------------------------------------------------------------
var _cx = BASE_WIDTH / 2;
var _cy = BASE_HEIGHT / 2;
for (var i = 0; i < 6; i++) {
	var _a = time_ * 0.5 + i * (pi / 3);
	var _r = 230 + sin(time_ * 1.5 + i) * 30;
	draw_set_colour(i mod 2 == 0 ? colAccent_ : colWarm_);
	draw_circle(_cx + cos(_a) * _r * 1.6, _cy + sin(_a) * _r, 26, false);
}

draw_set_colour(colWarm_);
draw_circle(_cx, _cy, 110, true);

draw_set_colour(colAccent_);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(_cx, _cy - 14, "SAFE AREA", 0.7, 0.7, 0);
draw_set_colour(colMuted_);
draw_text_transformed(_cx, _cy + 16, string(BASE_WIDTH) + " x " + string(BASE_HEIGHT), 0.55, 0.55, 0);

draw_set_colour(c_white);
draw_set_alpha(1);
