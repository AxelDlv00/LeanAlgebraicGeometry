---
author: sync
content_type: theorem
created: '2026-08-19T09:50:24'
decl: AlgebraicGeometry.Pic0FiniteStageGluePackage.rightRestrictionBaseChangeMap_naturality
docstring: 'Under the final chart and overlap comparisons, the pulled-back right

  restriction is the exact right restriction of the separably closed atlas.'
file: AlgebraicJacobian/Picard/Pic0FiniteStageRightRestrictionNaturality.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Pic0FiniteStageGluePackage.rightRestrictionBaseChangeMap_naturality
type: lean
updated: '2026-08-19T09:50:24'
---
theorem rightRestrictionBaseChangeMap_naturality
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    rightRestrictionBaseChangeMap C P U V ≫
        (chartRingBaseChangeIso C P V).hom =
      (overlapRingBaseChangeIso C P U V).hom ≫
        Spec.map (CommRingCat.ofHom
          (exactRightRestrictionAlgHom C U V).toRingHom) := by
  exact affineBaseChangeIso_trans_naturality
    P.N.1 k
    (Pic0FiniteStageChartBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N V)
    (Pic0FiniteStageOverlapBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U V)
    (Pic0FiniteStageRing C (Sum.inl V))
    (Pic0FiniteStageRing C (Sum.inr (U, V)))
    (rightRestrictionBaseChangeAlgHom C P U V)
    (chartFinalBaseChangeEquiv C P V)
    (overlapFinalBaseChangeEquiv C P U V)
    (exactRightRestrictionAlgHom C U V)
    (rightRestrictionFinalBaseChangeEquiv_naturality C P U V)