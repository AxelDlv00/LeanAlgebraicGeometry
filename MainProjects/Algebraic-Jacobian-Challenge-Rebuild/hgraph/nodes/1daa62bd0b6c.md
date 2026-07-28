---
author: sync
content_type: theorem
created: '2026-07-28T15:00:45'
decl: AlgebraicGeometry.thetaFamily_pow
docstring: '**The θ-family commutes with powers** — so `θ^m` may be read either as
  the `m`-th power

  of the family or as the family of the `m`-th power of the class.  The chart twist
  uses the

  former spelling and the collapse needs the latter.'
file: AlgebraicJacobian/Picard/Pic0ChartTwistCollapse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.thetaFamily_pow
type: lean
updated: '2026-07-28T15:00:45'
---
theorem thetaFamily_pow (L : (C ⊗ overSpec k k).left.CechPic)
    (T : Over (Spec (.of k))) (m : ℕ) :
    thetaFamily C (L ^ m) T = thetaFamily C L T ^ m := by
  unfold thetaFamily thetaBase
  rw [map_pow, map_pow, map_pow, map_pow]

variable (C) in