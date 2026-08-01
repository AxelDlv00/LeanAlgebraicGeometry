---
author: sync
content_type: theorem
created: '2026-08-01T13:18:07'
decl: Algebra.DescentDatum.Hom.comp_assoc
file: AlgebraicJacobian/Descent/AlgebraDescent.lean
generated: lean
lean_status: lean_ok
title: Algebra.DescentDatum.Hom.comp_assoc
type: lean
updated: '2026-08-01T13:18:07'
---
theorem comp_assoc {U : Type u} [CommRing U]
    [Algebra A U] [Algebra B U] [IsScalarTower A B U]
    {D₄ : DescentDatum A B U} (f : Hom D₁ D₂) (g : Hom D₂ D₃)
    (h : Hom D₃ D₄) :
    comp (comp f g) h = comp f (comp g h) := by
  ext
  rfl