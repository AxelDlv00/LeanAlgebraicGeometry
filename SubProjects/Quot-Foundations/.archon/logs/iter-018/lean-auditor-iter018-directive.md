# Lean Auditor Directive

## Slug
iter018

## Scope (files)
all

## Focus areas (optional)
- `AlgebraicJacobian/Picard/QuotScheme.lean` — 20 new declarations were added this iter
  under namespace `AlgebraicGeometry.GradedModule` (a new `polyEndHom`/`polyModule`/`polySubmodule`
  construction, a new `SubquotientDatum` structure, kernel/cokernel calculus lemmas, a base-case
  finiteness helper). Audit these new defs/structure as Lean: are the signatures sound, is
  `polyModule` (a class-typed `def` left un-`@[reducible]`) a defensible choice, are there any
  suspect bodies?
- `AlgebraicJacobian/Picard/FlatteningStratification.lean` — in-proof scaffolding was added inside
  `exists_localizationAway_finite_mvPolynomial` (L4), which still carries a `sorry`. Check whether the
  surviving `sorry` is honest scaffolding or papers over a wrong subgoal, and whether the long roadmap
  comments are accurate.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` — a long explanatory comment block was rewritten
  around the `base_change_mate_fstar_reindex_legs` `sorry` (Seam 2). Check the comment is accurate and
  not an excuse-comment masking a dead end.

## Known issues
- All three modules carry expected `sorry`s (FBC 4, GF 3, QUOT 4 protected stubs). Those are tracked;
  do not re-report the bare existence of `sorry` — report only suspect *bodies* or excuse-comments.
- Pre-existing predecessor-project iter markers / stale STATUS comments in FlatBaseChange and
  QuotScheme were flagged in prior audits; re-flag only if they actively mislead about current state.
- `set_option maxHeartbeats`/`synthInstance.maxHeartbeats` bumps exist in FBC and GF; flag only if one
  looks like it is hiding a loop rather than certifying a genuinely expensive defeq.
