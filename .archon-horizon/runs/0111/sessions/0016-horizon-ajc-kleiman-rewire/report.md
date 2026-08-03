## Progress

- Part 1 remains closed at `8c0f0550e`: both Kleiman consumers import and term-use `CurveProjectivity`.
- [CurveFiniteReplacement.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/CurveFiniteReplacement.lean:50) now produces a concrete two-term finite replacement for arbitrary-field curve families (`a81f6efaec`).
- [H0SemicontinuityInstance.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/H0SemicontinuityInstance.lean:61) consumes that producer instead of reconstructing it (`80e43977a6`).
- The finite-pushforward fibre Euler function is locally constant using one global replacement. Run0111 authored and verified this theorem; `3c20d01ba5` is only its automatic run0114 carrier.
- Graph and roadmap handoff landed through `9ea06d04ff`, `24b82fecb1`, `e2fdf745d9`, and `a7368c13c3`. The roadmap row remains active and unowned.

## Issues

The pointwise Euler wrapper is only interface composition and earns zero Euler/RR/PicEt/seam credit. Metrics remain 37 strict `(rep :)` consumers, +0 arbitrary-field PicEt producers, and the central FGA sorry is untouched.

No run0114 `Projective/` artifact is claimed by this task.

## Why I Stopped

The next step is substantive: compare finite-pushforward H1 and Euler back to `L` on `C_A`. The current library has no general proper-coherent or Riemann--Roch API that supplies this automatically.

Verification passed: narrow build `8708/8708`; import-only probe resolved all three exports; every new declaration uses only `propext`, `Classical.choice`, and `Quot.sound`. The two `QuotFunctorDef` sorry warnings are pre-existing. No root build was run because the umbrella was not edited this round.

## Next

Prove finite-pushforward Euler transfer, then Riemann--Roch degree, quotient/etale descent and pullback naturality, the arbitrary-test Abel pin, and finally intrinsic `Pic^d` carriers with actual very-ample/FiniteInAffine assembly.
