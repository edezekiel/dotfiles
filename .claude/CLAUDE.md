@RTK.md
@CLAUDE.local.md

# ~/dev and dotfiles are public — hard rule

`~/dev` and the dotfiles repo (`~/dotfiles`, bare repo, `dot` alias) are public-facing. Nothing private may appear in either: no organization or client names, no private repo names or paths, no hostnames or service names, no internal tooling, and no keys, tokens, or credentials. Skills created under `~/dev` must be generic.

Before any `dot add` or `dot commit`, grep the staged diff for the terms listed in `CLAUDE.local.md` and refuse to commit if anything matches. Never `dot push` without my explicit approval in the current conversation.

`CLAUDE.local.md` is never tracked in dotfiles. This file must stay generic so it can be.
