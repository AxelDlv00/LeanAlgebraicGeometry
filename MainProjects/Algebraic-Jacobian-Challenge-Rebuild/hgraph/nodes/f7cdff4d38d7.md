---
author: sync
content_type: theorem
created: '2026-07-29T07:37:19'
decl: AlgebraicGeometry.Scheme.cechPicMap_injective_of_isIso
docstring: '**Pullback along an isomorphism is injective on Čech Picard classes.**
  One face of

  `cechPicMapEquivOfIso`, named because a kernel *inclusion* consumes exactly this.'
file: AlgebraicJacobian/Tangent/CechPicIsoTransport.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.cechPicMap_injective_of_isIso
type: lean
updated: '2026-07-29T15:26:39'
---
theorem cechPicMap_injective_of_isIso (f : X ⟶ Y) [IsIso f] :
    Function.Injective (CechPic.map f) := by
  intro a b h
  have h2 := congrArg (CechPic.map (inv f)) h
  rwa [cechPicMap_map_inv f a, cechPicMap_map_inv f b] at h2