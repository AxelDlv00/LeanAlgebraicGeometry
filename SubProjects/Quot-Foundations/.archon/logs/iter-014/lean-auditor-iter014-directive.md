# Lean Auditor Directive

## Slug
iter014

## Scope (files)
all

## Focus areas (optional)
Two files received prover work this iter and warrant extra attention:
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (a multi-`have` conjugate-adjunction
  proof was just landed around the `base_change_mate_unit_value` declaration; a
  `set_option maxHeartbeats 4000000 in` was added).
- `AlgebraicJacobian/Picard/FlatteningStratification.lean` (five new helper declarations in
  namespace `AlgebraicGeometry.GenericFreeness` were added — `pullbackModuleAddEquiv`,
  `finite_of_pullbackModuleAddEquiv`, `pullback_isScalarTower`, `finite_of_quotientRingEquiv`,
  `isLocalizedModule_restrictScalars` — and `gf_torsion_reindex` was closed; a
  `set_option maxHeartbeats 4000000 in` was added).
Pay extra attention to whether the new `set_option maxHeartbeats` bumps are accompanied by
honest explanatory comments vs. masking a fragile proof, and whether any scratch/debug
declarations (`#check`, `section ScratchCheck`, `#eval`) were left behind.

Audit the rest of the project too — no scope shortcuts.

## Known issues
- Legacy cross-project STATUS comments referencing iter-234/236/240/241 (FlatBaseChange.lean)
  and iter-177+ (QuotScheme.lean) are known stale orphans from the pre-extraction source
  project. Report them if still present, but they are already tracked.
- The four open `sorry`s in each of FlatBaseChange / FlatteningStratification / QuotScheme are
  honest, openly-disclosed scaffolding for downstream targets — do not re-classify each as a
  surprise; flag only if a `sorry` is on a declaration the surrounding code/comments claim is
  complete.
- Absolute project root: `/home/archon/proj/Quot-Foundations`.
