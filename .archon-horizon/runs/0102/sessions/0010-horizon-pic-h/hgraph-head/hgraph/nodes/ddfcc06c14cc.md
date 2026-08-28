---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.Hom.pullbackUnitsCocycle_ev
file: AlgebraicJacobian/Picard/UnitsCocycle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Hom.pullbackUnitsCocycle_ev
type: lean
updated: '2026-08-01T09:44:17'
---
lemma pullbackUnitsCocycle_ev (γ : Y.unitsCocycle 𝒰) (x y : X) {T : X.Opens}
    (a : T ⟶ (𝒰.pullback f).opens x) (b : T ⟶ (𝒰.pullback f).opens y) :
    (f.pullbackUnitsCocycle γ).ev x y a b
      = f.unitsAppLE (𝒰.opens (f.base x) ⊓ 𝒰.opens (f.base y)) T
          (f.le_preimage_inf a.le b.le) (unitsEvInf γ (f.base x) (f.base y)) :=
  rfl

@[simp]