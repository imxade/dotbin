#!/bin/bash

path="${XDG_CONFIG_HOME}/shell/scripts/display"
# Read brightness and color temperature from files
brightnessFile="${path}/brightness.txt"
temperatureFile="${path}temperature.txt"

brightness=$(cat $brightnessFile)
temperature=$(cat $temperatureFile)

# Set brightness and color temperature using gammastep
gammastep -l 0:0 -o -P -b $brightness:$brightness -t $temperature:$temperature

