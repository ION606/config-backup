#!/bin/bash

img="$(find /home/ion606/Pictures/astolfo/ -type f | shuf -n 1)";
tmp="/tmp/i3lock-bg.png";

magick "$img" -strip "$tmp";

if [[ "$1" == "--single" ]]; then
  i3lock -i "$tmp" -F
  exit 0
fi

BLANK='#00000000'
CLEAR='#ffffff22'
DEFAULT='#00897bE6'
TEXT='#00897bE6'
WRONG='#880000bb'
VERIFYING='#00564dE6'

i3lock \
  --insidever-color=$CLEAR \
  --ringver-color=$VERIFYING \
  \
  --insidewrong-color=$CLEAR \
  --ringwrong-color=$WRONG \
  \
  --inside-color=$BLANK \
  --ring-color=$DEFAULT \
  --line-color=$BLANK \
  --separator-color=$DEFAULT \
  \
  --verif-color=$TEXT \
  --wrong-color=$TEXT \
  --time-color=$TEXT \
  --date-color=$TEXT \
  --layout-color=$TEXT \
  --keyhl-color=$WRONG \
  --bshl-color=$WRONG \
  \
  --screen 1 \
  --blur 9 \
  --clock \
  --indicator \
  --time-str="%H:%M:%S" \
  --date-str="%A, %Y-%m-%d" \
  --keylayout 1

# # paths for temporary images
# tmpbg='/tmp/lockscreen.png'
# original_bg='/tmp/original_lockscreen.png'
# icon='/home/ion606/Pictures/NBEE.png'
# if [[ -f "$tmpbg" ]]; then
#   rm "$tmpbg"
# fi
# if [[ -f "$original_bg" ]]; then
#   rm "$original_bg"
# fi

# # take a screenshot and blur it
# scrot "$original_bg"
# magick "$original_bg" -scale 10% -scale 1000% "$original_bg"

# # optional: overlay an icon on the blurred image
# if [[ -f "$icon" ]]; then
#   magick "$original_bg" "$icon" -gravity center -composite "$original_bg"
# fi

# # copy the original blurred image to tmpbg for the loop
# cp "$original_bg" "$tmpbg"

# # start i3lock with the initial image
# i3lock -i "$tmpbg" &
# lock_pid=$!

# # # update the image with the current time in a loop
# # while kill -0 "$lock_pid" 2>/dev/null; do
# #   # reset tmpbg to the original blurred image
# #   cp "$original_bg" "$tmpbg"

# #   # overlay the clock text on the reset image
# #   magick "$tmpbg" -gravity center -font Ubuntu-Bold -pointsize 50 -fill white \
# #     -annotate +0+200 "$(date '+%I:%M %p')" "$tmpbg"

# #   # reload i3lock with the updated image
# #   i3lock -i "$tmpbg" --nofork &
# #   sleep 1
# # done
