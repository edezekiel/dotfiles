#!/usr/bin/env bash
# Compile main.swift into ~/.local/bin/calendar-events. Skips when the binary is already newer.
set -euo pipefail
src="$(cd "$(dirname "$0")" && pwd)"
out="$HOME/.local/bin/calendar-events"
if [[ -x "$out" && "$out" -nt "$src/main.swift" && "$out" -nt "$src/Info.plist" ]]; then exit 0; fi
mkdir -p "$(dirname "$out")"
swiftc -O "$src/main.swift" -o "$out" \
  -Xlinker -sectcreate -Xlinker __TEXT -Xlinker __info_plist -Xlinker "$src/Info.plist"
echo "built $out"
