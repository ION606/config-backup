#!/usr/bin/env bash
# check status of a specific bluetooth device via bluetoothctl


# check if bluetooth service is active
if ! systemctl is-active --quiet bluetooth.service; then
  echo "Bluetooth off"  # icon or text when BT is down
  exit 0
fi

# check if controller is powered on
if ! bluetoothctl show | grep -q "Powered: yes"; then
  echo "BT ctrl off"
  exit 0
fi

# check connected status
mapfile -t macs < <(bluetoothctl devices | awk '{print $2}')

connected_name=""

for mac in "${macs[@]}"; do
  # get info for this device
  info=$(bluetoothctl info "$mac")
  if echo "$info" | grep -q "Connected: yes"; then
    # extract Name:
    name=$(echo "$info" | grep "^\\s*Name:" | sed 's/.*Name: //')
    connected_name="$name"
    break
  fi
done

if [[ -n "$connected_name" ]]; then
  # you can replace the icon with a nerd-font icon if you use one
  echo " $connected_name"
else
  echo " Disconnected"
fi

