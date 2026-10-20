-- Hyprland config, Lua format.
-- Reference: https://wiki.hypr.land/Configuring/Core/
-- LSP stubs live at /usr/share/hypr/stubs/hl.meta.lua

local launcher = "wofi --show run -n"
local terminal = "ghostty --gtk-single-instance=true"

-- INIT
-- ====

hl.on("hyprland.start", function()
    hl.exec_cmd("ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false")

    hl.exec_cmd("steam")

    -- Wallpapers
    hl.exec_cmd("hyprpaper")

    -- Lock screen
    hl.exec_cmd("hypridle")

    -- Statusbar
    hl.exec_cmd("waybar")

    -- Start 1password in the tray
    hl.exec_cmd("ELECTRON_OZONE_PLATFORM_HINT=auto 1password --silent")
end)

-- DISPLAYS
-- ========

-- Primary display (4K)
hl.monitor({
    output   = "DP-3",
    mode     = "3840x2160@240",
    position = "0x0",
    scale    = 1,

    -- only enabled in fullscreen
    vrr      = 2,

    -- enable HDR
    bitdepth = 8,
    -- anecdotally i found my monitor specifically reports kinda fucked up parameters for colorspace
    -- so i've chosen to override them instead of using hdredid
    cm       = "auto",

    sdrbrightness = 1,
    sdrsaturation = 0.95,

    sdr_min_luminance = 0.0,
    sdr_max_luminance = 150,
    min_luminance     = 0,
    max_luminance     = 500,
    max_avg_luminance = 150,
})

-- force workspace number 1 to appear on DP-3 always.
hl.workspace_rule({ workspace = "name:1", monitor = "DP-3" })

-- Secondary display (to the right, portrait orientation)
hl.monitor({
    output    = "DP-2",
    mode      = "2560x1440@144",
    position  = "3840x-320",
    scale     = 1,
    transform = 3,
})

-- For Steam Deck
-- hl.on("hyprland.start", function()
--     hl.exec_cmd("hyprctl output create headless HEADLESS")
-- end)
-- hl.monitor({
--     output   = "HEADLESS",
--     mode     = "1280x800@90",
--     position = "6000x0",
--     scale    = 1,
-- })

-- COMPATIBILITY
-- =============

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },

    render = {
        direct_scanout = 0,
        cm_auto_hdr    = 2,
    },
})

-- toolkit-specific scale
hl.env("GDK_SCALE", "1")
hl.env("XCURSOR_SIZE", "24")

-- nVidia setup

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- INPUT
-- =====

