---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.unitEndSection_id
docstring: The section of the identity endomorphism of the unit sheaf is `1`. Project-local.
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.unitEndSection_id
type: lean
updated: '2026-07-16T21:14:27'
---
lemma unitEndSection_id {X : Scheme.{0}} :
    unitEndSection (𝟙 (SheafOfModules.unit X.ringCatSheaf)) = 1 := rfl