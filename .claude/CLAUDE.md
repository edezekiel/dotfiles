@RTK.md
@CLAUDE.local.md

# ~/dev and dotfiles are public

`~/dev` and the dotfiles repo (`~/dotfiles`, bare repo, `dot` alias) are public-facing. Skills created under `~/dev` must be generic.

Before any `dot add` or `dot commit`, grep the staged diff for the terms listed in `CLAUDE.local.md` and refuse to commit if anything matches. Never `dot push` without my explicit approval in the current conversation.

`CLAUDE.local.md` is never tracked in dotfiles. This file must stay generic so it can be.

# Shell

Your shell is interactive zsh and loads `~/.zshrc`, so `ls` is `eza` and `cat` is `bat`; `ls -t` fails. Never build a path for `rm -rf` from a variable or command substitution: delete the literal path you created, or guard it with `${var:?}`. An empty variable once turned `rm -rf dir/$d` into `rm -rf dir/`.
