# Lean ↔ Blueprint Checker Directive

## Slug
relspec-iter174

## Lean file
AlgebraicJacobian/Picard/RelativeSpec.lean

## Blueprint chapter
blueprint/src/chapters/Picard_RelativeSpec.tex

## Known issues

- iter-174 Lane G: `QcohAlgebra` carrier (L117) was replaced from `Type (u+1) := sorry` to a substantive `structure` with two fields (`sheaf : TopCat.Sheaf CommRingCat X` + `unit : X.sheaf ⟶ sheaf`) — Encoding I per `analogies/qcohalgebra-structure.md`.
- The 5 downstream sorries (`RelativeSpec`, `structureMorphism`, `UniversalProperty`, `affine_base_iff`, `base_change`) remain typed-`sorry` per the lane directive's "out of scope" clause.
- Confirm whether the chapter's prose / proof sketches are sufficient to body-fill the 5 downstream pins, and whether the `QcohAlgebra` definition prose matches the Encoding I 2-field structure.
- The chapter already carries `\leanok` on `def:qc_sheaf_of_algebras` per `sync_leanok-state.json` iter-173 + iter-174 markers; the iter-174 Lane G report claims this is "fully earned" — verify.
