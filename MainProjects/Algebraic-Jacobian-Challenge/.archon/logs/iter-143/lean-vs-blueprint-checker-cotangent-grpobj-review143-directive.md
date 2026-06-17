# Lean ↔ Blueprint Checker Directive

## Slug
cotangent-grpobj-review143

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex

(Note: the pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` exists and routes to `RigidityKbar.tex` for all substantive content. You may glance at the pointer for orientation but the substantive `\lean{...}` declarations live in `RigidityKbar.tex`.)

## Known issues
- The iter-143 Wave 2 blueprint-writer expanded `RigidityKbar.tex` 1349 → 1634 LOC (+285) with: (a) Iter-142 empirical-lessons NOTE at L713 of the d_app recipe (three Rules: fully-explicit `change`, `NatTrans.naturality_apply` packaging, `pushforward_obj_map_apply'`), (b) decomposed Step 3 (3.a–3.d) sub-recipe at L786 for the adjunction-transpose chase, (c) iter-143 IsIso refactor NOTE at L1132 pointing downstream at `basechange_along_proj_two_inv_app_isIso`, (d) Route (b'2) items 2/3/4 concrete sub-recipes, (e) iter-142 d_map closed status note at L868.
- The iter-143 Wave 2 refactor inserted a NEW top-level theorem `basechange_along_proj_two_inv_app_isIso` (Lean L745–L751) that did NOT exist in the iter-142 blueprint as a stand-alone block. Check whether the iter-143 blueprint-writer added a corresponding `\lean{...}` block for it (per the iter-143 plan-agent's Wave 2 description, the NOTE at L1132 references it; check whether a proper `\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_app_isIso}` block was also added).
- The iter-143 prover did NOT close the d_app sub-sorry at L663; the body has new in-Lean comment scaffolding + 1-LOC `have hw` at L637–L638 but the iter-143+ residual chase remains `sorry` at L663. The d_map sub-sorry remains closed (iter-142 closure preserved at L664–L700).
- Long docstrings on `basechange_along_proj_two_inv_derivation` (L520–L572), `basechange_along_proj_two_inv` (L702–L710), `relativeDifferentialsPresheaf_basechange_along_proj_two` (L726–L744), and the new `basechange_along_proj_two_inv_app_isIso` (L727–L744) document the proof design (iter-140/142 lean-auditor verdict: NOT excuse-comments).
- The pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` iter-138 status text (L46–L49) reportedly says "d_app + d_map + IsIso" — d_map closed iter-142; per the iter-143 plan agent's iter-144+ stale-marker cleanup list, this pointer text is stale (cosmetic, low priority).
