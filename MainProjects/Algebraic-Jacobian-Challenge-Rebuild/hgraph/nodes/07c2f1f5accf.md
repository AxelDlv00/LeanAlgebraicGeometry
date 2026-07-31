---
author: sync
content_type: lemma
created: '2026-07-18T21:01:13'
decl: AlgebraicGeometry.resHom_relThetaWindowEquiv_one_tmul_fst
docstring: '**The pure-tensor value of the window identification, chart 0**: on `1
  ⊗ h` the

  window identification over `S` reads as the `k → S` sections comparison of the `k`-level

  relative theta section of `h`.'
file: AlgebraicJacobian/Picard/DivSchemeEpsCarveKit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.resHom_relThetaWindowEquiv_one_tmul_fst
type: lean
updated: '2026-07-31T09:47:07'
---
lemma resHom_relThetaWindowEquiv_one_tmul_fst
    (h : ↥(divisorSections k (n • fiberWeilDivisor π) ⊤)) :
    (relCurve C S).resHom (le_inf le_top le_rfl)
        ((relThetaWindowEquiv C S π n hH1 (1 ⊗ₜ h)).val.1)
      = relSectionsMap C k S (fiberTwoCover π).V₀
          ((relCurve C k).resHom (le_inf le_top le_rfl)
            ((relThetaFieldSection C π n h).val.1)) := by
  rw [congrArg ((relCurve C S).resHom (le_inf le_top le_rfl))
      (congrArg Prod.fst (relThetaWindowEquiv_one_tmul_eq C π S n hH1 h)),
    congrArg ((relCurve C S).resHom (le_inf le_top le_rfl))
      (congrArg Prod.fst (val_relTwistSectionsEquiv₀_mapEquiv C S (fiberTwoCover π)
        (relThetaCocycle_baseChange C S π n) _))]
  exact resHom_relTwistH0BaseChange_one_tmul_fst C S π (relThetaCocycle C k π n) hH1 _

set_option maxHeartbeats 1000000 in
-- Mixed `relCurve`/twist spellings force heavy defeq checks (`respectTransparency false`).
set_option synthInstance.maxHeartbeats 400000 in
set_option maxRecDepth 4000 in