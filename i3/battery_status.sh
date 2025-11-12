#!/usr/bin/env bash
# prints a battery icon + either percentage or time remaining
# depends (optional): upower or acpi; otherwise falls back to /sys

# config: icons from nerd fonts / font awesome
icon_empty="";   # very low
icon_low="";     # low
icon_mid="";     # medium
icon_high="";    # high
icon_full="";    # full
icon_charge="";  # charging bolt
icon_plug="";    # plugged/full
icon_alert="";   # critical

# config: low/critical thresholds
low_threshold=20;
crit_threshold=10;

state_file="${XDG_CACHE_HOME:-$HOME/.cache}/polybar_battery_mode";
mode="percent";
if [[ -f "$state_file" ]]; then
  mode="$(cat "$state_file" 2>/dev/null | tr -d '\n' )";
fi

bat_path="$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n1)";
if [[ -z "$bat_path" ]]; then
  echo "${icon_alert} no battery";
  exit 0;
fi

# helpers
pick_icon() {
  local pct="$1";
  local status="$2";
  local base;
  if   (( pct == 100 )); then base="^~^"
  elif (( pct >= 95 )); then base="$icon_full";
  elif (( pct >= 75 )); then base="$icon_high";
  elif (( pct >= 50 )); then base="$icon_mid";
  elif (( pct >= 25 )); then base="$icon_low";
  else                     base="$icon_empty";
  fi
  
  # overlay/override for charging or full on ac power
  if [[ "$status" == "Charging" ]]; then
    echo "$icon_charge $base";
  elif [[ "$status" == "Full" || "$status" == "Not charging" ]]; then
    echo "$icon_plug $base";
  else
    echo "$base";
  fi
}

fmt_time() {
  # normalize various formats (e.g., "1.5 hours", "02:41:13")
  local raw="$1";
  if [[ "$raw" =~ ^[0-9]+:[0-9]{2}:[0-9]{2}$ ]]; then
    # hh:mm:ss -> XhYm
    IFS=':' read -r h m s <<<"$raw";
    printf "%sh%sm" "$h" "$m";
  elif [[ "$raw" =~ ^([0-9]+(\.[0-9]+)?)\ hours?$ ]]; then
    # upower: "1.4 hours"
    local hours="${raw% hours}";
    hours="${hours% hour}";
    # convert decimal hours to h m
    local total_min;
    total_min="$(python - <<'PY'
import math,sys
h=float(sys.stdin.read().strip())
m=round((h-int(h))*60)
print(f"{int(h)}h{m}m")
PY
<<<"$hours")";
    printf "%s" "$total_min";
  else
    printf "%s" "$raw";
  fi
}

percentage="";
status="";
eta="";   # time to empty or to full

# try upower first (dbus-based, used by many desktops)
if command -v upower >/dev/null 2>&1; then
  dev="$(upower -e | grep -m1 BAT)";

  if [[ -n "$dev" ]]; then
    info="$(upower -i "$dev" 2>/dev/null)";
    status="$(awk -F': *' '/^\s*state:/{print $2}' <<<"$info")";
    percentage="$(awk -F': *' '/^\s*percentage:/{print $2}' <<<"$info" | tr -d '% ')";

    if [[ "$status" == "charging" ]]; then
      eta="$(awk -F': *' '/time to full/{print $2}' <<<"$info")";
    elif [[ "$status" == "discharging" ]]; then
      eta="$(awk -F': *' '/time to empty/{print $2}' <<<"$info")";
    fi

    # normalize capitalization
    status="$(tr '[:lower:]' '[:upper:]' <<<"${status:0:1}")${status:1}";
  fi
fi

# fallback: acpi (reads /sys or /proc and calculates eta)
if [[ -z "$percentage" || -z "$status" ]] && command -v acpi >/dev/null 2>&1; then
  line="$(acpi -b 2>/dev/null | head -n1)";
  # examples: "Battery 0: Discharging, 93%, 02:41:13 remaining"
  #           "Battery 0: Charging, 80%, 00:20:00 until charged"
  status="$(awk -F', *' -v OFS=',' '{split($1,a,": "); print a[2]}' <<<"$line")";
  percentage="$(awk -F', *' '{gsub("%","",$2); print $2}' <<<"$line")";
  eta="$(awk -F', *' '{print $3}' <<<"$line" | sed -E 's/(remaining|until charged)//g' | xargs)";
fi

# final fallback: sysfs (percentage + status only)
if [[ -z "$percentage" || -z "$status" ]]; then
  if [[ -r "$bat_path/capacity" && -r "$bat_path/status" ]]; then
    percentage="$(cat "$bat_path/capacity" 2>/dev/null)";
    status="$(cat "$bat_path/status" 2>/dev/null)";
  fi
fi

# guard rails
if [[ -z "$percentage" ]]; then
  echo "${icon_alert} n/a";
  exit 0;
fi

icon="$(pick_icon "$percentage" "$status")";

# add critical marker if really low and discharging
if (( percentage <= crit_threshold )) && [[ "$status" == "Discharging" ]]; then
  icon="${icon_alert} ${icon}";
fi

# output based on mode
if [[ "$mode" == "time" && -n "$eta" ]]; then
  echo "${icon} $(fmt_time "$eta")";
else
  echo "${icon} ${percentage}%";
fi
