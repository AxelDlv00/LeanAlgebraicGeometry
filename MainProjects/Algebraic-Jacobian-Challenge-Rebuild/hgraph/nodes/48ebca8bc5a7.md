---
author: sync
content_type: theorem
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.overSpecMap_comp_divRepClassifyZarAff
docstring: Naturality of the widened affine classifier as a morphism over `Spec k`.
file: AlgebraicJacobian/Picard/DivRepClassifyZarAffNaturality.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.overSpecMap_comp_divRepClassifyZarAff
type: lean
updated: '2026-08-07T05:01:47'
---
theorem overSpecMap_comp_divRepClassifyZarAff
    {A B : Type u} [CommRing A] [Algebra k A] [CommRing B] [Algebra k B]
    (phi : A →ₐ[k] B) (F : DivFamZarAff C A g) :
    Over.overSpecMap phi ≫ divRepClassifyZarAff hpi g hO hchi r₁ r₂ b₁ b₂ A F
      = divRepClassifyZarAff hpi g hO hchi r₁ r₂ b₁ b₂ B
          (DivFamZarAff.mapAlgHom phi F) := by
  apply Over.OverMorphism.ext
  rw [Over.comp_left, Over.overSpecMap_left]
  exact specMap_comp_divRepClassifyZarAff hpi g hO hchi r₁ r₂ b₁ b₂ phi F

set_option maxHeartbeats 1600000 in
-- The proof changes algebra structures twice for the off-diagonal classifier faces.