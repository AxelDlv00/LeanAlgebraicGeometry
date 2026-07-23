---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.FreeCechEngine.combHomotopy_zero
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FreeCechEngine.combHomotopy_zero
type: lean
updated: '2026-07-16T21:14:26'
---
@[simp] lemma combHomotopy_zero (r : ι) :
    combHomotopy (M := M) (n := n) r 0 = 0 := by
  funext τ; simp [combHomotopy]