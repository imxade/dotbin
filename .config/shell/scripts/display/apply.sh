#!/bin/bash

path="${XDG_CONFIG_HOME}/shell/scripts/display"
# Read brightness and color temperature from files
brightness_file="${path}/brightness.txt"
temperature_file="${path}/temperature.txt"

# Create a temporary timestamp file
timestamp_file="$(mktemp)"
touch "$timestamp_file"

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
    # Update the timestamp file if either file has been modified
    touch -r "$brightness_file" "$timestamp_file"
    touch -r "$temperature_file" "$timestamp_file"

    # If either file has been modified, rerun the function
    if find "$brightness_file" -newer "$timestamp_file" || find "$temperature_file" -newer "$timestamp_file"; then
        set_brightness_and_temperature
    fi

    # Sleep for a short period to avoid excessive CPU usage
    sleep 1
done

# Remove the temporary timestamp file
rm "$timestamp_file"

