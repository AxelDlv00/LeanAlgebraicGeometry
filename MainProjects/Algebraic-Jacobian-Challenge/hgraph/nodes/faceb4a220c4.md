---
author: sync
content_type: definition
created: '2026-07-30T03:33:55'
decl: AlgebraicGeometry.Scheme.PicScheme.crossBaseProjPullbackIsoInv
docstring: 'The mirror of `crossBaseProjPullbackIso`, in the `hom` direction, from

  `crossBaseTotalIso_hom_snd`.'
file: AlgebraicJacobian/Picard/PicEtCrossBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.crossBaseProjPullbackIsoInv
type: lean
updated: '2026-07-30T03:33:55'
---
noncomputable def crossBaseProjPullbackIsoInv (C : Over (Spec (CommRingCat.of k)))
    (T : Over (Spec (CommRingCat.of k'))) :
    Scheme.Modules.pullback (pullback.snd C.hom ((restrictTest k k').obj T).hom)
        ⋙ Scheme.Modules.pullback (crossBaseTotalIso C T).hom
      ≅ Scheme.Modules.pullback (pullback.snd (baseChangeField C k').hom T.hom) :=
  Scheme.Modules.pullbackComp _ _ ≪≫
    Scheme.Modules.pullbackCongr (crossBaseTotalIso_hom_snd C T)