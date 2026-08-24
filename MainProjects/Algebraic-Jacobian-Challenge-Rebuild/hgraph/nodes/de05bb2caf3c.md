---
author: sync
content_type: theorem
created: '2026-08-19T21:14:47'
decl: AlgebraicGeometry.Pic0FiniteStageGluePackage.chartBaseChangeIso_hom_ι
file: AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Pic0FiniteStageGluePackage.chartBaseChangeIso_hom_ι
type: lean
updated: '2026-08-19T21:14:47'
---
private theorem chartBaseChangeIso_hom_ι
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U : Pic0FiniteStageChartIndex C) :
    (chartBaseChangeIso C P U).hom ≫ U.1.1.ι =
      (chartRingBaseChangeIso C P U).hom ≫ U.1.2.fromSpec := by
  calc
    _ = (chartRingBaseChangeIso C P U).hom ≫
        (U.1.2.isoSpec.inv ≫ U.1.1.ι) := by
      simp only [chartBaseChangeIso, chartRingBaseChangeIso,
        chartFinalBaseChangeEquiv, affineBaseChangeIso, Iso.trans_hom,
        Iso.symm_hom, Category.assoc]
    _ = _ := congrArg (fun q => (chartRingBaseChangeIso C P U).hom ≫ q)
      U.1.2.isoSpec_inv_ι

set_option synthInstance.maxHeartbeats 3200000 in
-- Keep the dependent finite-subextension comparison out of the global diagram proof.
set_option maxHeartbeats 12800000 in
set_option backward.isDefEq.respectTransparency false in