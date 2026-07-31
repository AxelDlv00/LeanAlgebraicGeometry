---
author: sync
content_type: theorem
created: '2026-07-31T14:47:56'
decl: AlgebraicGeometry.Scheme.finiteInAffine_projectiveSpace
docstring: '**Relative projective space over an affine base satisfies `FiniteInAffine`**
  —

  and this is the non-vacuity witness that matters.


  `ℙ(n; S)` is by definition the base change of `Proj ℤ[Xᵢ]` along `S ⟶ ⊤_ Scheme`,
  so

  `toProjInt` is a pullback of `terminal.from S`, which is affine exactly when `S`
  is;

  `IsAffineHom` is stable under base change, and §2 then transports

  `finiteInAffine_proj`.


  Contrast the cheap witness `Scheme.finiteInAffine_of_isAffine`

  (`Picard/PicEtPointedReduction.lean`, `⊤` as the affine open). That one is degenerate

  — it says nothing about a projective object — and its own docstring says so. This
  one

  holds at a scheme that is **not** affine for `n` with at least two elements, so
  the

  results below are not statements about a class of schemes that happens to be affine.'
file: AlgebraicJacobian/Picard/QuasiProjectiveFiniteInAffine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.finiteInAffine_projectiveSpace
type: lean
updated: '2026-07-31T14:47:56'
---
theorem finiteInAffine_projectiveSpace (n : Type u) (S : Scheme.{u}) [IsAffine S] :
    FiniteInAffine (ProjectiveSpace n S) := by
  haveI : IsAffineHom (ProjectiveSpace.toProjInt n S) := by
    rw [ProjectiveSpace.toProjInt_eq_snd]
    exact MorphismProperty.pullback_snd _ _ inferInstance
  exact finiteInAffine_of_isAffineHom (ProjectiveSpace.toProjInt n S)
    (finiteInAffine_proj (MvPolynomial.homogeneousSubmodule n (ULift.{u} ℤ)))

/-! ## §3. The theorem the project was carrying by hand -/