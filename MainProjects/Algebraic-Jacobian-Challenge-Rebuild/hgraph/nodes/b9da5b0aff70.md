---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.fromSpecAffine_resAlgHom
docstring: '**Restriction coherence of `fromSpecAffine`**: the affine-open test object
  of a

  smaller affine open factors through that of a larger one, along `Spec` of the section

  restriction.'
file: AlgebraicJacobian/Picard/PicEtUnit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.fromSpecAffine_resAlgHom
type: lean
updated: '2026-08-01T09:44:16'
---
theorem fromSpecAffine_resAlgHom {T : Over (Spec (.of k))} {U V : T.left.affineOpens}
    (h : U.1 ≤ V.1) :
    Over.overSpecMap (Over.resAlgHom T h) ≫ fromSpecAffine T V = fromSpecAffine T U := by
  have he : U.1 ≤ (Over.Hom.left (𝟙 T)) ⁻¹ᵁ V.1 := fun x hx => by
    rw [Over.id_left]
    exact h hx
  rw [← Over.appLEAlgHom_id T V.1 U.1 he h, fromSpecAffine_naturality (𝟙 T) V U he,
    Category.comp_id]