# Lean Auditor Directive

## Slug
iter017

## Scope (files)
all

## Focus areas
The three files edited this iter (read every file, but pay extra attention here):
- `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean`
- `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean`

Specific points to verify (audit as Lean, no strategy bias):
- FlatBaseChange.lean: new private lemmas `base_change_mate_codomain_read_legs`,
  `base_change_mate_fstar_reindex_legs`, `gammaMap_pushforwardComp_hom_eq_id`,
  `gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardCongr_hom`, plus the concrete
  `base_change_mate_fstar_reindex` (now claims to be sorry-free, reducing to `…_legs`). Check the
  `base_change_mate_codomain_read` body was changed from `obtain` to `.1`/`.2` projections — confirm
  this is a genuine refactor, not a weakening. Check the `set_option maxHeartbeats 1600000` bumps
  (there are several) are honest (not masking a loop). Confirm the remaining `sorry`s are honest
  scaffolding.
- FlatteningStratification.lean: `gf_torsion_reindex` lost one existential binder (the redundant
  canonical `Module A_g T_g`). Confirm the signature change is a simplification, not a weakening of
  the conclusion. Confirm `exists_free_localizationAway_polynomial` (L5) is genuinely closed.
- QuotScheme.lean: ~13 new declarations in `namespace AlgebraicGeometry.GradedModule`
  `section Subquotient`. Verify none use `axiom`, none have fake/tautological bodies, the
  `omit [DirectSum.Decomposition ℳ]` usage is legitimate.

## Known issues (do not re-report as new)
- Pervasive predecessor-project iter markers / STATUS comments in FlatBaseChange.lean, RelativeSpec,
  QuotScheme (provenance noise, tracked since iter-011; prover-cleanup only).
- The 4 pre-existing protected `sorry` stubs in QuotScheme.lean (lines ~123/161/198/225).
- The 3 expected `sorry`s in FlatteningStratification.lean (L4 ~486, genericFlatnessAlgebraic,
  genericFlatness/GF-geo) and the FBC `sorry`s (Seam-2 step-iii, Seam-3, affine, FBC-B).
- Absolute paths: project root is `/home/archon/proj/Quot-Foundations`.
