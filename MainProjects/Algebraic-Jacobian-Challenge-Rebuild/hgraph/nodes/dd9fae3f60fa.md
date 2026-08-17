---
author: sync
content_type: definition
created: '2026-08-17T13:21:30'
decl: AlgebraicGeometry.pic0FiniteStageTransportedTripleTransitionOfModels
docstring: 'The exact cyclic transition transported through the concrete triple-model

  comparisons.'
file: AlgebraicJacobian/Picard/Pic0FiniteStageTransportedTripleTransitionFace.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0FiniteStageTransportedTripleTransitionOfModels
type: lean
updated: '2026-08-17T13:21:30'
---
noncomputable def pic0FiniteStageTransportedTripleTransitionOfModels
    (U V W : Pic0FiniteStageChartIndex C) :=
  pic0FiniteStageTransportedTripleTransition C L n m relation M mapM
    (pic0FiniteStageTripleModelComparisonFamily
      C L n m relation e M mapM hmapM) (U, (V, W))

set_option maxHeartbeats 3200000 in
-- Inferred source and target types preserve the component-comparison instances.