/// @description Input

time_ += delta_time / 1000000;

if (!mouseSeen_ && (device_mouse_x_to_gui(0) != 0 || device_mouse_y_to_gui(0) != 0)) mouseSeen_ = true;

// Zoom: mouse wheel / arrow keys, R to reset
if (mouse_wheel_up() || keyboard_check_pressed(vk_up))		display_scaler_set_zoom(display_scaler_get_zoom() + 0.1);
if (mouse_wheel_down() || keyboard_check_pressed(vk_down))	display_scaler_set_zoom(display_scaler_get_zoom() - 0.1);
if (keyboard_check_pressed(ord("R")))						display_scaler_set_zoom(1);

// Scale mode: M
if (keyboard_check_pressed(ord("M"))) cycle_mode();

// Overlay: I
if (keyboard_check_pressed(ord("I"))) display_scaler_show_overlay(!oDisplayScaler.showOverlay_);

// On-screen buttons (hit-tested against the DPR-corrected GUI mouse)
if (mouse_check_button_pressed(mb_left)) {
	var _mx = display_mouse_gui_x();
	var _my = display_mouse_gui_y();
	for (var i = 0; i < array_length(buttons_); i++) {
		var _r = buttons_[i].rect;
		if (point_in_rectangle(_mx, _my, _r[0], _r[1], _r[2], _r[3])) {
			buttons_[i].action();
			break;
		}
	}
}
