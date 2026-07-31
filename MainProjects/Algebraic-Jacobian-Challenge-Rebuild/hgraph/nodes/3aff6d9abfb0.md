---
author: sync
content_type: lemma
created: '2026-07-24T17:02:47'
decl: AlgebraicGeometry.windowShiftTheta₀_eq
docstring: 'The chart-0 multiplier section is the chart-0 component of the `s`-window
  image of

  the pure tensor `1 ⊗ a` — the Kit''s pure-tensor computation, read backwards.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivAssemble.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.windowShiftTheta₀_eq
type: lean
updated: '2026-07-31T20:15:22'
---
lemma windowShiftTheta₀_eq
    (hH1S : Subsingleton (relTwistPair C k π
      (relThetaCocycle C k π (windowS_choice π hπ g))).H1)
    (a : ↥(divisorSections k (windowS_choice π hπ g • fiberWeilDivisor π) ⊤)) :
    windowShiftTheta₀ C π hπ g K a
      = (relCurve C K).resHom (le_inf le_top le_rfl)
          ((relThetaWindowEquiv C K π (windowS_choice π hπ g) hH1S (1 ⊗ₜ a)).val.1) :=
  (resHom_relThetaWindowEquiv_one_tmul_fst C π K (windowS_choice π hπ g) hH1S a).symm

omit [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))] in