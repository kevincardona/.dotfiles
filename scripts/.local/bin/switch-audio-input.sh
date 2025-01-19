#!/bin/bash

# Get a list of all available audio sources
audio_sources=$(pactl list short sources | awk '{print $2}')

# Get the current default source
current_source=$(pactl get-default-source)

# Convert the list of sources to an array
source_array=($audio_sources)

# Find the index of the current source
for i in "${!source_array[@]}"; do
  if [ "${source_array[$i]}" == "$current_source" ]; then
    current_source_index=$i
    break
  fi
done

# Check for user argument
if [ "$1" == "prev" ]; then
  # Calculate the index of the previous source
  prev_source_index=$(( (current_source_index - 1 + ${#source_array[@]}) % ${#source_array[@]} ))
  next_source=${source_array[$prev_source_index]}
elif [ "$1" == "next" ]; then
  # Calculate the index of the next source
  next_source_index=$(( (current_source_index + 1) % ${#source_array[@]} ))
  next_source=${source_array[$next_source_index]}
else
  next_source=$current_source
fi

# Set the chosen source as the default
pactl set-default-source "$next_source"

echo "Switched default input to: $next_source"
notify-send "Switched default input to: $next_source"

