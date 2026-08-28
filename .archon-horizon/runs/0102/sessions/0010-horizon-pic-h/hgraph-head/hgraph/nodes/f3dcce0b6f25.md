---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.awayPullbackIso
docstring: 'The pullback of two principal-open inclusions

  `Spec R[1/x] → Spec R ← Spec R[1/y]` is `Spec R[1/(xy)]`: combine `pullbackSpecIso`

  (the pullback is `Spec` of the tensor product) with the localisation identification

  `R[1/x] ⊗_R R[1/y] ≅ R[1/(xy)]`.  Stated over a general base ring so its proof term

  carries the needed `IsScalarTower` instances (avoiding a typeclass timeout over
  the

  heavy chart ring).'
file: AlgebraicJacobian/Picard/GrassmannianGlue.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.awayPullbackIso
type: lean
updated: '2026-08-01T09:44:15'
---
noncomputable def awayPullbackIso {A : Type*} [CommRing A] (x y : A) :
    Limits.pullback
        (Spec.map (CommRingCat.ofHom (algebraMap A (Localization.Away x))))
        (Spec.map (CommRingCat.ofHom (algebraMap A (Localization.Away y)))) ≅
      Spec (CommRingCat.of (Localization.Away (x * y))) :=
  letI : IsLocalization.Away (x * y)
      (TensorProduct A (Localization.Away x) (Localization.Away y)) :=
    IsLocalization.Away.mul' (Localization.Away x) _ x y
  (pullbackSpecIso A (Localization.Away x) (Localization.Away y)) ≪≫
    Scheme.Spec.mapIso
      ((IsLocalization.algEquiv (Submonoid.powers (x * y))
        (TensorProduct A (Localization.Away x) (Localization.Away y))
        (Localization.Away (x * y))).toRingEquiv.toCommRingCatIso).symm.op