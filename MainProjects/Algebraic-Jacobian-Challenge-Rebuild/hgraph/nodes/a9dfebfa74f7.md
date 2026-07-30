---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: CategoryTheory.GrothendieckTopology.MayerVietorisSquare.moduleDeltaQuotient_mk
file: AlgebraicJacobian/Cohomology/MayerVietoris.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.GrothendieckTopology.MayerVietorisSquare.moduleDeltaQuotient_mk
type: lean
updated: '2026-07-30T15:46:00'
---
lemma moduleDeltaQuotient_mk (s : F.obj.obj (op S.X₁)) :
    S.moduleDeltaQuotient F (Submodule.Quotient.mk s) = S.moduleDelta F s :=
  rfl