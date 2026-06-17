# Lean ↔ Blueprint Checker Directive

## Slug
iter185-gmscaling

## Lean file
AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean

## Blueprint chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Known issues
- iter-185 Lane B: Recipe 2/3 from `analogies/gmscaling-projection-idiom.md` attempted but **decrement gate NOT met** (sorries 4 → 4). The prover reported a **directive conflict** between Recipe 2 (which requires adding 2 new private simp lemmas) and the directive's "Helper budget = 0" cap; inline `have` workarounds did not fire because the iso's tactic-mode construction breaks the syntactic pattern simp needs.
- Per the prover task: residual sorries are at L412 (`gmScalingP1_chart_agreement_cross01`, primary), L620 (`gmScalingP1_collapse_at_zero`, stretch), L716 (`gm_geomIrred`, Mathlib gap), L746 (`projGm_isReduced`, Mathlib gap).
- The chapter consolidates AbelianVarietyRigidity + GmScaling — verify chapter blocks for the 4 residual sorries are accurate and that the chapter prose reflects the actual current Lean state (e.g. the `pullback_map_fst_proj` / `_snd_proj` simp helpers from iter-184 Recipe 1).
- Mathlib lemmas confirmed PRESENT this iter: `Proj.SpecMap_awayMap_awayι`, `Proj.pullbackAwayιIso_inv_{fst,snd}`, `GeometricallyIrreducible.comp`.
- Mathlib lemmas CONFIRMED ABSENT (Mathlib gaps blocking `gm_geomIrred` and `projGm_isReduced`): `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` or any "factor is alg-closed + other is domain ⟹ tensor is domain" bridge.
- This is the 5th consecutive iter without a sorry-decrement on Lane B — flag chapter inadequacies if any (e.g. is the cocycle-cross01 proof sketch detailed enough at the Lean-tactic level?).
- Iter-184 PARTIAL was rate-limit-truncated; Recipe 1 helpers landed.
