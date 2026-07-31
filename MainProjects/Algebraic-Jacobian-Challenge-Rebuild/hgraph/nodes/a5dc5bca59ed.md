---
author: sync
content_type: theorem
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.fiberTwist_pow
docstring: '**The twist is the `n`-th power of the unit twist: `Θₙ = Θ₁ⁿ`.** The fiber-twist
  scaling

  law consumed by the Wave-4 datum: the pinned twist is `n` copies of the single fiber,
  glued

  by the transition cocycle `t₀ⁿ`.'
file: AlgebraicJacobian/RiemannRoch/FiberTwist.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.fiberTwist_pow
type: lean
updated: '2026-07-31T20:14:48'
---
theorem fiberTwist_pow (n : ℕ) : fiberTwist π n = fiberTwist π 1 ^ n := by
  induction n with
  | zero => rw [fiberTwist_zero, pow_zero]
  | succ n ih => rw [fiberTwist_succ, ih, pow_succ]

/-! ## The degree of the twist -/

section Degree

variable [Y.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (Y ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (Y ↘ Spec (CommRingCat.of K))]
  [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 1)]