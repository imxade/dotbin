#!/bin/bash

path="${XDG_CONFIG_HOME}/shell/scripts/display"
# Read brightness and color temperature from files
brightness_file="${path}/brightness.txt"
temperature_file="${path}/temperature.txt"

# Read initial content
brightness_content=$(cat $brightness_file)
temperature_content=$(cat $temperature_file)

# Loop to continuously check changes in the brightness and color temperature files
while true; do
    # Check if the content has changed
    current_brightness_content=$(cat $brightness_file)
    current_temperature_content=$(cat $temperature_file)
    
    if [[ $current_brightness_content != $brightness_content ]] || [[ $current_temperature_content != $temperature_content ]]; then
        # Kill the gammastep process
        kill $(cat /tmp/gammastep.pid)
        
        # Start the gammastep process again
        ${path}/apply.sh
        
        brightness_content=$current_brightness_content
        temperature_content=$current_temperature_content
    fi

    # Sleep for a short period to avoid excessive CPU usage
    sleep 1
done
