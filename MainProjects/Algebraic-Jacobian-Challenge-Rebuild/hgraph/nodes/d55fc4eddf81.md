---
author: sync
content_type: lemma
created: '2026-08-01T14:45:38'
decl: AlgebraicGeometry.GroupScheme.point_comp_rightMul_eq_point_comp_leftMul
file: AlgebraicJacobian/Descent/GroupAffineOpen.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GroupScheme.point_comp_rightMul_eq_point_comp_leftMul
type: lean
updated: '2026-08-02T07:12:48'
---
lemma point_comp_rightMul_eq_point_comp_leftMul
    (G : Over (Spec (.of K))) [GrpObj G]
    (p q : 𝟙_ (Over (Spec (.of K))) ⟶ G) :
    p ≫ rightMul G q = q ≫ leftMul G p := by
  rw [comp_rightMul, comp_leftMul]
  simp