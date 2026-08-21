Audit result: the dominant declaration is almost certainly `pic0FiniteStageTripleTransitionFacePackage` at [Pic0FiniteStageTripleTransitionFaceReflection.lean:222](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageTripleTransitionFaceReflection.lean:222), rather than the final `.face` wrapper.

Evidence:
- It alone constructs ten dependent finite/ambient maps and calls `scalarExtensionFacePackage` under `maxHeartbeats 6400000`; its own comment identifies simultaneous inference of tensor-product model carriers.
- The call pins only `A` and `D`; `B` and `E` remain inferred through `rightN`, `thetaN`, and `leftN`, exactly where dependent tensor-product instance unification explodes.
- Historic attempts document non-defeq TensorProduct metadata failures, followed by the current package design as the repair. The current target has no `.olean`, while both direct imports do; session 0090 reports the critical-root build stalled at this module.

Concrete semantics-preserving optimization: explicitly bind and pass all four carrier types at the package call:
```lean
(B := Pic0FiniteStageTripleTransitionModelSource
  C L n m relation M mapM (U, (V, W)))
(E := Pic0FiniteStageTripleTransitionModelTarget
  C L n m relation M mapM (U, (V, W)))
```
alongside the existing explicit `A`/`D`, ideally with typed local aliases for `rightN`, `tauN`, `leftN`, and the three ambient maps. This retains the same `ScalarExtensionFacePackage` and face theorem but prevents elaboration from searching for `B`/`E` and their algebra/tensor instances across every argument.

A smaller follow-on optimization is to make the final theorem build the package once as an explicit `let P := ...; P.face`; its current statement and proof each elaborate the full application. No compile was started and no files/index were changed.
