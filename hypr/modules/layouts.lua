---------------
--- LAYOUTS ---
---------------

hl.config({
    dwindle = {
        smart_split = true,
        preserve_split = true, -- You probably want this
        precise_mouse_move = true,
        use_active_for_splits = false
    },

    master = {
        mfact = 0.5,
        new_status = "slave",

    },

    scrolling = {
        follow_min_visible = 0.2,
        fullscreen_on_one_column = true
    }
})