-- https://wiki.hypr.land/Configuring/Variables/#input
hl.config({
    input = {
        kb_layout = "us",

        -- Super fast keyboard repeat.
        repeat_delay = 250,
        repeat_rate  = 40,

        follow_mouse = 1,

        sensitivity = -0.3, -- -1.0 - 1.0, 0 means no modification.

        -- Disable mouse acceleration
        accel_profile = "flat",

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- Make Logitech mice scroll naturally.
-- hl.device({
--     name           = "logitech-usb-receiver",
--     natural_scroll = true,
-- })

-- STYLE
-- =====

hl.config({
    cursor = {
        -- Required for nvidia :(
        no_hardware_cursors = true,
    },

    misc = {
        -- Disable default wallpaper and hyprland logo.
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        enable_anr_dialog       = false,

        key_press_enables_dpms = true,

        -- Let a fresh lock client take over an existing lock.
        allow_session_lock_restore = true,
    },

    ecosystem = {
        no_update_news   = true,
        no_donation_nag  = true,
    },

    general = {
        gaps_in = 6,

        -- Matches waybar config.
        gaps_out = { top = 0, right = 12, bottom = 12, left = 12 },

        border_size = 2,

        col = {
            -- Slight gradient that fades out towards the bottom right corner
            active_border   = { colors = { "rgba(ffffffff)", "rgba(ffffffaa)" }, angle = 45 },
            inactive_border = { colors = { "rgba(000000aa)", "rgba(000000dd)" }, angle = 20 },
        },
    },

    decoration = {
        rounding = 4,

        -- Shadows are tweaked to feel about right for floating windows on a white background.
        -- They will look somewhat weak on a dark background.

        shadow = {
            range          = 64,
            render_power   = 4,
            offset         = { 0, 2 },
            color          = "rgba(00000066)",
            color_inactive = "rgba(00000044)",
        },

        dim_special = 0.9,
        -- dim_inactive = true,
        dim_strength = 0.05,

        -- Keep in mind I'm running this on a beefy desktop GPU - these settings are definitely overkill.
        blur = {
            enabled           = true,
            size              = 8,
            passes            = 3,
            noise             = 0.03,
            vibrancy          = 0.2,
            vibrancy_darkness = 0.2,
            special           = true,
        },
    },
})

-- KEYBINDINGS
-- ===========

-- See https://wiki.hypr.land/Configuring/Basics/Binds/
local mod = "SUPER" -- Sets "Windows" key as main modifier

-- Screenshot a display
local screenshotOutput = "hyprshot -m active -m output --clipboard-only -z -s"
local screenshotWindow = "hyprshot -m window --clipboard-only -z -s"
local screenshotRegion = "hyprshot -m region --clipboard-only -z -s"

hl.bind("PRINT", hl.dsp.exec_cmd(screenshotOutput))
hl.bind(mod .. " + PRINT", hl.dsp.exec_cmd(screenshotWindow))
hl.bind(mod .. " + SHIFT + PRINT", hl.dsp.exec_cmd(screenshotRegion))

-- Launchers
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(launcher))
hl.bind(mod .. " + SHIFT + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + Q", hl.dsp.exec_cmd("loginctl lock-session"))

-- Close window
hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())

-- Quit Hyprland
hl.bind(mod .. " + SHIFT + CTRL + Q", hl.dsp.exit())

-- Move focus with arrow keys
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Move focus with gaming IJKL keys
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + I", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "down" }))

-- Move windows with gaming IJKL keys
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + I", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "down" }))

-- Focus a workspace, but first make sure Hyprland's "focused monitor" agrees with the
-- monitor of the window that actually has keyboard focus.
--
-- A pointer-locked gamescope game can knock the two out of sync: Hyprland records the
-- lock position once, when gamescope creates the lock, and if the cursor was on the other
-- monitor at that moment (e.g. clicking Play in Steam over there), every mouse movement
-- warps the hidden cursor back to that spot and marks *that* monitor as focused. A plain
-- hl.dsp.focus({ workspace = N }) then sees the target workspace as already on the
-- "current" monitor and silently does nothing.
local function focusWorkspace(i)
    return function()
        local win = hl.get_active_window()
        local mon = win and win.monitor
        if mon and not mon.focused then
            -- Re-sync. This also releases and re-establishes the game's pointer lock,
            -- which re-captures the lock position on the correct monitor.
            hl.dispatch(hl.dsp.focus({ monitor = mon }))
        end
        hl.dispatch(hl.dsp.focus({ workspace = i }))
    end
end

-- Switch workspaces with mod + [0-9]
-- Move active window to a workspace (silently) with mod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mod .. " + " .. key, focusWorkspace(i))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Toggle floating window, fake fullscreen, and real fullscreen
hl.bind(mod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- Swap display workspaces
hl.bind(mod .. " + M", hl.dsp.workspace.swap_monitors({ monitor1 = "DP-3", monitor2 = "DP-2" }))

-- Scratchpad workspace
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move/resize windows with mod + LMB/RMB and dragging
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mod .. " + H", hl.dsp.layout("orientationcycle"))

-- ANIMATIONS
-- ==========

hl.curve("easeExpoInOut", { type = "bezier", points = { { 0.75, 0 }, { 0.25, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 2, bezier = "easeExpoInOut" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 8, bezier = "easeExpoInOut", style = "slide" })

-- RULES
-- =====

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/ for more
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/ for workspace rules

-- Don't mess with my windows.
hl.window_rule({
    name  = "dont-mess-with-windows",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- Float these apps.
hl.window_rule({ name = "float-1password", match = { class = "^(1Password)$" }, float = true })
hl.window_rule({ name = "float-superbolide", match = { class = "^(Superbolide)$" }, float = true })
hl.window_rule({ name = "float-steam-settings", match = { class = "^(Steam Settings)$" }, float = true })

hl.window_rule({
    name  = "wofi-launcher",
    match = { class = "^(wofi)$" },

    border_size = 0,
    float       = true,
    pin         = true,
    animation   = "fade",
    center      = true,
})

hl.window_rule({
    name  = "steam-bigpicture",
    match = { class = "^(steam)$", title = "^(Steam Big Picture Mode)$" },

    fullscreen = true,
})

hl.window_rule({
    name  = "fh5",
    match = { title = "^(Forza Horizon 5)$" },

    fullscreen = true,
})
