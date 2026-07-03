# Axiom lean-client

The Lean 4 project template for authoring content you submit to Axiom.

Questions? Join the Axiom Discord.

## Quick start

```bash
axm init my-axiom-workspace   # clone this template, set up your AI agent, pre-warm Lake
cd my-axiom-workspace
axm auth                      # browser handoff; writes ~/.axiom/auth.json
# edit Axioms.lean and/or Workspace/*.lean
axm check                     # local validation (no network, no UUIDs)
axm publish                   # allocate UUIDs, transform, POST, record
```

The first time you run `axm publish` on a machine, the CLI prompts for explicit acknowledgement that publishing is
irrevocable; answer `always` to persist the acknowledgement, or pass `--yes` (`-y`) / set `AXIOM_AUTH_TOKEN` for
non-interactive use.

`axm status` shows what would publish; `axm fetch <uuid>` pulls server files into `.axiomdata/files/A/`;
`axm fork <uuid> <name>` scaffolds `Workspace/<name>.lean` from an existing file.

## AI agent skills

This template ships skills (onboarding, formalization help, conventions) authored once under `.axiom/skills/`.
`axm init` asks which AI coding agents you use and materializes the skills into each one's native format — Claude Code
(`.claude/skills/`), Cursor (`.cursor/rules/`), OpenAI Codex (`.agents/skills/`), GitHub Copilot
(`.github/instructions/`), or Gemini (`GEMINI.md`). Add an agent later with `axm agents add <agent>`, or see what's set
up with `axm agents list`. `AGENTS.md` is the always-loaded baseline every agent reads.

See [AGENTS.md](AGENTS.md) for the full file layout, validator rules, and writing conventions.
