#!/bin/bash
set -x
if [ -d /etc/linuxmint ];
then
	# On Linux Mint, the defaults result in movement that is too fast to manage.
	xinput --set-prop "CyPS/2 Cypress Trackpad" "Device Accel Velocity Scaling" 30
	xinput --set-prop "CyPS/2 Cypress Trackpad" "Synaptics Scrolling Distance" 10 10
else
	xinput --set-prop "CyPS/2 Cypress Trackpad" "Device Accel Velocity Scaling" 50
	xinput --set-prop "CyPS/2 Cypress Trackpad" "Synaptics Scrolling Distance" 8 8
fi
