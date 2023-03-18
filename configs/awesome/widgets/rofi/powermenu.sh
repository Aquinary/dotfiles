#!/usr/bin/env bash

cd ~/.config/awesome/widgets/rofi/

theme="style"
dir="$HOME/.config/awesome/widgets/rofi/theme/powermenu"

rofi_command="rofi -theme $dir/$theme"

# Options
shutdown=""
reboot=""
suspend=""
logout=""

# Variable passed to rofi
options="$shutdown\n$reboot\n$suspend\n$logout"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 2)"
case $chosen in
    $shutdown)
		systemctl poweroff
        ;;
    $reboot)
		systemctl reboot
        ;;
    $suspend)
		mpc -q pause
		amixer set Master mute
		systemctl suspend
        ;;
    $logout)
		killall awesome
    killall -u aquinary
        ;;
esac

