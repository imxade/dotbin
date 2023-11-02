import os
import subprocess
import psutil
import socket
import asyncio
import cairocffi
from libqtile.lazy import lazy
from libqtile.backend.wayland import InputConfig
from libqtile import layout, widget, hook, bar#, qtile
from libqtile.config import KeyChord, Key, Screen, Group, Drag, Click, Match#, ScratchPad, DropDown

MOD = "mod4"
TERMINAL = "flatpak run org.wezfurlong.wezterm"
EDITOR = "nvim"
HOME = os.path.expanduser("~")
SCRIPTS_DIR = f"{HOME}/.config/shell/scripts"

COLORS = {
    "magenta":"#d3869b",
    "yellow" :"#e1b060",
    "orange" :"#d79921",
    "purple" :"#b16286",
    "black"  :"#32302f",
    "green"  :"#98971a",
    "white"  :"#ffffff",
    "grey"   :"#504945",
    "aqua"   :"#6a8e5f",
    "blue"   :"#458588",
    "cyan"   :"#70c0ba",
    "red"    :"#ff5555",
    "clear"  :"#00000000",
}

    ###
    ### Libinput
    ###
wl_input_rules = {
    "type:touchpad": InputConfig(left_handed=True, tap=True, dwt=True),
    "type:keyboard": InputConfig(xkb_options="caps:swapescape"),
    "*": InputConfig(left_handed=False, pointer_accel=True),
}

