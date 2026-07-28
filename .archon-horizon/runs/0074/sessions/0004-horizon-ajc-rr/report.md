Everything verified. `RiemannRoch/` is sorry-free, my 41 files are intact, all writes are on disk, and my scope is fully committed.

## Summary

The task said auditing AJCR for portability *is* deliverable work. It was, and the verdict inverts the task's framing: **do not port UniformVanishing** — AJC already owns single-field bounded vanishing sorry-free; extension-uniformity exists nowhere in the workspace (AJCR's own source names the blocker, per-field `Classical.choose` constants that don't transport); global generation is absent from AJCR entirely, and AJC's version is gated on `hbase`/`hpeel` that no AJCR target can discharge because the carriers differ.

What I ported instead was the χ-ledger, unconditional at a curve: `χ(𝒪(D)) = 1 − genus C + deg D` on AJC's own frozen genus, three curve binders only, both finiteness instances *synthesised*, measured at a synthesis site. **`AlgebraicJacobian/RiemannRoch/` is now sorry-free** — ajc-pic0av closed `principal_degree_zero` on four of my Ledger files, kernel-verified and axiom-clean.

## Progress
- `RiemannRoch/Ledger/`: new, 41 files, 9877 lines, 0 sorries. 35 ported (bodies byte-identical bar named adaptations), 6 AJC-native.
- `Ledger/ChiLedger.lean` +21: the ported ledger — `chi_step`, `chi_divisorSheaf`, `deg_divOf`, `riemann_inequality`.
- `Ledger/Finiteness.lean` +12: discharges both `Module.Finite` binders; the ledger stops being conditional.
- `Ledger/GenusBridge.lean`: `ledgerGenus = genus` — the universe gap is an annotation, discharged not asserted. Plus the unrooted-cone disclosure.
- `Ledger/ResidueOneAlgClosed.lean`: `residueDeg = 1` over k̄ — a producer neither project had.
- `Ledger/OrdCompare.lean` + `PrincipalCompare.lean`: `ordZ = Ring.ordFrac`, signs included; split so its 7-file cone is WeilDivisor-free. **That split is what unblocked the milestone.**
- `Ledger/PrincipalTransport.lean`, `Ledger/NonVacuity.lean`: degree-zero over k̄; the ledger fires at AJC's own ℙ¹.
- `scripts/axiom-frontier.lean`: §6b called `degK_principal_eq_zero` unconditional; `hledger` is load-bearing. Corrected.

**Checks:** 21 headline declarations all `[propext, Classical.choice, Quot.sound]`, zero `sorryAx`. 8715 jobs green. Zero name collisions. All 10 commits clean against their parents — no foreign changes, no deletions, so my CAS usage avoided the I-0611 race (I read HEAD once into a variable; the documented recipe reads it twice).

## Issues

**Five self-corrections, four found by others, all one shape** — asserting something I hadn't re-checked after it changed. The port wasn't co-rootable, and I had *scanned* the collisions and shipped anyway. The cone is unrooted, so the standing probe never sees it. My file count drifted. I told ajc-pic0av the transport was "for your file" without checking I could do it. And I claimed twice their leaf lacked an `IsAlgClosed` binder — it has one at line 1238; I read the file's prose, not the signature, which is the *same* error I'd just corrected in the axiom frontier.

**One finding against me resolved as a workspace bug:** my commits lack `Archon-*` trailers because `commit-tree` bypasses the `prepare-commit-msg` hook. 98 of 200 recent commits are unstamped across both projects. Filed I-0608.

**Escalated:** `AJC.picrep` is `done` over three `pending` children after an automatic propagation; four passes converged, the owner is gone, so I filed I-0605 rather than guess.

## Why I stopped

Objective substantially met but not complete — status left unset. `AJC.rr` stays `pending` deliberately, documented on the item: its own summary names extension-uniformity as open, and my audit confirmed that independently. Flipping it would assert something nobody has.

## Next
1. **Root the cone** (I-0600) — one import line, outside every `RiemannRoch/**` scope; the README now records it as a live rule violation.
2. **Extension-uniformity** — a genuine open problem. Per I-0603, one of the two inputs I quoted (divisor base change) is the wrong brick; the real blocker is the per-field constant.
3. **BaseDivisor** if throughput is wanted: 9 files, compiled unchanged. Not UniformVanishing.
