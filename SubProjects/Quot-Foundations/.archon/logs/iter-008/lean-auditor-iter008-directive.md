# Lean Auditor Directive

## Slug
iter008

## Scope (files)
all

## Focus areas (optional)
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` — a substantive new proof body
  was landed for `base_change_mate_regroupEquiv`'s `map_smul'` obligation this iter
  (generator computation via `erw`); check the tactic chain is sound and the two
  remaining `sorry`s are honest scaffolding, not papered-over content.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean` — two new theorems were
  authored (`gf_generic_rank_ses`, `gf_clear_one_denominator`) plus a new
  `sorry`-bodied `gf_torsion_reindex`, and the L5 theorem
  `exists_free_localizationAway_polynomial` had its signature changed to a shared
  universe `(A N : Type u)` and its induction restructured. Pay attention to whether
  the universe change introduced any unsound shortcut and whether comments are accurate.

## Known issues
- `GrassmannianCells.lean` carries a stale docstring near line ~59 claiming "the body
  is a typed `sorry`" while the body is actually filled (flagged in prior iters; the
  review agent cannot edit `.lean`). Re-flag only briefly.
- Both edited files intentionally still carry `sorry`s — those are tracked scaffolding,
  not the target of this audit. Flag a `sorry` only if its surrounding comment misrepresents
  its status (claims proven when it is not, etc.).
