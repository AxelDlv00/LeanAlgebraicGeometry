---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.Hom.coe_unitsAppLE
file: AlgebraicJacobian/Picard/UnitsPresheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Hom.coe_unitsAppLE
type: lean
updated: '2026-07-30T15:46:07'
---
lemma coe_unitsAppLE (e : U ≤ f ⁻¹ᵁ V) (u : Γ(Y, V)ˣ) :
    (f.unitsAppLE V U e u : Γ(X, U)) = f.appLE V U e u :=
  rfl

/-- Restriction after pullback: the unit-level mirror of `Scheme.Hom.appLE_map`. -/
@[simp]