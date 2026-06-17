# Lean ↔ Blueprint Checker Directive

## Slug
codimone-iter179

## Lean file
AlgebraicJacobian/Albanese/CodimOneExtension.lean

## Blueprint chapter
blueprint/src/chapters/Albanese_CodimOneExtension.tex

## Known issues
- `extend_iff_order_nonneg` was RENAMED this iter to
  `mem_domain_iff_exists_partialMap_through_point` per auditor 178B Path D2.
  The unused `[Ring.KrullDimLE 1 …]` and `[IsLocallyNoetherian X.left]` typeclass
  binders were dropped; the docstring was demoted to honestly describe the
  2-LOC `mem_domain`-reshuffle the body actually proves.
- The blueprint label `thm:weil_divisor_obstruction` at L554 still has a
  `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_iff_order_nonneg}`
  reference that now points at a renamed declaration. The task_result requested
  the review agent EITHER (a) update the `\lean{...}` to the new name AND demote
  the blueprint statement to match the actual proven content, OR (b) keep the
  blueprint statement substantive and remove the `\lean{...}` until a future
  substantive lemma lands.
- `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` (L222 helper) gained a
  structured body this iter that exposes the closure path; the single internal
  `sorry` is named and isolates two Mathlib gaps (smooth ⟹ regular local;
  coheight ⟹ ringKrullDim).
- `extend_of_codimOneFree_of_smooth` (L356) and
  `indeterminacy_pure_codim_one_into_grpScheme` (L397) are not iter-179 targets;
  flag blueprint adequacy only.
