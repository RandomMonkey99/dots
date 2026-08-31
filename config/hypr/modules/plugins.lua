local variables = require("modules.variables")
local colors = require("modules.colors")

package.path = package.path .. ";./?.lua;./?/init.lua"
local smw = require("plugins.split-monitor-workspaces")

for i = 1, smw.get_amount_of_workspaces() do
    local n = tostring(i)
    if n == "10" then n = "0" end -- Optional if you configured 10 workspaces: bind workspace 10 to SUPER + 0
    -- Switch to the Nth workspace on the currently focused monitor.
    hl.bind(variables.mainMod .. " +" .. n, smw.workspace(n))
    -- Move the active window to the Nth workspace on the currently focused monitor silently (no focus change).
    hl.bind(variables.mainMod .. " + SHIFT +" .. n, smw.move_to_workspace_silent(n))
end

hl.config({
    plugin = {
        hyprexpo = {
            dynamic_grid = 1,
            columns = 10,
            gaps_in = 10,
            gaps_out = 0,
            bg_col = colors.background,
            workspace_method = "center current",
            gesture_distance = 200,
            cancel_key = "escape, q",
            show_cursor = 1,
            drag_drop_enable = 0, -- Disable moving windows by dragging workspace previews.
            tile_rounding = 5,
            border_color = 0,
            border_color_current = 0,
            border_color_focus = colors.primary_container,
            border_color_hover = 0,
            label_enable = 0,
        },
    },
})

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/hypremoji/?.lua"
require("hypremoji")
require("plugins.magnifier")
