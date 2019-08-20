# !/bin/bash
#
# Program: draw in mini program of eshop-switch(http://www.eshop-switch.com/)
# History: 2019-08-20
#

WID=`xdotool search --name "Google Pixel"`
COUNTER=0

while :
do
  xdotool mousemove -w $WID 0 0
  xdotool mousemove_relative 185 549
  xdotool click 1
  sleep 35
  xdotool mousemove -w $WID 0 0
  xdotool mousemove_relative 470 41
  xdotool click 1
  sleep 1
  COUNTER=$((COUNTER+1))
  echo "draw $COUNTER count"
done
