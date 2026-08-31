local variables = require("modules.variables")
local colors = require("modules.colors")

-- Close active window, or open hyprlock if no window is active
hl.bind(variables.mainMod .. " + C", function()
    if hl.get_active_window() ~= nil then
        hl.dispatch(hl.dsp.window.close())
    else
        hl.exec_cmd("hyprlock")
    end
end)

-- Force kill active window
hl.bind(variables.mainMod .. " + SHIFT + C", hl.dsp.window.kill())

-- Close all windows
local function close_all_windows()
    for _, window in ipairs(hl.get_windows()) do
        hl.dispatch(hl.dsp.window.close({
            window = window
        }))
    end
end

hl.bind(variables.mainMod .. " + ALT + C", close_all_windows)

-- Applications
hl.bind(variables.mainMod .. " + Q", hl.dsp.exec_cmd(variables.terminal), {
    locked = true
})

hl.bind(variables.mainMod .. " + T", hl.dsp.exec_cmd(variables.editor))
hl.bind(variables.mainMod .. " + E", hl.dsp.exec_cmd(variables.fileManager))
hl.bind(variables.mainMod .. " + R", hl.dsp.exec_cmd(variables.menu))
hl.bind(variables.mainMod .. " + F", hl.dsp.exec_cmd(variables.browser))

-- Power
hl.bind(variables.mainMod .. " + M", hl.dsp.exec_cmd("hyprshutdown"))
hl.bind(variables.mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("shutdown now"))

-- Clipboard
hl.bind(
    variables.mainMod .. " + V",
    hl.dsp.exec_cmd("kitty --class fzfmenu clip")
)

-- Close ALL windows
hl.bind(variables.mainMod .. " + CTRL + M", function()
    for _, client in ipairs(hl.get_windows()) do
        hl.dispatch(hl.dsp.window.close({
            window = client
        }))
    end
end)

-- Window controls
hl.bind(
    variables.mainMod .. " + SHIFT + V",
    hl.dsp.window.float({ action = "toggle" })
)

hl.bind(
    variables.mainMod .. " + P",
    hl.dsp.window.pseudo()
)

hl.bind(
    variables.mainMod .. " + J",
    hl.dsp.layout("togglesplit")
)

hl.bind(
    variables.mainMod .. " + N",
    hl.dsp.exec_cmd("kitty --class fzfmenu ~/.local/bin/nmfzf --hold")
)

-- Reload Waybar
hl.bind(
    variables.mainMod .. " + SHIFT + R",
    hl.dsp.exec_cmd("killall waybar && waybar")
)
-- Wallpaper
hl.bind(
    variables.mainMod .. " + W",
    hl.dsp.exec_cmd("qs")
)

-- Screenshots
hl.bind(
    "Print",
    hl.dsp.exec_cmd('grim "$(date +\'.png\')" | wl-copy')
)

hl.bind(
    "CTRL + Print",
    hl.dsp.exec_cmd('grim -g "$(slurp -d)" "$(date +\'.png\')" | wl-copy')
)

-- Screen recording
hl.bind(
    variables.mainMod .. " + Print",
    hl.dsp.exec_cmd('wf-recorder -g "$(slurp)" -f ~/Videos/recording.mp4')
)

-- Color picker
hl.bind(
    variables.mainMod .. " + SHIFT + P",
    hl.dsp.exec_cmd("hyprpicker -an")
)

-- Lock screen
hl.bind(
    variables.mainMod .. " + L",
    hl.dsp.exec_cmd("hyprlock")
)

-- Hyprexpo
hl.bind(
    variables.mainMod .. " + Tab", function()
        hl.plugin.hyprexpo.expo("toggle")
    end
)

hl.define_submap("hyprexpo", function()
    hl.bind("left", function() hl.plugin.hyprexpo.kb_focus("left") end)
    hl.bind("right", function() hl.plugin.hyprexpo.kb_focus("right") end)
    hl.bind("up", function() hl.plugin.hyprexpo.kb_focus("up") end)
    hl.bind("down", function() hl.plugin.hyprexpo.kb_focus("down") end)
    hl.bind("return", function() hl.plugin.hyprexpo.kb_confirm() end)
    hl.bind("escape", function() hl.plugin.hyprexpo.expo("cancel") end)
end)

---------------------
-- WINDOW FOCUS -----
---------------------

hl.bind(
    variables.mainMod .. " + left",
    hl.dsp.focus({ direction = "left" })
)

hl.bind(
    variables.mainMod .. " + right",
    hl.dsp.focus({ direction = "right" })
)

