---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.coverArrowOverSigmaIso
docstring: 'In `Over X`, the cover arrow `Over.mk (Sigma.desc 𝒰.f)` is the coproduct
  of the member

  arrows `Over.mk (𝒰.f i)`.  Project-local component of the Stub-1 distributivity
  step: the inner

  `∐ᵢ Uᵢ` of the fibre power, transported into `Over X`.'
file: AlgebraicJacobian/Cohomology/CechSectionIdentificationBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.coverArrowOverSigmaIso
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def coverArrowOverSigmaIso (𝒰 : X.OpenCover) :
    (∐ fun i : 𝒰.I₀ => Over.mk (𝒰.f i)) ≅ Over.mk (Sigma.desc 𝒰.f) :=
  (coproductIsCoproduct _).coconePointUniqueUpToIso (coverArrowOverIsColimit 𝒰)