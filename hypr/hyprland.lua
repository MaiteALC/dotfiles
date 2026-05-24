require("modules.env-vars")
require("modules.autostart")
require("modules.binds")
require("modules.input")
require("modules.animations")
require("modules.rules")

local success = pcall(require("modules.devices"))

if not success then
    print("Module 'modules/devices.lua' cannot be loaded. Proceding with default configurations.")
end

------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1.0",
})


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 6,
        gaps_out = 12,

        border_size = 1,

        col = {
            active_border = { colors = { "rgb(ECEFF4)" }},
            inactive_border = "rgba(64,64,64,0.4)",
        },

        resize_on_border = true,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding = 14,
        rounding_power = 2,

        active_opacity = 1.0,
        inactive_opacity = 0.95,
        fullscreen_opacity = 1.0,

        dim_inactive = true,
        dim_strength = 0.03,

        shadow = {
            enabled = false
        },

        blur = {
            enabled = true,

            size = 2,
            passes = 3,
            vibrancy = 0.3,

            new_optimizations = true,
            ignore_opacity = true,
            xray = true,

            noise = 0.03,
            contrast = 1,
            brightness = 0.82,

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
    key_press_enables_dpms = true
    },

    xwayland = {
        create_abstract_socket = true
    }
})
