/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cotangent.GrpObj
import AlgebraicJacobian.Rigidity
import Mathlib.RingTheory.IsTensorProduct
import Mathlib.RingTheory.Kaehler.Basic

-- iter-145 NOTE: the directive named `Mathlib.RingTheory.IsPushout` as a
-- desired import, but that file does not exist upstream; the closest
-- canonical anchor is `Mathlib.RingTheory.IsTensorProduct` (which exposes
-- the `Algebra.IsPushout` square API). The directive also listed
-- `Mathlib.Algebra.CharP.Frobenius`; it is not required for the
-- iter-145 `: True := sorry` placeholders and is intentionally omitted
-- (iter-146 may reintroduce it when the real signatures land).
--
-- iter-146 NOTE: import `AlgebraicJacobian.Rigidity` for the iter-125
-- packaging lemma `Scheme.Over.ext_of_eqOnOpen` consumed by the (lift)
-- sub-piece below. The Mathlib `Algebra.TensorProduct.rightAlgebra` is
-- a `local instance` inside `Mathlib.RingTheory.IsTensorProduct`; we
-- re-enable it as a local instance here so the canonical
-- `Algebra.IsPushout k B₁ B₂ (B₁ ⊗[k] B₂)` instance is in scope for the
-- (α) sub-piece closure.

/-!
# Chart-algebra skeleton for the iter-144 piece (ii) pivot

This file scaffolds the five sub-pieces of the iter-144 chart-algebra pivot
route for piece (ii) of the M2.body-pile (per `STRATEGY.md` §
"Iter-144 chart-algebra pivot — COMMITTED" + `RigidityKbar.tex` §
"Iter-144 chart-algebra envelope for piece (ii)"). Each declaration is
sorry-bodied; the iter-146+ prover lane closes them in turn.

Skeleton authoring is intentionally minimal:

* Signature shape per blueprint sketch (refined by the prover).
* `True` placeholders where the real signature requires
  universe-parameter / instance-argument plumbing not yet in scope
  (iter-128–iter-131 cotangent body-shape refactors are the
  cautionary tale on committing wrong signatures).
* DO NOT attempt body closure here.

For the informal mathematical content + closure-path documentation, see
`blueprint/src/chapters/RigidityKbar.tex` § "Chart-algebra piece (ii)
first-class decomposition".
-/

namespace AlgebraicGeometry

namespace GrpObj

/-- Chart-algebra (α): the affine pullback `Spec R ×_k Spec S = Spec (R ⊗_k S)`
is the canonical `Algebra.IsPushout` square at the ring level. Iter-145
chart-algebra skeleton; body iter-146+.

TODO iter-146: real signature; placeholder is `: True`. -/
theorem algebra_isPushout_of_affine_product : True := sorry

/-- Chart-algebra (β-core): per-chart translation-invariance Kähler-derivation.
If `f^# : Γ(W, O_A) → Γ(V, O_C)` is the chart-affine ring map and the
chart-Kähler-derivation difference `d(f^# φ) - f^# d(φ)` vanishes as a
derivation, then `f^# φ ∈ range (algebraMap k Γ(V, O_C))`. Iter-145
chart-algebra skeleton; body iter-146+.

TODO iter-146: real signature; placeholder is `: True`. -/
theorem df_zero_factors_through_constant_on_chart : True := sorry

end GrpObj

/-- Algebra-level core: for a base field `A`, if `b : B` satisfies `D b = 0`
in `Ω_{B/A}`, then `b ∈ range (algebraMap A B)` — constants are exactly
the kernel of the universal derivation. Iter-145 chart-algebra skeleton;
body iter-146+. Project-namespaced until upstreamed.

TODO iter-146: real signature; placeholder is `: True`. -/
theorem KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero : True := sorry

/-- Integrally-closed-constants helper: in a smooth proper geometrically
irreducible scheme `X` over a base field `k`, the global sections
`Γ(X, O_X) = k` (i.e. constants are exactly the base field). Iter-145
chart-algebra skeleton; body iter-146+.

TODO iter-146: real signature; placeholder is `: True`. -/
theorem constants_integral_over_base_field : True := sorry

namespace Scheme

namespace Over

/-- Scheme-level lift: if `f, g : C → A` over `Spec k` satisfy `df = dg`
and agree on a chart, then `f = g`. Packages the chart-algebra chain
in `Scheme.Over.ext_of_eqOnOpen`-shape. Iter-145 chart-algebra skeleton;
body iter-146+.

TODO iter-146: real signature; placeholder is `: True`. -/
theorem ext_of_diff_zero : True := sorry

end Over

end Scheme

end AlgebraicGeometry
