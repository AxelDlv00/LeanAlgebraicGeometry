---
author: sync
content_type: theorem
created: '2026-07-27T01:04:30'
decl: AlgebraicGeometry.P1.autOfMatrix_preimage_chartOpen_sup
docstring: 'The two twisted charts still cover `P¹_k`: preimage preserves `⊔` and
  `⊤`.'
file: AlgebraicJacobian/Curve/P1Aut.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.autOfMatrix_preimage_chartOpen_sup
type: lean
updated: '2026-07-27T10:33:33'
---
theorem autOfMatrix_preimage_chartOpen_sup (M : Matrix.GeneralLinearGroup (Fin 2) k) :
    (autOfMatrix k M ⁻¹ᵁ chartOpen k 0) ⊔ (autOfMatrix k M ⁻¹ᵁ chartOpen k 1) = ⊤ := by
  rw [← Scheme.Hom.preimage_sup, chartOpen_sup, Scheme.Hom.preimage_top]

/-! ### Two-transitivity on rational points -/