---
author: sync
content_type: theorem
created: '2026-07-21T23:32:10'
decl: AlgebraicGeometry.relThetaResSide_relThetaWindowEquiv_thetaWindowMul
docstring: Arbitrary-exponent multiplication, stated uniformly on either pinned chart.
file: AlgebraicJacobian/Picard/DivSchemeWindowMulGeneral.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relThetaResSide_relThetaWindowEquiv_thetaWindowMul
type: lean
updated: '2026-07-29T15:31:43'
---
theorem relThetaResSide_relThetaWindowEquiv_thetaWindowMul (p q : Nat)
    (a : ↥(divisorSections k (p • fiberWeilDivisor pi) ⊤))
    (hH1p : Subsingleton
      (relTwistPair C k pi (relThetaCocycle C k pi p)).H1)
    (hH1q : Subsingleton
      (relTwistPair C k pi (relThetaCocycle C k pi q)).H1)
    (hH1pq : Subsingleton
      (relTwistPair C k pi (relThetaCocycle C k pi (p + q))).H1)
    (side : Bool)
    (x : R ⊗[k] ↥(divisorSections k (q • fiberWeilDivisor pi) ⊤)) :
    relThetaResSide (p + q) side le_rfl
        (relThetaWindowEquiv C R pi (p + q) hH1pq
          (LinearMap.baseChange R (thetaWindowMul (C := C) (pi := pi) p q a) x)) =
      relThetaResSide p side le_rfl
          (relThetaWindowEquiv C R pi p hH1p (1 ⊗ₜ a)) *
        relThetaResSide q side le_rfl (relThetaWindowEquiv C R pi q hH1q x) := by
  cases side
  · simp only [relThetaResSide_false]
    calc
      _ = thetaWindowMulSectionFst (C := C) (pi := pi) R p a *
          (relCurve C R).resHom (le_inf le_top le_rfl)
            ((relThetaWindowEquiv C R pi q hH1q x).val.1) :=
        relThetaWindowEquiv_thetaWindowMul_fst C pi R p q a hH1q hH1pq x
      _ = _ := congrArg
        (· * (relCurve C R).resHom (le_inf le_top le_rfl)
          ((relThetaWindowEquiv C R pi q hH1q x).val.1))
        (resHom_relThetaWindowEquiv_one_tmul_fst C pi R p hH1p a).symm
  · simp only [relThetaResSide_true]
    calc
      _ = thetaWindowMulSectionSnd (C := C) (pi := pi) R p a *
          (relCurve C R).resHom (le_inf le_top le_rfl)
            ((relThetaWindowEquiv C R pi q hH1q x).val.2) :=
        relThetaWindowEquiv_thetaWindowMul_snd C pi R p q a hH1q hH1pq x
      _ = _ := congrArg
        (· * (relCurve C R).resHom (le_inf le_top le_rfl)
          ((relThetaWindowEquiv C R pi q hH1q x).val.2))
        (resHom_relThetaWindowEquiv_one_tmul_snd C pi R p hH1p a).symm