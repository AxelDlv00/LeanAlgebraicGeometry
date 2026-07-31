---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.CurveDivisor.single
docstring: 'The one-point Weil divisor `n · x` at a closed point `x`, as a `CurveDivisor`.
  The

  wrapper `CurveDivisor` is a plain `def` over `Finsupp`, which blocks elaboration
  of mixed

  `Finsupp`/`CurveDivisor` arithmetic; this smart constructor keeps one-point divisors
  on

  the `CurveDivisor` side of the seam.'
file: AlgebraicJacobian/RiemannRoch/ChiFiniteness.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.CurveDivisor.single
type: lean
updated: '2026-07-31T20:15:28'
---
noncomputable def Scheme.CurveDivisor.single {x : X} (hx : x ≠ genericPoint X) (n : ℤ) :
    X.CurveDivisor :=
  Finsupp.single (⟨x, hx⟩ : {p : X // p ≠ genericPoint X}) n