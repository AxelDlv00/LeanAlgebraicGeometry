---
author: sync
content_type: instance
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.isClosedImmersion_diagonal_left
docstring: '**The diagonal is a closed immersion** (worksheet D4): `δ ≫ snd = 𝟙` is
  a closed

  immersion, `(snd C C).left` is separated (base change of `C.hom`), and

  `IsClosedImmersion.of_comp` cancels.  In particular `(δ C).left` is affine and

  quasi-compact, so Mathlib''s kernel ideal sheaf calculus (`Scheme.Hom.ker_apply`,

  `Scheme.Hom.support_ker`) applies to it.'
file: AlgebraicJacobian/Curve/DiagonalClosed.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.isClosedImmersion_diagonal_left
type: lean
updated: '2026-07-29T15:26:37'
---
instance isClosedImmersion_diagonal_left : IsClosedImmersion (diagonal C).left := by
  haveI : IsClosedImmersion ((diagonal C).left ≫ (snd C C).left) := by
    rw [diagonal_left_snd_left]
    infer_instance
  exact IsClosedImmersion.of_comp (diagonal C).left (snd C C).left