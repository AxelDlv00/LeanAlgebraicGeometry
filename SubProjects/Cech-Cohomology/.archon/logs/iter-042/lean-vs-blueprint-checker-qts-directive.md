# Lean ↔ Blueprint Checker Directive

## Slug
qts

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Known issues
- This iter the prover landed exactly one new lemma `AlgebraicGeometry.tile_image_opens_identities`
  (Sub-lemma A; blueprint block `lem:tile_image_opens_identities`, now `\lean{}`-pinned).
- `tile_section_localization` (blueprint `lem:tile_section_localization`) was DEFERRED, NOT
  formalized — it is intentionally NOT in the Lean file (no sorry); a block comment records why
  (Sub-lemma B `lem:tile_section_comparison` is genuinely non-definitional, carriers are different
  module types `ModuleCat R_g` vs `ModuleCat R`). Confirm the deferred-note comment is honest and
  the blueprint sketch for `lem:tile_section_comparison` correctly describes a real (non-rfl)
  ~100–150 LOC construction. Do NOT report `lem:tile_section_localization` having no `\leanok` as a
  defect — it is a deliberate, recorded deferral.
- Prior iter-041 must-fix on `lem:tile_section_localization`'s sketch was already addressed by a
  blueprint-writer round (honest 5-step base-ring descent); no need to re-flag that history.
