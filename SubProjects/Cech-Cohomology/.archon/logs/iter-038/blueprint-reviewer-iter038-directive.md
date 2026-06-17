# Blueprint-reviewer directive — iter-038 (whole-blueprint audit)

Audit the WHOLE blueprint as usual (cross-chapter view is the point). Produce your standard per-chapter
completeness + correctness checklist and the HARD-GATE verdict per chapter.

## This iter's focus (for the gate decision the planner needs)

The planner intends to dispatch ONE prover this iter, on
`AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`, to build Route B step **B3**
(`lem:restrict_over_compat` / `AlgebraicGeometry.overBasicOpenIsoRestrict`) and the mechanical **B4**
(`lem:presentation_modulesRestrictBasicOpen`). The governing chapter is
`Cohomology_CechHigherDirectImage.tex` (it `% archon:covers` the Route B files).

Just before this review, a blueprint-writer + blueprint-clean round edited that chapter to:
- add `lem:overEquivalence_mathlib` (Mathlib anchor) + `lem:overEquivalence_isContinuous` (project block,
  pinning the 4 `Opens.overEquivalence_*` continuity decls that were prior coverage debt);
- expand the B3 proof sketch (`lem:restrict_over_compat`) with a B3a/B3b/B3c decomposition naming the
  structure-sheaf compatibility datum built from `(specBasicOpen g).ι.appIso`;
- tighten the B2 proof `\uses`;
- bundle `coversTop_iSup_eq_top` into B1's `\lean{}`.

Please confirm, as part of your per-chapter verdict, whether `Cohomology_CechHigherDirectImage.tex` is now
`complete: true` AND `correct: true` for the B3/B4 declarations specifically (statement well-formed, proof
sketch detailed enough to formalize, `\lean{}` pins name real intended declarations, `\uses{}` accurate),
with no must-fix-this-iter finding touching them — i.e. whether the HARD GATE is satisfied for dispatching
a prover on B3/B4 this iter.
