require("vars")

hl.monitor({
    output = "DP-1",
    mode = "2560x1440@180",
    position = "0x0",
    scale = 1
})


hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia-shell")
end)

for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), persistent = true })
end


hl.config({
    decoration = {
        rounding = 0,
        active_opacity = 0.95,
        inactive_opacity = 0.95,
        blur = {
            enabled = true,
            passes = 2,
            size = 3,
            vibrancy = 0.169600
        },
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = _G.vars.shadow_color
        }
    },

    general = {
        allow_tearing = true,
        border_size = 2,
        ["col.active_border"] = _G.vars.active_border_color,
        ["col.inactive_border"] = _G.vars.inactive_border_color,
        gaps_in = 2.5,
        gaps_out = 5,
        layout = _G.vars.layout,
        resize_on_border = false
    },

    input = {
        follow_mouse   = 1,
        force_no_accel = 1,
        kb_layout      = "us,br",
        kb_options     = "caps:escape",
        sensitivity    = 0,
        repeat_rate    = 35,
        repeat_delay   = 300
    },
    cursor = {
        no_warps = true
    },

    misc = {
        disable_hyprland_logo = true,
        force_default_wallpaper = 0,
        vrr = 0
    },

    master = {
        mfact = 0.5,
        orientation = "left",
        smart_resizing = true
    },

    dwindle = {
        preserve_split = true
    },

})

require("animations")
require("rules")
require("binds")
require("env")
