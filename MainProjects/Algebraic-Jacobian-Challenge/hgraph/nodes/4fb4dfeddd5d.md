---
author: sync
content_type: instance
created: '2026-07-31T03:47:20'
decl: AlgebraicJacobian.GaloisDescent.StableAffineOpen.quotientChartBaseChangeToGlued_isOpenImmersion
file: AlgebraicJacobian/Picard/GaloisDescent/GaloisQuotientOverlap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.StableAffineOpen.quotientChartBaseChangeToGlued_isOpenImmersion
type: lean
updated: '2026-07-31T03:47:20'
---
instance quotientChartBaseChangeToGlued_isOpenImmersion
    [FiniteDimensional K L] [IsGalois K L] (i : StableAffineOpen ρ) :
    IsOpenImmersion (quotientChartBaseChangeToGlued ρ i) := by
  letI : IsOpenImmersion
      (show quotientChart ρ i ⟶ gluedQuotient ρ from
        (quotientGlueData ρ).ι i) :=
    (quotientGlueData ρ).ι_isOpenImmersion i
  unfold quotientChartBaseChangeToGlued pullbackBaseChange
  infer_instance