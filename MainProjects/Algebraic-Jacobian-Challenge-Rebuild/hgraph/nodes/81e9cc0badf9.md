---
author: sync
content_type: definition
created: '2026-08-01T14:45:38'
decl: AlgebraicGeometry.GroupScheme.rightMul
docstring: Right translation by a rational point of a group scheme.
file: AlgebraicJacobian/Descent/GroupAffineOpen.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GroupScheme.rightMul
type: lean
updated: '2026-08-02T07:12:48'
---
noncomputable def rightMul (G : Over (Spec (.of K))) [GrpObj G]
    (p : 𝟙_ (Over (Spec (.of K))) ⟶ G) : G ⟶ G :=
  lift (𝟙 G) (toUnit G ≫ p) ≫ μ