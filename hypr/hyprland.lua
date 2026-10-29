-- Monitors
require("monitors")

-- Variables
local terminal    = "kitty"
local fileManager = "thunar"
-- local fileManager = "dolphin"
-- local menu        = "wofi --show drun"
local menu        = "hyprlauncher"
local browser     = "firefox"
local editor      = "zeditor"
local audio       = "pwvucontrol"
local locker      = "wlogout"
local screenshot  = 'slurp | grim -g - /home/skull/Pictures/Screenshots/screenshot-$(date +"%Y-%m-%d-%H-%M-%S").png'
local gamemode    = "~/.config/hypr/gamemode.sh"
local flux        = "hyprsunset"

-- Autostart https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    hl.exec_cmd(terminal)
    hl.exec_cmd(browser)
    hl.exec_cmd("thunar --daemon & hyprpaper & hypridle & hyprlauncher -d")
end)

-- Environment variables
require("env")

-- Permissions
require("permissions")

-- UI & animations
require("ui")

require("disableweabooshit")

-- Input
require("input")

-- Keybinds https://wiki.hypr.land/Configuring/Basics/Binds/
local super = "SUPER"

hl.bind(super .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(super .. " + C", hl.dsp.window.close())
hl.bind(super .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(super .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(super .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(super .. " + R", hl.dsp.exec_cmd(editor))
hl.bind(super .. " + Y", hl.dsp.exec_cmd(browser))
hl.bind(super .. " + A", hl.dsp.exec_cmd(audio))
hl.bind(super .. " + L", hl.dsp.exec_cmd(locker))
hl.bind(super .. " + P", hl.dsp.window.pseudo())
hl.bind(super .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind("Print", hl.dsp.exec_cmd(screenshot))
hl.bind(super .. " + SHIFT + Page_Up", hl.dsp.exec_cmd("pkill hyprsunset"))
hl.bind(super .. " + SHIFT + Page_Down", hl.dsp.exec_cmd(flux))
hl.bind(super .. " + B", hl.dsp.exec_raw("killall -SIGUSR1 waybar"), { transparent = true })

-- Move focus with super + arrow keys
hl.bind(super .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(super .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(super .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(super .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with super + [0-9]
-- Move active window to a workspace with super + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(super .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(super .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(super .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(super .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with super + scroll
hl.bind(super .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(super .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with super + LMB/RMB and dragging
hl.bind(super .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(super .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


-- Windows and workspaces

-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name           = "suppress-maximize-events",
    match          = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
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
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name = "thunar",
    match = { class = "thunar" },
    float = true
})

hl.window_rule({
    name = "laucher",
    match = { class = "hyprlauncher" },
    float = true,
    size = { 800, 600 }
})
