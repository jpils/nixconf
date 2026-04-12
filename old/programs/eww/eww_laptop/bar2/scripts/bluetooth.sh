#!/bin/sh 

switch() {
	bluetooth_list=$(bluetoothctl list)
	
	if [ "$bluetooth_list" == "" ]; then
		rfkill unblock all
	fi

	is_on=$(bluetoothctl show | grep "Powered:" | awk '{ print $2 }')

	if [ $is_on == "yes" ]; then
		bluetoothctl power off
		eww -c /home/jay/.config/eww/bar2 update bluetooth-icon=""
	elif [ $is_on == "no" ]; then
		bluetoothctl power on
		eww -c /home/jay/.config/eww/bar2 update bluetooth-icon=""
	else
		echo "Error occurred"
	fi
}

status() {
	is_on=$(bluetoothctl show | grep "Powered:" | awk '{ print $2 }')

	if [ $is_on == "yes" ]; then
		eww -c /home/jay/.config/eww/bar2 update bluetooth-icon=""
	else 
		eww -c /home/jay/.config/eww/bar2 update bluetooth-icon=""
	fi
}

if [ "$1" == "switch" ]; then
	switch
elif [ "$1" == "status" ]; then
	status
fi
