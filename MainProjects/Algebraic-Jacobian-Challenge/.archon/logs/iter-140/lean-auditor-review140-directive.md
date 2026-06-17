# Lean Auditor Directive

## Slug
review140

## Scope (files)
all .lean files under `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/` (and `AlgebraicJacobian.lean` if present at the project root). Exclude `.lake/`, `lake-packages/`, and `.archon/multilane/lanes/**` snapshots.

## Focus areas (optional)
- `AlgebraicJacobian/Cotangent/GrpObj.lean` — received prover work this iter (iter-140 BUNDLED piece (i.b) Step 2 sub-sorry lane). Pay extra attention to the new `private theorem isIso_of_app_iso_module` helper added at ~L544 and to the docstring expansions on `basechange_along_proj_two_inv_derivation` (~L552) and `relativeDifferentialsPresheaf_basechange_along_proj_two` (~L670).

## Known issues
- 6 declarations using `sorry` (3 in `Cotangent/GrpObj.lean`: L573 derivation, L670 basechange_along_proj_two, L806 mulRight_globalises_cotangent; 2 in `Jacobian.lean`: L193 genusZeroWitness, L219 positiveGenusWitness; 1 in `RigidityKbar.lean`: L75 rigidity_over_kbar). These are honest scaffolds documented in the blueprint; do NOT report each as must-fix UNLESS the body/comments cross into excuse-comment territory.
- 7 inline `sorry` tokens total (matches iter-138/139 close): `Cotangent/GrpObj.lean` L624 (d_app), L643 (d_map), L689 (per-open IsIso lambda body inside `relativeDifferentialsPresheaf_basechange_along_proj_two`), L817 (mulRight_globalises_cotangent main); plus the 2 Jacobian + 1 RigidityKbar entries.
- Iter-137/138/139 docstrings on `_basechange_along_proj_two` describe closure-recipe analysis attached to `sorry`-bodied declarations; previous lean-auditors (iter-137, iter-138, iter-139) judged these as proof-design analysis, not excuse-comments — confirm or re-flag.

## Output path
`.archon/task_results/lean-auditor-review140.md`
