---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.CechPic.extOpens
docstring: 'The members of the extension of a pointed cover across a clopen piece:
  the image of

  the member at the chosen preimage point over the range of `w`, the complement `Ω''`

  elsewhere.'
file: AlgebraicJacobian/Picard/CechPicClopenGlue.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.CechPic.extOpens
type: lean
updated: '2026-07-31T20:15:20'
---
noncomputable def extOpens (y : Y) : Y.Opens :=
  if hy : y ∈ w.opensRange then w ''ᵁ (𝒰₀.opens hy.choose) else Ω'