---
author: sync
content_type: instance
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.devissageSES_mono_f
docstring: '**Left exactness certificate.** The inclusion `𝒪(D − x) ↪ 𝒪(D)` is a monomorphism,
  so the

  dévissage complex is exact at its left term (landed `divisorSheafLE_mono`).'
file: AlgebraicJacobian/RiemannRoch/Devissage.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.devissageSES_mono_f
type: lean
updated: '2026-07-30T15:28:04'
---
instance devissageSES_mono_f : Mono (devissageSES K hx D).f :=
  divisorSheafLE_mono K (devissageDivisor_le hx D)