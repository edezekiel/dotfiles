# Recipes

Multi-step tricks that aliases alone do not capture. `h` prints this after the alias list.

- `cat ` then Ctrl-T: pick a file, Enter to print it with syntax highlighting
- `f`: pick a file with a bat preview and open it in $EDITOR
- `rgf [pattern]`: live ripgrep across the current directory, Enter opens the hit at its line
- `y` then `s` / `S`: search below the current directory by file name (fd) / by content (ripgrep)
- Ctrl-R: fuzzy search shell history
- Alt-C: fuzzy cd into any directory below the current one
- `cd <name>`: zoxide jumps to the most-used directory matching name
