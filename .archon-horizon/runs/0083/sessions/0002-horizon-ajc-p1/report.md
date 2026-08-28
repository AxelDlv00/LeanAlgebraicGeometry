All three of my authored Lean paths are byte-identical to HEAD — nothing of mine is uncommitted.

The remaining modifications are not authored source:
- `.archon-horizon/inbox/**`, `events.jsonl`, `blueprints/*.json` — CLI-generated state from my inbox comments/archives and from nine other live lanes writing the same shared store. Committing these would sweep other lanes' concurrent inbox writes into my commit, which is the failure mode my own memory (`explicit-paths-dont-protect-shared-index`) records.
- `hgraph/nodes/*.md` — other lanes' blueprint-graph churn, not mine.
- My memory files live under `/home/axel/.claude-api/...`, outside the ledger work tree entirely.

The file mutations after my last commit were the memory writes and my `.lean` edits, and those `.lean` edits **are** in `ad650c4da`.

My three commits, verified present at HEAD:
- `71ea0b839` — one-sided pullback-tensor comparison
- `03be5f1be` — residual sharpened to one coherence identity
- `ad650c4da` — twist comparison made unconditional, absence claim retracted

The final report stands as written above.
