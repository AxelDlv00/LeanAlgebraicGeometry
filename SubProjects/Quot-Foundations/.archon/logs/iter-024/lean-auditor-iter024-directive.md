# Lean Auditor Directive

## Slug
iter024

## Scope (files)
all

## Focus areas (optional)
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` — received prover work this iter (3 new
  `base_change_mate_inner_eCancel_*` atoms added; `base_change_mate_gstar_generator_close` proof
  closed; `base_change_mate_inner_value_eq` still `sorry`). Check the new atoms' bodies and the
  comments around `inner_value_eq`/`gstar_transpose` for staleness vs current state.
- `AlgebraicJacobian/Picard/QuotScheme.lean` — received prover work this iter (2 new theorems
  `isLocalizedModule_tilde_restrict`, `isLocalizedModule_restrict_of_isIso_fromTildeΓ`). Check the
  newly-added `/-! ... -/` section docstring and the theorem bodies/comments.

## Known issues
- `base_change_mate_fstar_reindex_legs` (FlatBaseChange.lean ~1421) is dead/orphaned code carrying a
  `sorry` — known, slated for a future dead-code removal; report it but it is not new.
- `base_change_mate_inner_value_eq` carries a `sorry` (literal-form-lock blocker) — known PARTIAL.
- The 4 protected QUOT stubs in QuotScheme.lean (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`,
  `Grassmannian.representable`) carry `sorry` by design (gated on upstream defs) — known.
- `affineBaseChange_pushforward_iso` / `flatBaseChange_pushforward_isIso` (FBC) carry `sorry` — known,
  out of scope.
