All twelve commits reachable, all five Lean files byte-identical at HEAD. Everything is committed and verified.

## Summary

Advanced all four fronts of the A.3 leg. Sorry counts are unchanged (3/3/1) but three fronts changed **route** rather than shrinking, and one route was ruled out by machine — which is the substance, since two of the four were previously reported as blocked on things that turned out not to be the obstruction.

## Progress

- `Picard/NilpotentThickeningFree.lean`: NEW, 5 declarations, sorry-free and axiom-clean. An invertible module over a ring with a nilpotent ideal, cyclic modulo the ideal, is free. Two mechanisms worth reusing: for *invertible* modules a surjection from the ring is automatically bijective (so cyclic ⟹ free, false in general), and the Nakayama iteration needs **no** finiteness — mathlib's version requires `N.FG`, which is precisely the binder that excludes curve charts.
- `Picard/DualNumberChartTriviality.lean`: NEW, 5 declarations, sorry-free. The dual-number specialisation: `ker(A[ε] → A)` is square-zero hence nilpotent, so an invertible `A[ε]`-module trivial along `ε ↦ 0` is trivial. This **closes clause (i)** of the tangent lane's three-clause geometric middle; clause (ii) turned out already landed as `baseChangeAlgEquiv`, unnoticed by both projects for eleven days.
- `Picard/Pic0AbelianVariety.lean`: 3 sorries → 3, each smaller. `universallyClosed_of_ambient` moves properness off the identity component entirely (Pic⁰ ↪ Pic is a *closed* immersion) — so the residue now sits on `Pic_{C/k}`, where Kleiman's theorem actually speaks. `geometricallyReduced_of_forall_isReduced` unfolds the smoothness residue to honest pullbacks. `relPicDualKernel` makes clause (iii) *stateable* additively.
- `Picard/IdentityComponent.lean`: 3 sorries → 3, plus 5 sorry-free declarations. `classOfSection`/`degreeOfSection` give the degree map via representability at the trivial test object — no Quot, no Hilbert polynomial — over one named input the sibling has proved.
- `RiemannRoch/WeilDivisor.lean`: 1 sorry → 1, deliberately. Found a third route: the Rebuild's χ-ledger `deg_divOf` proves this statement, kernel-verified `[propext, Classical.choice, Quot.sound]`, in a 22-file/5491-line sorry-free closure. Landed the index-set half of the bridge.
- Blueprint + hgraph: 5 new nodes, `\lean` names verified to resolve before committing.

Two findings I'd flag above the proofs. `PicScheme.degree` is **unprovable as stated** — its domain is an arbitrary morphism, not a section, so it never names a `k`-rational point; that sorry is a statement bug, not a hard proof. And I corrected myself twice: once on a wrong prerequisite claim, once on knowingly re-deriving a lemma the sibling already had.

## Issues

- **The fresh-context review did not land.** `work-reviewer` ran ~50 minutes, then went idle for 11 without delivering a report; the `janitor` did the same earlier. So my claims rest on my own kernel builds and axiom probes, not independent audit — same gap as last round, and I'm not papering over it.
- **The ledger race hit two of my commits** (foreign files in the recorded diff). I verified no work was lost — the deleted theorem is present at HEAD and in the working tree — and adopted the pathspec commit form afterwards.
- Every reduction was measured at a synthesis site with a control, plus two vacuity checks (does the gate synthesize? does the supplied hypothesis?) both negative by machine.
- Standing limit on all of it: axiom-clean **given** `[HasPicScheme C]`, whose only discharger is now conditional. No axiom-clean inhabitant exists in this development.

## Why I stopped

Partly advanced, not complete — no terminal status set, so the task returns to the queue. None of the four fronts closed. Full `lake build` green at 8762 jobs.

## Next

1. **Clause (iii)** is now stateable and is the *joint* residue with AJCR — either side proving it hands it over.
2. `geometricallyReduced` and `universallyClosed` of the **ambient** Pic are the two cheapest structural wins; do not retry the k̄-descent for reducedness (no `DescendsAlong` instance).
3. `ClassDegree` is a carrier transport from the Rebuild's `relPicDeg`, not a new theorem.
4. Someone should decide what to do about the pinned `degree` — consumers should migrate to `degreeOfSection`.
