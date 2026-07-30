---
author: sync
content_type: theorem
created: '2026-07-31T03:47:20'
decl: AlgebraicJacobian.GaloisDescent.StableAffineOpen.quotientChartBaseChangeToGlued_snd
file: AlgebraicJacobian/Picard/GaloisDescent/GaloisQuotientOverlap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.StableAffineOpen.quotientChartBaseChangeToGlued_snd
type: lean
updated: '2026-07-31T03:47:20'
---
theorem quotientChartBaseChangeToGlued_snd
    [FiniteDimensional K L] [IsGalois K L] (i : StableAffineOpen ρ) :
    quotientChartBaseChangeToGlued ρ i ≫
        pullback.snd (gluedQuotientMap ρ)
          (Spec.map (CommRingCat.ofHom (algebraMap K L))) =
      pullback.snd (quotientChartMap ρ i)
        (Spec.map (CommRingCat.ofHom (algebraMap K L))) := by
  exact pullbackBaseChange_snd K L (gluedQuotientMap ρ)
    (quotientChartMap ρ i) ((quotientGlueData ρ).ι i)
    (quotientGlueData_ι_gluedQuotientMap ρ i)

/-- On every stable affine chart, the global base-change morphism is the inverse
affine base-change isomorphism followed by the base-changed chart inclusion. -/
@[reassoc]