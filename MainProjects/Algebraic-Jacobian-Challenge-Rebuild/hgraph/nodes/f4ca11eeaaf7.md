---
author: sync
content_type: definition
created: '2026-07-29T02:23:55'
decl: AlgebraicGeometry.divFunctorToAff
docstring: '**The comparison of divisor functors**: the chart-typed locally certified
  divisor functor maps

  naturally into the widened one of R2.


  This is the form a consumer substitutes: it may replace `divFunctor` by `divFunctorAff`
  and keep

  every restriction equation it had, without re-deriving anything over the widened
  cover.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffFunctorCompare.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divFunctorToAff
type: lean
updated: '2026-07-31T20:15:23'
---
def divFunctorToAff : divFunctor C π n ⟶ divFunctorAff C n where
  app T := ↾divFamZarToAffVehicle C n π
  naturality {T T'} g := by
    ext s
    exact divFamZarToAffVehicle_map g.unop s

@[simp]