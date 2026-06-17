# Directive — lean-vs-blueprint-checker (GrassmannianCells, iter-007)

Bidirectional verification of exactly one Lean file against its blueprint chapter.

## Lean file
`/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean`

## Blueprint chapter
`/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianCells.tex`

## What changed this iter
The single blueprint-pinned declaration `AlgebraicGeometry.Grassmannian.affineChart`
(`def:gr_affine_chart`) had its typed `sorry` body filled with
`AlgebraicGeometry.Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ))`.

## Report
(a) Lean → blueprint: does the filled `affineChart` body match the blueprint recipe
(`Spec ℤ[x^I_{p,q}]_{q ∉ I}`, the polynomial ring on the `d(r-d)` free entries)? Is the
signature consistent with the `\lean{...}` hint? Any fake/placeholder/weakened content?
(b) Blueprint → Lean: is `def:gr_affine_chart` detailed enough to have guided this
formalization? Flag any must-fix-this-iter findings on either side.
