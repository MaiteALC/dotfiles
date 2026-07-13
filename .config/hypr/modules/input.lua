---------------
---- INPUT ----
---------------

hl.config({
	input = {
		follow_mouse = 1,

		sensitivity = 0, -- 0 means no modification.

		touchpad = {
			natural_scroll = true,
			tap_to_click = true,
			clickfinger_behavior = true,
		},
	},

	cursor = {
		hide_on_key_press = true,
		min_refresh_rate = 60,
		inactive_timeout = 45,
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.gesture({
	fingers = 3,
	direction = "swipe",
	mods = "CONTROL",
	action = "move",
})

hl.gesture({
	fingers = 3,
	direction = "swipe",
	mods = "SHIFT",
	action = "resize",
})
