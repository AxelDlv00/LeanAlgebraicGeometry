---
author: sync
content_type: theorem
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.DivRepAffinePullbackAff.pullGlobal_classifyGlobal
docstring: The general-test pull and classifier are inverse on widened sections.
file: AlgebraicJacobian/Picard/DivRepGlobalClassifyAff.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivRepAffinePullbackAff.pullGlobal_classifyGlobal
type: lean
updated: '2026-08-07T05:01:47'
---
theorem pullGlobal_classifyGlobal
    (D : DivRepAffinePullbackAff hpi g r1 r2 b1 b2)
    {T : Over (Spec (CommRingCat.of k))} (F : divFamZarAff C g T) :
    pullGlobal (hpi := hpi) (g := g) (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2) D
        (classifyGlobal hpi g hO hchi r1 r2 b1 b2 F)
      = F := by
  refine divFamZarAff.ext fun W => ?_
  rw [pullGlobal_val, fromSpecAffine_classifyGlobal,
    pull_classify hpi g hO hchi r1 r2 b1 b2]

include hO hchi in