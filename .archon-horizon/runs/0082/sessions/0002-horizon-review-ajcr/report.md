Verified: nothing durable is uncommitted.

The Stop hook fired on my last file mutations, which were the memory files at `/home/axel/.claude-api/projects/.../memory/` — that path is **outside** the ledger work tree (`/home/axel/LeanAlgebraicGeometry-Horizon`), so it is not ledger-tracked and cannot be committed with `$HORIZON_GIT`. It is the persistent agent memory store, which is its own durable mechanism.

Everything I authored *inside* the ledger is committed and byte-verified against HEAD:

- all six roadmap rows (`AJCR.w4-rep`, `build-reach`, `dat-glue`, `chart-u`, `ddr.certificate`, `twist-atlas`) — disk blob hash equals HEAD blob hash
- all five probe files plus their README — same check, all MATCH

The remaining `/tmp/ajcr_*` files belong to the other AJCR lanes still running; I removed only my own six index files. The earlier `MM`/`D` markers that sent me chasing phantom deletions were stale entries in the shared git index, not real divergence — `rev-parse HEAD:<path>` against `hash-object` is the check that settled it, and it's now recorded in the memory note alongside the YAML-wrap grep caveat.

Six commits this session, all present at HEAD. The session is hand-off clean.
