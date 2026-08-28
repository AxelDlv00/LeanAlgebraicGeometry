Hygiene audit complete; source remained read-only.

- Task queue remains `20` open vs recommended `12`: `12 running`, `4 blocked`, `4 queued`.
- Eight Stacks tasks are stale `running`: `fs-stacks-part01-prelim` through `part08`. Their latest sessions were reaped at `2026-08-28 01:10 UTC`, with no live process. Reconcile them to `queued` only after current runs quiesce.
- Only four runs are live: AJCR, Mumford, Milne, and Hartshorne.
- Roadmap is consistent: `203` rows, no warnings (`131 done`, `52 pending`, `14 blocked`, `2 active`, `4 rejected`).
- Inbox visible to Milne is manageable: `3 protections`, `8 issues`, `9 memories`, no conversations. Raw-store warnings remain `11 memories`, `16 conversations`, `52 non-protection`; hidden/private items were not altered.
- Milne’s path is clean at ledger HEAD `f154c3df9a`. The global worktree is heavily dirty from concurrent activity, primarily `MainProjects`; avoid broad staging.
- Ledger HEAD still tracks `630` volatile `.lock`/`.tmp` files. Existing tooling issues `I-2039`/`I-1913` cover this; I appended the fresh measurements to `I-2039`.
- Milne hgraph is synchronized with `stale=0`; the remaining warning is `24` unattached Lean helper declarations, up from the prior recorded `19`.
- README/layout are concise and current; no documentation cleanup was needed.

Counts before/after were unchanged because concurrent-run state made task and raw-inbox cleanup unsafe.
