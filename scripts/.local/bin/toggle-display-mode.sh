#!/bin/bash

# Check if $1 is set to something specific, e.g., "single"
if [ "$1" == "tv" ]; then
    if kscreen-doctor -o | grep -A 5 "DP-3" | grep "2560x1440@120\*"; then
        kscreen-doctor output.DP-1.disable output.DP-2.disable output.HDMI-A-1.enable output.DP-3.enable
        kscreen-doctor output.HDMI-A-1.position.0,0 output.HDMI-A-1.mode.3840x2160@120 output.HDMI-A-1.scale.2.5 output.HDMI-A-1.primary
        kscreen-doctor output.DP-3.position.0,0 output.DP-3.mode.3840x2160@60 output.DP-3.scale.2.5
        notify-send "Switched display mode to tv (4k60)"
    elif kscreen-doctor -o | grep -A 5 "DP-3" | grep "3840x2160@60\*"; then
        kscreen-doctor output.DP-1.disable output.DP-2.disable output.HDMI-A-1.enable output.DP-3.enable
        kscreen-doctor output.HDMI-A-1.position.0,0 output.HDMI-A-1.mode.2560x1440@120 output.HDMI-A-1.scale.2.0 output.HDMI-A-1.primary
        kscreen-doctor output.DP-3.position.0,0 output.DP-3.mode.2560x1440@120 output.DP-3.scale.2.0
        notify-send "Switched display mode to tv (1440p120)"
    else
        kscreen-doctor output.DP-1.disable output.DP-2.disable output.HDMI-A-1.enable output.DP-3.enable
        kscreen-doctor output.HDMI-A-1.position.0,0 output.HDMI-A-1.mode.3840x2160@144 output.HDMI-A-1.scale.2.5 output.HDMI-A-1.primary
        kscreen-doctor output.DP-3.position.0,0 output.DP-3.mode.3840x2160@120 output.DP-3.scale.2.5
        notify-send "Switched display mode to tv (4k120)"
    fi
else
    # Default behavior: toggle between multi-monitor and single monitor
    if kscreen-doctor -o | grep -A 1 "DP-1" | grep "disabled"; then
        # If DP-1 is disabled, enable all monitors (triple monitor mode)
        kscreen-doctor output.DP-2.enable output.HDMI-A-1.enable output.DP-1.enable output.DP-3.disable
        kscreen-doctor output.DP-2.position.0,103 output.HDMI-A-1.position.2195,0 output.DP-1.position.4755,103
        kscreen-doctor output.DP-2.mode.3840x2160@60 output.HDMI-A-1.mode.3840x2160@144 output.DP-1.mode.3840x2160@60
        kscreen-doctor output.DP-2.scale.1.75 output.HDMI-A-1.scale.1.5 output.DP-1.scale.1.75
        kscreen-doctor output.HDMI-A-1.primary
        notify-send "Switched display mode to triple monitor"
    else
        # If DP-1 is enabled, switch to HDMI-only mode
        kscreen-doctor output.DP-1.disable output.DP-2.disable output.HDMI-A-1.enable output.DP-3.disable
        notify-send "Switched display mode to single monitor"
    fi
fi

