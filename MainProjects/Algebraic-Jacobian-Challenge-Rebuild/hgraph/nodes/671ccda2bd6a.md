---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.mem_unitGluedOver_iff
file: AlgebraicJacobian/Picard/DivisorFamilyThetaRank.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.mem_unitGluedOver_iff
type: lean
updated: '2026-07-29T15:31:45'
---
lemma mem_unitGluedOver_iff {x : A.chartProd} :
    x ∈ A.unitGluedOver u ↔ x ∈ A.unitGluedSubmodule u :=
  Iff.rfl

/-! ## The pairing input and invertibility -/