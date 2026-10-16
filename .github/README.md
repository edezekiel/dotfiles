# Dotfiles

**Created by**: Edward Ezekiel <ed.a.ezekiel@gmail.com>
**Version**: 1.0, 10.15.2024
**Description**: Dotfiles configuration

## Backup technique

I used a _git bare repository_ to backup my dotfiles. See [DistroTube](https://www.youtube.com/watch?v=tBoLDpTWVOM&t=2s);
[Atlassian](https://www.atlassian.com/git/tutorials/dotfiles).

### Git bare repository setup

#### 1. Create a bare repository

Create a dotfiles directory:

```sh
cd $HOME && mkdir dotfiles
```

Initialize the bare git repository in the dotfiles directory:

```sh
git init --bare $HOME/dotfiles
```

#### 2. Link the bare repository with a worktree

```sh
echo "alias dot='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'" >> $HOME/.zshrc
```

- You can name the alias whatever you'd like, in this case I called it _dot_
- The command creates a permanent alias in your .zshrc

#### 3. Hide untracked files

```sh
dot config --local status.showUntrackedFiles no
```

#### 4. Reload your shell

Reload your shell (or close the terminal and open a new one):

```sh
source $HOME/.zshrc
```

#### 5. Push dotfiles to GitHub

Create a new repository in GitHub called 'dotfiles'.

```sh
dot remote add origin git@github.com:edezekiel/dotfiles.git
dot branch -M main
dot push -u origin main
```

Add local dotfiles and push to the repository (repeat for each dotfile you
would want to backup):

```sh
dot status
dot add .zshrc
dot commit -m "feat: Add my .zshrc"
dot push
```

#### 6. Create a README file (optional)

```sh
mkdir $HOME/.github
cd $HOME/.github
touch README.md
```

## Tools

Homebrew packages are listed in `~/.Brewfile`. Install them with:

```sh
brew bundle --global
```

Globally available CLI tools managed by [mise](https://mise.jdx.dev) are listed in
`~/.config/mise/config.toml`. Install them with:

```sh
mise install
```

Machine- or work-specific config is kept out of this repo: `~/.zshrc.local` is sourced
from `.zshrc` if present, and `~/.Brewfile.work` holds extra packages.
