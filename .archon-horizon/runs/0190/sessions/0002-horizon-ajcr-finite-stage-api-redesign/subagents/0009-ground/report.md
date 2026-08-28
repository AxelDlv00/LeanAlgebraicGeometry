Read-only review complete. The redesign is directionally improving the stable package, but it has not reached a closeable state:

- The canonical face boundary remains the key API/soundness blocker: `fac_of_context` takes an arbitrary certificate while rebuilding the canonical comparison family and ignoring `D.Q`.
- Current ledger state is not the previously reported `80c9378fc8`: HEAD is `116b1d1`, with AJCR changes still uncommitted and stable orbit/assembly files untracked.
- `StableOrbitAffine.olean` is fresh, but `StableAffineCover.olean` is stale from Aug 20; no current serialized cover check is recorded.
- Hgraph lacks stable-orbit nodes and retains old stable-cover signatures. Roadmap comment C-0003 overstates verification.
- P7 remains mathematically blocked, appropriately; do not close the task.

Highest-value next action: settle the canonical context-to-face API (rename/restrict the current theorem and add an `ofCanonical` wrapper if needed), then produce a fresh kernel artifact for `StableAffineCover` and synchronize hgraph/evidence.
