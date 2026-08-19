---
author: sync
content_type: theorem
created: '2026-08-19T06:28:15'
decl: AlgebraicGeometry.specMap_algHom_comp_algebraMap
docstring: The spectrum of an algebra homomorphism lies over the base spectrum.
file: AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.specMap_algHom_comp_algebraMap
type: lean
updated: '2026-08-19T09:50:24'
---
theorem specMap_algHom_comp_algebraMap
    {R A B : Type u} [CommRing R] [CommRing A] [CommRing B]
    [Algebra R A] [Algebra R B] (r : A →ₐ[R] B) :
    Spec.map (CommRingCat.ofHom r.toRingHom) ≫
        Spec.map (CommRingCat.ofHom (algebraMap R A)) =
      Spec.map (CommRingCat.ofHom (algebraMap R B)) := by
  rw [← Spec.map_comp]
  rw [← CommRingCat.ofHom_comp]
  congr 1
  ext x
  exact r.commutes x

@[reassoc]