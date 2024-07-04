#!/bin/bash

BAT=$(acpi -b | grep -E -o '[0-9]+%' | tr -d '%')

# Full and short texts
echo "Battery: $BAT%"
echo "BAT: $BAT%"

# Set urgent flag below 10% or use orange below 20%
if [ "$BAT" -le 15 ]; then
    echo "#FF0000"
    #exit 33
elif [ "$BAT" -le 30 ]; then
    echo "#FF8000"
elif [ "$BAT" -ge 100 ]; then
    echo "#00FF00" # Green background for 100%
fi

exit 0
