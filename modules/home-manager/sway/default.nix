{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.modules.sway;

in {
    options.modules.sway= { enable = mkEnableOption "sway"; };
    config = mkIf cfg.enable {
	home.packages = with pkgs; [
	 dunst rofi-wayland swaybg wlsunset pavucontrol swaylock-effects swayidle kitti3 autotiling wayland xwayland
	];



  # enable sway window manager
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
    xwayland = true;
    config.bars = [];
    extraConfig = ''
bar swaybar_command waybar
exec_always swaybg -i $NIXOS_CONFIG_DIR/pics/RainbowDracula.png
exec_always --no-startup-id autotiling
#exec_always --no-startup-id picom -b --config ~/.config/picom/picom.conf
# notification manager
exec_always --no-startup-id dunst
# https://github.com/LandingEllipse/kitti3
exec_always --no-startup-id kitti3 -n packageupdater -p RC -s .35 1 
exec_always --no-startup-id kitti3 -n scratchpad -p CC -s 0.6 0.6 



corner_radius 20


#
# #---Basic Definitions---# #
smart_gaps on
smart_borders on
set $inner_gaps 15px
set $outer_gaps 0
set $term --no-startup-id kitty
set $mod Mod4
set $alt Mod1
set $powbutton XF86PowerOff
set $shutdown shutdown -h now
set $reboot reboot
set $suspend systemctl suspend
set $hibernate systemctl hibernate

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# Fonts
# Iosevka package on arch uses NF abbr.
font pango:Iosevka Comfy 16
font pango:Iosevka Nerd Font 16
font pango:Iosevka Nerd Font 16

# Dracula Color Palette

# class                 border  bground text    indicator child_border
client.focused          #50fa7b #6272A4 #F8F8F2 #6272A4   #6272A4
client.focused_inactive #44475A #44475A #F8F8F2 #44475A   #44475A
client.unfocused        #282A36 #282A36 #BFBFBF #282A36   #282A36
client.urgent           #44475A #FF5555 #F8F8F2 #FF5555   #FF5555
client.placeholder      #282A36 #282A36 #F8F8F2 #282A36   #282A36

client.background       #50fa7b
#client.background       #F8F8F2


# #---Gaps---# #
for_window [class="^.*"] border pixel 2
gaps inner $inner_gaps
gaps outer $outer_gaps

# #---Basic Bindings---# #

# bindsym $mod+Return 		         exec $term --hold -e rxfetch
bindsym $mod+Return 		         exec notify-send "Use slash or semicolon punk "
# bindsym $mod+Shift+Return	       exec $term --hold -e neofetch

bindsym $powbutton	             exec --no-startup-id $HOME/.config/rofi/powermenu/type-3/powermenu.sh
bindsym $mod+Escape	             exec --no-startup-id swaylock --screenshots --clock --indicator --indicator-radius 200 --indicator-thickness 10 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color 6272a4 --key-hl-color ff79c6 --line-color 6272a400 --inside-color 282a3688 --separator-color 282a3600 --fade-in 0.2 --font 'Iosevka Comfy' --font-size 32 --timestr '%I:%M:%S' --datestr '%e %B %Y' --text-color f8f8f2
# bindsym $mod+BackSpace
# bindsym $mod+Shift+BackSpace	   exec --no-startup-id prompt "Reboot computer?" $reboot

# space
bindsym $mod+space 			         exec $term -e ranger


# #---Letter Key Bindings---# #
bindsym $mod+q			            [con_id="__focused__" instance="^(?!dropdown_).*$"] kill
bindsym $mod+Shift+q		        [con_id="__focused__" instance="^(?!dropdown_).*$"] exec --no-startup-id kill -9 `xdotool getwindowfocus getwindowpid`

# w
# Brave is a web browser idc about
bindsym $mod+w 			            exec $term -e mapwacom -d "Wacom Intuos Pro M Pen stylus" -d "Wacom Intuos Pro M Pen cursor" -d "Wacom Intuos Pro M Pen eraser" -s "DisplayPort-2"

# c
bindsym $mod+c 			                  exec rofi -show calc -modi calc -no-show-match -no-sort 
# bindsym $mod+Shift+c		            exec --no-startup-id $suspend

# For VSCode code-insiders
# e
bindsym $mod+e                        workspace $ws8; exec $term neomutt; focus
bindsym $mod+Shift+e                  exec --no-startup-id rofimoji -f nerd_font.csv --selector-args="-theme ~/.config/rofi/rofimoji.rasi -kb-mode-next Shift+Right -kb-mode-previous Shift+Left -kb-row-left Control+h -kb-row-right Control+l" --hidden-descriptions
# bindsym $mod+Shift+e 			            exec --no-startup-id emacs-28.2

# r
bindsym $mod+r 			            exec --no-startup-id renoise
# bindsym $mod+Shift+r		        exec --no-startup-id winresize
#
# t
bindsym $mod+t 			            workspace $ws7; exec $term -e btop; focus
bindsym $mod+Shift+t            focus mode_toggle

# y
bindsym $mod+y			            exec --no-startup-id flameshot gui -p ~/Media/Pictures/Screenshots
bindsym $mod+Shift+y		        exec --no-startup-id flameshot full -p ~/Media/Pictures/Screenshots

# u
bindsym $mod+u                  [urgent=latest] focus

# i
bindsym $mod+i                  nop scratchpad
# bindsym $mod+Shift+i 	          floating toggle

# o
# bindsym $mod+o			            nop scratchpad
# bindsym $mod+Shift			        exec --no-startup-id $term -e nvim ~/Repos

# a
# I removed todofi for todoist
# bindsym $mod+a		              exec ~/bin/todofi

# s
# I don't want to use spotify
# bindsym $mod+s        			    workspace $ws10; exec $term -e spt; focus
bindsym $mod+Shift+s			      split toggle

# d
# bindsym $mod+d                  exec --no-startup-id i3-dmenu-desktop --dmenu="dmenu_run -b -i -nf '#F8F8F2' -nb '#282A36' -sb '#6272A4' -sf '#F8F8F2' -fn 'monospace-10' -p 'dmenu%'"
bindsym $mod+d            exec firefox

# f
bindsym $mod+f			            fullscreen toggle
bindsym $mod+Shift+f 	          floating toggle

# g
bindsym $mod+g		              gaps inner current set $inner_gaps; gaps outer current set $outer_gaps
bindsym $mod+Shift+g		        gaps inner current set 0; gaps outer current set 0

# h
bindsym $mod+h			            focus left
bindsym $mod+Shift+h		        move left 30
bindsym $mod+Ctrl+h		          move workspace to output left

# j
bindsym $mod+j			            focus down
bindsym $mod+Shift+j		        move down 30
bindsym $mod+Ctrl+j		          focus child

# k
bindsym $mod+k			            focus up
bindsym $mod+Shift+k		        move up 30
bindsym $mod+Ctrl+k		          focus parent

# l
bindsym $mod+l			            focus right
bindsym $mod+Shift+l		        move right 30
bindsym $mod+Ctrl+l		          move workspace to output right

# z
# not where my dotfiles are anymore
# bindsym $mod+z			            exec --no-startup-id $term -e nvim ~/.dotfiles

# x
# Why would I have this
# bindsym $mod+x 			            exec --no-startup-id $reboot
# bindsym $mod+Shift+x		        exec --no-startup-id $shutdown

# p
bindsym $mod+p			            nop packageupdater
# bindsym $mod+Shift+p		        exec --no-startup-id killall picom

# Creepy facetime jumpscare
# v
bindsym $mod+v			            exec --no-startup-id mpv /dev/video0

# b
bindsym $mod+b                  exec --no-startup-id rofi-bluetooth
bindsym $mod+Shift+b			      exec --no-startup-id feh --bg-fill ~/Media/Pictures/dracula-soft-waves-6272a4.png

# n
# Lookup methods
bindsym $mod+n		              exec --no-startup-id wmfocus

# m
# bindsym $mod+m		              workspace $ws10; exec $term -e ncmpcpp
bindsym $mod+m		              exec --no-startup-id slippi
bindsym $mod+Shift+m		        exec --no-startup-id minecraft

# read 1 character and go to the window with the character
# bindsym $mod+Shift+m exec i3-input -F '[con_mark="%s"] focus' -l 1 -P 'Goto: '

# #---Workspace Bindings---# #
# bindsym $mod+Tab		            exec --no-startup-id rofi-menu-windows
bindsym $mod+Tab		            layout toggle tabbed split
bindsym $mod+grave		          workspace back_and_forth
# bindsym $mod+Shift+Tab		      workspace prev
bindsym $mod+apostrophe		      split horizontal ;; exec $term
bindsym $mod+slash		          split vertical ;; exec $term --hold -e rxfetch
bindsym $mod+Shift+slash	      kill
# bindsym $mod+backslash		      workspace back_and_forth

#set $ws1 "1:Terminal  "
#set $ws2 "2:Browser  "
#set $ws3 "3:File  "
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"
#set $ws8 "8: Mail  "
#set $ws9 "9: Message  "
#set $ws10 "10:Music  "

# Assign Workspaces:
# assign [class="Brave"] $ws1
# assign [class="Chromium"] $ws2
# assign [class="discord"] $ws8
# for_window [class="Spotify"] move to workspace $ws9
# assign [class="obs"] $ws10

# Assigning autofloat
# for_window [title=".*Emulator.*"] floating enable

# switch to workspace
bindsym $mod+1		workspace $ws1
bindsym $mod+2		workspace $ws2
bindsym $mod+3		workspace $ws3
bindsym $mod+4		workspace $ws4
bindsym $mod+5		workspace $ws5
bindsym $mod+6		workspace $ws6
bindsym $mod+7		workspace $ws7
bindsym $mod+8		workspace $ws8
bindsym $mod+9		workspace $ws9
bindsym $mod+0		workspace $ws10


# Dont work for some reason
# for_window [class="Zoom"] move workspace $ws10
# for_window [class="Steam"] move workspace $ws9

# move focused container to workspace
bindsym $mod+Shift+1	move container to workspace $ws1
bindsym $mod+Shift+2	move container to workspace $ws2
bindsym $mod+Shift+3	move container to workspace $ws3
bindsym $mod+Shift+4	move container to workspace $ws4
bindsym $mod+Shift+5	move container to workspace $ws5
bindsym $mod+Shift+6	move container to workspace $ws6
bindsym $mod+Shift+7	move container to workspace $ws7
bindsym $mod+Shift+8	move container to workspace $ws8
bindsym $mod+Shift+9	move container to workspace $ws9
bindsym $mod+Shift+0	move container to workspace $ws10

for_window [title="GIMP Startup"] move workspace $ws5
for_window [class="Gimp"] move workspace $ws5
for_window [window_role="GtkFileChooserDialog"] resize set 800 600
for_window [window_role="GtkFileChooserDialog"] move position center


# Dropdown / Scratchpad stuff
# exec $term --name="dropdown"
# for_window [instance="dropdown"] floating enable
# for_window [instance="dropdown"] resize set 1120 630 
# for_window [instance="dropdown"] move scratchpad
# for_window [instance="dropdown"] border pixel 5


# #---Function Buttons---# #
bindsym $mod+F1		        restart
# bindsym $mod+F2		        exec --no-startup-id screenkey -p fixed -g 90%x10%+5%-10% --opacity .9 --font-color white
bindsym $mod+F3	          exec $term -e ncpamixer 
# Screenshots
# bindsym $mod+F10			            exec --no-startup-id flameshot gui -p ~/Media/Pictures/Screenshots
# bindsym $mod+Shift+F10		        exec --no-startup-id flameshot full -p ~/Media/Pictures/Screenshots
# screenshots
bindsym $mod+F10 exec grim  -g "$(slurp)" /tmp/$(date +'%H:%M:%S.png')

# Wifi TUI
bindsym $mod+F11	        exec --no-startup-id networkmanager_dmenu

# #---Arrow Keys---# #
bindsym $mod+Left		      focus left
bindsym $mod+Shift+Left   resize shrink width 5 px or 5 ppt
bindsym $mod+Ctrl+Left		move workspace to output right
bindsym $mod+Down		      focus down
bindsym $mod+Shift+Down   resize shrink height 5 px or 5 ppt
bindsym $mod+Ctrl+Down		move workspace to output up
bindsym $mod+Up			      focus up
bindsym $mod+Shift+Up     resize grow height 5 px or 5 ppt
bindsym $mod+Ctrl+Up		  move workspace to output down
bindsym $mod+Right 		    focus right
bindsym $mod+Shift+Right  resize grow width 5 px or 5 ppt
bindsym $mod+Ctrl+Right		move workspace to output left

# sets the sound fn keys to do what they are supposed to 
# Pulse Audio controls
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% #increase sound volume
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% #decrease sound volume
bindsym XF86AudioMute        exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle # mute sound

# Brightness
bindsym XF86MonBrightnessDown exec light -U 10
bindsym XF86MonBrightnessUp exec light -A 10




# Need for nixos
exec dbus-sway-environment
exec configure-gtk
    '';
  };

    };
}
