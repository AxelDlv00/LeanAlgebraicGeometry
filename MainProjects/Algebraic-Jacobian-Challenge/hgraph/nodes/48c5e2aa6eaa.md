---
author: sync
content_type: theorem
created: '2026-07-28T15:48:27'
decl: AlgebraicGeometry.isDominant_opens_ι
docstring: '**A dense open inclusion is dominant.** Used to transport an equation
  proved on a

  dense open to the whole (reduced) scheme.'
file: AlgebraicJacobian/Albanese/AlbaneseFromData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isDominant_opens_ι
type: lean
updated: '2026-07-28T15:48:27'
---
theorem isDominant_opens_ι {X : Scheme.{u}} (V : X.Opens) (hV : Dense (V : Set X)) :
    IsDominant V.ι := by
  rw [isDominant_iff]
  simpa [DenseRange, Scheme.Opens.range_ι] using hV