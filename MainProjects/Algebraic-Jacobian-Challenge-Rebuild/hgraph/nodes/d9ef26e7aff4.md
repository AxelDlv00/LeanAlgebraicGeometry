---
author: sync
content_type: lemma
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.shiftMap_coe
file: AlgebraicJacobian/RiemannRoch/JumpDimension.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.shiftMap_coe
type: lean
updated: '2026-07-31T20:14:51'
---
@[simp] lemma shiftMap_coe (a : ℤ) (g : ↥(pointLattice K hx a)) :
    (shiftMap K hx a g : X.functionField) = uniformizer K hx ^ a * (g : X.functionField) :=
  rfl