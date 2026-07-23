---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.radical_vanishingIdeal
file: AlgebraicJacobian/Picard/GenericFlatnessGeometric.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.radical_vanishingIdeal
type: lean
updated: '2026-07-16T21:14:27'
---
lemma radical_vanishingIdeal (Z : TopologicalSpace.Closeds S) :
    (Scheme.IdealSheafData.vanishingIdeal Z).radical =
      Scheme.IdealSheafData.vanishingIdeal Z := by
  rw [← Scheme.IdealSheafData.vanishingIdeal_support, support_vanishingIdeal]