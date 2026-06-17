# Lean ↔ Blueprint Checker Directive

## Slug
relativespec-iter179

## Lean file
AlgebraicJacobian/Picard/RelativeSpec.lean

## Blueprint chapter
blueprint/src/chapters/Picard_RelativeSpec.tex

## Known issues
- The `RelativeSpec` body was REWRITTEN this iter (plan-phase refactor `relative-spec-block-a`):
  - `QcohAlgebra` now has 3 fields (`sheaf`, `unit`, `coequifibered`); the
    new third field is `NatTrans.Coequifibered (Functor.whiskerLeft … unit.hom)`.
  - `RelativeSpec _𝒜` body is now `(AffineZariskiSite.relativeGluingData _𝒜.coequifibered).glued`
    (was the placeholder `:= X` flagged CRITICAL by auditor iter-176).
  - `structureMorphism _𝒜` body is now `.toBase` of the same gluing data.
- Lane B (this iter) closed `UniversalProperty` and `affine_base_iff` kernel-clean,
  and `base_change` via 2 NAMED helpers (`Scheme.QcohAlgebra.pullback` at L209 and
  `Scheme.RelativeSpec.pullback_iso` at L347) which carry residual `sorry` on
  one field each (substantive types).
- The blueprint chapter likely still describes the iter-174 carrier (2 fields);
  flag stale prose.
