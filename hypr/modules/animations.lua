-----------------------------
--- CURVES AND ANIMATIONS ---
----------------------------- 

-- Default bezier curves
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default spring curves
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })


-- Customized bezier curves
hl.curve("bounce",  { type = "bezier", points = { {0.1, 1.25}, {0.15, 1.0}  } })
hl.curve("buttery", { type = "bezier", points = { {0.1, 1.15}, {0.17, 1.02} } })
hl.curve("smooth",  { type = "bezier", points = { {0.0, 0.0}, {0.12, 1.0}   } })
hl.curve("linear",  { type = "bezier", points = { {0.0, 0.0}, {1.0, 1.0}    } })


-- Animation Tree configuration
hl.animation({ leaf = "border",     enabled = false })
hl.animation({ leaf = "fadeIn",     enabled = false })
hl.animation({ leaf = "fadeOut",    enabled = false })
hl.animation({ leaf = "fadeLayers", enabled = false })
hl.animation({ leaf = "fadeShadow", enabled = false })
hl.animation({ leaf = "fadeSwitch", enabled = false })
hl.animation({ leaf = "fadeDim",    enabled = false })

hl.animation({
    leaf = "global",
    enabled = true,
    speed = 8,
    bezier = "default"
})

hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 3.6,
    bezier = "easeOutQuint",
    style = "slide bottom"
})

hl.animation({
    leaf = "layers",
    enabled = true,
    speed = 5,
    bezier = "buttery",
    style = "slide top"
})

hl.animation({
    leaf = "fadePopups",
    enabled = false,
    speed = 3.03,
    bezier = "smooth"
})

hl.animation({
    leaf = "fadeDpms",
    enabled = false,
    speed = 8,
    bezier = "smooth"
})


hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 6,
    bezier = "buttery",
    style = "slidefade 18%"
})

hl.animation({
    leaf = "specialWorkspace",
    enabled = true,
    speed = 2.7,
    bezier = "almostLinear",
    style = "slidefadevert -15%"
})

hl.animation({
    leaf = "zoomFactor",
    enabled = true,
    speed = 5,
    bezier = "quick"
})
