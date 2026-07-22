---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.unitsAppLE_congr_hom
docstring: Congruence in the morphism for `unitsAppLE` at fixed open and section.
file: AlgebraicJacobian/Picard/CechKernelGlue.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.unitsAppLE_congr_hom
type: lean
updated: '2026-07-16T21:33:28'
---
lemma unitsAppLE_congr_hom {X Y : Scheme.{u}} {f g : X ⟶ Y} (h : f = g)
    (V : Y.Opens) (O : X.Opens) (e : O ≤ f ⁻¹ᵁ V) (u : Γ(Y, V)ˣ) :
    f.unitsAppLE V O e u = g.unitsAppLE V O (h ▸ e) u := by
  subst h; rfl