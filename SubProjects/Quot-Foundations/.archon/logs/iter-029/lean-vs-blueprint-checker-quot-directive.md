# Lean ↔ Blueprint Checker Directive

## Slug
quot

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

## Blueprint chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Known issues
- The 4 typed `sorry` stubs (@126/165/201/228) are intentional protected skeleton placeholders.
- gap1 `isIso_fromTildeΓ_of_isQuasicoherent` is a known-open multi-iter sub-build (blocked on a
  modules restriction-to-basic-open + over↔pullback transport that has no Mathlib support) — do not
  re-report it as "missing", just confirm the blueprint represents it honestly.
- The new theorem `exists_finite_basicOpen_cover_le_quasicoherentData` (~line 730) was just added
  and has NO blueprint block yet (known coverage debt). Confirm it should map to a block near
  `lem:exists_isIso_fromTildeΓ_basicOpen_cover` and report under blueprint adequacy.
