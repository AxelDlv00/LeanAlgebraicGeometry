---
author: sync
content_type: lemma
created: '2026-07-19T15:01:16'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.inv_unitsEvInf
docstring: The pair value of an inverse unit cocycle is the inverse pair value.
file: AlgebraicJacobian/Picard/DivisorDatumInverse.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.BasicOpenCocycleDatum.inv_unitsEvInf
type: lean
updated: '2026-07-31T20:15:23'
---
private lemma inv_unitsEvInf {X : Scheme.{u}} {𝒰 : X.PointedCover}
    (γ : X.unitsCocycle 𝒰) (i j : X) :
    Scheme.unitsEvInf γ⁻¹ i j = (Scheme.unitsEvInf γ i j)⁻¹ := rfl