# Lean ↔ Blueprint Checker Directive

## Slug
gf

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

## Known issues
- `exists_free_localizationAway_polynomial` (`lem:gf_polynomial_core`, was sorry) was CLOSED this
  iter by defusing an OreLocalization instance-presentation diamond. As part of this,
  `gf_torsion_reindex`'s signature lost ONE existential binder (the redundant canonical
  `Module (Localization.Away g) (LocalizedModule (powers g) T)`). The chapter's INTENDED LEAN
  SIGNATURE comment for `lem:gf_torsion_reindex` (~line 944) has already been corrected this iter to
  note the drop. Verify the landed `gf_torsion_reindex` signature matches the prose statement (the
  math statement is unchanged; `T_g` still carries the compatible `A_g`-module structure via the
  canonical instance). Do NOT re-flag the comment correction.
- Expected remaining `sorry`s: L4 `exists_localizationAway_finite_mvPolynomial` (~486),
  `genericFlatnessAlgebraic`, `genericFlatness` (GF-geo, out of scope). These are genuine
  Mathlib-absent residue, not placeholders.
- Verify L5's landed proof matches the blueprint's IH+descent sketch.
