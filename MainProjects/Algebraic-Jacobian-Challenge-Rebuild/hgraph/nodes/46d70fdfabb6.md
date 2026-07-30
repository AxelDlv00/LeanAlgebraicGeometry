---
author: sync
content_type: theorem
created: '2026-07-29T04:13:40'
decl: AlgebraicGeometry.whiskerLeft_overDualNumberZero_left'
docstring: The factorisation on the underlying schemes, in the whiskering spelling.
file: AlgebraicJacobian/Tangent/DualNumberUnitTransport.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.whiskerLeft_overDualNumberZero_left'
type: lean
updated: '2026-07-30T15:46:08'
---
theorem whiskerLeft_overDualNumberZero_left' :
    (C ◁ overDualNumberZero k).left
      = (C ◁ (unitIso k).hom).left ≫ (C ◁ overSpecMap (k := k) (DualNumber k) k).left := by
  rw [← Over.comp_left, ← whiskerLeft_overDualNumberZero]

/-! ## The transport on relative curves -/