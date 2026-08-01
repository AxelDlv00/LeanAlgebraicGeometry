---
author: sync
content_type: theorem
created: '2026-07-20T17:31:56'
decl: AlgebraicGeometry.test_total_unit
file: ScratchGenericTotal.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.test_total_unit
type: lean
updated: '2026-07-20T18:02:07'
---
theorem test_total_unit
    (z : relCurve C R) (b : Bool) (hz : z ∈ relPinnedChart C R π b)
    (x : R ⊗[k] ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤))
    (hx : windowCompare R (relCurveBasePoint C R z).asIdeal.ResidueField x ≠ 0)
    (hzg : relCurveResiduePoint C R z =
      genericPoint (relCurve C (relCurveBasePoint C R z).asIdeal.ResidueField)) :
    IsUnit (((relCurve C R).presheaf.germ (relPinnedChart C R π b) z hz).hom
      (relThetaResSide a b le_rfl (relThetaWindowEquiv C R π a hH1 x))) := by
  let K := (relCurveBasePoint C R z).asIdeal.ResidueField
  let zK := relCurveResiduePoint C R z
  have hzK : zK ∈ relPinnedChart C K π b :=
    relCurveResiduePoint_mem_relPinnedChart C R (π := π) b hz
  have hη : genericPoint (relCurve C K) ∈ relPinnedChart C K π b := by
    rw [← hzg]
    exact hzK
  have huFib := isUnit_germ_genericPoint_of_windowCompare_ne_zero
    C R K π a hH1 b hη hx
  rw [relPinnedSectionsMap_germ_eq_stalkMap C R K (π := π) b hη] at huFib
  have huTotalAtImage :=
    (isUnit_map_iff ((relCurveMap C R K).stalkMap (genericPoint (relCurve C K))).hom _).mp
      huFib
  have hmap : (relCurveMap C R K).base (genericPoint (relCurve C K)) = z := by
    rw [← hzg]
    exact relCurveMap_relCurveResiduePoint C R z
  simpa only [hmap] using huTotalAtImage