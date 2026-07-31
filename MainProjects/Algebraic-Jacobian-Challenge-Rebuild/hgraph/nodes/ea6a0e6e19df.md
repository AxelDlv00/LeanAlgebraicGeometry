---
author: sync
content_type: definition
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.gluedSubordUnit
docstring: 'The pair value of the subordinated cocycle: the transition unit `g (σ
  x) (σ y)`

  restricted to the overlap `𝒲.opens x ⊓ 𝒲.opens y` of the subordinated cover.'
file: AlgebraicJacobian/Cohomology/GluedSheafClass.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.gluedSubordUnit
type: lean
updated: '2026-07-31T20:15:17'
---
noncomputable def gluedSubordUnit (g : ∀ i j : J, Γ(X, U i ⊓ U j)ˣ) (𝒲 : X.PointedCover)
    (σ : X → J) (hσ : ∀ x : X, 𝒲.opens x ≤ U (σ x)) (x y : X) :
    Γ(X, 𝒲.opens x ⊓ 𝒲.opens y)ˣ :=
  X.unitsRestrict
    (le_inf (inf_le_left.trans (hσ x)) (inf_le_right.trans (hσ y)) :
      𝒲.opens x ⊓ 𝒲.opens y ≤ U (σ x) ⊓ U (σ y))
    (g (σ x) (σ y))