keys = [
    ###
    ### Switch focus between windows in a workspace
    ###
    Key([MOD], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([MOD], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([MOD], "j", lazy.layout.down(), desc="Move focus down"),
    Key([MOD], "k", lazy.layout.up(), desc="Move focus up"),
    ###
    ### Move the focused window within a workspace
    ###
    Key([MOD, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([MOD, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window right"),
    Key([MOD, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([MOD, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    ###
    ### Manage window sizes
    ###
    Key([MOD, "mod1"], "h", lazy.layout.shrink(), desc="Shrink window"),
    Key([MOD, "mod1"], "l", lazy.layout.grow(), desc="Grow window"),
    Key([MOD], "f", lazy.window.toggle_fullscreen(), desc="Toggle Fullscreen for window"),
    Key([MOD, "control"], "s", lazy.window.toggle_floating(), desc="Toggle Floating mode for window"),
    ###
    ### Hotkeys
    ###
    Key([MOD], "Return", lazy.spawn(TERMINAL), desc="Launch terminal"),
    Key([MOD], "e", lazy.spawn("gammastep -PO 2000"), desc="Change gamma"),
    Key([MOD], "b", lazy.spawn(f"sh {SCRIPTS_DIR}/chrome.sh"), desc="Launch Chrome"),
    Key(["mod1"], "b", lazy.spawn(f"sh {SCRIPTS_DIR}/firefox.sh"), desc="Launch FireFox"),
    Key(["mod1"], "s", lazy.spawn(f"sh {SCRIPTS_DIR}/screenshot.sh"), desc="screenshot"),
    Key(["mod1"], "v", lazy.spawn(f"sh {SCRIPTS_DIR}/screencast.sh"), desc="start screencap"),
    Key(["mod1"], "k", lazy.spawn(f"sh {SCRIPTS_DIR}/killcast.sh"), desc="stop screencap"),
    Key([MOD], "a", lazy.spawn(f"cp -sf {HOME}/.config/alsa/bluetooth {HOME}/.asoundrc"), desc="switch to bluetooth device"),
    Key([MOD, "shift"], "a", lazy.spawn(f"cp -sf {HOME}/.config/alsa/speaker {HOME}/.asoundrc"), desc="switch to speaker"),

    ###
    ### Multimedia Keys
    ###
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioStop", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer set Master '5%+'")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer set Master '5%-'")),
    Key([], "XF86AudioMute", lazy.spawn("amixer set Master '100%-'")),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set 10%+")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),
    ###
    ### Manage Qtile
    ###
    Key([MOD], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([MOD], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([MOD, "shift"], "r", lazy.reload_config(), desc="Restart Qtile"),
    Key([MOD, "mod1"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([MOD, "mod1"], "0", lazy.spawn("qtile cmd-obj -o cmd -f hide_show_bar"), desc="hide_show_bar"),
    Key(
        [MOD, "shift"],"c",
        lazy.spawn(f"{TERMINAL} -e {EDITOR} -n {HOME}/.config/qtile/config.py"),
        desc="Edit Qtile configuration",
    ),
]

#  groups = [Group(i) for i in "1234567890"]
groups = [
    Group(name, **kwargs)
    for name, kwargs in [
        ("1", {}),
        ("2", {"matches": [
            Match(wm_class=["firefox"]),
            Match(wm_class=["chromium"]),
            Match(wm_class=["qutebrowser"]),
            Match(wm_class=["brave-browser"]),
            ]}),
        ("3", {"matches": [
            Match(wm_class=["ffplay"]),
            Match(wm_class=["mpv"]),
            ]}),
        ("4", {"matches": [
            Match(wm_class=["steam"]),
            ]}),
        ("5", {"matches": [
            Match(wm_class=["VirtualBox Manager"]),
            Match(wm_class=["qemu-system-x86_64"]),
            ]}),
        ("6", {}),
        ("7", {}),
        ("8", {}),
    ]
]

for i, group in enumerate(groups, 1):
    keys.extend(
        [
            ###
            ### Switch between workspaces
            ###
            Key(
                [MOD],
                str(i if i != 10 else 0),
                lazy.group[group.name].toscreen(toggle=False),
                desc=f"Switch to group {group.name}",
            ),
            ###
            ### Move focused window to workspace
            ###
            Key(
                [MOD, "shift"],
                str(i if i != 10 else 0),
                lazy.window.togroup(group.name),
                desc=f"Move focused window to group {group.name}",
            ),
        ]
    )

layout_theme = {"border_width": 0,
                "margin": 8,
                "single_margin": 8,
                "border_focus": "e1acff",
                "border_normal": COLORS["clear"],
                }

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    layout.Stack(stacks=2, **layout_theme),
    layout.RatioTile(**layout_theme),
    layout.TreeTab(
         font = "Hurmit Nerd",
         fontsize = 12,
         sections = ["FIRST", "SECOND", "THIRD", "FOURTH"],
         section_fontsize = 12,
         border_width = 2,
         bg_color = "1c1f24",
         active_bg = "c678dd",
         active_fg = "000000",
         inactive_bg = "a9a1e1",
         inactive_fg = "1c1f24",
         padding_left = 0,
         padding_x = 0,
         padding_y = 5,
         section_top = 10,
         section_bottom = 20,
         level_shift = 8,
         vspace = 3,
         panel_width = 200
         ),
    layout.Floating(**layout_theme),
    #layout.MonadWide(**layout_theme),
    #layout.Bsp(**layout_theme),
    #layout.Columns(**layout_theme),
    #layout.Tile(shift_windows=True, **layout_theme),
    #layout.VerticalTile(**layout_theme),
    #layout.Matrix(**layout_theme),
    #layout.Zoomy(**layout_theme),
]

widget_defaults = dict(
    font="Hurmit Nerd Font",
    foreground=COLORS["orange"],
    background=COLORS["clear"],
    fontsize=14,
    padding=0,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.TextBox(
                    text=" ",
                    foreground=COLORS["grey"],
                    fontsize=22,
                    padding=0,
                ),
                widget.Clock(
                    format="%H:%M",
                    fontsize=16,
                    background=COLORS["grey"],
                    foreground=COLORS["red"],
                    padding=4,
                ),
                widget.TextBox(
                    "",
                    fontsize=24,
                    background=COLORS["grey"],
                    padding=4,
                ),
                widget.Clock(
                    format=" %a %b %d",
                    fontsize=14,
                    background=COLORS["grey"],
                    foreground=COLORS["red"],
                ),
                widget.TextBox(
                    text=" ",
                    foreground=COLORS["grey"],
                    fontsize=22,
                    padding=-1,
                ),
                widget.TextBox(
                    text=" ",
                    foreground=COLORS["grey"],
                    fontsize=22,
                    padding=0,
                ),
                widget.TextBox(
                    text="",
                    background=COLORS["grey"],
                    fontsize=20,
                    padding=6,
                ),
                widget.Net(
                    format='{down}',
                    fmt="{} ",
                    background=COLORS["grey"],
                    foreground=COLORS["red"],
                ),
                widget.TextBox(
                    text="",
                    background=COLORS["grey"],
                    fontsize=20,
                    padding=6,
                ),
                widget.Net(
                    format='{up}',
                    fmt="{}",
                    background=COLORS["grey"],
                    foreground=COLORS["red"],
                ),
                widget.TextBox(
                    text=" ",
                    foreground=COLORS["grey"],
                    fontsize=22,
                    padding=-1,
                ),
                widget.Spacer(),
                widget.GroupBox(
                    borderwidth=2,
                    active=COLORS["yellow"],
                    inactive=COLORS["clear"],
                    highlight_color=COLORS["clear"],
                    highlight_method="text",
                    this_current_screen_border=COLORS["red"],
                ),
                widget.Spacer(),
                widget.TextBox(
                    text=" ",
                    foreground=COLORS["grey"],
                    fontsize=22,
                    padding=0,
                ),
                widget.TextBox(
                    text="墳",
                    background=COLORS["grey"],
                    fontsize=22,
                    padding=4,
                ),
                widget.TextBox(
                    text=" VOL ",
                    background=COLORS["grey"],
                    fontsize=6,
                ),
                widget.Volume(
                    fmt="{}",
                    background=COLORS["grey"],
                    foreground=COLORS["red"],
                ),
                widget.TextBox(
                    text=" ",
                    foreground=COLORS["grey"],
                    fontsize=22,
                    padding=-1,
                ),
                widget.TextBox(
                    text=" ",
                    foreground=COLORS["grey"],
                    fontsize=22,
                    padding=0,
                ),
                widget.TextBox(
                    text="",
                    background=COLORS["grey"],
                    fontsize=22,
                    padding=4,
                ),
                widget.TextBox(
                    text=" CPU ",
                    background=COLORS["grey"],
                    fontsize=6,
                    padding=0,
                ),
                widget.CPU(
                    format='{load_percent}%',
                    background=COLORS["grey"],
                    foreground=COLORS["red"],
                    fmt='{}',
                ),
                widget.TextBox(
                    text=" ",
                    foreground=COLORS["grey"],
                    fontsize=22,
                    padding=-1,
                ),
                widget.TextBox(
                    text=" ",
                    foreground=COLORS["grey"],
                    fontsize=22,
                    padding=0,
                ),
                widget.TextBox(
                    text="﬙",
                    background=COLORS["grey"],
                    fontsize=22,
                    padding=4,
                ),
                widget.TextBox(
                    text=" RAM ",
                    background=COLORS["grey"],
                    fontsize=6,
                ),
                widget.Memory(
                    format='{MemPercent}%',
                    background=COLORS["grey"],
                    foreground=COLORS["red"],
                    fmt='{}',
                ),
                widget.TextBox(
                    text=" ",
                    foreground=COLORS["grey"],
                    fontsize=22,
                    padding=-1,
                ),
                widget.TextBox(
                    text=" ",
                    foreground=COLORS["grey"],
                    fontsize=22,
                    padding=0,
                ),
                widget.BatteryIcon(
                    background=COLORS["grey"],
                ),
                widget.StatusNotifier(),
#               widget.Systray(),
                widget.TextBox(
                    text=" ",
                    foreground=COLORS["grey"],
                    fontsize=22,
                    padding=-1,
                ),
            ],
            24,
            margin = [8, 8, 0, 8],
            opacity = 1,
        ),
        wallpaper = "~/.config/wall/gruv_waifu.jpg",
        wallpaper_mode = 'fill',
    ),
]

mouse = [
    ###
    ### Use mouse only for floating mode.
    ###
    Drag(
        [MOD],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [MOD],
        "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click([MOD], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

# Determine which class of windows should be in floating mode.
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ]
)

# Automatically fullscreen a window if it requests it
auto_fullscreen = True

# Automatically minimize a window if it requests it
auto_minimize = True

# Automatically focus window in current group if it requests it
focus_on_window_activation = "smart"

reconfigure_screens = True


@hook.subscribe.startup_once
def start_once():
    subprocess.call([f"{HOME}/.config/qtile/autostart.sh"])

wmname = "LG3D"
