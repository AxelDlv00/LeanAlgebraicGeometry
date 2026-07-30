---
author: sync
content_type: instance
created: '2026-07-31T04:59:31'
decl: AlgebraicJacobian.GaloisDescent.fieldGraph_isOpenImmersion
file: ProbePicFKernel.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicJacobian.GaloisDescent.fieldGraph_isOpenImmersion
type: lean
updated: '2026-07-31T06:25:57'
---
instance fieldGraph_isOpenImmersion (gamma : L ≃ₐ[K] L) :
    IsOpenImmersion (fieldGraph K L gamma) := by
  haveI : IsOpenImmersion
      (Sigma.ι (fun _ : L ≃ₐ[K] L ↦ Spec (CommRingCat.of L)) gamma) :=
    (Scheme.sigmaOpenCover
      (fun _ : L ≃ₐ[K] L ↦ Spec (CommRingCat.of L))).map_prop gamma
  unfold fieldGraph
  infer_instance