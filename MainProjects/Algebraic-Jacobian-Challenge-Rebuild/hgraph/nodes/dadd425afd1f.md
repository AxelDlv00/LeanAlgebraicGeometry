---
author: sync
content_type: theorem
created: '2026-08-14T15:00:50'
decl: AlgebraicGeometry.Scheme.finiteInAffine_projectiveSpace
docstring: Relative projective space over an affine base satisfies `FiniteInAffine`.
file: AlgebraicJacobian/Descent/QuasiProjectiveFiniteInAffine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.finiteInAffine_projectiveSpace
type: lean
updated: '2026-08-18T20:50:54'
---
theorem finiteInAffine_projectiveSpace (n : Type u) (S : Scheme.{u}) [IsAffine S] :
    FiniteInAffine (ProjectiveSpace n S) := by
  haveI : IsAffineHom (ProjectiveSpace.toProjInt n S) := by
    rw [ProjectiveSpace.toProjInt_eq_snd]
    exact MorphismProperty.pullback_snd _ _ inferInstance
  exact finiteInAffine_of_isAffineHom (ProjectiveSpace.toProjInt n S)
    (finiteInAffine_proj (MvPolynomial.homogeneousSubmodule n (ULift.{u} ℤ)))