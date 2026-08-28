---
author: sync
content_type: structure
created: '2026-07-24T17:02:46'
decl: Module.IsDescentCocycle
docstring: 'A **descent 1-cocycle** relative to `A → B`: a unit of `B ⊗[A] B`, normalized
  along

  the multiplication map, satisfying the 1-cocycle identity in `B ⊗[A] (B ⊗[A] B)`.  For

  `B = ∏ i, A_{fᵢ}` a finite product of localizations covering `Spec A`, this is exactly
  a

  Čech 1-cocycle of units on the cover by the basic opens `D(fᵢ)`.'
file: AlgebraicJacobian/Descent/UnitDescent.lean
generated: lean
lean_status: lean_ok
title: Module.IsDescentCocycle
type: lean
updated: '2026-08-01T09:44:10'
---
structure IsDescentCocycle (u : (B ⊗[A] B)ˣ) : Prop where
  /-- Normalization: the multiplication `B ⊗[A] B → B` sends the cocycle to `1`. -/
  lmul'_eq_one : Algebra.TensorProduct.lmul' A (S := B) u.val = 1
  /-- The 1-cocycle identity. -/
  cocycle : descentFace₂₃ A B u.val * descentFace₁₂ A B u.val = descentFace₁₃ A B u.val