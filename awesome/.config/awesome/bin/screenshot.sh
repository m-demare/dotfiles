#!/bin/sh

# flameshot doesn't restore focus to de original window, which is annoying
focused_win=$(xdotool getactivewindow)
flameshot gui
[ "$focused_win" = "$(xdotool getactivewindow)" ] && xdotool windowfocus $focused_win
