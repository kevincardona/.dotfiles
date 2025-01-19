#!/bin/bash

# Get a list of all available audio sinks
audio_sinks=$(pactl list short sinks | awk '{print $2}')

# Get the current default sink
current_sink=$(pactl get-default-sink)

# Convert the list of sinks to an array
sink_array=($audio_sinks)

# Find the index of the current sink
for i in "${!sink_array[@]}"; do
  if [ "${sink_array[$i]}" == "$current_sink" ]; then
    current_index=$i
    break
  fi
done

# Check for user argument
if [ "$1" == "prev" ]; then
  # Calculate the index of the previous sink
  prev_index=$(( (current_index - 1 + ${#sink_array[@]}) % ${#sink_array[@]} ))
  next_sink=${sink_array[$prev_index]}
else
  # Calculate the index of the next sink
  next_index=$(( (current_index + 1) % ${#sink_array[@]} ))
  next_sink=${sink_array[$next_index]}
fi

# Set the chosen sink as the default
pactl set-default-sink "$next_sink"

echo "Switched default audio to: $next_sink"

