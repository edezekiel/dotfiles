#!/usr/bin/env bash
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# Next event from Calendar.app via icalBuddy. Titles never shown.
#   nothing left today     -> calendar symbol only
#   next event later       -> calendar symbol, "2:30"
#   starts within SOON_MIN -> calendar+clock symbol, orange "4m"
#   already running        -> calendar+exclamation symbol, red "now"
# Idle states carry no color so they inherit the menu bar text color.
# Symbol shape changes with state so color is not the only signal.

SOON_MIN=5
ORANGE='#FF9F0A' ; RED='#FF453A'

now=$(date +%s)
label="" ; color="" ; symbol="calendar"

while IFS=';' read -r range; do
  [[ "$range" =~ ^([0-9]{2}:[0-9]{2})\ -\ ([0-9]{2}:[0-9]{2})$ ]] || continue
  start=$(date -j -f "%H:%M" "${BASH_REMATCH[1]}" +%s)
  end=$(date -j -f "%H:%M" "${BASH_REMATCH[2]}" +%s)
  (( now >= end )) && continue
  if (( now >= start )); then
    label="now"; color=$RED; symbol="calendar.badge.exclamationmark"
  else
    mins=$(( (start - now + 59) / 60 ))
    if (( mins <= SOON_MIN )); then
      label="${mins}m"; color=$ORANGE; symbol="calendar.badge.clock"
    else
      label=$(date -r "$start" "+%-I:%M")
    fi
  fi
  break
done < <(icalBuddy -nc -b "" -npn -nrd -iep datetime -df "" -tf "%H:%M" -ea eventsToday 2>/dev/null)

echo "${label} | sfimage=$symbol size=13${color:+ color=$color sfcolor=$color}"
echo "---"
echo "Open Calendar | bash=/usr/bin/open param1=-a param2=Calendar terminal=false"
