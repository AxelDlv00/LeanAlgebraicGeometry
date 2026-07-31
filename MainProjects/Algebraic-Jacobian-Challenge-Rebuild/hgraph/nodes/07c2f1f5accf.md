---
author: sync
content_type: lemma
created: '2026-07-18T21:01:13'
decl: AlgebraicGeometry.resHom_relThetaWindowEquiv_one_tmul_fst
docstring: '(Implementation) The window identification at `1 ⊗ h`, chart 0: the `k
  → S`

  sections comparison of a fixed field-level section, independent of the test ring.'
file: AlgebraicJacobian/Picard/DivisorFamilyWindowTriangle.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.resHom_relThetaWindowEquiv_one_tmul_fst
type: lean
updated: '2026-07-31T20:31:20'
---
private lemma resHom_relThetaWindowEquiv_one_tmul_fst (S : Type u) [CommRing S]
    [Algebra k S] (h : ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) :
    (relCurve C S).resHom (le_inf le_top le_rfl)
        ((relThetaWindowEquiv C S π a hH1 (1 ⊗ₜ h)).val.1)
      = relSectionsMap C k S (fiberTwoCover π).V₀
          ((relCurve C k).resHom (le_inf le_top le_rfl)
            ((relTwistSectionsEquiv₀ C k (fiberTwoCover π) (relThetaCocycle C k π a)
              (((relThetaH0FieldEquiv C π a).trans
                (thetaTwistH0Equiv k π a)).symm h)).val.1)) := by
  rw [congrArg ((relCurve C S).resHom (le_inf le_top le_rfl))
      (congrArg Prod.fst (relThetaWindowEquiv_one_tmul C π a S hH1 h)),
    congrArg ((relCurve C S).resHom (le_inf le_top le_rfl))
      (congrArg Prod.fst (val_relTwistSectionsEquiv₀_mapEquiv C S (fiberTwoCover π)
        (relThetaCocycle_baseChange C S π a) _))]
  exact resHom_relTwistH0BaseChange_one_tmul_fst C S π (relThetaCocycle C k π a) hH1 _

set_option maxHeartbeats 1000000 in
-- Mixed `relCurve`/twist spellings force heavy defeq checks (`respectTransparency false`).
set_option synthInstance.maxHeartbeats 400000 in
set_option maxRecDepth 4000 in