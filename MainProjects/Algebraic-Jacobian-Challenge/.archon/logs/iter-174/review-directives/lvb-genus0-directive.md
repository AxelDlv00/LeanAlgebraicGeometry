# Lean ↔ Blueprint Checker Directive

## Slug
genus0-iter174

## Lean file
AlgebraicJacobian/Genus0BaseObjects.lean

## Blueprint chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

(Per `% archon:covers` the rigidity chapter blueprints `Genus0BaseObjects.lean`. Also examine `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex` if `gm_grpObj` or related grp-obj declarations are pinned there.)

## Known issues

- `gmScalingP1_chart` (L911) closed iter-173 — already audited.
- `gmScalingP1_over_coherence` (L1158): iter-174 closed it via `Cover.hom_ext` + `chart_PLB_eq` helper. The body is 3 lines with no own sorry; sorries propagate through helper.
- `gmScalingP1_chart_PLB_eq` (L991, new helper) — Step C has 2 sorries on `i=0` / `i=1` cases (Fin-mismatch gap, deferred per analogist).
- `gmScalingP1_chart_agreement` (L1120) — diagonal cases `(0,0)` + `(1,1)` axiom-clean; cross `(0,1)` + `(1,0)` deferred as `sorry` per analogist Decision 2.
- `homogeneousLocalizationAwayIso_algebraMap` (L555 area) — NEW helper, axiom-clean.
- `gm_grpObj` (L808) — out of scope this iter; do NOT report it as a Lean-side gap.

Pay particular attention to whether the chapter has `\lean{...}` pins for the new helpers (`homogeneousLocalizationAwayIso_algebraMap`, `gmScalingP1_chart_PLB_eq`) — if not, that is a writer-side gap to surface.
