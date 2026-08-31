local variables = require("modules.variables")
local colors = require("modules.colors")

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,

        border_size = 2,

        col = {
            active_border = colors.primary_container,
            inactive_border = colors.primary_container,
        },

        resize_on_border = true,

        allow_tearing = false,

        layout = "master",
    },

    decoration = {
        rounding = 5,
        rounding_power = 2,

        active_opacity = 0.9,
        inactive_opacity = 0.9,

        shadow = {
            enabled = false,
            range = 10,
            render_power = 3,
            color = "#1a1a1aee",
        },

        blur = {
            enabled = false,
            size = 6,
            passes = 1,
            vibrancy = 0,
            xray = true,
        },
    },

    animations = {
        enabled = true,
    },
})