hl.bind(
    variables.mainMod .. " + up",
    hl.dsp.focus({ direction = "up" })
)

hl.bind(
    variables.mainMod .. " + down",
    hl.dsp.focus({ direction = "down" })
)

hl.bind(
    variables.mainMod .. " + A",
    hl.dsp.layout("swapwithmaster master ignoremaster")
)

---------------------
-- WAYBAR TOGGLE ----
---------------------

hl.bind("SUPER + X", function()
    local handle = io.popen("pidof waybar")

    if not handle then
        hl.exec_cmd("waybar")
        return
    end

    local value_raw = handle:read("*a")
    handle:close()

    local pid = value_raw:gsub("[%n\r]", "")

    if pid == "" then
        hl.exec_cmd("waybar")
    else
        hl.exec_cmd("killall waybar")
    end
end)

---------------------
-- RICE MODE --------
---------------------

hl.bind("F2", function()
    local handle = io.popen("pidof waybar")

    if not handle then
        return
    end

    local value_raw = handle:read("*a")
    handle:close()

    local pid = value_raw:gsub("[%n\r]", "")

    if pid == "" then
        -- Rice mode ON
        hl.config({
            general = {
                gaps_in = 5,
                gaps_out = 10,
                border_size = 2,
            },
            decoration = {
                active_opacity = 0.9,
                inactive_opacity = 0.9,
                rounding = 5,
            },
        })

        hl.exec_cmd("waybar")
    else
        -- Rice mode OFF
        hl.config({
            general = {
                gaps_in = 0,
                gaps_out = 0,
                border_size = 0,
            },
            decoration = {
                active_opacity = 1,
                inactive_opacity = 1,
                rounding = 0,
            },
        })

        hl.exec_cmd("killall waybar")
    end
end)

---------------------
-- WORKSPACES -------
---------------------

for i = 1, 10 do
    local key = i % 10

    hl.bind(
        variables.mainMod .. " + " .. key,
        hl.dsp.focus({ workspace = i })
    )

    hl.bind(
        variables.mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = i })
    )
end

---------------------
-- SPECIAL WORKSPACE
---------------------

hl.bind(
    variables.mainMod .. " + S",
    hl.dsp.workspace.toggle_special("magic")
)

hl.bind(
    variables.mainMod .. " + SHIFT + S",
    hl.dsp.window.move({
        workspace = "special:magic"
    })
)

---------------------
-- WORKSPACE SCROLL -
---------------------

hl.bind(
    variables.mainMod .. " + mouse_down",
    hl.dsp.focus({ workspace = "e+1" })
)

hl.bind(
    variables.mainMod .. " + mouse_up",
    hl.dsp.focus({ workspace = "e-1" })
)

---------------------
-- MOUSE ------------
---------------------

hl.bind(variables.mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(variables.mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

---------------------
-- AUDIO ------------
---------------------

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(
        "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ & swayosd-client --output-volume raise"
    ),
    {
        locked = true,
        repeating = true
    }
)

hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(
        "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- & swayosd-client --output-volume lower"
    ),
    {
        locked = true,
        repeating = true
    }
)

hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle & swayosd-client --output-volume mute-toggle"
    ),
    {
        locked = true,
        repeating = true
    }
)

hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle & swayosd-client --input-volume mute-toggle"
    ),
    {
        locked = true,
        repeating = true
    }
)

---------------------
-- BRIGHTNESS -------
---------------------

hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd(
        "brightnessctl -e4 -n2 set 5%+ & swayosd-client --brightness raise"
    ),
    {
        locked = true,
        repeating = true
    }
)

hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd(
        "brightnessctl -e4 -n2 set 5%- & swayosd-client --brightness lower"
    ),
    {
        locked = true,
        repeating = true
    }
)

---------------------
-- MEDIA ------------
---------------------

hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd("playerctl next"),
    { locked = true }
)

hl.bind(
    "XF86AudioPause",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true }
)

hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true }
)

hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd("playerctl previous"),
    { locked = true }
)

---------------------
-- Gestures ---------
---------------------
hl.gesture({
    fingers = 3,
    direction = "vertical",
    action = "workspace",
})

hl.plugin.hyprexpo.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "expo",
})

hl.gesture({
    fingers = 4,
    direction = "left",
    action = function()
        hl.exec_cmd("killall waybar")
    end
})

hl.gesture({
    fingers = 4,
    direction = "right",
    action = function()
        hl.exec_cmd("waybar")
    end
})
