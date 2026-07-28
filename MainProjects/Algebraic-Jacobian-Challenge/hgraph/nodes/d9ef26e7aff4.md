---
author: sync
content_type: lemma
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.shiftMap_coe
file: AlgebraicJacobian/RiemannRoch/Ledger/JumpDimension.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.shiftMap_coe
type: lean
updated: '2026-07-28T18:12:20'
---
@[simp] lemma shiftMap_coe (a : ℤ) (g : ↥(pointLattice K hx a)) :
    (shiftMap K hx a g : X.functionField) = uniformizer K hx ^ a * (g : X.functionField) :=
  rfl