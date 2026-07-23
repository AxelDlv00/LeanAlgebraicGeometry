---
author: sync
content_type: lemma
created: '2026-07-16T21:14:25'
decl: AlgebraicGeometry.CombinatorialCech.combHomotopy_zero
file: AlgebraicJacobian/Cohomology/CechAcyclic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.CombinatorialCech.combHomotopy_zero
type: lean
updated: '2026-07-24T03:02:09'
---
@[simp] private lemma combHomotopy_zero (r : ι) :
    combHomotopy (M := M) (n := n) r 0 = 0 := by
  funext τ; simp [combHomotopy]