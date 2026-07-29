---
author: sync
content_type: theorem
created: '2026-07-30T03:33:55'
decl: AlgebraicGeometry.Scheme.PicScheme.crossBase_relPicRel_inv
docstring: '**The mirror relation transport.** Symmetric to `crossBase_relPicRel`,
  with

  the same coset witness, via `crossBaseProjPullbackIsoInv`.'
file: AlgebraicJacobian/Picard/PicEtCrossBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.crossBase_relPicRel_inv
type: lean
updated: '2026-07-30T03:33:55'
---
theorem crossBase_relPicRel_inv (C : Over (Spec (CommRingCat.of k)))
    (T : Over (Spec (CommRingCat.of k')))
    {L L' : LineBundle.OnProduct C.hom ((restrictTest k k').obj T).hom}
    (h : PicSharp.relPicRel C.hom ((restrictTest k k').obj T).hom L L') :
    PicSharp.relPicRel (baseChangeField C k').hom T.hom
      (crossBaseOnProductInv C T L) (crossBaseOnProductInv C T L') := by
  obtain ⟨N, hN, ⟨e⟩⟩ := h
  refine ⟨N, hN, ⟨?_⟩⟩
  refine (Scheme.Modules.pullback (crossBaseTotalIso C T).hom).mapIso e ≪≫ ?_
  refine Modules.pullbackTensorIsoOfLocallyTrivial _ _ _
    (LineBundle.pullbackAlongProjection _ _ N hN).isLocallyTrivial
    L'.isLocallyTrivial ≪≫ ?_
  exact Modules.tensorObjIsoOfIso ((crossBaseProjPullbackIsoInv C T).app N) (Iso.refl _)