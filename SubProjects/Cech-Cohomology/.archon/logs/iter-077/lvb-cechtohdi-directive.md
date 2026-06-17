# Lean↔blueprint check — CechToHigherDirectImage.lean

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(blocks: lem:pushforward_mapHC_cechComplexOnX, lem:cechAugmented_to_acyclicResolutionInput @11886, lem:cech_computes_cohomology_affineCover @11926)

## Check
- `cechAugmented_to_acyclicResolutionInput` Lean uses `×'` (PProd); blueprint says Prod/×. Flag.
- Capstone `cech_computes_higherDirectImage_of_affineCover` (Lean:197) lacks `[S.IsSeparated]` + the `hres` family, yet calls `cechTerm_pushforward_acyclic` (which requires both) at line 207 — does the theorem even type-check? Flag the signature gap and whether the blueprint statement omits the same required hypotheses.
- `mapAlternatingCofaceMapComplexIso` new helper — blueprint coverage present or debt?
