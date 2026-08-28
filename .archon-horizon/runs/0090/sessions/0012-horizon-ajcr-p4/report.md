Nothing to commit. The flagged mutations were my two cross-session memory writes plus the `MEMORY.md` index line, at `/home/axel/.claude-api/projects/…/memory/` — outside the ledger work tree (`/home/axel/LeanAlgebraicGeometry-Horizon`) by design, so they produce no durable workspace change. The `rm -rf scratch_p4r5` before them removed only untracked probe files; the directory is gone and was never tracked.

Verified just now, not assumed: all five of my Lean/root/board paths hash-match `HEAD:`, and all four inbox items I filed (I-1318, I-1333, I-1389, I-1390, plus I-1395) exist at HEAD.

## Progress

- `Picard/Pic0ChartCoverForcesNonInj.lean`: new, rooted at `AlgebraicJacobian.lean`, 10 declarations, **0 sorries**, all axiom-clean on exactly `[propext, Classical.choice, Quot.sound]` against a control (`AlgebraicGeometry.Jacobian`) firing `sorryAx`. Root `lake build` EXIT=0, 9327 jobs.
  - `not_injective_of_pointwiseCoverage_of_ne_top` — for an **arbitrary** map of big-site presheaves into `pic0SigmaSheaf` and an open `V ≠ ⊤`, `PointwiseCoverage` for the restricted family exhibits a test where the map is not injective. Witness: the **tautological** section read at a point outside `V`. An auditor re-proved it for an arbitrary presheaf on `Scheme`, zero instance binders.
  - Composed at the Abel chart it closes the `⊤` end of the `V`-interval **without deciding the `abel-noninj` fork** — coverage *supplies* the non-injectivity `not_restrictedChartFibre_top_of_not_injective` assumes.
  - Non-vacuity: `specSecMap_injective` + `bot_ne_top_specObj` + `not_pointwiseCoverage_specSecMap`.
- `Pic0ChartRestrictedFibreSat.lean`, `Pic0ChartAbelNonInjective.lean`: docstring corrections only; both re-elaborated EXIT=0.

**Which item and why fourth.** p1 held `framecover-aff`, p2 `cover-threshold`, p3 `fieldmono-aff` — all leaf inputs to antecedents 2 and 3. Nobody held the **joint** of antecedents 1 and 2, which `Pic0ChartAtlasCoupling.lean` calls "an obligation between two antecedents, owned by no row". Claimed and announced (I-1318) before editing, per I-0838.

**State: advanced, no antecedent closed.** `rep` has no producer, coverage at a proper `V` has no producer, and `(huniv V, hcov V)` has no measured inhabitant at any `V`.

## Issues

**Three of my own claims were refuted** by an audit I commissioned, fixed at HEAD rather than caveated (I-1377/1378/1379/1380, acknowledged and archived):

- **The equivalence is one-directional.** `N → Q` holds; `Q → N` does not — `Works ≡ False` satisfies all three landed facts and `Q` vacuously with `N` false. The converse needs a seam inhabitant the sibling file says was never measured.
- **My non-vacuity witness was off-target.** `restrictChart f ⊥` is injective, but its source has a subsingleton open lattice, so the theorem admits no `V ≠ ⊤` there — and injectivity is free anyway. Replaced; the old one kept with its defect named.
- **Understated in my own favour once:** under the positive branch `⊤` dies too, so the seam is unsatisfiable at **every** `V`.

**The finding for other lanes (I-1389).** Single-chart coverage converts to *unrestricted* one-chart coverage, which two of this project's files say should not hold. So a coverage hypothesis at a fixed index is not antecedent 2, and refuting the collapsed form would kill every such hypothesis at once. Untried.

**My commit `9199f1f71d` transiently reverted two AJC files** (I-1333, fifth reproduction of the read-tree race) despite following I-1222's four steps and re-seeding after the guard rejected attempt 1. Healed by `ajc-p3`'s next commit; both files re-verified at HEAD == disk. No repair made, deliberately.

**Live at session end (I-1395):** the shared index stages deletion of two other lanes' AJCR proof files intact at HEAD and on disk, plus five content reversions with no `D` line, 438 deletions total. Not mine to fix.

## Why I stopped

Partly advanced, not complete: the item is released `pending` with three pins because the joint inhabitation question is still open. I linked two rows that were tracked apart and gave the fork a second route; I discharged nothing.

## Next

Refute unrestricted one-chart coverage. If it falls, every fixed-index coverage hypothesis falls with it, and the multi-index form becomes the only live shape — settling whether the tautological-section mechanism reaches the atlas the seam consumes or only its one-chart caricature.
