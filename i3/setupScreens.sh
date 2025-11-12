# get list of connected outputs
outputs=$(xrandr --query | grep " connected" | awk '{print $1}')
current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name') || 1

dp=""
hdmi=""

for out in $outputs; do
  if [[ $out == DisplayPort-* ]]; then
    dp="$out"
  elif [[ $out == HDMI-* ]]; then
    # pick the first HDMI found
    if [[ -z $hdmi ]]; then
      hdmi="$out"
    fi
  fi
done

if [[ -z $dp ]]; then
  echo "No DisplayPort output found. Exiting."
  exit 1
fi

if [[ -z $hdmi ]]; then
  echo "No HDMI output found. Using only $dp as primary."
  xrandr --output "$dp" --auto --primary
  exit 0
fi

# both found: apply layout
xrandr --output "$dp" --auto --primary --output "$hdmi" --auto --left-of "$dp"

# move windows

# send workspace 1 to HDMI output
i3-msg "workspace 1; move workspace to output $hdmi"

# move 2,3,4 to DP out
i3-msg "workspace 2; move workspace to output $dp"
i3-msg "workspace 3; move workspace to output $dp"
i3-msg "workspace 4; move workspace to output $dp"

# polybar
killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done

for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
  MONITOR=$m polybar -c .config/polybar/main.module &
done

# switch back to the workspace I was on
i3-msg "workspace number $current_workspace"