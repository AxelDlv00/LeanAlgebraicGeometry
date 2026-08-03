## Progress

- Closed Part 1: `CurveProjectivity` is explicitly imported and term-used at both Kleiman consumer boundaries. Import-only probes resolve `Adelic.isProjective_of_smoothProperGeometricallyIntegral`.
- Added derived/Cech Euler comparison, generic two-term kernel/cokernel transport, and family-to-fibre Cech equivalences with H0 and H1 consequences.
- Commit `3d902798c7` gives [RigidPushforwardFiberChart.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardFiberChart.lean:490) sole ownership of `exists_fiberCechLinearEquiv`; [RigidPushforwardRank.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardRank.lean:9) now consumes it through an explicit dependency.
- Removed 209 lines of duplicated high-heartbeat proof.
- Metadata commits: `918dc5993359` and `c028187d813f`. Independent review found no issues.

Verification passed:

- FiberChart: `8684/8684`
- Rank: `8690/8690`
- Import-only probes passed for five declarations.
- All new declarations use only `propext`, `Classical.choice`, and `Quot.sound`.

## Issues

Arbitrary-field PicEt producers remain `+0`; strict `(rep :)` consumers remain `+0`; `fgaPicardRepresentability` is untouched. The two warnings are pre-existing sorries in `QuotFunctorDef.lean:458` and `:690`.

No umbrella build was run because no umbrella import changed.

## Why I Stopped

This round completed a coherent, verified substrate unit and repaired the transient duplicate-declaration integration state. The full FiniteInAffine/very-ample objective remains active.

## Next

Join the fibre Euler calculation across the residue-field versus `Spec` global-section scalar dialects, then build finite replacements and the Riemann–Roch degree theorem. Intrinsic Picard degree carriers and representation must precede any general Proj/ample work because no current typed consumer exists.
