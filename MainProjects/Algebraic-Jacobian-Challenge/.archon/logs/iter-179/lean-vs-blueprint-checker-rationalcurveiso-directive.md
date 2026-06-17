# Lean ↔ Blueprint Checker Directive

## Slug
rationalcurveiso-iter179

## Lean file
AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean

## Blueprint chapter
blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex

## Known issues
- `morphismToP1OfGlobalSections` (L198+) had its signature TIGHTENED this iter
  by Lane C with a new `_halg` hypothesis (a concrete `kbar`-algebra-map
  equation `f.comp (algebraMap kbar (MvPolynomial (Fin 2) kbar)) =
  X.hom.appTop.hom.comp (Scheme.ΓSpecIso (CommRingCat.of kbar)).inv.hom`).
  Pin 1 was then closed kernel-clean. Verify the blueprint matches the new
  signature and the proof body is faithful to the chapter sketch.
- Pin 2 (`morphism_degree_via_pole_divisor` at L296) and Pin 3 (`iso_of_degree_one`
  at L356) still carry `sorry` — they are off-target this iter; flag the
  blueprint adequacy for them only.
- Iter-178 audited a section-condition gap (auditor 178A) on the OLD signature
  of `morphismToP1OfGlobalSections`; that gap is RESOLVED by Lane C's signature
  tightening.
