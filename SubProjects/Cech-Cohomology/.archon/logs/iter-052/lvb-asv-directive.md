# Lean ↔ Blueprint Checker Directive

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

(This consolidated chapter blueprints several Cohomology files; the relevant blocks for this Lean
file are `lem:affine_serre_vanishing` (~line 3208) and `lem:affine_cech_vanishing_qcoh` (~line 6057),
plus the residual `lem:affine_cech_vanishing_tilde_subcover`.)

## Context
This iter the prover discharged the two 02KG tops unconditionally:
- `affine_cech_vanishing_qcoh` — `HasVanishingHigherCech (affineCoverSystem R) F` for qcoh F.
- `affine_serre_vanishing` — `Ext (jShriekOU ⊤) F p = 0` for p > 0, qcoh F.
- `affine_tildeVanishing` (NEW private helper) — re-shapes the residual
  `sectionCech_homology_exact_of_localizationAway` (from CechAcyclic.lean,
  blueprint `lem:affine_cech_vanishing_tilde_subcover`) into the `ULift (Fin n)`-indexed
  hypothesis shape the two `_of_tildeVanishing` reduction lemmas consume.

## What to check
- Whether the Lean signatures of `affine_cech_vanishing_qcoh` / `affine_serre_vanishing` match
  their `\lean{...}` pins and the blueprint statements.
- Whether the proofs are faithful (not placeholders / not hypothesis-weakened).
- Whether the blueprint chapter is detailed enough to have guided this formalization, OR
  understates the work (e.g. the `affine_tildeVanishing` reshaping has no blueprint block).
- Report bidirectionally.

## Output
Bidirectional report to task_results/.
