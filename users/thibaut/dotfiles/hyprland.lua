-- ============================================================
--  Base = exemple officiel Hyprland + Paramètres Doctalia
-- ============================================================

------------------
---- MONITORS ----
------------------
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60.00300",
    position = "auto",
    scale    = "1",
})

---------------------
---- MY PROGRAMS ----
---------------------
local terminal    = "alacritty"
local fileManager = "nemo"
local menu        = ""

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
  hl.exec_cmd("kdeconnect-indicator")
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding       = 20,
        rounding_power = 2,
        active_opacity   = 0.9,
        inactive_opacity = 0.85,
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },
        blur = {
            enabled   = true,
            size      = 3,
            passes    = 3,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Animations Caelestia
hl.curve("specialWorkSwitch", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("emphasizedAccel",   { type = "bezier", points = { { 0.3, 0 },    { 0.8, 0.15 } } })
hl.curve("emphasizedDecel",   { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("standard",          { type = "bezier", points = { { 0.2, 0 },    { 0, 1 } } })

hl.animation({ leaf = "layersIn",  enabled = true, speed = 5, bezier = "emphasizedDecel", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 4, bezier = "emphasizedAccel", style = "slide" })
hl.animation({ leaf = "fadeLayers", enabled = true, speed = 5, bezier = "standard" })

hl.animation({ leaf = "windowsIn",   enabled = true, speed = 5, bezier = "emphasizedDecel" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 3, bezier = "emphasizedAccel" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 6, bezier = "standard" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 5, bezier = "standard" })

hl.animation({
    leaf    = "specialWorkspace",
    enabled = true,
    speed   = 4,
    bezier  = "specialWorkSwitch",
    style   = "slidefadevert 15%"
})
hl.animation({ leaf = "fade",    enabled = true, speed = 6, bezier = "standard" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 6, bezier = "standard" })
hl.animation({ leaf = "border",  enabled = true, speed = 6, bezier = "standard" })

hl.config({
    dwindle = { preserve_split = true },
    master = { new_status = "master" },
    scrolling = { fullscreen_on_one_column = true },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },
})

---------------
---- INPUT ----
---------------
hl.config({
    input = {
        kb_layout  = "fr",
        kb_variant = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = { natural_scroll = false },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

---------------------
---- KEYBINDINGS ----
---------------------
local mainMod = "SUPER"

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + O",      hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F",   hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

local keys = { "ampersand", "eacute", "quotedbl", "apostrophe", "parenleft", "minus", "egrave", "underscore", "ccedilla", "agrave" }
for i, key in ipairs(keys) do
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + ALT + " .. key,   hl.dsp.window.move({ workspace = i, follow = false }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = true }))
end

hl.bind(mainMod .. " + G",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- IPC Noctalia
local ipc = "noctalia msg "
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. " + S",     hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
hl.bind(mainMod .. " + colon", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
hl.bind(mainMod .. " + L",   hl.dsp.exec_cmd(ipc .. "session lock"))
hl.bind(mainMod .. " + Tab",         hl.dsp.exec_cmd(ipc .. "window-switcher"))
hl.bind(mainMod .. " + semicolon", hl.dsp.exec_cmd(ipc .. "panel-toggle liamwh/emoji-picker:wide"))

hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd(ipc .. "volume-up"))
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd(ipc .. "volume-down"))
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd(ipc .. "volume-mute"))
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(ipc .. "brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))
hl.bind("XF86PowerOff",          hl.dsp.exec_cmd("noctalia msg panel-toggle session"), { locked = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.workspace_rule({ workspace = "1", monitor = "eDP-1", persistent = true, default_name = "web" })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1", persistent = true, default_name = "code" })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1", persistent = true, default_name = "chat" })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1", persistent = true, default_name = "game" })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1", persistent = true, default_name = "design" })

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = { class = "", title = "", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({ match = { class = "firefox", title = ".*Preferences.*" }, float = true })
hl.window_rule({ match = { class = "org.keepassxc.KeePassXC" }, float = true })
hl.window_rule({ match = { class = "discord" }, workspace = 3 })

hl.window_rule({
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size = { 1080, 920 },
})

hl.layer_rule({
    name = "noctalia",
    match = {
        namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
    },
    no_anim = true,
    ignore_alpha = 0.5,
    blur = true,
    blur_popups = true,
})
