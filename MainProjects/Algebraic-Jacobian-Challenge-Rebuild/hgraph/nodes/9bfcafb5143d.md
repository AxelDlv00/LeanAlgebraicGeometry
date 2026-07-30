---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.unitsSndEquiv_apply
file: AlgebraicJacobian/Picard/ProjectionUnits.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.unitsSndEquiv_apply
type: lean
updated: '2026-07-30T15:28:02'
---
lemma unitsSndEquiv_apply {V : T.left.Opens} (hV : IsAffineOpen V) (v : Γ(T.left, V)ˣ) :
    unitsSndEquiv C T hV v
      = (snd C T).left.unitsAppLE V ((snd C T).left ⁻¹ᵁ V) le_rfl v :=
  rfl

/-! ## The `symm`/round-trip calculus -/