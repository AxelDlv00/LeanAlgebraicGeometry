---
author: sync
content_type: theorem
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.DivRepAffinePullbackAff.pull_classify
docstring: Pulling the canonical classifier recovers the widened class.
file: AlgebraicJacobian/Picard/DivRepGlobalClassifyAff.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivRepAffinePullbackAff.pull_classify
type: lean
updated: '2026-08-18T20:50:56'
---
theorem pull_classify
    (D : DivRepAffinePullbackAff hpi g r1 r2 b1 b2)
    (S : Type u) [CommRing S] [Algebra k S] (F : DivFamZarAff C S g) :
    D.pull S (divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2 S F) = F := by
  exact eq_of_isDivRepClassifyAff hpi g hO hchi r1 r2 b1 b2 _ _
    (D.isDivRepClassify_pull S _)
    (divRepClassifyZarAff_isDivRepClassifyAff hpi g hO hchi r1 r2 b1 b2 F)

include hO hchi in