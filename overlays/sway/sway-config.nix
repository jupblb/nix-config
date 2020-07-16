{ bemenu, grim, slurp, wob, xdg-user-dirs, xsettingsd, writeTextFile }:

let
  picture-dir     = "$(${xdg-user-dirs}/bin/xdg-user-dir PICTURES)";
  xsettingsd-conf = writeTextFile {
    name = "xsettingsd-config";
    text = "Gdk/WindowScalingFactor 2\n";
  };
in ''
### Startup
exec --no-startup-id mkfifo $SWAYSOCK.wob && tail -f $SWAYSOCK.wob \
  | ${wob}/bin/wob
exec ${xsettingsd}/bin/xsettingsd -c ${xsettingsd-conf}

### Variables
set $mod Mod1

set $left h
set $down j
set $up k
set $right l

set $bg       #282828
set $fg       #f9f5d7
set $red      #cc241d
set $green    #98971a
set $yellow   #d79921
set $blue     #458588
set $purple   #b16286
set $aqua     #689d68
set $gray     #7c6f64
set $darkgray #1d2021
set $dummy    #ffffff

set $menu ${bemenu}/bin/bemenu-run --fn 'PragmataPro 12' -p "" \
  --fb '$bg' --ff '$fg' --hb '$green' --hf '$fg' --nb '$bg' --nf '$fg' \
  --sf '$bg' --sb '$fg' --tf '$fg' --tb '$bg'
set $term kitty

### Input/Output configuration
output * {
  background ${./wallpaper.png} fill
  scale 2
}
xwayland force scale 2

input * {
  click_method clickfinger
  middle_emulation enabled
  pointer_accel 1
  scroll_factor 2
  tap enabled
  xkb_layout pl
  xkb_options caps:escape
}

### Seat configuration
seat * hide_cursor 5000

### General configuration
# class                 border    backgr    text      indicator child_border
client.focused          $yellow   $bg       $fg       $green    $yellow
client.focused_inactive $green    $bg       $fg       $yellow   $green
client.unfocused        $green    $bg       $fg       $yellow   $green
client.urgent           $red      $bg       $fg       $red      $red

font pango:PragmataPro 10

default_border pixel 5
smart_borders on

### Idle configuration

### Key bindings
floating_modifier $mod normal

bindsym $mod+b splith
bindsym $mod+v splitv

bindsym $mod+f fullscreen

bindsym $mod+Return exec $term
bindsym $mod+Shift+q kill
bindsym $mod+d exec $menu
bindsym $mod+Shift+e exec swaymsg exit

bindsym $mod+$left focus left
bindsym $mod+$down focus down
bindsym $mod+$up focus up
bindsym $mod+$right focus right

bindsym $mod+Shift+$left move left
bindsym $mod+Shift+$down move down
bindsym $mod+Shift+$up move up
bindsym $mod+Shift+$right move right

bindsym $mod+s layout stacking
bindsym $mod+t layout tabbed
bindsym $mod+e layout toggle split

mode passthrough {
	bindsym $mod+Pause mode default
}
bindsym $mod+Pause mode passthrough

mode resize {
    bindsym $left resize shrink width 40px
    bindsym $down resize grow height 40px
    bindsym $up resize shrink height 40px
    bindsym $right resize grow width 40px

    bindsym Return mode default
    bindsym Escape mode default
}
bindsym $mod+r mode resize

bindsym $mod+Shift+space floating toggle
bindsym $mod+space focus mode_toggle
bindsym $mod+a focus parent

bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
bindsym $mod+3 workspace 3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5
bindsym $mod+6 workspace 6
bindsym $mod+7 workspace 7
bindsym $mod+8 workspace 8
bindsym $mod+9 workspace 9
bindsym $mod+0 workspace 10

bindsym $mod+Shift+1 move container to workspace 1
bindsym $mod+Shift+2 move container to workspace 2
bindsym $mod+Shift+3 move container to workspace 3
bindsym $mod+Shift+4 move container to workspace 4
bindsym $mod+Shift+5 move container to workspace 5
bindsym $mod+Shift+6 move container to workspace 6
bindsym $mod+Shift+7 move container to workspace 7
bindsym $mod+Shift+8 move container to workspace 8
bindsym $mod+Shift+9 move container to workspace 9
bindsym $mod+Shift+0 move container to workspace 10

bindsym Print exec ${grim}/bin/grim \
  ${picture-dir}/screenshots/$(date +'%F_%R:%S_grim.png')
bindsym $mod+Print exec ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" \
  ${picture-dir}/screenshots/$(date +'%F_%R:%S_grim.png')

bindsym XF86AudioRaiseVolume exec --no-startup-id pactl \
  set-sink-volume @DEFAULT_SINK@ +2% && amixer sget Master | grep 'Right:' \
  | awk -F'[][]' '{ print substr($2, 0, length($2)-1) }' > $SWAYSOCK.wob
bindsym XF86AudioLowerVolume exec --no-startup-id pactl \
  set-sink-volume @DEFAULT_SINK@ -2% && amixer sget Master | grep 'Right:' \
  | awk -F'[][]' '{ print substr($2, 0, length($2)-1) }' > $SWAYSOCK.wob
bindsym XF86AudioMute        exec --no-startup-id pactl \
  set-sink-mute   @DEFAULT_SINK@ toggle

### Status bar
bar {
    position top
    mode hide
    modifier Mod1

    status_command exec i3status

    separator_symbol " | "
    font pango:PragmataPro Mono Liga 11

    colors {
        background $bg
        statusline $fg

        # workspaces section border    background text
        focused_workspace    $green    $green     $fg
        inactive_workspace   $bg       $fg        $bg
        urgent_workspace     $bg       $red       $fg
    }

    tray_output none
}

include ~/.config/sway/config
''

