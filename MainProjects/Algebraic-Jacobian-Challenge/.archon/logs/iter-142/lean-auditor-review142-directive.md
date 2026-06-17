# Lean Auditor Directive

## Slug
review142

## Scope (files)
all

## Focus areas (optional)
- `AlgebraicJacobian/Cotangent/GrpObj.lean` — this iteration's prover-touched file. The iter-142 prover lane closed one sub-sorry inside `basechange_along_proj_two_inv_derivation` (d_map at L643 was substantively discharged via `NatTrans.naturality_apply` + `relativeDifferentials'_map_d`), and extended the d_app explicit-`change` skeleton at L623–L626. Audit for excuse-comments, suspect bodies, dead-end tactic chains, parallel APIs, and the long-running multi-iter helper docstrings (the file has accumulated ~150 LOC of proof-design analysis distributed across `_basechange_along_proj_two`, `_basechange_along_proj_two_inv_derivation`, and `_basechange_along_proj_two_inv` docstrings/inline comments). Re-confirm or contest the iter-140 lean-auditor's defensive read that those docstrings are proof-design analysis (not excuse-comments).
- Pay extra attention to `Cotangent/GrpObj.lean:602–637` (d_app body with new closure-recipe comment block; ends in `sorry`), `Cotangent/GrpObj.lean:638–674` (d_map body — now closed; verify the `change`+`rw [show ... from ...]`+`exact` chain reads cleanly), and `Cotangent/GrpObj.lean:719–721` (IsIso `letI ... (fun _ => sorry)`).

## Known issues
- 6 declarations using `sorry` and 6 inline `sorry` occurrences across the project remain genuine open work (target lines in `AlgebraicJacobian/Cotangent/GrpObj.lean:573,701,833`, `AlgebraicJacobian/Jacobian.lean:193,219`, `AlgebraicJacobian/RigidityKbar.lean:75`). These are honest scaffolds — do NOT flag them as excuse-comments unless their docstrings make false claims about what was attempted.
- The `private theorem isIso_of_app_iso_module` at `Cotangent/GrpObj.lean` is iter-140 carry-over (upstream-PR candidate). It already passed prior audit.

## Absolute paths
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean
