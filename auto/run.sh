#!/bin/bash

PER=$(( $(cat /sys/class/power_supply/BAT1/charge_now) * 100 / $(cat /sys/class/power_supply/BAT1/charge_full) ))
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )")


# Check if the PC is charging
IS_CHARGING=false
[ "$(cat /sys/class/power_supply/BAT1/status)" == "Charging" ] && IS_CHARGING=true

declare -A props

# Load properties from file
load_props() {
    local file="$SCRIPT_DIR/props.txt"
    if [[ -f "$file" ]]; then
        while IFS='=' read -r key value; do
            props["$key"]="$value"
        done < "$file"
    else
        props["lowchargenotifsent"]=false
        props["ischarge"]=$IS_CHARGING
        props["ischargingnotifshown"]=false
        props["isunpluggednotifshown"]=false  # Add the new property for unplugging notification
    fi
}

# Save properties to file
save_props() {
    local file="$SCRIPT_DIR/props.txt"
    > "$file"
    for key in "${!props[@]}"; do
        echo "$key=${props[$key]}" >> "$file"
    done
}

# Load the properties at the start
load_props

# Battery percentage-based logic
if [[ "$PER" -le 10 ]]; then
    # Always show notification if battery is 10% or less
    bash $SCRIPT_DIR/shownotif.sh lowbat
elif [[ "$PER" -le 20 && "${props["lowchargenotifsent"]}" == "false" ]]; then
    # Show notification if battery is 20% or less, but only if it hasn't been sent already
    bash $SCRIPT_DIR/shownotif.sh lowbat
    props["lowchargenotifsent"]=true
fi

# Check if props["ischarge"] does not match IS_CHARGING and update accordingly
if [[ "${props["ischarge"]}" != "$IS_CHARGING" ]]; then
    if [[ "$IS_CHARGING" == true ]]; then
        bash $SCRIPT_DIR/shownotif.sh charging-status-mismatch "Now Charging"
    else
        bash $SCRIPT_DIR/shownotif.sh charging-status-mismatch "Now Unplugged"
    fi
    props["ischarge"]=$IS_CHARGING
fi

# Check if the PC is charging and show a notification if needed
if [[ "$IS_CHARGING" == true && "${props["ischargingnotifshown"]}" == "false" ]]; then
    bash $SCRIPT_DIR/shownotif.sh charging
    props["ischargingnotifshown"]=true
    props["isunpluggednotifshown"]=false  # Reset unplugged notification flag when charging
elif [[ "$IS_CHARGING" == false && "${props["isunpluggednotifshown"]}" == "false" ]]; then
    # Show unplugged notification when the PC is no longer charging
    bash $SCRIPT_DIR/shownotif.sh unplugged
    props["isunpluggednotifshown"]=true
    props["ischargingnotifshown"]=false  # Reset charging notification flag when unplugged
fi

# Save updated properties
save_props


# temperature
TEMP=$(sensors | grep -i 'temp1' | head -n 1 | awk '{print $2}' | sed 's/+//g;s/°C//g')

# force to int
TEMP=${TEMP%.*}

if [ "$TEMP" -gt 75 ]; then
  bash $SCRIPT_DIR/shownotif.sh temperature
fi
