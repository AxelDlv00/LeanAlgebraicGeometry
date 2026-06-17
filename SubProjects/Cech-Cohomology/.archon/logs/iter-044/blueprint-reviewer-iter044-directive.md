# Blueprint-reviewer directive — iter-044 (HARD GATE re-confirm for the active prover lane)

Read the WHOLE blueprint as you always do; produce your standard per-chapter checklist and any
unstarted-phase proposals. The plan agent will act on the cross-chapter view.

## The specific gate this iter hinges on
The single active prover lane this iter is `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`, backed
by chapter `Cohomology_CechHigherDirectImage.tex` (`% archon:covers QcohTildeSections.lean`). This iter a
blueprint-writer + blueprint-clean just revised the Sub-lemma B region of that chapter:
- Added two `rfl`-bridge lemma blocks `lem:modulesSpecToSheaf_smul_eq`,
  `lem:modulesRestrictBasicOpen_smul_eq` (clearing the prior coverage debt).
- Rewrote the `lem:tile_section_comparison` proof note to the accurate decomposition: carriers + scalar
  actions are definitional (via the two bridges + `lem:restrict_obj_mathlib`), and the sole residual is
  ONE structure-sheaf ring identity (`ρ^{D(g)}(θ_R(r)) = β_g^{-1}(θ_{R_g}(r̄))`) with two named closure
  routes (Γ–Spec naturality; `IsLocalization.Away` uniqueness).

The iter-043 full review HARD-GATE-CLEARED this chapter; the only regression since was the
`lem:tile_section_comparison` sketch going stale (it overstated the residual 3–5× and claimed
"genuinely non-definitional"), which the lean-vs-blueprint checker flagged. That is what the writer just
fixed.

## What I need confirmed
1. Is `Cohomology_CechHigherDirectImage.tex` now `complete: true` AND `correct: true` for the active
   prover target (`lem:tile_section_comparison` → `lem:tile_section_localization`)? Specifically: does the
   revised `lem:tile_section_comparison` proof note give a prover enough to close the residual ring
   identity WITHOUT misdirecting it into a 100–150 LOC construction, and are the two new bridge blocks
   correctly stated with accurate `\uses{}`?
2. Any remaining must-fix-this-iter finding touching this chapter that should defer the prover lane.
Report your normal whole-blueprint checklist in addition.
