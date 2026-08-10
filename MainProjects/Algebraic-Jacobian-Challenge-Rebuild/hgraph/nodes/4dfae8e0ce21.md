---
author: sync
content_type: definition
created: '2026-08-10T13:01:42'
decl: AlgebraicGeometry.PicRankOneEvaluationDivisorData.AbelInverse
docstring: 'The separate uniqueness obligation saying every divisor in the rank-one
  presentation

  preimage is the canonical evaluation divisor of its Abel class.'
file: AlgebraicJacobian/Picard/Pic0RankOneFibrePresentedProducer.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRankOneEvaluationDivisorData.AbelInverse
type: lean
updated: '2026-08-10T13:01:42'
---
def AbelInverse (E : PicRankOneEvaluationDivisorData pi) : Prop :=
  rankOneAbelSigma pi ≫ E.divisor = 𝟙 _