---
author: sync
content_type: theorem
created: '2026-07-29T02:23:55'
decl: AlgebraicGeometry.divFamZarToAffVehicle_map
docstring: '**The vehicle comparison commutes with restriction along an arbitrary
  test morphism.**


  Both sides are widened sections over `T''`; by the widened uniqueness of glued values
  it is enough

  that the left-hand one has the widened pullback property, and each of its clauses
  is the

  `toAff`-image of a clause of the chart-typed `divFamZar.mapVal_spec`

  (`DivFamZar.toAff_mapAlgHom`).'
file: AlgebraicJacobian/Picard/DivisorFamilyAffFunctorCompare.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divFamZarToAffVehicle_map
type: lean
updated: '2026-07-30T15:28:06'
---
theorem divFamZarToAffVehicle_map {T T' : Over (Spec (.of k))} (f : T' ⟶ T)
    (s : divFamZar C π n T) :
    divFamZarToAffVehicle C n π (divFamZar.map C π n f s)
      = divFamZarAff.map C n f (divFamZarToAffVehicle C n π s) := by
  refine divFamZarAff.ext fun W => ?_
  rw [divFamZarToAffVehicle_val, divFamZarAff.map_val]
  refine (divFamZarAff.mapVal_eq_of C n f (divFamZarToAffVehicle C n π s) ?_).symm
  intro W₀ hW₀ V hV
  -- `divFamZarToAffVehicle_val` must fire FIRST: the widened value at `V` is only `rfl`-equal to
  -- `(s.1 V).toAff`, and until it is spelled that way the backward rewrite has no `toAff` to
  -- match on the right-hand side.
  rw [divFamZarToAffVehicle_val, ← DivFamZar.toAff_mapAlgHom, ← DivFamZar.toAff_mapAlgHom,
    divFamZar.map_val]
  exact congrArg DivFamZar.toAff (divFamZar.mapVal_spec C π n f s W W₀ hW₀ V hV)

variable (C π n) in