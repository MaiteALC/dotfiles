local function load_module(module_name)
	local default_font_size = 22
	local is_valid = module_name:match("^[%w_.-]+$")

	if not is_valid then
		hl.notification.create({
			text = string.format(" Unable to load module with invalid name.\n Name: `%s`", module_name),
			timeout = 6000,
			icon = 3, -- -1: No icon
			-- 0: WARNING
			-- 1: INFO
			-- 2: HINT
			-- 3: ERROR
			-- 4: CONFUSED
			-- 5: OK
			font_size = default_font_size,
		})
		return
	end

	local modules_root_dir = "modules."
	local success, module = pcall(require, modules_root_dir .. module_name)

	if success then return end

	local not_found_error_prefix = "module 'modules." .. module_name .. "' not found:"
	local notification_msg_prefix = string.format(" The module `%s` cannot be loaded.\n", module_name)
	local icon = 0

	if module_name == "devices" then
		notification_msg_prefix = " Optional per-device configuration module (modules/devices.lua) cannot be loaded.\n Proceeding with default settings.\n"
		icon = 1
	end

	if module:sub(1, #not_found_error_prefix) == not_found_error_prefix then -- equivalent to a starts_with() method
		hl.notification.create({
			text = notification_msg_prefix .. " Error: module not found.",
			icon = icon,
			timeout = 6000,
			font_size = default_font_size,
		})
	else
		hl.notification.create({
			text = notification_msg_prefix .. " Error: " .. module,
			timeout = 7000,
			icon = icon,
			font_size = default_font_size,
		})
	end
end

local modules_list = {
	"env-vars",
	"autostart",
	"binds",
	"input",
	"animations",
	"rules",
	"devices",
}

for _, module in pairs(modules_list) do
	load_module(module)
end

------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1.0",
})

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		gaps_in = 6,
		gaps_out = 12,

		border_size = 1,

		col = {
			active_border = { colors = { "rgb(ECEFF4)" } },
			inactive_border = "rgba(64,64,64,0.4)",
		},

		resize_on_border = true,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,

		active_opacity = 1.0,
		inactive_opacity = 0.95,
		fullscreen_opacity = 1.0,

		dim_inactive = true,
		dim_strength = 0.03,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = true,

			size = 3,
			passes = 3,
			vibrancy = 0.2,

			new_optimizations = true,
			ignore_opacity = true,
			xray = true,

			noise = 0.02,
			contrast = 1,
			brightness = 0.56,

			popups = true,
			special = true,
		},
	},

	animations = {
		enabled = true,
	},

	misc = {
		force_default_wallpaper = 0,

		disable_hyprland_logo = true,

		animate_manual_resizes = true,
		animate_mouse_windowdragging = true,

		vrr = 1,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
	},

	xwayland = {
		create_abstract_socket = true,
	},
})
