---
author: sync
content_type: theorem
created: '2026-07-17T10:19:49'
decl: AlgebraicGeometry.Scheme.RationalMap.hom_ext_of_toRationalMap_eq
docstring: 'Morphisms from a reduced scheme to a separated scheme are determined by

  their rational-map class: if `g₁.toRationalMap = g₂.toRationalMap` then

  `g₁ = g₂`. This is the reduced-and-separated agreement principle

  (`AlgebraicGeometry.ext_of_isDominant`) routed through the `PartialMap`

  equivalence: the two morphisms agree on a common dense open.'
file: AlgebraicJacobian/Albanese/CodimOneExtensionUnique.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.RationalMap.hom_ext_of_toRationalMap_eq
type: lean
updated: '2026-07-30T15:28:06'
---
theorem hom_ext_of_toRationalMap_eq {X Y : Scheme.{u}} [IsReduced X]
    [Y.IsSeparated] {g₁ g₂ : X ⟶ Y}
    (e : g₁.toRationalMap = g₂.toRationalMap) : g₁ = g₂ := by
  obtain ⟨W, hW, hle₁, hle₂, he⟩ := PartialMap.toRationalMap_eq_iff.mp e
  haveI : IsDominant W.ι := Opens.isDominant_ι hW
  exact ext_of_isDominant W.ι (by simpa [Scheme.Hom.toPartialMap] using he)

set_option backward.isDefEq.respectTransparency false in