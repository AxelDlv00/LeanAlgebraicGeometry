---
author: sync
content_type: theorem
created: '2026-07-31T02:29:39'
decl: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators.targetOpen0IsoAffineChartAt_hom_incl
file: AlgebraicJacobian/Picard/FiniteMapProjectiveImmersion.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators.targetOpen0IsoAffineChartAt_hom_incl
type: lean
updated: '2026-07-31T02:29:39'
---
theorem targetOpen0IsoAffineChartAt_hom_incl :
    G.targetOpen0IsoAffineChartAt.hom ≫
        ProjectiveSpace.affineChartAt.incl
          G.ProjectiveIndex G.firstIndex (Spec (.of k)) =
      G.targetOpen0.ι :=
  IsOpenImmersion.isoOfRangeEq_hom_fac _ _ _

@[reassoc]