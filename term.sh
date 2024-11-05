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
python3 sample.py
# sleep 4
# pkill -f 'python3 sample.py'

terminator_width=$(xdpyinfo | awk '/dimensions:/ {print $2}' | cut -d'x' -f1)
terminator_height=$(expr $(xdpyinfo | awk '/dimensions:/ {print $2}' | cut -d'x' -f2) / 2)


# First window
terminator --geometry=${terminator_width}x${terminator_height}+0+0 &
sleep 1
ssh_login
simulate_input "roscore"                                                                                         # roscore command
split_horizontal
ssh_login
simulate_input "sudo chmod a+rw /dev/ttyACM*"                                                                    # permissions command for serial port 
simulate_input "kratos123"
split_vertical
ssh_login
simulate_input "rosrun rosserial_python serial_node.py /dev/ttyACM0 _baud:=57600"                                # rosserial command
split_vertical
ssh_login
simulate_input "roslaunch usb_cam usb_cam-test.launch"                                                           # usb_cam launch command
split_vertical
ssh_login
simulate_input "roslaunch darknet_ros yolov3_custom.launch"                                                      # darkent ros command
xdotool key Alt+Up
split_vertical
ssh_login
simulate_input "rosrun urc2022 videofeed1 0"                                                                   # view feed command
split_vertical 
ssh_login
simulate_input "roslaunch mavros px4.launch"            # gps command

# Second Window
command_cd="cd catkin_ws/src/autonomous_irc/controls_auto/scripts/"
terminator --geometry=${terminator_width}x${terminator_height}+0+${terminator_height} &
sleep 1
ssh_login
simulate_input "$command_cd"
simulate_input "./search_arrow.py"                                                                         # search arrow
split_horizontal
ssh_login
simulate_input "$command_cd"
simulate_input "./follow_arrow.py"                                                                         # follow arrow
split_vertical
ssh_login
simulate_input "$command_cd"
simulate_input "./rotate90.py"                                                                            # roate_90
command_cd="cd catkin_ws_2/src/autonomous_irc/controls_auto/scripts/"
split_vertical
ssh_login
simulate_input "$command_cd"
simulate_input "./gps_map.py"                                                                                    # gps_info
xdotool key Alt+Up                                                                                   
split_vertical
ssh_login
simulate_input "$command_cd"
simulate_input "./maincontrol.py"    
split_vertical
simulate_input "rosrun rqt_image_view rqt_image_view"                                                                     # main control
