------------------------------------------
--- WINDOW, WORKSPACE, AND LAYER RULES ---
------------------------------------------

hl.layer_rule({
    blur = false,
    match = {
        namespace = "^(waybar|swaync-control-center)$",
    }
})

hl.layer_rule({
    match = { namespace = "swaync-control-center" },
    animation = "slide right"
})

hl.window_rule({
    match = {
        class = "xwayland:1",
        float = true
    },

    no_blur = true
})

hl.window_rule({
    match = { class = "blueman-manager" },

    float = true,
    center = true,
    size = {"monitor_w*0.4", "monitor_h*0.5"}
})

hl.window_rule({
    -- Ignore maximize requests from all apps
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})