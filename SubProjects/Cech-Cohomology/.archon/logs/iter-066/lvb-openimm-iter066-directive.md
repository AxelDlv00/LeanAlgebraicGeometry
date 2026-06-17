# lean-vs-blueprint-checker — OpenImmersionPushforward (iter-066)

Lean file: /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean
Blueprint chapter: /home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(the consolidated chapter; this file is declared via `% archon:covers AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`)

This iter closed `higherDirectImage_openimmersion_comp` (the `R^k f_*(j_* H) ≅ R^k (j∘f)_* H` STRETCH result),
all four sub-leaves (hacyc/eRes/hexact/transport). The blueprint `_comp` proof was rewritten last iter onto the
adjoint-preserves-injectives route for `hacyc` (NOT the flawed Serre-vanishing-on-U∩f⁻¹V route).

Verify bidirectionally:
- Lean → blueprint: does the closed Lean `_comp` faithfully follow the blueprint's rewritten proof? Any
  fake/placeholder statements, signature mismatches, or `\lean{}` names pointing at renamed/absent decls?
- Blueprint → Lean: is the chapter's `_comp` proof (esp. the `hacyc` adjoint route) detailed enough to have
  guided this formalization? Any stale prose still describing the abandoned Serre-vanishing route?
- Check the `higherDirectImage_openImmersion_acyclic` block reflects its closed (defeq φ'') state.

Report must-fix vs advisory. Write under task_results/.
