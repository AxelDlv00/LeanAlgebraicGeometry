---
author: sync
content_type: theorem
created: '2026-07-19T16:01:13'
decl: AlgebraicGeometry.relPinnedSectionsMap_relThetaResSide_windowEquiv
docstring: '**The compared-side triangle** (the G-2 crux, side-uniform): the fibre
  comparison

  of the side component of a relative window section is the side component of the
  fibre

  window section of the compared vector.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivRead.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.relPinnedSectionsMap_relThetaResSide_windowEquiv
type: lean
updated: '2026-07-30T15:28:04'
---
theorem relPinnedSectionsMap_relThetaResSide_windowEquiv (b : Bool)
    (x : R ⊗[k] ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) :
    relPinnedSectionsMap C R K π b
        (relThetaResSide a b le_rfl (relThetaWindowEquiv C R π a hH1 x))
      = relThetaResSide a b le_rfl
          (relThetaWindowEquiv C K π a hH1 (windowCompare R K x)) := by
  rw [windowCompare_eq_cancelBaseChange]
  cases b with
  | false =>
    exact (resHom_relThetaWindowEquiv_cancelBaseChange_fst C R K π a hH1 x).symm
  | true =>
    exact (resHom_relThetaWindowEquiv_cancelBaseChange_snd C R K π a hH1 x).symm

variable [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))]

set_option maxHeartbeats 800000 in
-- the G-2 crux triangle crosses the mixed `relCurve`/product spellings
set_option synthInstance.maxHeartbeats 400000 in
set_option linter.unusedSectionVars false in