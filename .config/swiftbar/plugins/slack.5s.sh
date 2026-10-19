#!/usr/bin/env bash
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# Mirror Slack's Dock badge in the menu bar.
#   ""  -> "0"      "•" -> "•"      "N" -> red count
# Idle states carry no color so they inherit the menu bar text color.

badge=$(lsappinfo info -only StatusLabel -app com.tinyspeck.slackmacgap 2>/dev/null \
  | sed -n 's/.*"label"="\([^"]*\)".*/\1/p')

FONT='font="Hack Nerd Font" size=13'
case "$badge" in
  "")  echo " 0 | $FONT" ;;
  "•") echo " • | $FONT" ;;
  *)   echo " $badge | $FONT color=#FF453A" ;;
esac
echo "---"
echo "Open Slack | bash=/usr/bin/open param1=-a param2=Slack terminal=false"
