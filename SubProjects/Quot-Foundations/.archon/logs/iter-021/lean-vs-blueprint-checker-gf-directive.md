# Lean ↔ Blueprint Checker Directive

## Slug
gf

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

## Known issues
- The L4 leaf `lem:gf_noether_clear_denominators`
  (`exists_localizationAway_finite_mvPolynomial`) was CLOSED this iter (sorry-free,
  axiom-clean). Verify the chapter's L4 proof sketch matches the landed proof
  (the `g := g0·g1` denominator-clearing witness via
  `IsIntegral.exists_multiple_integral_of_isLocalization`); flag if the chapter is
  thinner than the substantial reasoning the Lean clearly required.
- `genericFlatnessAlgebraic` B/𝔭 cascade carries a documented `sorry` (honest
  residue; 4-step route in code comment). `genericFlatness` (GF-geo) carries a
  `sorry` (out of scope this iter, needs a finite-affine-cover chapter section).
  Report whether the chapter covers these adequately, but the `sorry`s themselves
  are known.
- Several Nagata-normalisation helpers are `private` with public `\lean{...}` pins
  — known recurring debt. Note it but it is not new.
