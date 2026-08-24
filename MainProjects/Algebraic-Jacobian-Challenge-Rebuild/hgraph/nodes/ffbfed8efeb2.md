---
author: sync
content_type: definition
created: '2026-08-04T10:53:20'
decl: AlgebraicGeometry.Scheme.Cover.RelativeGluingData.ofIdealSheafData
docstring: 'Compatible ideal sheaves on a locally directed open cover, viewed as relative
  gluing data

  for their associated closed subschemes.'
file: AlgebraicJacobian/Picard/IdealSheafRelativeGluing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Cover.RelativeGluingData.ofIdealSheafData
type: lean
updated: '2026-08-18T20:51:03'
---
noncomputable def ofIdealSheafData (𝒰 : S.OpenCover) [Category 𝒰.I₀]
    [𝒰.LocallyDirected] (I : ∀ i, (𝒰.X i).IdealSheafData)
    (hI : ∀ {i j} (f : i ⟶ j), (I j).comap (𝒰.trans f) = I i) :
    𝒰.RelativeGluingData where
  functor := subschemeFunctor 𝒰 I hI
  natTrans := subschemeNatTrans 𝒰 I hI
  equifibered := subschemeNatTrans_equifibered 𝒰 I hI