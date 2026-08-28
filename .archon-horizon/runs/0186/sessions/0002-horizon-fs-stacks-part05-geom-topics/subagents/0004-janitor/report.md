Hygiene audit completed.

- Task queue: 95 total; 20 open (`12 running`, `4 queued`, `4 blocked`, `1 failed`). All 12 running tasks have live `horizon ps` processes. Queued/blocked objectives are unresolved or human-owned, so I did not cancel them.
- Roadmap: 203 total; active items reduced from 5 to 2 by marking three abandoned compile-frontier leaves blocked and ownerless. The remaining universal parent/child mismatch is intentional and documented in `I-2049`.
- Inbox: archived resolved `I-1987` and consumed handoff `I-2022`; added the current 630-path volatile-artifact census to `I-1913`. Current direct count is 51 open items, with 11 distinct durable memories left intentionally.
- Pollution: moved the unused 103 MiB Phase-0 snapshot, three stale Horizon temp files, empty `H`, and empty root `M`/`k` files to recoverable `/tmp` quarantine locations. No Lean or blueprint files were changed.
- Tracked `.lock`/`.tmp` cleanup was deferred as required by `I-1913`; it needs a serialized tooling pass.

Commits: `e595f070ca`, `e219692659`, `eb1b6c45cb`.
