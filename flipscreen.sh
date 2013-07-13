#!/bin/bash
#
# Utility script that assists in swapping the state of a screen in
# Ubuntu between "normal" and "inverted" on a Dell XPS 12. Most useful
# when it's bound to the 'Auto-rotate' key in Ubuntu. See 
# http://blog.jay.sh/ubuntu-12-10-on-the-dell-xps-12/ for more information.

(
	# Attempt to get an exclusive lock on /tmp/last_flipscreen_timestamp.
	# If it fails, we exit immediately - this works around the 
	# problem of Ubuntu executing this script twice (sometimes).
	flock --nonblock 9 || exit 1

	# Get the timestamp of the last time the screen was rotated. The
	# existence check is useful for the first run, or after a reboot
	# (for /tmp's which are mounted via tmpfs).
	if [ -e /tmp/last_flipscreen_timestamp ]; then
		last_screen_rotation=$( cat /tmp/last_flipscreen_timestamp );
	else
		last_screen_rotation=0;
	fi

	# If it's been too soon since the last rotation, ignore the request.
	seconds_since_last_rotate=$(( $(date +%s) - $last_screen_rotation ));
	if [ $seconds_since_last_rotate -lt 5 ]; then
		exit 1
	fi

	# Update the file with the current timestamp.
	date +%s > /tmp/last_flipscreen_timestamp

	# Compute the current rotation
	current_rotation=$(xrandr -q --verbose | grep eDP1 | cut -b37-43)
	if [ $current_rotation == "normal" ]; then
		xrandr -o inverted
	else
		xrandr -o normal
	fi
	
) 9>/tmp/last_flipscreen_timestamp.lock

