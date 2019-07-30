#!/bin/bash
# Brightness script for Sony Vaio P

# Reduce and Increase the brigthness for a Sony Vaio P
#  Use some beautiful notifications when possible

device='/sys/devices/virtual/backlight/psb-bl/brightness'
notify='/usr/bin/notify-send'

show_notification () {
	if [ -e $notify ]; then
		`$notify -t 700 'Brightness' $1`
	fi
}


if [ -z $1 ]; then
	# No action given. Exit
	exit
else
	action=$1
	actual=`cat $device`
fi


case $action in
	'inc') 
		if [ $actual -gt 90 ]; then
			# In case brightness is not always x0 and we want to reach 100
			actual=90
		fi
		value=$((actual + 10))
		echo $value | sudo /usr/bin/tee $device
		show_notification $value
	;;
	'dec') 
		if [ $actual -lt 10 ]; then
			# In case brightness is not always x0 and we want to reach 0
			actual=10
		fi
		value=$((actual - 10))
		echo $value | sudo /usr/bin/tee $device
		show_notification $value
	;; 
	*) exit;;
esac
