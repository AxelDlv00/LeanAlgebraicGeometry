# Lean ↔ Blueprint Checker Directive

## Slug
cotangent-grpobj-iter142

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex

(Note: `Cotangent/GrpObj.lean` has TWO blueprint chapters by convention — the pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` (82 LOC, all declarations bullet-listed with cross-references to `RigidityKbar.tex`) and the substantive chapter `RigidityKbar.tex` (1349 LOC, carries the actual proof prose and `\lean{...}` blocks). Audit primarily against `RigidityKbar.tex`; cross-check the pointer chapter only if you find substantive mismatches.)

## Pointer chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex

## Known issues
- The iter-142 prover lane closed 1 of 3 sub-sorries on piece (i.b) Step 2 (d_map at L643). Remaining `sorry` lines in this file are at L637 (d_app body), L720 (IsIso `fun _ => sorry`), and L848 (`mulRight_globalises_cotangent` Main body) — these are honest open scaffolds, do NOT flag as fake/placeholder.
- The `RigidityKbar.tex` chapter carries three carry-over `\leanok` mis-mark candidates (per iter-141 watchpoint and iter-142 prover task_result):
  - L524 `lem:GrpObj_omega_basechange_proj` proof block: `\leanok` while inner Lean body retains `(fun _ => sorry)` at `Cotangent/GrpObj.lean:720`.
  - L1152 `lem:GrpObj_omega_basechange_proj_inv_derivation` proof block: `\leanok` while inner Lean body retains the d_app `sorry` at `Cotangent/GrpObj.lean:637`.
  - These are `sync_leanok` deterministic-phase concerns; flag bidirectionally if the chapter's prose claims the Lean block is fully closed but the Lean retains a `sorry`, OR if the Lean clearly closed something the chapter still talks about as open.
- The iter-141 mathlib-analogist artifacts (`analogies/d-app-d-map-recipe-shape.md`, `analogies/isiso-basechange-along-proj-two-inv.md`, `analogies/scheme-frobenius-piece-iii-scoping.md`) are out of scope for this dispatch but are referenced from the chapter.
