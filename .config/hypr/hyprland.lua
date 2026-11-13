------------------
---- MONITORS ----
------------------

hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto",
})

------------------
---- PROGRAMS ----
------------------

local terminal = "ghostty"
local menu = "rofi -show drun"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  hl.exec_cmd("swaybg -c '#181818'")
  hl.exec_cmd("waybar")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd(terminal, { workspace = "2 silent" })
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "18")
hl.env("HYPRCURSOR_SIZE", "18")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
  general = {
    gaps_in = 0,
    gaps_out = 0,
    border_size = 0,
    layout = "dwindle",
  },

  decoration = {
    rounding = 0,

    shadow = {
      enabled = false,
    },

    blur = {
      enabled = false,
    },
  },

  animations = {
    enabled = false,
  },

  dwindle = {
    preserve_split = true,
  },

  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
  },
})

---------------
---- INPUT ----
---------------

hl.config({
  input = {
    kb_layout = "us",
    repeat_rate = 40,
    repeat_delay = 200,

    follow_mouse = 1,

    accel_profile = "flat",
    sensitivity = 0.7, -- -1.0 - 1.0, 0 means no modification.

    touchpad = {
      natural_scroll = true,
      disable_while_typing = true,
      tap_to_click = true,
      middle_button_emulation = true,
    },
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "ALT"
local locked = { locked = true } -- bindl
local lockedRepeat = { locked = true, repeating = true } -- bindel

-- WM control
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("hyprlock"))

hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("hyprshutdown"))

hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + E", hl.dsp.layout("togglesplit"))

local centred = false
hl.bind(mainMod .. " + SHIFT + EQUAL", function()
  centred = not centred
  hl.config({ layout = { single_window_aspect_ratio = centred and { 1, 1 } or { 0, 0 } } })
end)

-- Window focus and movement
local directions = { h = "left", j = "down", k = "up", l = "right" }
for key, direction in pairs(directions) do
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end

-- Workspace focus and movement
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + SHIFT + O", hl.dsp.workspace.move({ monitor = "+1" }))

-- Resize mode
local resizeSteps = { h = { -20, 0 }, j = { 0, 20 }, k = { 0, -20 }, l = { 20, 0 } }
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
  for key, step in pairs(resizeSteps) do
    hl.bind(key, hl.dsp.window.resize({ x = step[1], y = step[2], relative = true }), { repeating = true })
  end
  hl.bind("escape", hl.dsp.submap("reset"))
  hl.bind("return", hl.dsp.submap("reset"))
end)

-- Media and brightness
local volDown = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
local volUp = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
local mute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
local micMute = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
local playPause = "playerctl play-pause"

hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(volDown), lockedRepeat)
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd(volUp), lockedRepeat)
hl.bind(mainMod .. " + semicolon", hl.dsp.exec_cmd(mute), locked)
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd(micMute), locked)
hl.bind(mainMod .. " + apostrophe", hl.dsp.exec_cmd(playPause), locked)

hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(volDown), lockedRepeat)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(volUp), lockedRepeat)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(mute), locked)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(micMute), locked)

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), lockedRepeat)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), lockedRepeat)

hl.bind("XF86AudioPause", hl.dsp.exec_cmd(playPause), locked)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(playPause), locked)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), locked)
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), locked)

-- Notifications, clipboard, screenshots
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("makoctl dismiss -a"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("makoctl invoke"))

hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
  -- Ignore maximize requests from all apps
  name = "suppress-maximize-events",
  match = { class = ".*" },

  suppress_event = "maximize",
})

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

-- Added by hyprmoncfg: its generated monitor rules load last, so nothing before this can override the applied layout.
do local path = os.getenv("HOME") .. "/.config/hypr/hyprmoncfg-monitors.lua"; local file = io.open(path, "r"); if file then file:close(); dofile(path) end end
