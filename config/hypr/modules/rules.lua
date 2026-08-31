local variables = require("modules.variables")
local colors = require("modules.colors")

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name = "fzfmenu",
    match = { class = "fzfmenu" },
    move = { "51", "234" },
    size = { "489", "475" },
    float = true,
    pin = true
})

hl.window_rule({
    name = "wallpaper",
    match = { class = "wall" },
    move = { "67", "421" },
    size = { "967", "287" },
    float = true,
    pin = true
})

hl.window_rule({
    name = "connection",
    match = { class = "org.nmrs.ui" },
    move = "60 410",
    size = "515 301",
    float = true,
    pin = true,
})


hl.on("window.active", function(w)
    if w.class ~= "org.nmrs.ui" then
        hl.exec_cmd("killall nmrs")
    end
end)

hl.on("window.active", function(w)
    if w.class ~= "fzfmenu" then
        hl.dsp.window.kill({ class = "fzfmenu" })
        hl.exec_cmd("kill $(hyprctl clients -j | jq -r '.[] | select(.class == \"fzfmenu\") | .pid')")
    end
end)

hl.on("window.active", function(w)
    if w.class ~= "wall" then
        hl.dsp.window.kill({ class = "wall" })
        hl.exec_cmd("kill $(hyprctl clients -j | jq -r '.[] | select(.class == \"wall\") | .pid')")
    end
end)
