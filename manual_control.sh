#!/bin/bash

ssh_login() {
    xdotool type "ssh kratos@192.168.1.10"
    xdotool key Return
    sleep 1
    xdotool type "kratos123"
    xdotool key Return
    sleep 1
    xdotool type "clear"
    xdotool key Return
    sleep 1
}

simulate_input() {
    xdotool type "$1"
    xdotool key Return
    sleep 1
}

split_vertical() {
    xdotool key Ctrl+Shift+E
    sleep 1
}

split_horizontal() {
    xdotool key Ctrl+Shift+O
    sleep 1
}

# Function to bring the specified terminator window to the front
bring_to_front() {
    wmctrl -r :ACTIVE: -e 0,0,0,-1,-1
}

move_left() {
    xdotool key Alt+Left
    sleep 1
}

move_right() {
    xdotool key Alt+Right
    sleep 1
}

move_up() {
    xdotool key Alt+Up
    sleep 1
}

move_down() {
    xdotool key Alt+Down
    sleep 1
}


terminator_width=$(xdpyinfo | awk '/dimensions:/ {print $2}' | cut -d'x' -f1)
terminator_height=$(expr $(xdpyinfo | awk '/dimensions:/ {print $2}' | cut -d'x' -f2) / 1)

terminator --geometry=${terminator_width}x${terminator_height}+0+0 &
bring_to_front
sleep 1

ssh_login
simulate_input "roscore"
split_horizontal
ssh_login
simulate_input "roslaunch irc2024 esp-serial.launch"
split_vertical
simulate_input "roslaunch irc2024 manual_control.launch"
move_up
split_vertical
ssh_login
simulate_input "roslaunch usb_cam usb_cam-test.launch"
move_down
split_vertical
ssh_login
simulate_input "rosrun urc2022 videofeed1 0"
split_vertical
simulate_input "rosrun rqt_image_view rqt_image_view"