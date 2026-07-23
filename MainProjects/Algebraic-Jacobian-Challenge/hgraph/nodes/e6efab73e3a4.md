---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechComplex_hom_identification
docstring: '**The Čech hom-identification** (blueprint `lem:cech_complex_hom_identification`).


  The cochain-complex isomorphism `Hom_{PMod}(K(𝒰)_•, F) ≅ Č•(𝒰, F)` identifying the

  hom-complex of the free Čech resolution with the section Čech complex of `F`. Obtained
  by

  applying the alternating-coface-map complex functor to the cosimplicial natural
  isomorphism

  `homCechSectionCosimplicialIso`, so the differential intertwining is automatic from
  the

  cosimplicial naturality.


  Project-local: the comparison of the free-resolution hom-complex with the section
  complex has

  no Mathlib counterpart.'
file: AlgebraicJacobian/Cohomology/CechBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechComplex_hom_identification
type: lean
updated: '2026-07-24T03:02:09'
---
noncomputable def cechComplex_hom_identification (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    (F : X.PresheafOfModules) :
    homCechComplex 𝒰 F ≅ sectionCechComplex (coverOpen 𝒰) F :=
  (AlgebraicTopology.alternatingCofaceMapComplex Ab.{u}).mapIso (homCechSectionCosimplicialIso 𝒰 F)

/-! ## Project-local Mathlib supplement — hom-complex as contravariant transport

The injective-acyclicity assembly (`lem:injective_cech_acyclic`, gated on Lane-1's
`cechFreeComplex_quasiIso`) needs `homCechComplex 𝒰 F` — the alternating *coface* complex of
the hom-cosimplicial object `homCechCosimplicial 𝒰 F` — to be identified with the
contravariant transport `Hom(-, F) = preadditiveYoneda.obj F` of the *opposite* of the free
Čech chain complex `cechFreePresheafComplex 𝒰`.  Once this identification is in hand,
`quasiIso_map_preadditiveYoneda_of_injective` (applied to `(cechFreeComplexAug 𝒰).op`) and
`cechComplex_hom_identification` combine in a single step to turn the free resolution into
Čech acyclicity of injective sheaves.

Project-local: the comparison of the alternating-coface hom-complex with the mapped opposite
of the alternating-face free complex has no Mathlib counterpart. -/