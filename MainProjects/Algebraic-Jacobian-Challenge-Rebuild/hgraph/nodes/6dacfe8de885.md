---
author: sync
content_type: theorem
created: '2026-07-18T21:01:13'
decl: AlgebraicGeometry.resHom_relThetaWindowEquiv_cancelBaseChange_fst
docstring: '**THE TRIANGLE, chart 0** (the G-2 crux, `informal/spec-w4-gates.md` §G-2):
  the

  window identification over `R''` of the `cancelBaseChange`-compared ambient vector
  is

  the `relSectionsMap`-compared window identification over `R`, on the first chart

  component.  The recorded orientation seam: the ambient comparison is

  `cancelBaseChange k R R'' R''` applied to `1 ⊗ₜ x` — the `ker_baseChangeMkQ` normal
  form

  of `Picard/DivCarveKit.lean`.'
file: AlgebraicJacobian/Picard/DivisorFamilyWindowTriangle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.resHom_relThetaWindowEquiv_cancelBaseChange_fst
type: lean
updated: '2026-08-01T09:44:14'
---
theorem resHom_relThetaWindowEquiv_cancelBaseChange_fst
    (x : R ⊗[k] ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) :
    (relCurve C R').resHom (le_inf le_top le_rfl)
        ((relThetaWindowEquiv C R' π a hH1
          (TensorProduct.AlgebraTensorModule.cancelBaseChange k R R' R' _
            (1 ⊗ₜ x))).val.1)
      = relSectionsMap C R R' (fiberTwoCover π).V₀
          ((relCurve C R).resHom (le_inf le_top le_rfl)
            ((relThetaWindowEquiv C R π a hH1 x).val.1)) := by
  induction x with
  | zero => simp only [TensorProduct.tmul_zero, map_zero, Submodule.coe_zero,
      Prod.fst_zero, map_zero]
  | add x y hx hy =>
    have hL : TensorProduct.AlgebraTensorModule.cancelBaseChange k R R' R'
        (↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) (1 ⊗ₜ (x + y))
        = TensorProduct.AlgebraTensorModule.cancelBaseChange k R R' R' _ (1 ⊗ₜ x)
          + TensorProduct.AlgebraTensorModule.cancelBaseChange k R R' R' _ (1 ⊗ₜ y) := by
      rw [TensorProduct.tmul_add, map_add]
    have h2 : (relThetaWindowEquiv C R' π a hH1
          (TensorProduct.AlgebraTensorModule.cancelBaseChange k R R' R' _ (1 ⊗ₜ x)
            + TensorProduct.AlgebraTensorModule.cancelBaseChange k R R' R' _
              (1 ⊗ₜ y))).val.1
        = (relThetaWindowEquiv C R' π a hH1
            (TensorProduct.AlgebraTensorModule.cancelBaseChange k R R' R'
              _ (1 ⊗ₜ x))).val.1
          + (relThetaWindowEquiv C R' π a hH1
              (TensorProduct.AlgebraTensorModule.cancelBaseChange k R R' R'
                _ (1 ⊗ₜ y))).val.1 := by
      rw [map_add]
      rfl
    have h3 : (relThetaWindowEquiv C R π a hH1 (x + y)).val.1
        = (relThetaWindowEquiv C R π a hH1 x).val.1
          + (relThetaWindowEquiv C R π a hH1 y).val.1 := by
      rw [map_add]
      rfl
    rw [hL, h2, map_add, hx, hy, h3, map_add, map_add]
  | tmul r h =>
    -- the compared pure tensor: `1 ⊗ (r ⊗ h) ↦ algebraMap r • (1 ⊗ h)`
    have hcmp : TensorProduct.AlgebraTensorModule.cancelBaseChange k R R' R'
        (↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) (1 ⊗ₜ (r ⊗ₜ h))
        = algebraMap R R' r • ((1 : R') ⊗ₜ h) := by
      rw [TensorProduct.AlgebraTensorModule.cancelBaseChange_tmul,
        TensorProduct.smul_tmul', Algebra.smul_def, mul_one, smul_eq_mul, mul_one]
    have hsm : (r ⊗ₜ h : R ⊗[k] ↥(Scheme.divisorSections k
        (a • fiberWeilDivisor π) ⊤)) = r • ((1 : R) ⊗ₜ h) := by
      rw [TensorProduct.smul_tmul', smul_eq_mul, mul_one]
    have e1 : (relThetaWindowEquiv C R' π a hH1
          (TensorProduct.AlgebraTensorModule.cancelBaseChange k R R' R' _
            (1 ⊗ₜ (r ⊗ₜ h)))).val.1
        = algebraMap R R' r • (relThetaWindowEquiv C R' π a hH1 (1 ⊗ₜ h)).val.1 := by
      rw [hcmp, map_smul]
      rfl
    have e2 : (relThetaWindowEquiv C R π a hH1 (r ⊗ₜ h)).val.1
        = r • (relThetaWindowEquiv C R π a hH1 (1 ⊗ₜ h)).val.1 := by
      rw [hsm, map_smul]
      rfl
    refine ((congrArg ((relCurve C R').resHom (le_inf le_top le_rfl)) e1).trans
      (resHom_smul_rel' C R' _ _ _)).trans ?_
    refine (congrArg (algebraMap R R' r • ·)
      (resHom_relThetaWindowEquiv_one_tmul_fst C π a hH1 R' h)).trans ?_
    refine ((congrArg (algebraMap R R' r • ·)
      (relSectionsMap_relSectionsMap C R R' (fiberTwoCover π).V₀ _)).symm).trans ?_
    refine ((relSectionsMap_smul C R R' (fiberTwoCover π).V₀ r _).symm).trans ?_
    refine congrArg (relSectionsMap C R R' (fiberTwoCover π).V₀) ?_
    exact (((congrArg ((relCurve C R).resHom (le_inf le_top le_rfl)) e2).trans
      (resHom_smul_rel' C R _ _ _)).trans
      (congrArg (r • ·)
        (resHom_relThetaWindowEquiv_one_tmul_fst C π a hH1 R h))).symm
set_option maxHeartbeats 1000000 in
-- Mixed `relCurve`/twist spellings force heavy defeq checks (`respectTransparency false`).
set_option synthInstance.maxHeartbeats 400000 in