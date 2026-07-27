local function add_gpu_env_vars(gpu_file_path)
	if not gpu_file_path then
		return
	end

	local file = io.open(gpu_file_path, "r")

	if file then
		local line = file:read("*l")

		file:close()

		if string.match(string.lower(line), ".*name=.*nvidia.*") then
			hl.env("LIBVA_DRIVER_NAME", "nvidia")
			hl.env("GBM_BACKEND", "nvidia-drm")
			hl.env("WLR_NO_HARDWARE_CURSORS", "1")
			hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
		end

		local gpu_card_path = string.match(line, ".*card_path=(%S+)")

		if gpu_card_path then
			hl.env("AQ_DRM_DEVICES", gpu_card_path)
		end
	end
end

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- Cursor variables
hl.env("XCURSOR_SIZE", "20")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "20")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")

-- XDG variables
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Qt variables
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "0")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Toolkit variables
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("ELECTRON_OZONE_PLATFORM", "wayland")

-- GPU-related variables
local gpu_info_file = "/tmp/hyprland-rice/gpu-info"

add_gpu_env_vars(gpu_info_file)
