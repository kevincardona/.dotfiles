#!/bin/bash

# Set display variables (modify if necessary)
STEAM_MULTIPLE_XWAYLANDS=1
export DISPLAY=:0
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# Launch Steam Big Picture with Gamescope
STEAM_MULTIPLE_XWAYLANDS=1 gamescope --adaptive-sync -- steam -gamepadui -steamdeck
