#!/bin/sh

# Path variable
path="${XDG_CONFIG_HOME}/shell/scripts/display"

# Read brightness from file
file="$path/brightness.txt"
current_brightness=$(awk '{print $1}' $file)

# Increase brightness only if current brightness is less than 1
if awk -v a="$current_brightness" 'BEGIN{exit !(a > 0)}'; then
    new_brightness=$(awk -v a="$current_brightness" 'BEGIN {print a - 0.1}')

    # Write new brightness back to file
    echo $new_brightness > $file
fi
