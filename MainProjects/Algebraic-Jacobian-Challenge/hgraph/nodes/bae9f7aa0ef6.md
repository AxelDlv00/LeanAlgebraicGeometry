---
author: sync
content_type: definition
created: '2026-07-30T09:32:36'
decl: AlgebraicGeometry.Scheme.PicScheme.twistLeft
docstring: 'The `γ`-twist of `T ×_k Spec k''` on underlying schemes: the identity
  on the `T`

  factor and `Spec γ` on the `Spec k''` factor.


  Well defined because `Spec γ` is a morphism over `Spec k` (`specGal_comp`), so the

  twisted pair still satisfies the pullback condition.'
file: AlgebraicJacobian/Picard/GaloisDescent/PicEtGaloisBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.twistLeft
type: lean
updated: '2026-07-30T09:32:36'
---
noncomputable def twistLeft (T : Over (Spec (CommRingCat.of k))) (γ : k' ≃ₐ[k] k') :
    pullback T.hom (specMapAlgebra k k') ⟶ pullback T.hom (specMapAlgebra k k') :=
  pullback.lift (pullback.fst _ _) (pullback.snd _ _ ≫ specGal γ) (by
    rw [Category.assoc, specGal_comp]
    exact pullback.condition)