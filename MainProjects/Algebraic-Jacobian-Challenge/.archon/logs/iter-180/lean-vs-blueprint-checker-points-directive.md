# lean-vs-blueprint-checker — Points.lean ↔ AbelianVarietyRigidity.tex

## File pair

- **Lean**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects/Points.lean`
- **Blueprint**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex` (covers Points.lean).

## What changed this iter (Lane B — iter-180)

- 5 new axiom-clean supporting declarations to install `gm_grpObj`: `gmHomFunctor`, `gmHomEquiv_toFun`, `gmHomEquiv_invFun`, `gmHomEquiv_invFun_isOver`, `gmHomEquiv_homEquiv_comp`.
- 2 substantive sorries on round-trip identities: `gmHomEquiv_left_inv` (L382), `gmHomEquiv_right_inv` (L400).
- `gm_grpObj` body now `GrpObj.ofRepresentableBy (Gm kbar) (gmHomFunctor kbar) (gmHomFunctor_representableBy kbar)` (canonical Mathlib idiom). Transitively carries sorryAx via the 2 round-trip helpers.

## Report bidirectionally

1. **Lean → blueprint**: do the chapter's `\lean{...}` pins reference `gm_grpObj` or any of the new helpers? Should any be added? Any signature mismatches?
2. **Blueprint → Lean**: is the chapter detailed enough on the units-of-global-sections functor route (Yoneda + `GrpObj.ofRepresentableBy`) to guide iter-181 closing of the 2 round-trip identities? Cross-reference the persistent recipe `analogies/gm-grpobj-representable.md` for the canonical Mathlib idiom.

Output to `task_results/lean-vs-blueprint-checker-points.md`.
