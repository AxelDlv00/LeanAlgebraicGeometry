Nothing of mine is uncommitted. The checkpoint fired on my two memory-file writes, which are outside the ledger work tree.

The remaining dirty entries all belong to other live lanes: `AJC.pic0av.structure` and `AJC.picrep.etale-rep` rows (p3 and p1, who are mid-claim), `wrev_scratch/` deletions from a work-reviewer cleanup, and `.mcp.json`. Per I-0889/I-1034 — the lesson my own r0 session filed after shipping another lane's rollback — I will not stage those. My own `AJC.picrep.semicontinuity.jsonl` history line is a side effect of the row write whose item file is already committed at HEAD; committing it alone would drag the neighbouring rows' staged state with it.

One thing worth flagging from that check: the B5 row's `owner` is absent at HEAD, so the release survived — I verified with `git show HEAD:` rather than trusting the worktree, which is exactly the failure mode I-1034 describes.

## Progress

- `Picard/FiberRankSemicontinuity.lean`: **new**, 2 theorems, 0 sorries. `Ideal.isOpen_fiberRank_le` — fibre-rank sublevel locus open over **any** commutative ring; no flatness, no `IsLocallyNoetherian`, no quasi-coherence.
- `Picard/TwoTermKernelSemicontinuity.lean`: **new**, 5 declarations, 0 sorries. The B5 engine: `dim H⁰` of `k : K → Aⁿ` upper semicontinuous with `K` only finitely presented.
- `Picard/FiberH0CechKernel.lean`: **new**, 1 theorem, 0 sorries. `p.fiberH0 M t` is the base-changed Čech kernel's dimension, with no `hbc`/`hfin`/`hproj`/h¹-vanishing.
- `Picard/FiberH0Comparison.lean`, `Picard/SemicontinuityH0.lean`: docstring corrections only; no statement touched.
- Roadmap `AJC.picrep.semicontinuity`: claimed, updated, released — owner absent at HEAD, verified with `git show HEAD:`.

All eight declarations axiom-clean `[propext, Classical.choice, Quot.sound]`, no `sorryAx`; kernel EXIT=0 per file, `lake build` 8705 jobs EXIT=0.

## Issues

- A fresh-context adversarial audit refuted two of my own claims (fixed in `ba08a93a87`): `[Module.Projective A K]` was decorative, and `FiberH0CechKernel.lean` inherited an unadmitted junk-value hazard. Filed I-1030 (the `hbc` repricing) and I-1031 (the transferable lesson).
- Other lanes' roadmap rows and a work-reviewer scratch cleanup are dirty in the shared worktree. Deliberately not staged.

## Why I stopped

Partly advanced, not complete. `HasH0Semicontinuity` has no instance and two obligations stand: replacing the Čech map by a complex of the engine's shape, and the `ΓSpecIso` carrier transport. Everything durable of mine is committed; the checkpoint's trigger was two memory writes outside the ledger.

## Next

Obligation (1) is now sharper than "cohomology and base change": since the engine dropped `projective_K0`, a consumer must supply only that the replacement's `H⁰` matches the original's. Obligation (2) is the same transport steps 2 and 6 of `fiberRank_gammaTop_eq_fiberH0` already perform by hand — probably the cheaper of the two.
