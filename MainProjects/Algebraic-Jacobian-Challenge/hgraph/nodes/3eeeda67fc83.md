---
author: sync
content_type: theorem
created: '2026-07-31T03:49:57'
decl: AlgebraicJacobian.GaloisDescent.StableAffineOpen.restrict_act_hom_stableAffineQuotientMap
file: AlgebraicJacobian/Picard/GaloisDescent/GaloisQuotientOverlap.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.StableAffineOpen.restrict_act_hom_stableAffineQuotientMap
type: lean
updated: '2026-07-31T06:25:52'
---
theorem restrict_act_hom_stableAffineQuotientMap
    [FiniteDimensional K L] [IsGalois K L]
    (i : StableAffineOpen ρ) (gamma : L ≃ₐ[K] L) :
    ((ρ.restrict i.stable).act gamma).hom ≫
        SemilinearGalAction.stableAffineQuotientMap ρ i.stable i.affine =
      SemilinearGalAction.stableAffineQuotientMap ρ i.stable i.affine := by
  let q := SemilinearGalAction.stableAffineQuotientMapRestrict
    ρ i.stable i.affine le_rfl i.stable
  let W := quotientChartTopOpen ρ i
  have hfac : q ≫ W.ι =
      SemilinearGalAction.stableAffineQuotientMap ρ i.stable i.affine := by
    dsimp only [q, W, quotientChartTopOpen, quotientChart]
    simpa only [Scheme.homOfLE_rfl, Category.id_comp] using
      (SemilinearGalAction.stableAffineQuotientMapRestrict_fac
        ρ i.stable i.affine le_rfl i.stable)
  have hinv := GaloisQuotientWitnessWithProjection.act_hom_comp_quotientMap
    (quotientChartTopWitness ρ i) gamma
  change ((ρ.restrict i.stable).act gamma).hom ≫ q = q at hinv
  rw [← hfac]
  change (((ρ.restrict i.stable).act gamma).hom ≫ q) ≫ W.ι = q ≫ W.ι
  exact congrArg (fun z ↦ z ≫ W.ι) hinv

/-- The local projection into the glued quotient is Galois-invariant. -/
@[reassoc]