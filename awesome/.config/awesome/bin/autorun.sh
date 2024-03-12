#!/bin/sh

run() {
    if ! pgrep -f "$1" > /dev/null ;
    then
        echo starting
        "$@"&
    fi
}
run picom --config $HOME/.config/picom/picom.conf

if xrandr | grep -q 'HDMI1 connected' ; then
    MAIN_DISPLAY=$(xrandr | grep '^HDMI1.* connected' | awk '{print $1;}')
    LAPTOP_DISPLAY=$(xrandr | grep '^eDP1.* connected' | awk '{print $1;}')
    xrandr --auto --output $MAIN_DISPLAY --mode 1920x1080 --right-of $LAPTOP_DISPLAY
fi

nitrogen --restore
