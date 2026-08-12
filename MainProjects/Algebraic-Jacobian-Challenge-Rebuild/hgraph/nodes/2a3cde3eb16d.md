---
author: sync
content_type: theorem
created: '2026-08-12T15:42:08'
decl: AlgebraicJacobian.GaloisDescent.GaloisQuotientWitnessWithProjection.quotientMap_comp_base
file: AlgebraicJacobian/Descent/GaloisQuotientUniqueness.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.GaloisQuotientWitnessWithProjection.quotientMap_comp_base
type: lean
updated: '2026-08-12T15:42:08'
---
theorem quotientMap_comp_base
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    {rho : SemilinearGalAction K L X f}
    {Y : Scheme.{u}} {g : Y ⟶ Spec (CommRingCat.of K)}
    {q : X ⟶ Y}
    (w : GaloisQuotientWitnessWithProjection rho Y g q) :
    q ≫ g = f ≫ Spec.map (CommRingCat.ofHom (algebraMap K L)) := by
  rw [← w.projection]
  simp only [Category.assoc]
  rw [pullback.condition]
  rw [← w.over]
  simp

/-- The inverse of the pinned base-change isomorphism has the source structure
map as its second projection. -/
@[reassoc]