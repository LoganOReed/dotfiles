# Current Theme

# CMDs
uptime="`uptime | awk -F'( |,|:)+' '{d=h=m=0; if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes."}'`"
host=`hostname`

# Options
shutdown=' '
reboot=' '
lock=' '
suspend=''
logout=' '
yes=' '
no=''

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "Uptime: $uptime" \
		-mesg "Uptime: $uptime" \
		-theme "$HOME/.config/rofi/style.rasi"
}

# Confirmation CMD
confirm_cmd() {
	rofi -dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme "$HOME/.config/rofi/confirm.rasi"
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot
		elif [[ $1 == '--suspend' ]]; then
			systemctl suspend
      swaylock --screenshots --clock --indicator --indicator-radius 200 --indicator-thickness 10 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color 6272a4 --key-hl-color ff79c6 --line-color 6272a400 --inside-color 282a3688 --separator-color 282a3600 --fade-in 0.2 --font 'Iosevka Comfy' --font-size 32 --timestr '%I:%M:%S' --datestr '%e %B %Y' --text-color f8f8f2
		elif [[ $1 == '--logout' ]]; then
			i3-msg exit
		fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case "$chosen" in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $lock)
		swaylock --screenshots --clock --indicator --indicator-radius 200 --indicator-thickness 10 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color 6272a4 --key-hl-color ff79c6 --line-color 6272a400 --inside-color 282a3688 --separator-color 282a3600 --fade-in 0.2 --font 'Iosevka Comfy' --font-size 32 --timestr '%I:%M:%S' --datestr '%e %B %Y' --text-color f8f8f2
        ;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
