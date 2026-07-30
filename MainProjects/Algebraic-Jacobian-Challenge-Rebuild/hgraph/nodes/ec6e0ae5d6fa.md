---
author: sync
content_type: theorem
created: '2026-07-17T08:59:07'
decl: AlgebraicGeometry.Grassmannian.exists_isUnit_mul_of_matrixPoint_eq
docstring: '**Two split presentations of the same point differ by a `GL_d(S)` left
  factor**: if

  `X` and `Y` present the same matrix point, there is a unit-determinant `U` with
  `X = U Y`.

  Content: the two surjections `matrixProj X`, `matrixProj Y` share a kernel, hence
  induce

  the same quotient of the ambient module, so the two identifications with the free
  quotient

  `S^d` differ by a linear automorphism `u = mulVec U`; the reverse identification
  gives its

  inverse, forcing `det U` to be a unit.'
file: AlgebraicJacobian/Picard/GrassmannianChartFrame.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Grassmannian.exists_isUnit_mul_of_matrixPoint_eq
type: lean
updated: '2026-07-30T15:28:05'
---
theorem exists_isUnit_mul_of_matrixPoint_eq (X Y : Matrix (Fin d) (Fin r) S)
    (hX : Function.Surjective (matrixProj k d r S X))
    (hY : Function.Surjective (matrixProj k d r S Y))
    (h : matrixPoint k d r S X hX = matrixPoint k d r S Y hY) :
    ∃ U : Matrix (Fin d) (Fin d) S, IsUnit U.det ∧ X = U * Y := by
  have hker : LinearMap.ker (matrixProj k d r S X)
      = LinearMap.ker (matrixProj k d r S Y) := by
    have h2 := congrArg Module.Grassmannian.toSubmodule h
    rwa [matrixPoint_toSubmodule, matrixPoint_toSubmodule] at h2
  set φX := matrixProj k d r S X with hφX
  set φY := matrixProj k d r S Y with hφY
  -- the two quotient identifications and the lifts of one map over the other's kernel
  set eY := LinearMap.quotKerEquivOfSurjective φY hY with heY
  set eX := LinearMap.quotKerEquivOfSurjective φX hX with heX
  set lX := (LinearMap.ker φY).liftQ φX hker.ge with hlX
  set lY := (LinearMap.ker φX).liftQ φY hker.le with hlY
  set u := lX ∘ₗ (eY.symm : (Fin d → S) →ₗ[S] _) with hu
  set v := lY ∘ₗ (eX.symm : (Fin d → S) →ₗ[S] _) with hv
  -- `u` intertwines the two surjections; `v` is its two-sided inverse
  have hmkY : (eY.symm : (Fin d → S) →ₗ[S] _) ∘ₗ φY = (LinearMap.ker φY).mkQ := by
    refine LinearMap.ext fun w => ?_
    simp only [LinearMap.comp_apply, LinearEquiv.coe_coe]
    apply eY.injective
    rw [LinearEquiv.apply_symm_apply, heY, Submodule.mkQ_apply,
      LinearMap.quotKerEquivOfSurjective_apply_mk]
  have hmkX : (eX.symm : (Fin d → S) →ₗ[S] _) ∘ₗ φX = (LinearMap.ker φX).mkQ := by
    refine LinearMap.ext fun w => ?_
    simp only [LinearMap.comp_apply, LinearEquiv.coe_coe]
    apply eX.injective
    rw [LinearEquiv.apply_symm_apply, heX, Submodule.mkQ_apply,
      LinearMap.quotKerEquivOfSurjective_apply_mk]
  have huφcomp : u ∘ₗ φY = φX := by
    rw [hu, LinearMap.comp_assoc, hmkY]
    exact (LinearMap.ker φY).liftQ_mkQ φX hker.ge
  have hvφcomp : v ∘ₗ φX = φY := by
    rw [hv, LinearMap.comp_assoc, hmkX]
    exact (LinearMap.ker φX).liftQ_mkQ φY hker.le
  have huφ : ∀ w, u (φY w) = φX w := fun w => LinearMap.congr_fun huφcomp w
  have hvφ : ∀ w, v (φX w) = φY w := fun w => LinearMap.congr_fun hvφcomp w
  have huv : u ∘ₗ v = LinearMap.id := by
    refine LinearMap.ext fun y => ?_
    obtain ⟨w, rfl⟩ := hX y
    simp only [LinearMap.comp_apply, LinearMap.id_apply, hvφ w, huφ w]
  -- transport `u` to a matrix and read off `X = U Y`
  set U := LinearMap.toMatrix' u with hUdef
  have hUu : U.mulVecLin = u := by
    rw [hUdef, ← Matrix.toLin'_apply', Matrix.toLin'_toMatrix']
  refine ⟨U, ?_, ?_⟩
  · -- `det U` is a unit: `U · toMatrix' v = 1`
    have hcomp : U * LinearMap.toMatrix' v = 1 := by
      rw [hUdef, ← LinearMap.toMatrix'_comp, huv, LinearMap.toMatrix'_id]
    exact IsUnit.of_mul_eq_one _ (by
      rw [← Matrix.det_mul, hcomp, Matrix.det_one] :
      U.det * (LinearMap.toMatrix' v).det = 1)
  · -- `X = U · Y`: both send the coordinate frame the same way
    have hpt : ∀ w : Fin r → S, u (Y.mulVec w) = X.mulVec w := by
      intro w
      have hYw : φY ((TensorProduct.piScalarRight k S S (Fin r)).symm w) = Y.mulVec w := by
        rw [hφY, matrixProj, LinearMap.comp_apply, LinearEquiv.coe_toLinearMap,
          LinearEquiv.apply_symm_apply, Matrix.mulVecLin_apply]
      have hXw : φX ((TensorProduct.piScalarRight k S S (Fin r)).symm w) = X.mulVec w := by
        rw [hφX, matrixProj, LinearMap.comp_apply, LinearEquiv.coe_toLinearMap,
          LinearEquiv.apply_symm_apply, Matrix.mulVecLin_apply]
      rw [← hYw, ← hXw, huφ]
    have hML : (U * Y).mulVecLin = X.mulVecLin := by
      refine LinearMap.ext fun w => ?_
      rw [Matrix.mulVecLin_apply, ← Matrix.mulVec_mulVec, ← Matrix.mulVecLin_apply, hUu,
        hpt w, ← Matrix.mulVecLin_apply]
    have hUYX : U * Y = X := by
      have h2 := congrArg LinearMap.toMatrix' hML
      rwa [← Matrix.toLin'_apply', ← Matrix.toLin'_apply', LinearMap.toMatrix'_toLin',
        LinearMap.toMatrix'_toLin'] at h2
    exact hUYX.symm