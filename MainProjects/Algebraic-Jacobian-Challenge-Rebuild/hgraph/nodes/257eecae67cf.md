---
author: sync
content_type: theorem
created: '2026-07-29T15:26:06'
decl: AlgebraicGeometry.abelDiv_isPlusHonest
docstring: '**THE ABEL VALUE IS HONEST AT EVERY TEST** — the witness that carries
  weight, and the one this

  file''s header cited by name before it existed (see the header''s own retraction).


  The θ- and Σ-family witnesses above are the *twist factors*, which `chartTwist_isPlusHonest`

  discharges anyway; they say nothing about the class being charted.  Since

  `chartValue = abelDiv · Σ · (θᵐ)⁻¹` and honesty is a subgroup condition, honesty
  of a **chart

  value** reduces to honesty of `abelDiv` — so this is the row that makes CHART-U(b)
  unconditional

  on the classes DAT-C''s Σ-chart actually reads.


  It is cheap for a structural reason: `abelDiv`''s components are `abelDivPlus`,
  i.e. `PicEtAff.unit`

  of `relPicMk` of the family''s class, and `relPicToPicEt`''s components are `PicEtAff.unit`
  of

  `relPicMap` — so the witness on the piece `U` is the class of the *restricted* family,
  and

  `abelDiv_val` plus `picEtMap_abelDiv` line the two up.'
file: AlgebraicJacobian/Picard/Pic0ChartPlusFibreProducer.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.abelDiv_isPlusHonest
type: lean
updated: '2026-07-31T20:15:27'
---
theorem abelDiv_isPlusHonest {n : ℕ} (T : Over (Spec (.of k)))
    (s : divFamZar C π n T) :
    IsPlusHonest C T (abelDiv C π n T s) := by
  intro U
  refine ⟨relPicMk C (overSpec k Γ(T.left, U.1))
    ((divFamZarAffineEquiv C π n Γ(T.left, U.1)
      (divFamZar.map C π n (Over.fromSpecAffine T U) s)).picClass), ?_⟩
  rw [picEtMap_abelDiv, abelDiv_overSpec]
  rfl

variable (C) in