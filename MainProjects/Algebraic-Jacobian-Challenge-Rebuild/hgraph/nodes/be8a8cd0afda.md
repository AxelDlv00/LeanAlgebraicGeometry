---
author: sync
content_type: theorem
created: '2026-07-21T23:32:10'
decl: AlgebraicGeometry.relThetaWindowEquiv_thetaWindowMul_fst
docstring: Arbitrary-exponent relative multiplication on the first theta chart.
file: AlgebraicJacobian/Picard/DivSchemeWindowMulGeneral.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relThetaWindowEquiv_thetaWindowMul_fst
type: lean
updated: '2026-07-29T15:31:43'
---
theorem relThetaWindowEquiv_thetaWindowMul_fst (p q : Nat)
    (a : ↥(divisorSections k (p • fiberWeilDivisor pi) ⊤))
    (hH1q : Subsingleton
      (relTwistPair C k pi (relThetaCocycle C k pi q)).H1)
    (hH1pq : Subsingleton
      (relTwistPair C k pi (relThetaCocycle C k pi (p + q))).H1)
    (x : R ⊗[k] ↥(divisorSections k (q • fiberWeilDivisor pi) ⊤)) :
    (relCurve C R).resHom (le_inf le_top le_rfl)
        ((relThetaWindowEquiv C R pi (p + q) hH1pq
          (LinearMap.baseChange R (thetaWindowMul (C := C) (pi := pi) p q a) x)).val.1) =
      thetaWindowMulSectionFst (C := C) (pi := pi) R p a *
        (relCurve C R).resHom (le_inf le_top le_rfl)
          ((relThetaWindowEquiv C R pi q hH1q x).val.1) := by
  induction x with
  | zero => simp only [map_zero, Submodule.coe_zero, Prod.fst_zero, mul_zero]
  | add x y hx hy =>
      have h2 : (relThetaWindowEquiv C R pi (p + q) hH1pq
            (LinearMap.baseChange R (thetaWindowMul (C := C) (pi := pi) p q a) x +
              LinearMap.baseChange R (thetaWindowMul (C := C) (pi := pi) p q a) y)).val.1 =
          (relThetaWindowEquiv C R pi (p + q) hH1pq
            (LinearMap.baseChange R (thetaWindowMul (C := C) (pi := pi) p q a) x)).val.1 +
          (relThetaWindowEquiv C R pi (p + q) hH1pq
            (LinearMap.baseChange R (thetaWindowMul (C := C) (pi := pi) p q a) y)).val.1 := by
        rw [map_add]
        rfl
      have h3 : (relThetaWindowEquiv C R pi q hH1q (x + y)).val.1 =
          (relThetaWindowEquiv C R pi q hH1q x).val.1 +
            (relThetaWindowEquiv C R pi q hH1q y).val.1 := by
        rw [map_add]
        rfl
      rw [map_add, h2, map_add, hx, hy, h3, map_add, mul_add]
  | tmul r m =>
      have hone : (relCurve C R).resHom (le_inf le_top le_rfl)
          ((relThetaWindowEquiv C R pi (p + q) hH1pq
            (1 ⊗ₜ thetaWindowMul (C := C) (pi := pi) p q a m)).val.1) =
          thetaWindowMulSectionFst (C := C) (pi := pi) R p a *
            (relCurve C R).resHom (le_inf le_top le_rfl)
              ((relThetaWindowEquiv C R pi q hH1q (1 ⊗ₜ m)).val.1) :=
        ((resHom_relThetaWindowEquiv_one_tmul_fst C pi R (p + q) hH1pq
            (thetaWindowMul (C := C) (pi := pi) p q a m)).trans
          ((congrArg (relSectionsMap C k R (fiberTwoCover pi).V₀)
              (resHom_relThetaFieldSection_thetaWindowMul_fst C pi p q a m)).trans
            (map_mul (relSectionsMap C k R (fiberTwoCover pi).V₀) _ _))).trans
          (congrArg (thetaWindowMulSectionFst (C := C) (pi := pi) R p a * ·)
            (resHom_relThetaWindowEquiv_one_tmul_fst C pi R q hH1q m).symm)
      have hbc : LinearMap.baseChange R
          (thetaWindowMul (C := C) (pi := pi) p q a) (r ⊗ₜ m) =
          r • ((1 : R) ⊗ₜ thetaWindowMul (C := C) (pi := pi) p q a m) := by
        rw [LinearMap.baseChange_tmul, TensorProduct.smul_tmul', smul_eq_mul, mul_one]
      have hsm : (r ⊗ₜ m : R ⊗[k]
          ↥(divisorSections k (q • fiberWeilDivisor pi) ⊤)) = r • ((1 : R) ⊗ₜ m) := by
        rw [TensorProduct.smul_tmul', smul_eq_mul, mul_one]
      have e1 : (relThetaWindowEquiv C R pi (p + q) hH1pq
            (LinearMap.baseChange R (thetaWindowMul (C := C) (pi := pi) p q a)
              (r ⊗ₜ m))).val.1 =
          r • (relThetaWindowEquiv C R pi (p + q) hH1pq
            (1 ⊗ₜ thetaWindowMul (C := C) (pi := pi) p q a m)).val.1 := by
        rw [hbc, map_smul]
        rfl
      have e2 : (relThetaWindowEquiv C R pi q hH1q (r ⊗ₜ m)).val.1 =
          r • (relThetaWindowEquiv C R pi q hH1q (1 ⊗ₜ m)).val.1 := by
        rw [hsm, map_smul]
        rfl
      have e2' : (relCurve C R).resHom (le_inf le_top le_rfl)
          ((relThetaWindowEquiv C R pi q hH1q (r ⊗ₜ m)).val.1) =
          r • (relCurve C R).resHom (le_inf le_top le_rfl)
            ((relThetaWindowEquiv C R pi q hH1q (1 ⊗ₜ m)).val.1) :=
        (congrArg ((relCurve C R).resHom (le_inf le_top le_rfl)) e2).trans
          (resHom_smul_rel' C R _ _ _)
      refine ((congrArg ((relCurve C R).resHom (le_inf le_top le_rfl)) e1).trans
        (resHom_smul_rel' C R _ _ _)).trans ?_
      refine (congrArg (r • ·) hone).trans ?_
      refine Eq.trans ?_
        (congrArg (thetaWindowMulSectionFst (C := C) (pi := pi) R p a * ·) e2'.symm)
      rw [Scheme.overModule_smul_def, Scheme.overModule_smul_def, mul_left_comm]

set_option maxHeartbeats 1000000 in
-- Mixed relative-curve and tensor spellings make the pure-tensor reduction expensive.
set_option synthInstance.maxHeartbeats 400000 in