---
author: sync
content_type: lemma
created: '2026-07-28T18:12:20'
decl: CategoryTheory.GrothendieckTopology.MayerVietorisSquare.moduleDeltaQuotient_mk
file: AlgebraicJacobian/RiemannRoch/Ledger/MayerVietoris.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.GrothendieckTopology.MayerVietorisSquare.moduleDeltaQuotient_mk
type: lean
updated: '2026-07-28T18:12:20'
---
lemma moduleDeltaQuotient_mk (s : F.obj.obj (op S.X₁)) :
    S.moduleDeltaQuotient F (Submodule.Quotient.mk s) = S.moduleDelta F s :=
  rfl