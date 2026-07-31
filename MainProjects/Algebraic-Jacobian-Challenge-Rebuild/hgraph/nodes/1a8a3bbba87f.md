---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicJacobian.Diagonal.pointBaseChange_pointGen
docstring: The base change kills the point generator.
file: AlgebraicJacobian/Algebra/PointFiberIdeal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.Diagonal.pointBaseChange_pointGen
type: lean
updated: '2026-07-31T20:15:16'
---
lemma pointBaseChange_pointGen : pointBaseChange B F (pointGen k B F) = 0 := by
  rw [pointGen, map_sub, pointBaseChange_tmul, pointBaseChange_tmul, coord_tmul_one_point,
    sub_self]

/-! ### The telescoping identity and the kernel of the base change (mirror of (a)) -/

omit [Algebra (Polynomial k) B] [IsScalarTower k (Polynomial k) B]
  [Algebra (Polynomial k) F] [IsScalarTower k (Polynomial k) F] in