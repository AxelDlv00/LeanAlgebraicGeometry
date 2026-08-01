---
author: sync
content_type: theorem
created: '2026-07-17T10:19:49'
decl: AlgebraicGeometry.relThetaCocycle_baseChange
docstring: '**Cocycle functoriality**: the relative theta cocycle over the base field
  `k`

  base-changes to the relative theta cocycle over `R`. This is `relSectionsMap_pullback`

  (pullback of a curve section commutes with the relative-curve comparison map) packaged
  at

  the `Units.map` level.'
file: AlgebraicJacobian/Cohomology/RelThetaTwist.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relThetaCocycle_baseChange
type: lean
updated: '2026-08-01T09:44:09'
---
theorem relThetaCocycle_baseChange :
    relCocycleBaseChange C k R (fiberTwoCover π) (relThetaCocycle C k π n)
      = relThetaCocycle C R π n := by
  refine Units.ext ?_
  change relSectionsMap C k R (fiberChart₀ π ⊓ fiberChart₁ π)
      ((relUnitCocycle C k (fiberTwoCover π) (thetaUnit π ^ n)).val)
    = (relUnitCocycle C R (fiberTwoCover π) (thetaUnit π ^ n)).val
  change relSectionsMap C k R (fiberChart₀ π ⊓ fiberChart₁ π)
      (relPullbackSection C k (fiberChart₀ π ⊓ fiberChart₁ π)
        ((thetaUnit π ^ n : Γ(C.left, _)ˣ) : Γ(C.left, _)))
    = relPullbackSection C R (fiberChart₀ π ⊓ fiberChart₁ π)
        ((thetaUnit π ^ n : Γ(C.left, _)ˣ) : Γ(C.left, _))
  exact relSectionsMap_pullback C k R (fiberChart₀ π ⊓ fiberChart₁ π) _