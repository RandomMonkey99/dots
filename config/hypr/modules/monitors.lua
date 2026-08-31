local variables = require("modules.variables")
local colors = require("modules.colors")

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})
hl.monitor({
    output = "HDMI-A-1",
    position = "0x-1080"
})
