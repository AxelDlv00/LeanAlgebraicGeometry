---
author: sync
content_type: lemma
created: '2026-08-13T10:39:11'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.coe_unitsRestrict
docstring: 'The underlying section of a restricted unit is the restriction of its
  underlying

  section.'
file: AlgebraicJacobian/Picard/DivisorDatumSectionOfClass.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.BasicOpenCocycleDatum.coe_unitsRestrict
type: lean
updated: '2026-08-18T20:51:00'
---
private lemma coe_unitsRestrict {X : Scheme.{u}} {W U : X.Opens} (h : W ≤ U)
    (u : Γ(X, U)ˣ) :
    ((X.unitsRestrict h u : Γ(X, W)ˣ) : Γ(X, W)) = X.resHom h (u : Γ(X, U)) :=
  rfl

/-! ## The α-corrected local sections and their matching law -/