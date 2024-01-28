#!/bin/bash

path="${XDG_CONFIG_HOME}/shell/scripts/display"
# Read brightness and color temperature from files
brightness_file="${path}/brightness.txt"
temperature_file="${path}/temperature.txt"

# Function to set brightness and color temperature using gammastep
set_brightness_and_temperature() {
    brightness=$(cat $brightness_file)
    temperature=$(cat $temperature_file)
    gammastep -l 0:0 -o -P -b $brightness:$brightness -t $temperature:$temperature
}

# Run gammastep in the background and save the process ID
set_brightness_and_temperature & echo $! > /tmp/gammastep.pid
