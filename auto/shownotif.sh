#!/bin/bash

PER=$(( $(cat /sys/class/power_supply/BAT1/charge_now) * 100 / $(cat /sys/class/power_supply/BAT1/charge_full) ))


IS_CHARGING=true
[ "$(cat /sys/class/power_supply/BAT1/status)" == "Charging" ] && IS_CHARGING=true || IS_CHARGING=false


case $1 in
    info)
        dunstify "INFO" "$2!" -u critical -i $PWD/icons/info.svg
        ;;

    lowbat)
        if [ $IS_CHARGING == true ]; then
            action=$(dunstify -A default,exit "LOW BATTERY!" "battery at $PER%!" -u critical -i $PWD/icons/low-battery.svg)

            if [ "$(echo "$action" | xargs)" = "default" ]; then
                brightnessctl set $(($(brightnessctl m) / 2))
                kill -9 $(ps aux | grep vesktop | grep -v grep | awk '{print $2}')
                kill -9 $(ps aux | grep discord | grep -v grep | awk '{print $2}')
            fi
        fi
        ;;

    success)
        dunstify "SUCCESS!" "Action completed successfully!" -u low -i $PWD/icons/check.svg
        ;;

    temperature)
        dunstify "ERROR!" "YOUR PC IS OVERHEATING!!!\nDO SOMETHING!!!" -u critical -i $PWD/icons/no.svg
        kill -9 $(ps aux | grep vesktop | grep -v grep | awk '{print $2}')
        kill -9 $(ps aux | grep discord | grep -v grep | awk '{print $2}')
        ;;

    err)
        dunstify "ERROR!" "see $2 for more details" -u critical -i $PWD/icons/no.svg
        ;;

    charging)
        dunstify "CHARGING!" "battery at $PER%!" -u critical -i $PWD/icons/charging-station.svg
        ;;

    unplugged)
        dunstify "STOPPED CHARGING!" "battery at $PER%!" -u critical -i $PWD/icons/unplugged.svg
        ;;

esac
