---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.thetaUnit
docstring: '**The theta transition unit** `t₀|_{V₀ ⊓ V₁} ∈ Γ(Y, V₀ ⊓ V₁)ˣ`: the restriction
  of

  the pulled-back chart-0 coordinate to the two-cover overlap, a unit with explicit

  inverse the restricted chart-1 coordinate (`fiberCoord_mul_fiberCoord₁_res`). Its
  `n`-th

  power is the transition cocycle of the fiber twist `Θⁿ` (`fiberDivisor`/`fiberCocycle`

  normalization, `RiemannRoch/FiberTwist.lean`).'
file: AlgebraicJacobian/RiemannRoch/ThetaSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.thetaUnit
type: lean
updated: '2026-07-31T20:15:29'
---
noncomputable def thetaUnit : Γ(Y, fiberChart₀ π ⊓ fiberChart₁ π)ˣ where
  val := (Y.presheaf.map (homOfLE
    (inf_le_left : fiberChart₀ π ⊓ fiberChart₁ π ≤ fiberChart₀ π)).op).hom (fiberCoord π)
  inv := (Y.presheaf.map (homOfLE
    (inf_le_right : fiberChart₀ π ⊓ fiberChart₁ π ≤ fiberChart₁ π)).op).hom (fiberCoord₁ π)
  val_inv := fiberCoord_mul_fiberCoord₁_res π
  inv_val := by rw [mul_comm]; exact fiberCoord_mul_fiberCoord₁_res π