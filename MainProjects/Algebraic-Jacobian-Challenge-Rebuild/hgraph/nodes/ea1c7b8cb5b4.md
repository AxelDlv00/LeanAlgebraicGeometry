---
author: sync
content_type: definition
created: '2026-07-31T16:07:32'
decl: AlgebraicGeometry.relPicToPicEtEquiv_of_section
docstring: '**The functor-level unit is a group isomorphism over a section-admitting
  field test**

  (Kleiman 2.5, both parts, at the level of the sheafified functor): if the curve
  admits a

  `K`-point `σ`, the unit component `relPicToPicEt C (Spec K)` is a `MulEquiv`

  `relPic C (Spec K) ≃* picEt C (Spec K)`.


  It is `PicEtAff.unitEquiv_of_section` conjugated by the affine comparison

  `picEtAffineEquiv`; `relPicToPicEtEquiv_of_section_apply` records that its underlying
  map

  is `relPicToPicEt`, so nothing about the honest unit is lost in the packaging.'
file: AlgebraicJacobian/Picard/PicEtUnitFieldComparison.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relPicToPicEtEquiv_of_section
type: lean
updated: '2026-08-01T09:44:16'
---
noncomputable def relPicToPicEtEquiv_of_section (σ : overSpec k K ⟶ C) :
    relPic C (overSpec k K) ≃* picEt C (overSpec k K) :=
  (PicEtAff.unitEquiv_of_section C K σ).trans (picEtAffineEquiv C K).symm

/-- The field-point isomorphism's underlying map is the functor-level unit
`relPicToPicEt` — so it is the honest unit made bijective, not a different arrow. -/
@[simp]