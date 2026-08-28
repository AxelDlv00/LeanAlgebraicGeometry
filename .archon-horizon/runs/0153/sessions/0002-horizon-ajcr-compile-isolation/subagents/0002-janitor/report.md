Read-only hygiene audit delivered to `/root`.

Findings:

- Horizon CLI warns on every command: workspace managed at 0.1.2, CLI is 0.1.3. This is already covered by issue `I-1985`.
- Inbox: 25 open items, including 1 protection, 12 issues, 10 memories, 1 info, and 1 hint; 12 advisory-unread items; no unread conversations; no CLI health warnings.
- Tasks: 79 total, with 2 running, 4 queued, 25 done, 2 blocked, 1 failed, and 45 cancelled. No orphan-task or queue warning.
- Roadmap: 184 nodes, with no status consistency warnings.
- Worktree: extensive shared/generated residue across `.archon-horizon`, hgraph nodes, run/session metadata, references/status outputs, and a `phase0-pre-*` scratch tree. No cleanup or reversion was performed.

No task, roadmap, or inbox update is required before terminal completion.
