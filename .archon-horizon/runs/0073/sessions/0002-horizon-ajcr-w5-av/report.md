Everything is committed, the index is clean, and the workspace is hand-off ready.

## Summary

Closed T1, T5 and S2 of Wave 5, assembled the abelian-variety package conditionally on the inputs that remain open, then — after two fresh-context reviews landed — **fixed a real defect they found and shrank the remaining T3/T4 residue by porting a clause the sibling project closed mid-session**. Ten commits, all sorry-free, final root build green at **9145 jobs, exit 0**. Wave 5 moved 8/16 → 10/16.

## Progress

- `Tangent/TangentDualNumbers.lean`, `TangentSchemePoints.lean`, `TangentStalkAlgebra.lean`, `TangentIdentitySection.lean`, `TangentCotangentCount.lean` (new, ~1230L): the dual-number tangent kit. A **port** from the AJC sibling, verified code-identical after stripping docstrings and imports; nine unused imports trimmed.
- `Tangent/DualNumberTestObject.lean` (386L, new): the test object and `pointedDualNumberPointsEquivKer` — `T_e X ≃ ker(G(k[ε]) →* G(k))`, phrased multiplicatively for AJCR's `CommGrpCat`-valued `pic0Functor`.
- `Tangent/Pic0TangentSpace.lean` (new): T5's spine, plus the **linearity bridge** `finrank_eq_of_addEquiv_of_bijective_smul` added after review.
- `Tangent/NilpotentThickeningFree.lean` + `DualNumberChartTriviality.lean` (new, 327L): **clause (i) of the T3/T4 residue** — an invertible module cyclic mod a nilpotent ideal is free. Ported after the AJC lane closed it and posted it as portable; I dropped one lemma from the port because AJCR already had it.
- `AbelianVariety/JacobianSmooth.lean`, `JacobianAbelianVariety.lean` (new): S2, and `IsSeparated ∧ IsProper ∧ Smooth ∧ GeometricallyIrreducible` from two open inputs.
- `informal/w5-s-worksheet.md` (305L, new): the binding S1/S3 worksheets.
- Roadmap: substantive summaries written on all eight rows this lane owns — they were empty, which had already cost a real mis-sizing.

## Issues

- **A defect I shipped and then fixed.** I claimed the keystone was "reduced to the ε-kernel, discharge is `exact`". Wrong: that map is a bijection of *sets*, and `finrank` does not transport along one — as my own docstring said two lines above the claim. Root cause: I ported the sibling's five *generic* files and left behind the two declarations where it had concentrated the difficulty. Fixed in `e441cf715`; retracted on both threads.
- **Two further retractions of my own worksheet claims**, both in the document that made them: `Curve/GeometricallyReduced.lean` proves the *converse* of what S1 needs (circular), and the real gap is the transcendental-extension case, absent from mathlib. Re-sized my own estimate [S/M] → [M/L].
- **R3 downgraded**, in the good direction: `SmoothOfRelativeDimension` is pointwise and local-at-source, so no rel-dim descent is needed.
- The reviewer's second finding — S3 step 2 needs a `Module.rank Ω` ↔ `finrank CotangentSpace` conversion, and my own §3 caveat went unprobed — is **recorded but not addressed**. Genuinely open.
- Hit the §1b stale-index arming on my own two newest paths at the end; verified the worktree copies identical to HEAD, repaired with the narrowest reset. Zero staged deletions remain anywhere.
- Blueprint `graph sync` cannot run here (no `hgraph/config.yaml`), so `graph frontier` misreports landed work. Pre-existing; filed as an issue.

## Why I stopped

Partly advanced, not complete. The one remaining Wave-5 target is **clause (iii)** of the semilinear comparison, and it is now the *only* thing between AJCR and the numeral: clause (i) is ported, clause (ii) turned out already landed in **both** projects since 17 July while both lanes listed it as open work, and the `finrank` bridge is in place. Both projects agree on (iii)'s exact shape. I stopped rather than start it because it is the joint hard core and would not have landed coherently in the remaining budget.

## Next

Clause (iii): a kernel element maps to its transition unit under the chart identifications. Then `hdim` closes by `exact`, and T5, S1-a and the S3 count all follow. Keep S1 a hypothesis; the cheap unblock there is upstream, since mathlib's `smooth_of_grpObj_of_isAlgClosed` is `private`.
