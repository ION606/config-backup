#!/usr/bin/env bash
# toggles display mode (percent <-> time) for the battery module
state_file="${XDG_CACHE_HOME:-$HOME/.cache}/polybar_battery_mode";
current="percent";
if [[ -f "$state_file" ]]; then
  current="$(cat "$state_file" 2>/dev/null | tr -d '\n')";
fi
if [[ "$current" == "percent" ]]; then
  echo "time" > "$state_file";
else
  echo "percent" > "$state_file";
fi
