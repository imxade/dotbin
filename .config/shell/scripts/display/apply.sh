#!/bin/bash

path="${XDG_CONFIG_HOME}/shell/scripts/display"
# Read brightness and color temperature from files
brightness_file="${path}/brightness.txt"
temperature_file="${path}/temperature.txt"

# Initialize modification times
brightness_modification_time=$(stat -c %Y $brightness_file)
temperature_modification_time=$(stat -c %Y $temperature_file)

# Function to set brightness and color temperature using gammastep
set_brightness_and_temperature() {
    brightness=$(cat $brightness_file)
    temperature=$(cat $temperature_file)
    gammastep -l 0:0 -o -P -b $brightness:$brightness -t $temperature:$temperature
}

# Initial call to set brightness and color temperature
set_brightness_and_temperature

# Loop to monitor changes in the brightness and color temperature files
while true; do
    # Check modification times
    current_brightness_modification_time=$(stat -c %Y $brightness_file)
    current_temperature_modification_time=$(stat -c %Y $temperature_file)

    # If either file has been modified, rerun the function
    if [[ $current_brightness_modification_time != $brightness_modification_time ]] || [[ $current_temperature_modification_time != $temperature_modification_time ]]; then
        set_brightness_and_temperature
        brightness_modification_time=$current_brightness_modification_time
        temperature_modification_time=$current_temperature_modification_time
    fi

    # Sleep for a short period to avoid excessive CPU usage
    sleep 1
done
