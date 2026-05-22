local kb_device = "royuan-akko-multi-modes-keyboard-b"
local ipc = "noctalia-shell ipc call "
local screenshot_dir = os.getenv("HOME") .. "/Pictures/Screenshots/"

if _G.vars.layout == "dwindle" then
    hl.bind("SUPER + Z", hl.dsp.layout("togglesplit"))
    hl.bind("SUPER + X", hl.dsp.layout("swapsplit"))

    hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
    hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
elseif _G.vars.layout == "master" then
    hl.bind("SUPER + A", hl.dsp.layout("swapwithmaster ignoremaster"))
    hl.bind("SUPER + SHIFT + A", hl.dsp.layout("focusmaster master"))
    hl.bind("SUPER + Z", hl.dsp.layout("cyclenext"))
    hl.bind("SUPER + X", hl.dsp.layout("cycleprev"))


    hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
    hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
elseif _G.vars.layout == "scrolling" then
    hl.bind("SUPER + A", hl.dsp.layout("colresize +conf"))
    hl.bind("SUPER + SHIFT + A", hl.dsp.layout("fit active"))
    hl.bind("SUPER + Z", hl.dsp.layout("fit visible"))
    hl.bind("SUPER + X", hl.dsp.layout("fit all"))
    -- hl.bind("SUPER + mouse_down", hl.dsp.focus({ direction = "l" }))
    -- hl.bind("SUPER + mouse_up", hl.dsp.focus({ direction = "r" }))
    hl.bind("SUPER + mouse_down", hl.dsp.layout("move -col"))
    hl.bind("SUPER + mouse_up", hl.dsp.layout("move +col"))
end

hl.bind("SUPER + Return", hl.dsp.exec_cmd(_G.vars.terminal))
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd(_G.vars.terminal, { float = true, center = true }))
hl.bind("SUPER + E", hl.dsp.exec_cmd(_G.vars.fileManager))
hl.bind("SUPER + B", hl.dsp.exec_cmd(_G.vars.browser))
hl.bind("SUPER + C", hl.dsp.exec_cmd(_G.vars.editor))


hl.bind("SUPER + S", hl.dsp.exec_cmd(ipc .. "launcher toggle"))
hl.bind("SUPER + Tab", hl.dsp.exec_cmd(ipc .. "launcher windows"))
hl.bind("SUPER + M", hl.dsp.exec_cmd(ipc .. "sessionMenu toggle"))
hl.bind("SUPER + L", hl.dsp.exec_cmd(ipc .. "lockScreen lock"))
hl.bind("SUPER + P", hl.dsp.exec_cmd("hyprshot -zm region -o " .. screenshot_dir))
hl.bind("SUPER + K", hl.dsp.exec_cmd("hyprctl switchxkblayout " .. kb_device .. " next"))


hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + W", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ action = "toggle" }))


for i = 1, 9 do
    hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
end


local directions = {
    { arrow = "Left",  vim = "h", focus = "l", x = -30, y = 0 },
    { arrow = "Right", vim = "l", focus = "r", x = 30,  y = 0 },
    { arrow = "Up",    vim = "k", focus = "u", x = 0,   y = -30 },
    { arrow = "Down",  vim = "j", focus = "d", x = 0,   y = 30 }
}

for _, dir in ipairs(directions) do
    local keys = { dir.arrow }

    for _, key in ipairs(keys) do
        hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = dir.focus }))

        hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.resize({ x = dir.x, y = dir.y, relative = true }),
            { repeating = true })
    end
end

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume increase"),
    { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume decrease"),
    { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume muteOutput"),
    { repeating = true, locked = true })
