hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ match = { title = "(?i)picture[- ]in[- ]picture" }, float = true, size = "720 405" })
hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, float = true, center = true })
hl.window_rule({ match = { class = "^(org.gnome.FileRoller)$" }, size = "900 600", float = true })
hl.window_rule({ match = { class = "^(org.gnome.seahorse.Application)$" }, float = true })
hl.window_rule({ match = { class = "^(qalculate-gtk)$" }, float = true })
hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" }, float = true, size = "900 700", center = true })
hl.window_rule({ match = { class = "^(qt6ct)$" }, float = true })
hl.window_rule({ match = { class = "^(qt5ct)$" }, float = true })
hl.window_rule({ match = { title = "^(Kvantum Manager)$" }, float = true })


hl.window_rule({
    name = float_hypr_portal,
    match    = {
        -- class      = "^(xdg-desktop-portal-hyprland)$",
        initial_title = "^(Select what to share)*"
    },
    center = true,
    float = true
})

hl.window_rule({
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true
})

hl.layer_rule({
    match = { namespace = "^noctalia-background-.*$" },
    ignore_alpha = 0.5,
    blur = true,
    blur_popups = true
})
