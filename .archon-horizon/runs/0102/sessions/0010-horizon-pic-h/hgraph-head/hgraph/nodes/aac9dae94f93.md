---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.divUniversalFst
docstring: '**The universal first window** `K_M^{univ}` over a `Z(♦)`-chart ring:
  the

  tautological chart-`I` window pushed to the quotient.'
file: AlgebraicJacobian/Picard/DivSchemeFamilyUniv.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalFst
type: lean
updated: '2026-08-01T09:44:11'
---
noncomputable def divUniversalFst (i : (glueData k g r₁).J) (j : (glueData k g r₂).J) :
    grFunctorAff k (Fin r₁ → k) g (DivCarveChartRing k A B g r₁ r₂ b₁ b₂ i j) :=
  Module.Grassmannian.map (divCarveChartMk k A B g r₁ r₂ b₁ b₂ i j)
    (pairTautFst k g r₁ r₂ i j)