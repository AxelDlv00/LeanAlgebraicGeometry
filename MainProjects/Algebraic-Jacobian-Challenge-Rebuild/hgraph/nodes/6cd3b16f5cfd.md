---
author: sync
content_type: definition
created: '2026-07-30T12:49:24'
decl: AlgebraicGeometry.DivFamZar.trivEqns
docstring: '**The trivial local-equation system on the relative curve**: the constant
  equation `1` on

  the top cover.


  This is `Scheme.LocalEquations.unitEquations` (`Picard/DivisorFamilyBackward.lean:51`)

  transcribed *without* its `[IsIntegral X]` binder — that lemma''s section carries
  the binder for

  its `presentationDivisor` statements, and `relCurve C R` over a general test ring
  `R` is not

  integral, so the landed name is not applicable at the site this file needs.  The
  two `Prop`

  fields need only that `1` is a unit: `regular` is `map_one` plus `one_mem`, and
  the overlap

  ratio is `1`.'
file: AlgebraicJacobian/Picard/DivisorFamilyDegreeZero.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivFamZar.trivEqns
type: lean
updated: '2026-07-30T12:49:24'
---
noncomputable def trivEqns : (relCurve C R).LocalEquations where
  cover := ⊤
  eqn := fun _ => 1
  regular := fun _ y _ => by rw [map_one]; exact one_mem _
  ratio_isUnit := fun _ _ => ⟨1, by simp⟩

@[simp]