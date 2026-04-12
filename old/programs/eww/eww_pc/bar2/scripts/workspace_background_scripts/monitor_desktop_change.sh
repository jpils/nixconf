#! /bin/sh

monitor() {

	current_desktop=$(wmctrl -d | grep "*" | awk '{print $1}')

	if [ "$current_desktop" != "$previous_desktop" ]; then
		echo "switched"

		previous_desktop="$current_desktop"
	
	fi
} 

previous_desktop=""

while true; do
	monitor
	sleep 0.5
done
