---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.opensRange_le_chartLocus_tautological
docstring: '**The chart image lies in the tautological chart locus**: the open range
  of the

  chart immersion `ι_I` is one of the opens over which the tautological chart composite

  is invertible. Project-local — provides the cover for the uniqueness law of

  `represents`.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.opensRange_le_chartLocus_tautological
type: lean
updated: '2026-07-16T21:14:27'
---
lemma opensRange_le_chartLocus_tautological (d r : ℕ) (I : (theGlueData d r).J) :
    Scheme.Hom.opensRange ((theGlueData d r).ι I)
      ≤ chartLocus (tautologicalRankQuotient d r) I.1 I.2 := by
  have heq : ((theGlueData d r).ι I).isoOpensRange.inv ≫ (theGlueData d r).ι I
      = (Scheme.Hom.opensRange ((theGlueData d r).ι I)).ι :=
    (Iso.inv_comp_eq _).mpr (Scheme.Hom.isoOpensRange_hom_ι ((theGlueData d r).ι I)).symm
  haveI h1 : IsIso ((Scheme.Modules.pullback
      (((theGlueData d r).ι I).isoOpensRange.inv ≫ (theGlueData d r).ι I)).map
      (chartComposite (tautologicalRankQuotient d r) I.1 I.2)) :=
    isIso_pullback_map_comp _ _ _
  have hmem : IsIso ((Scheme.Modules.pullback
      (Scheme.Hom.opensRange ((theGlueData d r).ι I)).ι).map
      (chartComposite (tautologicalRankQuotient d r) I.1 I.2)) := by
    rw [← heq]; exact h1
  exact le_sSup hmem

set_option maxHeartbeats 800000 in
-- the inverse-collapse steps traverse the `X.Modules` instance diamond