#!/bin/bash

# Read Temp from file
path="${XDG_CONFIG_HOME}/shell/scripts/display"
file="${path}/temperature.txt"
currentTemp=$(cat $file)

# Increase Temp
newTemp=$((currentTemp + 200))

# Write new Temp back to file
echo $newTemp > $file

# Call the third script to set Temp
source "${path}/apply.sh"

