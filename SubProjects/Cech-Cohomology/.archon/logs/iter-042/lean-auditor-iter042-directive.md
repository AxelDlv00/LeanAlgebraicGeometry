# Lean Auditor Directive

## Slug
iter042

## Scope (files)
all

## Focus areas (optional)
Pay extra attention to `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` — it received prover
work this iter (one new lemma `tile_image_opens_identities`; a large block comment was added near
the end of `section TileSectionLocalization` recording a deferred declaration
`tile_section_localization`). Verify the new lemma's proof is honest (not a syntactic dead-end), and
judge whether the deferred-declaration block comment is an acceptable handoff note vs an
excuse-comment masking wrong/incomplete code.

## Known issues
- `AlgebraicGeometry.CechAcyclic.affine` is a known dead/superseded declaration carrying a `sorry`
  (deferred to a future P5b assembly rework); no need to re-flag it as new.
- The frozen `CechHigherDirectImage.lean` P5b material is intentionally superseded; pre-existing.
- Absolute paths to read are under `/home/archon/proj/Cech-Cohomology/`.
