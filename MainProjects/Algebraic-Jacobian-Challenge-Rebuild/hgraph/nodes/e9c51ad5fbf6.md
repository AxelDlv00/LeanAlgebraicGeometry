---
author: sync
content_type: class
created: '2026-07-24T17:02:47'
decl: identity
file: AlgebraicJacobian/Picard/Pic0ChartLocusFibreField.lean
generated: lean
lean_status: lean_ok
title: identity
type: lean
updated: '2026-07-24T17:02:47'
---
class identity `map (relCurveMap … κ(q)) D_A.cechPicClass = map (relCurveMap … κ(q))
D_B.cechPicClass` (I-0252 gap 1, the Σ/θ naturality) — and the `chartLocus` definition
itself (DAT-C C9).  Both are divRep/C9-gated; neither is a mathematical wall on the
invariance itself, which is complete.
-/

set_option autoImplicit false
/- Statements mix `relCurve C L` with the product spelling `(C ⊗ overSpec k L).left`. -/
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161). -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
open TopologicalSpace Opposite

open scoped TensorProduct

namespace AlgebraicGeometry

open AlgebraicJacobian

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

/-! ## The module-theoretic core -/