Committed at `dfc6a8b09`. Everything is now durable in the ledger.

## Summary

Ported AJCR's fibrewise large-twist H¹ vanishing into AJC and composed it with the landed χ-ledger, which **discharges the conditional layer my own r3 had left**: `Ledger/DegreeVanishing.lean` was sorry-free and axiom-clean while every theorem in it rested on a base vanishing AJC witnessed at *no proper curve* (its sole producer carries `[IsAffine X]`). AJC now has exact Riemann–Roch on its own curve under three curve binders and no vanishing hypothesis.

The audit was the deliverable the task said it would be, and it inverted the price. AJCR's `FLVVanishing` has a 59-module closure with 21 modules absent from AJC, fourteen of them `Picard.*`. Counted by **declaration reference** rather than import line, the vanishing chain uses `picClass`/`CechPic`/`classDeg`/`divisorClass` **zero** times: the Picard cone hangs off AJCR's class-side `fiberDivisor`/`fiberTwist`, which the argument never mentions. Substituting a small `coeffAt` calculus for that one import, the chain elaborates unchanged — the claim is measured, not argued.

## Progress
- `Ledger/FiberChart.lean`: new, 171 lines, 0 sorries — chart preimages, pulled-back coordinate, overlap = `basicOpen t₀`. Cover half of AJCR `FiberTwist`; class half deliberately dropped.
- `Ledger/FiberDivisor.lean`: new, 453 lines — the fiber unit in `K(Y)ˣ`, its order table, the effective `F = (div u)⁺`. Carries the `coeffAt` calculus AJC lacked (extracted from a Picard file, not imported).
- `Ledger/FiberLattice.lean`: new, 329 lines — the geometric heart: the Čech H¹ denominators form an increasing ladder in a *fixed* ambient and **exhaust** it by pole clearing at the fiber over `[1:0]`.
- `Ledger/QcohSections.lean` + `AffineVanishingQcoh.lean`: new, 629 lines — affine Serre vanishing for a quasi-coherence *packaging*, not just the structure sheaf. Byte-identical ports.
- `Ledger/DivisorSheafQcoh.lean`: new, 455 lines — divisor sheaves are `QcohOn`. This file *is* the empirical confirmation of the audit.
- `Ledger/FiberVanishing.lean`: new, 341 lines — `H¹(𝒪(D + n·F)) = 0` for large `n`. AJCR's mathematics, bodies unchanged.
- `Ledger/FiberBound.lean`: new, 289 lines — all four cluster-P statements unconditional; two ★ curve-level forms; extension-uniformity split with its free half proved.
- `scripts/ajcrr-fibervanishing-axioms.lean`: new — 42/42 clean, control firing, scratch-path caveat stated.
- `Ledger/DegreeVanishing.lean`, `scripts/axiom-frontier.lean`: docstring-only, code byte-identical, rebuilt — retracting my own port-cost overestimate where it lives.

## Issues

**Four review findings against me, all accepted and fixed.** One was serious: the two curve-level headlines were genuinely **uncommitted** when the reviewer measured, so the committed probe referencing them would not have elaborated from a clean checkout — my 41/41 was a working-tree property at that moment. Closed at `8157e43e5`, re-verified byte-identical. Also a **phantom declaration name** in a landed docstring (second time I've committed that failure mode), and two figures I published as *measurements* that were wrong: the Picard cone is **fourteen** modules not twelve, the absent set **21** not 23. I re-measured both; the reviewer's counts reproduce and mine did not. The lesson is recorded — I quoted a script's output while the script had a known path-rewrite caveat.

**Scratch-path caveat.** All eight modules are **outside the root import cone** (257/274 reachable), so no axiom line *through the root* reaches them. Rooting is one import line, outside this task's write scope (I-0600). Disclosed in the probe header and the README.

**Subagent reports stalled at 191 bytes** — the pathology of I-0677, all three. The ground review reached me via inbox instead; the janitor never reported, so I did its checks myself.

Concurrency was clean: the CAS guard caught one stale-index race and one clobber attempt and refused both rather than reverting another lane. 12 commits, zero deletions, zero foreign paths, `WeilDivisor.lean` untouched.

## Why I stopped

The core objective is **complete and verified**; one named gap is deliberately left. Cluster-P items 1–3 (bounded vanishing, exact Riemann–Roch/section drop, global generation) are present at AJC's own curve under hypotheses the project synthesises. **Extension-uniformity remains open and I claim nothing about it** — but I split it rather than disclaiming it: the free half (all three binders stable under base change, so the theorem re-fires per field) is now a theorem; the open half is that the constant does not transport, `n₀` being a `Classical.choose` on a stabilization re-run per base field — the same obstruction AJCR names as its `Nat.find`.

## Next
1. **Root the eight modules** — one import line in `AlgebraicJacobian.lean`; until then every clean axiom line here is scratch-path.
2. **Extension-uniformity**, now precisely scoped: flat base change for section spaces, and a `WeilDivisor` pullback along `C_κ ⟶ C`. With those, `b(k)` itself serves as the uniform bound.
3. Consumers wanting unconditional Riemann–Roch should call `FiberBound.exists_bound_h0_eq_genus_curve`, not the conditional forms in `DegreeVanishing`.
