#!/usr/bin/env bash
# Install the menu bar calendar widget: SwiftBar, the calendar plugin, and its EventKit helper.
# Safe to re-run. Touches only ~/.config/swiftbar, ~/.local/bin/calendar-events, the SwiftBar
# plugin folder, and /Applications/SwiftBar.app (when SwiftBar is not already installed).
set -euo pipefail

RAW="https://raw.githubusercontent.com/edezekiel/dotfiles/main/.config/swiftbar"
ROOT="$HOME/.config/swiftbar"
BUNDLE_ID="com.ameba.SwiftBar"

say() { printf '\n==> %s\n' "$1"; }
die() { printf '\nError: %s\n' "$1" >&2; exit 1; }

[[ "$(uname)" == "Darwin" ]] || die "This widget only runs on macOS."
major=$(sw_vers -productVersion | cut -d. -f1)
(( major >= 14 )) || die "macOS 14 (Sonoma) or newer is required; this Mac runs $(sw_vers -productVersion)."

# The helper is compiled locally, which needs Apple's Command Line Tools.
if ! xcode-select -p >/dev/null 2>&1 || ! xcrun -f swiftc >/dev/null 2>&1; then
  xcode-select --install >/dev/null 2>&1 || true
  die "Apple's Command Line Tools are needed. Click Install in the dialog that just opened, wait for it to finish (5-10 minutes), then run this script again."
fi

say "Downloading the widget"
mkdir -p "$ROOT/calendar-events" "$ROOT/plugins"
for f in calendar-events/build.sh calendar-events/main.swift calendar-events/Info.plist plugins/calendar.30s.sh; do
  curl -fsSL "$RAW/$f" -o "$ROOT/$f" || die "Could not download $f."
done
chmod +x "$ROOT/calendar-events/build.sh" "$ROOT/plugins/calendar.30s.sh"

say "Building the calendar helper"
"$ROOT/calendar-events/build.sh" || die "The calendar helper failed to compile (output above)."

if [[ ! -d "/Applications/SwiftBar.app" && ! -d "$HOME/Applications/SwiftBar.app" ]]; then
  say "Installing SwiftBar"
  if command -v brew >/dev/null 2>&1; then
    brew install --cask swiftbar
  else
    zip_url=$(curl -fsSL https://api.github.com/repos/swiftbar/SwiftBar/releases/latest \
      | grep -o 'https://[^"]*\.zip' | head -1)
    [[ -n "$zip_url" ]] || die "Could not find the SwiftBar download. Install it from https://swiftbar.app and run this script again."
    tmp=$(mktemp -d)
    trap 'rm -rf "${tmp:?}"' EXIT
    curl -fsSL "$zip_url" -o "$tmp/SwiftBar.zip"
    ditto -xk "$tmp/SwiftBar.zip" "$tmp/unzipped"
    app=$(find "$tmp/unzipped" -maxdepth 2 -name SwiftBar.app | head -1)
    [[ -n "$app" ]] || die "The SwiftBar download did not contain the app."
    ditto "$app" /Applications/SwiftBar.app
  fi
fi

# Keep an existing SwiftBar plugin folder; otherwise use ours.
plugin_dir=$(defaults read "$BUNDLE_ID" PluginDirectory 2>/dev/null || true)
plugin_dir="${plugin_dir/#\~/$HOME}"
if [[ -z "$plugin_dir" || ! -d "$plugin_dir" ]]; then
  plugin_dir="$ROOT/plugins"
  defaults write "$BUNDLE_ID" PluginDirectory -string "$plugin_dir"
elif [[ "$plugin_dir" != "$ROOT/plugins" ]]; then
  ln -sf "$ROOT/plugins/calendar.30s.sh" "$plugin_dir/calendar.30s.sh"
fi

say "Starting SwiftBar"
if pgrep -xq SwiftBar; then
  open -g "swiftbar://refreshallplugins"
else
  open -a SwiftBar
fi

cat <<'EOF'

Done. Two things to check:

  1. Click "Allow Full Access" when macOS asks about Calendar access. If the widget
     shows a red "!", enable SwiftBar under System Settings > Privacy & Security >
     Calendars.
  2. The widget reads the Mac's Calendar app. If your work calendar isn't there yet,
     add it under System Settings > Internet Accounts (turn on Calendars).

To have it start at login: click the widget > SwiftBar > Launch at Login, or add
SwiftBar under System Settings > General > Login Items.
EOF
