import os 
import asyncio
import subprocess
from libqtile import hook
from libqtile import bar, layout
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.widget import currentlayout
from libqtile.log_utils import logger
#from qtile_extras import widget
#from qtile_extras.widget.decorations import RectDecoration
from libqtile.backend.base import Window

mod = "mod4"
terminal = "kitty" 
browser = "firefox"
mail_client = "betterbird"
filemanager = "thunar"

keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # monadtall
    Key([mod, "control"], "h", lazy.layout.shrink_main(),desc='Shrink window (MonadTall), decrease number in master pane (Tile)'),
    Key([mod, "control"], "k", lazy.layout.grow(),desc='Shrink window (MonadTall), decrease number in master pane (Tile)'),
    Key([mod, "control"], "j", lazy.layout.shrink(),desc='Shrink window (MonadTall), decrease number in master pane (Tile)'),
    Key([mod, "control"], "l", lazy.layout.grow_main(), desc='Expand window (MonadTall), increase number in master pane (Tile)' ),
    # alternate
    Key(["mod1", "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(["mod1", "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key(["mod1", "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key(["mod1", "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "control"], "n", lazy.layout.reset(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "BackSpace", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # power state bindings
    Key([mod, "mod1"], "s", lazy.spawn("systemctl poweroff"), desc="Shutdown laptop"),
    Key([mod, "mod1"], "h", lazy.spawn("systemctl hibernate"), desc="Put laptop into hibernation"),
    # audio controls
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"), desc="Raise Volume"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"), desc="Lower Volume"),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"), desc="Mute"),
    # brightness controls
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%"), desc="turn up monitor brightness"),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-"), desc="turn down monitor brightness"),
    # app shortcuts
    Key([mod], "w", lazy.spawn(browser), desc="open browser"),
    Key([mod], "m", lazy.spawn(mail_client), desc="open mail_client"),
    Key([mod], "s", lazy.spawn("spotify"), desc="open mail_client"),
    Key([mod], "p", lazy.spawn('kitty --listen-on=unix:@"$(date +%s%N)" -o allow_remote_control=yes'), desc="open jukit kitty session"),

    Key([], "Print", lazy.spawn("scrot ~/Pictures/Screenshots/%Y-%m-%d-%T-screenshot.png"), desc="screenshot"),
    Key([mod], "Print", lazy.spawn("flameshot gui"), desc="open flameshot"),
    # rofi application menu
    Key([mod], "n", lazy.spawn(filemanager), desc="open filemanager"),
    Key([mod], "d", lazy.spawn("rofi -modi drun -show drun -config ~/.config/rofi/rofidmenu.rasi"), desc="open rofi"),
    Key([mod], "t", lazy.spawn("rofi -show window -config ~/.config/rofi/rofidmenu.rasi"), desc="open roi window display"),
    # toggle floating windows
    Key([mod], "f", lazy.window.toggle_floating()),
    # toggle fullscreen mode
    Key([], "F11", lazy.window.toggle_fullscreen())
]

groups =[]
group_labels = ["", "", "", "", "", "", "" , "9", "10"] #"",
group_names = [i for i in "1234567"]
for i in range(len(group_names)):
    groups.append(
            Group(
                name=group_names[i],
                label=group_labels[i]
                )
            )

groups.append(Group("8", layout="max", label=""))
groups.append(Group("9", label="9", layout="max"))
groups.append(Group("0", label="10"))

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

#configurate scratchpad
groups.append(ScratchPad('scratchpad', [
    DropDown('Terminal', terminal, width=0.8, height=0.8, x=0.1, y=0.1, opacity=1),
    DropDown('Filemanager', filemanager, width=0.5, height=0.5, x=0.25, y=0.2, opacity=1),
    DropDown('Calculator', "qalculate-gtk", width=0.5, height=0.5, x=0.25, y=0.2, opacity=1)]))
keys.extend([
    Key(["mod1"], "1", lazy.group['scratchpad'].dropdown_toggle('Terminal')),
    Key(["mod1"], "2", lazy.group['scratchpad'].dropdown_toggle('Filemanager')),
    Key(["mod1"], "3", lazy.group['scratchpad'].dropdown_toggle('Calculator'))])

layout_theme = {"border_width": 3,
                "margin": 8,
                #"border_focus": "e1acff",
                "border_focus": "89B4FA", #"7678ed",
                "border_normal": "6C7086"
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    # layout.Columns(**layout_theme),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(**layout_theme),
    # layout.VerticalTile(),
    # layout.Zoomy(**layout_theme),
]

