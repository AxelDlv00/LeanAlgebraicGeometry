# Lean ↔ Blueprint Checker Directive

## Slug
weildivisor-iter174

## Lean file
AlgebraicJacobian/RiemannRoch/WeilDivisor.lean

## Blueprint chapter
blueprint/src/chapters/RiemannRoch_WeilDivisor.tex

## Known issues

- iter-174 Lane D (narrow): `Scheme.WeilDivisor.ofClosedPoint` (body now at L184) closed kernel-clean via a junk-defined dependent `if Order.coheight P = 1` branch.
- Two bridge equation lemmas added: `ofClosedPoint_eq_single` and `ofClosedPoint_eq_zero` (around L199–L217).
- The remaining 4 sorries (`RationalMap.order`, `principal`, `principal_hom`, `principal_degree_zero`) are out-of-scope this lane (gated on DVR-extraction sub-build).
- Verify the chapter's "Lean signature scope" paragraph (cited by the prover as L330–L340 of the chapter) accurately documents the junk-branch convention and that the `\lean{}` pins reflect the actual declaration names.
- Also check that the chapter contains adequate proof sketches for `RationalMap.order` body (Krull-Schmidt / DVR-extraction) since this is the next-iter target.
