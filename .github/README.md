# Dotfiles

**Created by**: Edward Ezekiel <ed.a.ezekiel@gmail.com>

**Description**: Dotfiles configuration, kept in a bare git repository with `$HOME` as the work tree.

## New machine

Everything after the clone is declared in `~/.config/mise/config.toml` and applied by
[mise bootstrap](https://mise.jdx.dev/bootstrap.html).

```sh
# 1. Homebrew, then mise
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install mise

# 2. Clone the bare repo over HTTPS (no SSH key yet) and check out the tracked files into $HOME
git clone --bare https://github.com/edezekiel/dotfiles.git $HOME/dotfiles
alias dot='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
dot checkout   # if this complains about existing files, move them aside and run it again

# 3. Preview, then apply
mise bootstrap --dry-run
mise bootstrap

# 4. Open a new shell

# 5. After adding an SSH key to GitHub, switch the remote so you can push
dot remote set-url origin git@github.com:edezekiel/dotfiles.git
```

`mise bootstrap` installs the Homebrew formulae and casks, the mise-managed CLI tools, the
betterleaks pre-commit hook and exclude list for the bare repo, and the macOS defaults. It is
safe to run again at any time; `mise bootstrap status` shows what is in place.

## Local overrides

Machine-specific config lives next to the tracked files and is never committed. The
bare repo's `info/exclude` ignores these paths, and `mise bootstrap` creates them empty if missing:

| File | Used by |
|---|---|
| `~/.zshrc.local` | sourced at the end of `.zshrc` |
| `~/.gitconfig.local` | included from `.gitconfig` |
| `~/.ssh/config.local` | included from `.ssh/config` |
| `~/.claude/CLAUDE.local.md` | imported from `.claude/CLAUDE.md` |
| `~/.config/mise/conf.d/*.toml` | extra `[bootstrap.packages]` and tools for mise |

## Day to day

`dot` is `git` for this repo. The pre-commit hook runs betterleaks on the staged diff.

```sh
dot status
dot add .zshrc
dot commit -m "feat: ..."
dot push
```

## Why a bare repository

See [Atlassian's write-up](https://www.atlassian.com/git/tutorials/dotfiles). No symlinks, no
install script for the files themselves: the tracked files sit where their programs expect them.
