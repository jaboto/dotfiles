#!/bin/sh
# Based on the script from
# http://quepagina.es/ubuntarium/vamos-a-personalizar-la-tecla-switch-display-de-portatil.html
# Modified on 23/1/2017 to enable specific VGA settings


# Will do a cycling output from state 0 to 2 and use a sound as feedback
# State VGA LVDS Beeps
#   0    0   1      1
#   1    1   0      2   
#   2    1   1      3
#   (back to state 0)   

# Function to play noise over normal speaker and not beep
output_noise(){
  (speaker-test --frequency 400 --test sine )& pid=$!;
  sleep 0.08;
  kill -9 $pid
}


#For identifying our monitors use xrandr tool and view output
LVDS=LVDS-1      # could be another one like: LVDS, LVDS-1, etc
VGA=DP1        # could be another one like: VGA, VGA-1, etc
VGA_MODE=848x480    # used by the LED projector I own
EXTRA="--right-of $LVDS" # addtional info while dual display
EXTRA_EXT="--brightness 3"

# Lets check both LVDS and VGA state from the string "$display connected (" 
xrandr | grep -q "$LVDS connected (" && LVDS_IS_ON=0 || LVDS_IS_ON=1
xrandr | grep -q "$VGA connected (" && VGA_IS_ON=0 || VGA_IS_ON=1

echo "LVDS is : $LVDS_IS_ON "
echo "VGA is : $VGA_IS_ON "

# Output switch cycle
if [ $LVDS_IS_ON -eq 1 ] && [ $VGA_IS_ON -eq 1 ]; then
    echo "state 0"
    #Go to state 0 -> just LVDS
    xrandr --output $LVDS --auto 
    xrandr --output $VGA --off
    output_noise
elif [ $LVDS_IS_ON -eq 1 ]; then
    echo "state 1"
    #Go to state 1 -> just VGA
    xrandr --output $LVDS --off
    xrandr --output $VGA --mode $VGA_MODE $EXTRA_EXT
    output_noise && output_noise
elif [ $VGA_IS_ON -eq 1 ]; then
    echo "state 2"
    #Go to state 2 -> both outputs
    xrandr --output $LVDS --auto
    xrandr --output $VGA --mode $VGA_MODE $EXTRA $EXTRA_EXT
    output_noise && output_noise && output_noise
else
    echo "state 3"
    #This should never be reached but just in case..
    xrandr --output $LVDS --auto 
    beep && beep && beep && beep
fi
