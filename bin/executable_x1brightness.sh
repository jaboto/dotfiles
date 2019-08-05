# Dell N4010 brightness control workaround
# Note: add the following to /etc/rc.local
#       chmod 777 /sys/class/backlight/intel_backlight/brightness
# The file .config/khotkeysrc should contain the hotkeys CTRL+SHIFT+F4/F5 to
# adjust brightness down and up respectively.
#
# Usage:
#    ./brightness.sh up   # bump up brightness
#    ./brightness.sh down # bump down brightness
#

if [ -z $1 ]; then
	exit
else
	action=$1
	echo "Action is $action"
fi

case $action in
	'inc')
		xbacklight -inc 5
		curBrightness=`xbacklight -get`
		notify-send -t 200 'Brigthness' $curBrightness
	;;
	'dec')
		xbacklight -dec 5
		curBrightness=`xbacklight -get`
		notify-send -t 200 'Brigthness' $curBrightness
	;;
	*) echo 'No proper input action, exiting' && exit;;
esac


