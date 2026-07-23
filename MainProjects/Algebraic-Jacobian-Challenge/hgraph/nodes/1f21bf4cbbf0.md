---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.twistedSMul_zero_right
docstring: The local graded action annihilates zero in the module slot.
file: AlgebraicJacobian/Picard/InvertibleSectionLocalization.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.twistedSMul_zero_right
type: lean
updated: '2026-07-16T21:14:27'
---
lemma twistedSMul_zero_right (F L : X.Modules) (i j : ℕ) (U : X.Opens)
    (r : Γ(tensorPow L i, U)) :
    twistedSMul F L i j U r (0 : Γ(moduleTensorPow F L j, U)) = 0 := by
  unfold twistedSMul
  erw [TensorProduct.tmul_zero, map_zero, map_zero]
  rfl