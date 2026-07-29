---
author: sync
content_type: theorem
created: '2026-07-30T03:33:55'
decl: AlgebraicGeometry.Scheme.PicScheme.crossBaseTotalIso_naturality
docstring: '**The naturality square for `crossBaseTotalIso`**, in the project''s own

  spelling: the cancellation iso commutes with the base-change morphisms

  `PicSharp.baseChangeOverC` that `relFunctorial` acts by.


  This is `pullbackLeftPullbackSndIso_naturality` applied at

  `f = C.hom`, `φ = Spec k'' ⟶ Spec k` — it needs no separate argument, because

  `baseChangeOverC` is by definition the `pullback.map` of the generic lemma and

  `crossBaseTotalIso` is by definition its `pullbackLeftPullbackSndIso`.'
file: AlgebraicJacobian/Picard/PicEtCrossBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.crossBaseTotalIso_naturality
type: lean
updated: '2026-07-30T03:33:55'
---
theorem crossBaseTotalIso_naturality (C : Over (Spec (CommRingCat.of k)))
    (T T' : Over (Spec (CommRingCat.of k'))) (g : T' ⟶ T) :
    PicSharp.baseChangeOverC (baseChangeField C k').hom T.hom T'.hom g.left
          (Over.w g).symm
        ≫ (crossBaseTotalIso C T).hom
      = (crossBaseTotalIso C T').hom
        ≫ PicSharp.baseChangeOverC C.hom ((restrictTest k k').obj T).hom
            ((restrictTest k k').obj T').hom g.left
            (Over.w ((restrictTest k k').map g)).symm :=
  pullbackLeftPullbackSndIso_naturality C.hom (specMapAlgebra k k') T.hom T'.hom
    g.left (Over.w g).symm