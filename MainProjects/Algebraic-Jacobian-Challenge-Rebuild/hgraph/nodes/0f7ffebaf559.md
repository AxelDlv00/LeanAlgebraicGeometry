---
author: sync
content_type: definition
created: '2026-07-28T17:25:29'
decl: AlgebraicGeometry.Scheme.IsTrimmedTrivializing
docstring: '**The trivializing relation of a chart cochain**, as a standalone predicate:
  `t` trivializes

  the cocycle `γ` on the `W`-trimmings of the members of `𝒩`. This is exactly the
  conclusion of

  the landed `exists_trimmed_trivializing_of_cechPicMap_ι_eq_one`, named so that the
  two chart

  instances can be handled uniformly.'
file: AlgebraicJacobian/Tangent/TwoChartRepresentable.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.IsTrimmedTrivializing
type: lean
updated: '2026-07-29T15:26:09'
---
def IsTrimmedTrivializing {𝒩 : X.PointedCover} (γ : X.unitsCocycle 𝒩) (W : X.Opens)
    (t : ∀ b : X, Γ(X, 𝒩.opens b ⊓ W)ˣ) : Prop :=
  ∀ b b' : X,
    X.unitsRestrict (le_inf (inf_le_left.trans inf_le_left) inf_le_right :
        (𝒩.opens b ⊓ 𝒩.opens b') ⊓ W ≤ 𝒩.opens b ⊓ W) (t b)
      * X.unitsRestrict (inf_le_left :
          (𝒩.opens b ⊓ 𝒩.opens b') ⊓ W ≤ 𝒩.opens b ⊓ 𝒩.opens b')
          (Scheme.unitsEvInf γ b b')
    = X.unitsRestrict (le_inf (inf_le_left.trans inf_le_right) inf_le_right) (t b')