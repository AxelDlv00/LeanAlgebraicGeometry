# Lean ↔ Blueprint Checker Directive

## Slug
cotangent-grpobj-review140

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex

(The chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` is a pointer chapter that re-states the Lean targets and points at `RigidityKbar.tex` for the proof prose. You may consult both; the proof-detail chapter is `RigidityKbar.tex`.)

## Known issues
- Iter-140 prover lane on `Cotangent/GrpObj.lean` shipped PARTIAL: 0 of 3 sub-sorries fully closed substantively. Structural refactor adds `private theorem isIso_of_app_iso_module` (~L544–550) — a 5-line `PresheafOfModules` morphism iso-reflection bridge — and restructures the IsIso sub-sorry from "whole-morphism is iso" to per-open `(fun _ => sorry)`. d_app gained a successful `change` scaffold (L623) + 16-line closure-recipe docstring (L606–622); d_map gained 18-line closure-recipe docstring (L626–642) but no body change (the `change` attempt caused a deterministic `whnf` timeout — reverted).
- Inline sorries on this file at iter-140 close: L624 (d_app inside `basechange_along_proj_two_inv_derivation`), L643 (d_map inside same), L689 (per-open IsIso lambda body inside `relativeDifferentialsPresheaf_basechange_along_proj_two`), L817 (main `mulRight_globalises_cotangent`).
- Declarations using `sorry` on this file: L573 (`basechange_along_proj_two_inv_derivation`), L670 (`relativeDifferentialsPresheaf_basechange_along_proj_two`), L806 (`mulRight_globalises_cotangent`).
- Blueprint `RigidityKbar.tex` was substantively expanded iter-139 (+468 LOC; iter-138 closure-shape NOTE, d_app + d_map closure recipes, Route (b'2) sub-paragraph, two new `\lean{...}` blocks for `basechange_along_proj_two_inv_derivation` + `basechange_along_proj_two_inv`, plus `% NOTE iter-139:` flag on `\leanok` mis-mark concern at L491–L504). Iter-140 added no new blueprint prose — assess whether the iter-139 expansion still adequately previews the iter-140 prover deliverables (the new helper `isIso_of_app_iso_module`, the iter-140 closure recipe encoded in the d_app docstring, the d_map docstring).
- Iter-137 prover lane added inverse-direction docstring analysis on `_basechange_along_proj_two`; iter-138 added `basechange_along_proj_two_inv_derivation` + `basechange_along_proj_two_inv` helpers; iter-139 added `\lean{...}` blocks for those two helpers in `RigidityKbar.tex`. Iter-140 helper `isIso_of_app_iso_module` is private and may not warrant a dedicated `\lean{...}` block — confirm or flag.
- Iter-139 lean-vs-blueprint-checker (when last run on this pair, iter-138 actually) returned PASS; verify whether iter-140 changes break that judgment.

## Output path
`.archon/task_results/lean-vs-blueprint-checker-cotangent-grpobj-review140.md`
