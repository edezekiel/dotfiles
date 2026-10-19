# SwiftBar widgets

SwiftBar runs the scripts in `~/.config/swiftbar/plugins`: the Slack badge refreshes
every 5 seconds, and the calendar widget refreshes every 30 seconds. Keep helper
files and documentation outside `plugins` so SwiftBar does not try to run them.

## Setup and compilation

The calendar helper requires macOS and the Swift compiler from Xcode or the Xcode
Command Line Tools. If `swiftc` is unavailable, install the tools with
`xcode-select --install`.

Run `mise bootstrap` after checking out the dotfiles. It installs SwiftBar,
configures its plugin directory, and runs the tracked
`calendar-events/build.sh` script. To compile just the helper:

```sh
~/.config/swiftbar/calendar-events/build.sh
```

The script compiles `main.swift`, embeds the Calendar permission description from
`Info.plist`, and writes `~/.local/bin/calendar-events`. It skips compilation when
the executable is newer than both inputs. The binary is generated locally and
should not be committed. The calendar plugin also runs this build check before
each refresh, so a source update rebuilds the helper automatically.

Open SwiftBar and allow Calendar access when prompted. If access is denied, check
System Settings → Privacy & Security → Calendars and enable SwiftBar.

## Behavior and troubleshooting

The helper reads today's timed events through EventKit, excluding all-day and
declined events. Each output line contains the start and end Unix timestamps,
separated by a space, preserving the dates of meetings that cross midnight.
Event titles are not displayed.

The widget shows the next start time, an orange countdown within five minutes,
or a red `now` while an event is running. An empty calendar icon means there are
no remaining timed events today. A red `!` means the build or calendar read failed,
or the helper returned unexpected data; open the widget menu for guidance.

For a build failure, run `build.sh` in Terminal to see the compiler output. To
inspect the helper output directly:

```sh
~/.local/bin/calendar-events
```

Authorize the app named in any Calendar permission prompt. Access for a Terminal
run does not replace the permission needed when SwiftBar runs the widget.

## Editing

Use the `dot` alias to inspect changes in the bare dotfiles repository:

```sh
cd ~
dot status
dot diff -- .config/swiftbar .config/mise/config.toml
```

After editing Swift source, run `build.sh` to verify compilation and check the
widget in SwiftBar before pushing. Build and widget refreshes do not commit or
push anything.
