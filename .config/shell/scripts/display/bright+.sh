#!/bin/bash

# Read brightness from file
path="${XDG_CONFIG_HOME}/shell/scripts/display"
file="${path}/brightness.txt"
currentBrightness=$(cat $file)

# Increase brightness
newBrightness=$((currentBrightness + 0.1))

# Write new brightness back to file
echo $newBrightness > $file

# Call the third script to set brightness
source "${path}/apply.sh"