#widget_color = None
#widget_defaults=dict(
#    font='sans',
#    fontsize=15,
#    padding=3,
#    background=widget_color
#)
#
#extension_defaults = widget_defaults.copy()
#
#widget_list=[
#        widget.Spacer(
#            length=10,
#            background=None,
#        ),
#        widget.CurrentLayoutIcon(
#            scale=0.7,
#            use_mask=True,
#            foreground="F9E2AF",
#        ),
#        widget.Spacer(
#            length=5,
#            background=None,
#        ),
#        widget.GroupBox(
#            padding_x = 10,
#            hide_unused=True,
#            highlight_method='text',
#            this_current_screen_border="F38BA8",
#            borderwidth=2,
#            active='89B4FA',
#        ),
#        widget.Spacer(
#            length=5,
#            background=None,
#        ),
#        widget.CheckUpdates(
#            distro='Arch_checkupdates',
#            colour_have_updates = "FAB387",
#        ),
#        widget.Spacer(
#            length=5,
#            background=None,
#        ),
#        widget.Spacer(
#            background=None,
#        ),
#        #widget.Mpris2(
#        #    NAME="spotify",
#        #    pause_text="Paused", 
#        #    display_metadata=["xesam:title", "xesam:artist"],
#        #    objname="org.mpris.MediaPlayer2.spotify",
#        #    foreground='89B4FA', background=None,
#        #),
#        widget.Spacer(
#            background=None,
#        ),
#        widget.Spacer(
#            length=5,
#            background=None,
#        ),
#        widget.TextBox(
#            background=None,
#            fmt='',
#            padding=None,
#            foreground='89B4FA'
#        ),
#        widget.Volume(
#                background=None,
#                fmt='{}',
#                step=5
#        ),
#        widget.Spacer(
#            length=5,
#            background=None,
#        ),
#        widget.Battery(
#            charge_char='',
#            discharge_char='',
#            unknown_char='',
#            format='{char} ',
#            low_percentage=0.25,
#            notify_below=0.25,
#            foreground='89B4FA',
#        ),
#        widget.Battery(
#            format='{percent:2.0%}',
#        ),
#        widget.Spacer(
#            length=5,
#            background=None,
#        ),
#        widget.TextBox(
#            background=None,
#            fmt='',
#            padding=None,
#            foreground='89B4FA'
#        ),
#        widget.ThermalSensor(
#            tag_sensor='CPU',
#            format=' {temp:.0f} {unit}',
#        ),
#        widget.Spacer(
#            length=5,
#            background=None,
#        ),
#        widget.TextBox(
#            background=None,
#            fmt='',
#            padding=None,
#            foreground='89B4FA'
#        ),
#        widget.Memory(
#            measure_mem='G',
#            measure_swap='G',
#            format='{MemUsed:.1f}{mm}/{MemTotal:.1f}{mm}',
#        ),
#        widget.TextBox(
#            background=None,
#            fmt='',
#            padding=None,
#            foreground='89B4FA'
#        ),
#        widget.Memory(
#            measure_mem='G',
#            measure_swap='G',
#            format='{SwapUsed:.1f}{ms}/{SwapTotal:.1f}{ms}',
#        ),
#        widget.Spacer(
#            length=5,
#            background=None,
#        ),
#        widget.TextBox(
#            background=None,
#            fmt='',
#            padding=None,
#            foreground='89B4FA'
#        ),
#        widget.Wlan(
#            format='{essid}',
#        ),
#        widget.Spacer(
#            length=10,
#            background=None,
#        ),
#        widget.TextBox(
#            background=None,
#            fmt='',
#            padding=None,
#            foreground='89B4FA'
#        ),
#        widget.Clock(
#            format="%D",
#        ),
#        widget.Clock(
#            format="%H:%M",
#        ),
#        widget.Spacer(
#            length=10,
#            background=None,
#        ),
#]

screens = [
    Screen(
#                top=bar.Bar(
#                widget_list,
#                background='13111f',
#                size=28,
#                border_width=[0, 0, 0, 0],
                
                left = bar.Gap(55) #55
            ),
#    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="Msgcompose"), # thunderbird write mail
        Match(wm_class="mailspring"), # thunderbird write mail
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(title='Qalculate!'),
    ],
    border_focus='89B4FA',
    border_width=2
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])

@hook.subscribe.client_new
def client_to_workspace(client):
    #if client.name == terminal:
    #    client.togroup("1", switch_group = True)
    if client.name == 'Mozilla Firefox':
        client.togroup("2", switch_group = True)
    elif client.name == 'obsidian':
        client.togroup("3", switch_group = True)
    elif client.name == 'Betterbird':
        client.togroup("4", switch_group = True)
    elif client.name == 'Telegram':
        client.togroup("5", switch_group = True)
    elif client.name == 'WhatsApp for Linux':
        client.togroup("5", switch_group = True)
    elif client.name == "webcord":
        client.togroup("6", switch_group = True)
    elif client.name == 'Zotero':
        client.togroup("9", switch_group = True)

@hook.subscribe.client_name_updated
def move_spotify_workaround(client):
    if client.name.lower() == 'spotify':
        client.togroup("9", switch_group = True)

wl_input_rules = None
wmname = "LG3D"
