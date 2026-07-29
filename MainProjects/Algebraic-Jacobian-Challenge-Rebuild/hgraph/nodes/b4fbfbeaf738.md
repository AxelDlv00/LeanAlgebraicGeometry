---
author: sync
content_type: lemma
created: '2026-07-29T09:42:53'
decl: AlgebraicGeometry.AffAdaptation.relFiberCoordSidePow_false
file: AlgebraicJacobian/Picard/DivisorFamilyAffTheta.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.relFiberCoordSidePow_false
type: lean
updated: '2026-07-29T15:31:44'
---
lemma relFiberCoordSidePow_false (n : ℕ) :
    relFiberCoordSidePow (C := C) (R := R) (π := π) n false
      = relFiberCoordPow C R π n := rfl

@[simp]