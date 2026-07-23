---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.GradedModule.coker_isHomogeneous
docstring: The cokernel subquotient's upper module `N' ⊔ x·N` is homogeneous. Project-local.
file: AlgebraicJacobian/Picard/GradedHilbertSerre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GradedModule.coker_isHomogeneous
type: lean
updated: '2026-07-24T03:02:10'
---
lemma coker_isHomogeneous {x : M →ₗ[κ] M} (hx : RaisesDegree ℳ x)
    {N N' : Submodule κ M} (hN : N.IsHomogeneous ℳ) (hN' : N'.IsHomogeneous ℳ) :
    (N' ⊔ N.map x).IsHomogeneous ℳ :=
  sup_isHomogeneous ℳ hN' (map_isHomogeneous ℳ hx hN)

omit [DirectSum.Decomposition ℳ] in