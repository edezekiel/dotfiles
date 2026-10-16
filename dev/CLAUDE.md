# ~/dev

This directory is the public home for my development setup and configuration. Everything here is written to be published and reused by anyone setting up a similar machine.

## Layout

- `~/dev/<project>` is one of my personal repos. Each has its own `CLAUDE.md` or `AGENTS.md`; defer to it once inside.
- Dotfiles are a bare git repo at `~/dotfiles` with `$HOME` as the work tree. Use the `dot` alias in place of `git` for them.
- `~/.Brewfile` and `~/.config/mise/config.toml` list the tracked tools. `brew bundle --global` and `mise install` restore them on a new machine.
- `~/.zshrc.local` is sourced from `.zshrc` when present and holds per-machine overrides that stay out of dotfiles.

## Skills

Skills created here are general-purpose and machine-setup oriented: installing dotfiles on a new machine, auditing installed tools, keeping configuration in sync. They are written for any developer, not for one environment.

## Pushing to dotfiles

Pushing to the dotfiles repo requires my explicit approval in the current conversation. Commit locally, show me the staged diff, and wait for a go before `dot push`.

## Tools

- `y` opens yazi and changes directory on exit. Inside yazi, `T` opens a new Warp tab at the current directory.
- `eza` is aliased over `ls` and `tree`.
- `mise` manages runtimes per project via each repo's `mise.toml`; the global config only pins defaults.
