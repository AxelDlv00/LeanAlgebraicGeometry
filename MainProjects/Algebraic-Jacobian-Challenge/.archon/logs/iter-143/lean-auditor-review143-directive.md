# Lean Auditor Directive

## Slug
review143

## Scope (files)
all

## Focus areas
- `AlgebraicJacobian/Cotangent/GrpObj.lean` (prover-touched this iter — d_app body received new in-Lean comment scaffolding at L602–L662 and a 1-LOC `have hw` at L637–L638; the residual sorry at L663 is the iter-143+ continuation. Pay extra attention to the new ~60 LOC of in-Lean comments around the d_app sorry to flag any excuse-comment patterns vs honest deferred-work documentation.)
- `AlgebraicJacobian/Cotangent/GrpObj.lean` lines 745–751 (NEW iter-143 sorry-bodied theorem `basechange_along_proj_two_inv_app_isIso` extracted from a previously-embedded `(fun _ => sorry)` in the iter-143 Wave 2 refactor). Audit whether the new declaration's name, signature, and docstring are consistent with standard Lean naming + audit transparency.

## Known issues
- 6 declaration-level sorries / 6 inline sorries persist across the project (carry-over from iter-142). Specifically: 3 in `Cotangent/GrpObj.lean` (L573 derivation with internal d_app at L663, L745 `basechange_along_proj_two_inv_app_isIso`, L890 `mulRight_globalises_cotangent`), 2 in `Jacobian.lean` (L193, L219), 1 in `RigidityKbar.lean` (L75).
- The 3 long docstrings on `Cotangent/GrpObj.lean` `basechange_along_proj_two_inv_derivation` (L520–L572), `basechange_along_proj_two_inv` (L702–L710), and `relativeDifferentialsPresheaf_basechange_along_proj_two` (L726–L744) were re-confirmed proof-design analysis (NOT excuse-comments) by `lean-auditor-review140` and `lean-auditor-review142`. Re-flag only if the iter-143 changes around L602–L662 introduce NEW excuse-comment pattern relative to those prior verdicts.

## Absolute paths to read
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RigidityKbar.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Rigidity.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelJacobi.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/MayerVietoris.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/SheafCompose.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean
