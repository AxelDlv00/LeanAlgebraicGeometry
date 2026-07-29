---
author: sync
content_type: theorem
created: '2026-07-29T22:53:22'
decl: AlgebraicGeometry.restrictedChartFibre_bot
file: scratch_p1/Probe3.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.restrictedChartFibre_bot
type: lean
updated: '2026-07-29T22:53:32'
---
theorem restrictedChartFibre_bot {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ)) :
    RestrictedChartFibre C π n rep m Z hdeg ⊥ := by
  intro T g
  refine ⟨⟨⊥, isInitialOfIsEmpty.to _, ?_, ?_⟩⟩
  · ext S x
    have : IsEmpty (S.unop : Scheme.{u}) := x.base.hom.1.isEmpty
    exact (sheaf_obj_subsingleton_of_isEmpty (C := C) S.unop).elim _ _
  · intro S v w hvw
    have : IsEmpty S := v.base.hom.1.isEmpty
    exact ⟨isInitialOfIsEmpty.to _, isInitialOfIsEmpty.hom_ext _ _,
      isInitialOfIsEmpty.hom_ext _ _⟩