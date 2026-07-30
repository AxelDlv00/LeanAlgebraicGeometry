---
author: sync
content_type: theorem
created: '2026-07-18T23:31:13'
decl: AlgebraicGeometry.Grassmannian.exists_matrixPoint_eq_of_free
docstring: '**K2 — matrix presentation from a free quotient** (quotient frame convention,

  worksheet §0.1): a coordinate Grassmannian point over a nontrivial ring whose quotient

  is FREE is a matrix point.  The matrix is `LinearMap.toMatrix''` of the composite

  "quotient map then quotient-basis coordinates", read through the coordinate

  identification — its columns are the quotient-basis coordinates of the images of
  the

  standard ambient generators; no submodule-side generators are chosen.'
file: AlgebraicJacobian/Picard/DivSchemeFrameKit.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Grassmannian.exists_matrixPoint_eq_of_free
type: lean
updated: '2026-07-30T15:28:02'
---
theorem exists_matrixPoint_eq_of_free {T : Type u} [CommRing T] [Algebra k T]
    [Nontrivial T] {g r : ℕ} (x : grFunctorAff k (Fin r → k) g T)
    (hfree : Module.Free T (TensorProduct k T (Fin r → k) ⧸ x.toSubmodule)) :
    ∃ (X : Matrix (Fin g) (Fin r) T) (hX : Function.Surjective (matrixProj k g r T X)),
      matrixPoint k g r T X hX = x := by
  haveI := hfree
  -- the free quotient has rank `g`: the point's own stalk-rank clause at any prime
  obtain ⟨p⟩ : Nonempty (PrimeSpectrum T) := inferInstance
  have hfin : Module.finrank T (TensorProduct k T (Fin r → k) ⧸ x.toSubmodule) = g := by
    have h1 := x.rankAtStalk_eq p
    rwa [congrFun (Module.rankAtStalk_eq_finrank_of_free
      (R := T) (M := TensorProduct k T (Fin r → k) ⧸ x.toSubmodule)) p] at h1
  have hcard : Fintype.card (Module.Free.ChooseBasisIndex T
      (TensorProduct k T (Fin r → k) ⧸ x.toSubmodule)) = g := by
    rw [← Module.finrank_eq_card_chooseBasisIndex]
    exact hfin
  set b : Module.Basis (Fin g) T (TensorProduct k T (Fin r → k) ⧸ x.toSubmodule) :=
    (Module.Free.chooseBasis T _).reindex (Fintype.equivFinOfCardEq hcard) with hb
  set φ : TensorProduct k T (Fin r → k) →ₗ[T] (Fin g → T) :=
    b.equivFun.toLinearMap ∘ₗ x.toSubmodule.mkQ with hφ
  set X : Matrix (Fin g) (Fin r) T := LinearMap.toMatrix'
    (φ ∘ₗ (TensorProduct.piScalarRight k T T (Fin r)).symm.toLinearMap) with hXdef
  -- the matrix presentation IS `φ`
  have hproj : matrixProj k g r T X = φ := by
    have hcancel : (TensorProduct.piScalarRight k T T (Fin r)).symm.toLinearMap ∘ₗ
        (TensorProduct.piScalarRight k T T (Fin r)).toLinearMap = LinearMap.id :=
      LinearMap.ext fun z => by
        simp only [LinearMap.comp_apply, LinearEquiv.coe_toLinearMap,
          LinearEquiv.symm_apply_apply, LinearMap.id_apply]
    rw [matrixProj, hXdef, ← Matrix.toLin'_apply', Matrix.toLin'_toMatrix',
      LinearMap.comp_assoc, hcancel, LinearMap.comp_id]
  have hXs : Function.Surjective (matrixProj k g r T X) := by
    rw [hproj, hφ, LinearMap.coe_comp, LinearEquiv.coe_toLinearMap]
    exact b.equivFun.surjective.comp x.toSubmodule.mkQ_surjective
  refine ⟨X, hXs, Module.Grassmannian.ext ?_⟩
  rw [matrixPoint_toSubmodule, hproj, hφ, LinearMap.ker_comp,
    show LinearMap.ker b.equivFun.toLinearMap = ⊥ from LinearEquiv.ker b.equivFun]
  exact x.toSubmodule.ker_mkQ

end MatrixFromFree

/-! ## K5: frame-minor selection -/

section MinorSelect