@RTK.md
@CLAUDE.local.md

# GitHub repo visibility — hard rule

NEVER create a public GitHub repository, and never change an existing repository's visibility to public, unless I explicitly authorize it in the current conversation. This applies to every org I am a member of and to every tool path: `gh repo create`, `gh repo edit`, `gh api`, curl to the GitHub API, and any GitHub MCP connector tool.

When creating any repository, always pass an explicit `--private` flag (or the tool's equivalent) — never rely on the org's default visibility, which may be public.

# Code comments — all projects

Keep net-new comments minimal: one line, only where the code cannot say it
itself. Write them in plain human prose, never terse or caveman style, even
when a session is running in caveman mode. Put reasoning in the commit
message or PR body, not in the source file.

# ~/dev and dotfiles are public — hard rule

`~/dev` and the dotfiles repo (`~/dotfiles`, bare repo, `dot` alias) are public-facing. Nothing confidential to my employer may appear in either: no employer references, no work repo names or paths, no cluster, hostname, or service names, no internal tooling, and no keys, tokens, or credentials. Skills created under `~/dev` must be generic; anything that only makes sense at work stays in the work tree named in `CLAUDE.local.md`.

Before any `dot add` or `dot commit`, grep the staged diff for the work terms listed in `CLAUDE.local.md` and refuse to commit if anything matches. Never `dot push` without my explicit approval in the current conversation.

`CLAUDE.local.md` names the employer and is never tracked in dotfiles. This file must stay generic so it can be.
