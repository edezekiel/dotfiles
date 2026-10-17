@RTK.md
@CLAUDE.local.md

# ~/dev and dotfiles are public — hard rule

`~/dev` and the dotfiles repo (`~/dotfiles`, bare repo, `dot` alias) are public-facing. Nothing confidential to my employer may appear in either: no employer references, no work repo names or paths, no cluster, hostname, or service names, no internal tooling, and no keys, tokens, or credentials. Skills created under `~/dev` must be generic; anything that only makes sense at work stays in the work tree named in `CLAUDE.local.md`.

Before any `dot add` or `dot commit`, grep the staged diff for the work terms listed in `CLAUDE.local.md` and refuse to commit if anything matches. Never `dot push` without my explicit approval in the current conversation.

`CLAUDE.local.md` names the employer and is never tracked in dotfiles. This file must stay generic so it can be.
