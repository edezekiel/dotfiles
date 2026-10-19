#!/usr/bin/env bash
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# Next event from Calendar.app via the calendar-events helper (EventKit). Titles never shown.
#   nothing left today     -> calendar symbol only
#   next event later       -> calendar symbol, "2:30"
#   starts within SOON_MIN -> calendar+clock symbol, orange "4m"
#   already running        -> calendar+exclamation symbol, red "now"
#   helper unavailable     -> calendar+exclamation symbol, red "!", details in menu
# Idle states carry no color so they inherit the menu bar text color.
# Symbol shape changes with state so color is not the only signal.

SOON_MIN=5
EVENTS="$HOME/.local/bin/calendar-events"
ORANGE='#FF9F0A' ; RED='#FF453A'

show_error() {
  echo "! | sfimage=calendar.badge.exclamationmark size=13 color=$RED sfcolor=$RED"
  echo "---"
  echo "$1 | disabled=true"
  echo "Open Calendar | bash=/usr/bin/open param1=-a param2=Calendar terminal=false"
}

# The build script skips an up-to-date binary. Check every refresh so source updates
# cannot leave an older helper emitting a different format.
if ! "$HOME/.config/swiftbar/calendar-events/build.sh" >/dev/null 2>&1; then
  show_error "Calendar helper could not be built. Run mise bootstrap in Terminal."
  exit 0
fi
if ! events=$("$EVENTS" 2>/dev/null); then
  show_error "Calendar unavailable. Check SwiftBar access in System Settings → Privacy & Security → Calendars."
  exit 0
fi

now=$(date +%s)
label="" ; color="" ; symbol="calendar"

while IFS= read -r range; do
  [[ -z "$range" ]] && continue
  if [[ ! "$range" =~ ^([0-9]+)\ ([0-9]+)$ ]]; then
    show_error "Calendar helper returned unexpected data. Run mise bootstrap in Terminal."
    exit 0
  fi
  start=${BASH_REMATCH[1]}
  end=${BASH_REMATCH[2]}
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
done <<< "$events"

echo "${label} | sfimage=$symbol size=13${color:+ color=$color sfcolor=$color}"
echo "---"
echo "Open Calendar | bash=/usr/bin/open param1=-a param2=Calendar terminal=false"
