# Blueprint-writer directive — slug `tosheaf-fix`

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (ONLY this file). Edit ONLY the block
`lem:toSheaf_preservesFiniteColimits` (~L3508). Touch nothing else.

## Two must-fixes (from blueprint-reviewer `iter033`)
The block's Step 1 is fine. Step 2 (descent from the composite to `toSheaf R` alone) is
mathematically sound but written illegibly, and the `\uses{}` list is missing one edge.

1. **Rewrite Step 2 prose** to state the descent explicitly and with UNIFIED notation (pick ONE
   convention — Lean-style `.comp` OR `∘` — and use it throughout the block; the current prose
   switches mid-paragraph and has at least one composition-order typo). The correct argument:
   - The sheafification adjunction (Lemma~\ref{lem:mod_pmod_adjunction}) has, restricted to the
     reflective image, an invertible counit: writing `L = sheafification (𝟙 R₀)` and `ι` the
     forgetful direction, the counit `L ∘ ι ≅ id` is an isomorphism on sheaves (sheafification of a
     sheaf is itself).
   - Hence `toSheaf R` is, up to natural isomorphism, a **retract** of the composite
     `L ⋙ toSheaf R` (equivalently `toSheaf R ≅ ι ⋙ (L ⋙ toSheaf R)` using the counit-iso), where
     the composite preserves finite colimits by Step 1.
   - A retract of a finite-colimit-preserving functor preserves finite colimits; therefore
     `toSheaf R` preserves finite colimits.
   State these three sub-steps (counit-iso; retract; retract-preserves-colimits) as explicit clauses.

2. **Add `\uses{lem:mod_pmod_adjunction}`** to BOTH the statement block's `\uses{}` and the proof
   block's `\uses{}` for `lem:toSheaf_preservesFiniteColimits` (the label exists at ~L2549,
   `\lean{PresheafOfModules.sheafificationAdjunction}`). Keep the existing `\uses{}` entries.

## Out of scope
No `\leanok`. Do not touch `lem:to_sheaf_preserves_epi`, `lem:standard_cover_cofinal`, or any other
block. This is project-bespoke Mathlib infra — no `% SOURCE` quote needed.
