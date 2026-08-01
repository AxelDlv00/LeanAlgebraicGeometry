---
author: sync
content_type: definition
created: '2026-08-01T14:45:38'
decl: AlgebraicGeometry.GroupScheme.leftMul
docstring: Left translation by a rational point of a group scheme.
file: AlgebraicJacobian/Descent/GroupAffineOpen.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GroupScheme.leftMul
type: lean
updated: '2026-08-01T14:45:38'
---
noncomputable def leftMul (G : Over (Spec (.of K))) [GrpObj G]
    (p : 𝟙_ (Over (Spec (.of K))) ⟶ G) : G ⟶ G :=
  lift (toUnit G ≫ p) (𝟙 G) ≫ μ