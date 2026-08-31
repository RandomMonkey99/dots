-- HyprEmoji Configuration

-- Keybind to open hypremoji
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("hypremoji"))

-- Window rules for HyprEmoji
hl.window_rule({
    match = { title = "^(HyprEmoji)$" },
    float = true,
    move  = {647, 72},
    size  = {611, 626},
})