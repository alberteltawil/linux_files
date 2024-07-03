#!/bin/bash

BAT=$(acpi -b | grep -E -o '[0-9][0-9]?%')

# Full and short texts
echo "Battery: $BAT"
echo "BAT: $BAT"

# Set urgent flag below 10% or use orange below 20%
[ ${BAT%?} -le 10 ] && exit 33
[ ${BAT%?} -le 20 ] && echo "#FF8000"

exit 0
