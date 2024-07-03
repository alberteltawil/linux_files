#!/bin/bash

# Specify the directory path
directory="$HOME/Pictures/Backgrounds"

# Check if the directory exists
if [ ! -d "$directory" ]; then
 # echo "Error: Directory not found!"
	echo "$HOME/Pictures/Backgrounds"
  exit 1
fi

# Get a list of files in the directory and shuffle them
files=($(shuf -e "$directory"/*))

# Check if there are any files in the directory
if [ ${#files[@]} -eq 0 ]; then
  echo "Error: No files found in the directory!"
  exit 1
fi

# Select the first (randomized) file from the list
random_file="${files[0]}"

if [ "$1" = "xfce" ]; then
	# Set Xfce background
	xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitoreDP-1/workspace0/last-image -s $random_file
else
	# Set i3 background
	feh --bg-scale --no-xinerama $random_file	
fi
