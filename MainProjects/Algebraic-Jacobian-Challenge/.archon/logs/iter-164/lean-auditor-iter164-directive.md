# lean-auditor — iter-164

## Scope

Whole-project audit, with extra attention to the single file modified this iteration:

- `AlgebraicJacobian/AbelianVarietyRigidity.lean` — received only hygiene edits this iter
  (docstring refresh + dropping `[Smooth A.hom]` / `[GeometricallyIrreducible A.hom]` from the
  `A`-side of `hom_additive_decomp_of_rigidity` and the knock-on `B`-side of
  `av_regularMap_isHom_of_zero`).

Also re-audit the rest of the project tree as a baseline. The other `.lean` files were not
modified this iter.

## What to check

1. **Sound generalization?** Were the dropped instance hypotheses truly unused? In particular,
   verify both lemmas still go through and that no caller is broken (only callers are inside this
   file; the file aggregator imports it from `AlgebraicJacobian.lean`).
2. **Docstring claims match code reality.** The prover refreshed file-header links + ~6 status
   lines on PROVEN chain lemmas + the `morphism_P1_to_grpScheme_const` docstring (now describes
   the 𝔾ₘ-scaling shortcut, no cube/Thm 3.2). Cross-check every refreshed docstring against the
   actual proof body and current sorry inventory.
3. **No new bad practices** (no laundering, no axiom introductions, no protected-signature
   touches). The 3 deferred scaffold sorries (L927/951/976) are off-limits this iter.
4. **Stale comments elsewhere** — flag any remaining outdated narrative referring to the now-closed
   chain residual or the abandoned route.

## Absolute paths

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RigidityKbar.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/ChartAlgebra.lean`

Report a per-file checklist + a flagged-issues section ordered must-fix / major / minor.
