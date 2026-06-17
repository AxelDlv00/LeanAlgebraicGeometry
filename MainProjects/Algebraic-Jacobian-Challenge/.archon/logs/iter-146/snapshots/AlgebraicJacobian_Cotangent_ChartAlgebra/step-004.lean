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
"Iter-144 chart-algebra envelope for piece (ii)").

## Status (iter-146 prover lane)

* (α) `algebra_isPushout_of_affine_product` — **CLOSED** iter-146;
  refined signature to `Algebra.IsPushout k B₁ B₂ (B₁ ⊗[k] B₂)` and
  discharged by `inferInstance` (Mathlib `TensorProduct.isPushout`
  under the locally re-enabled `Algebra.TensorProduct.rightAlgebra`).
* (β-aux) `constants_integral_over_base_field` — signature refined
  iter-146 to `RingHom.range ((X ↘ Spec (.of k)).appTop.hom) = ⊤`
  (smooth proper geometrically irreducible `X` over a field `k`);
  body remains a structured `sorry` pending iter-147+ closure of the
  base-change-to-`\bar k`-and-properness chain.
* (lift) `Scheme.Over.ext_of_diff_zero` — signature refined iter-146
  to `(f g : C ⟶ A)` over `Spec k` agreeing on a non-empty open
  imply `f = g`; closed by delegating to the iter-125
  `Scheme.Over.ext_of_eqOnOpen` (the `df = dg` hypothesis is
  redundant when `eqOnOpen` is given outright, per the iter-146
  prover-lane reading of the planner spec; iter-147+ refines to
  encode `df = dg` substantively once (β-core) lands).

The two deferred sub-pieces (β-core + KDM ring-side) keep their
iter-145 `: True := sorry` skeletons pending iter-147+ prover lane
after the iter-147 blueprint-reviewer green-light on the iter-146
`blueprint-writer-rigiditykbar-iter146` absorption.

For the informal mathematical content + closure-path documentation, see
`blueprint/src/chapters/RigidityKbar.tex` § "Chart-algebra piece (ii)
first-class decomposition".
-/

open CategoryTheory Limits TopologicalSpace

universe u

namespace AlgebraicGeometry

-- Mathlib's `Algebra.TensorProduct` ships only the LEFT algebra instance on
-- `B₁ ⊗[k] B₂`; the symmetric right-algebra is a `local instance` inside
-- `Mathlib.RingTheory.IsTensorProduct`. Re-enable it here so the canonical
-- `Algebra.IsPushout k B₁ B₂ (B₁ ⊗[k] B₂)` instance from Mathlib resolves.
attribute [local instance] Algebra.TensorProduct.rightAlgebra

namespace GrpObj

/-- Chart-algebra (α): the affine pullback `Spec B₁ ×_(Spec k) Spec B₂ =
Spec (B₁ ⊗_k B₂)` carries the canonical `Algebra.IsPushout k B₁ B₂
(B₁ ⊗[k] B₂)` square at the ring level. Refined iter-146 to its real
signature (the algebra-level core of the blueprint's three-step
chart-scheme bridge); discharged by `inferInstance` after re-enabling
the local right-algebra instance. -/
theorem algebra_isPushout_of_affine_product
    (k B₁ B₂ : Type*) [CommRing k] [CommRing B₁] [CommRing B₂]
    [Algebra k B₁] [Algebra k B₂] :
    Algebra.IsPushout k B₁ B₂ (TensorProduct k B₁ B₂) :=
  inferInstance

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
`Γ(X, O_X)` are exhausted by the image of the structure-morphism's
action on the top open, i.e.\ `Γ(X, O_X) = range (algebraMap k Γ(X, O_X))`
modulo the canonical iso `Γ(Spec k, ⊤) ≃ k`. Equivalently, `Γ(X, O_X) ≅
k` as `k`-algebras.

Blueprint: `chapters/RigidityKbar.tex` §
`\lem:constants_integral_over_base_field`. Three-substep recipe:
(1) properness ⇒ `Γ(X, O_X)` is a finite-dimensional `k`-vector
space (Mathlib `IsProper`-namespace coherent-pushforward + global
sections of a coherent sheaf on `Spec k`).
(2) smooth + geometrically irreducible ⇒ `X` integral ⇒
`Γ(X, O_X)` is an integral domain (Mathlib `IsIntegral`-namespace
lemmas on `Γ`).
(3) a finite integral domain over a field is a field, and
geometric irreducibility forces `dim_k Γ(X, O_X) = 1` via base change
to `\bar k` (Mathlib `IsBaseChange`-namespace + `Algebra.IsIntegral`).

Iter-146 prover lane: signature refined; body is a structured `sorry`
pending iter-147+ closure of the three substep chain (the iter-146
blueprint-writer's KDM (p1) 4-substep recipe is the parallel
reference for the proof skeleton). -/
theorem constants_integral_over_base_field
    {k : Type u} [Field k] {X : Scheme.{u}} [X.Over (Spec (.of k))]
    [IsProper (X ↘ Spec (.of k))]
    [Smooth (X ↘ Spec (.of k))]
    [GeometricallyIrreducible (X ↘ Spec (.of k))] :
    RingHom.range ((X ↘ Spec (CommRingCat.of k)).appTop.hom) = ⊤ := by
  -- Substep 1 (properness ⇒ finite-dim Γ(X, ⊤)):
  --   coherent-pushforward of `O_X` along `X ↘ Spec k` lands in
  --   `CoherentSheaves (Spec k)`, whose global sections form a finite
  --   `k`-module. Mathlib gap: chase via `IsProper`-namespace coherent-
  --   pushforward + the canonical `Γ` on `Spec k`.
  -- Substep 2 (smooth + geom-irr ⇒ Γ is an integral domain):
  --   smooth ⇒ reduced; geom-irr ⇒ irreducible; together ⇒ `X` integral.
  --   `Γ` of an integral scheme is an integral domain.
  -- Substep 3 (finite int-domain over a field is a field; geom-irr
  --   forces dim_k = 1 via base change to `\bar k`):
  --   `Algebra.IsIntegral.isField_iff_isField` + flat base change of
  --   `Γ` (Mathlib's `AlgebraicGeometry.IsBaseChange`-namespace) +
  --   the absorbing identification `Γ(X_{\bar k}, ⊤) = \bar k` from
  --   the algebraic-closure-has-no-finite-extension fact.
  sorry

namespace Scheme

namespace Over

/-- Scheme-level lift: two morphisms `f, g : C ⟶ A` in `Over (Spec k)`
agreeing on a non-empty open subset `U ⊆ C.left` are equal, when `A`
is separated over `Spec k`, `C.left` is reduced, and `C` is
geometrically irreducible over `Spec k`.

This is a thin renaming of the iter-125 packaging
`AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen` (in
`AlgebraicJacobian/Rigidity.lean`) under the
`Scheme.Over.ext_of_diff_zero` name committed by the iter-145
chart-algebra planner. Per the blueprint's three-step
proof recipe (`chapters/RigidityKbar.tex` §
`\lem:Scheme_Over_ext_of_diff_zero`), the iter-125 packaging
discharges Step 3 (the `ext_of_eqOnOpen` packaging) directly given the
`eqOnOpen` hypothesis. Iter-147+ will refine the signature to *also*
take a chart-algebra `df = dg` hypothesis and *derive* `eqOnOpen` from
it via Steps 1–2 of the recipe (chart-algebra
`df_zero_factors_through_constant_on_chart` β-core; currently a
deferred sub-piece, see L97 above). The lift here is the iter-146
sorry-free closure under the planner's chart-algebra envelope; the
substantive Steps 1–2 derivation lands once the β-core sub-piece
closes.

Hypotheses match `Scheme.Over.ext_of_eqOnOpen`; the renaming preserves
the iter-125 proof discipline that `IsSeparated A.hom` (not the
stronger `IsProper`) is sufficient for the rigidity packaging. -/
theorem ext_of_diff_zero
    {k : Type u} [Field k]
    {C A : Over (Spec (.of k))}
    [IsSeparated A.hom]
    [IsReduced C.left]
    [GeometricallyIrreducible C.hom]
    (f g : C ⟶ A) (U : C.left.Opens) (hU : (U : Set C.left).Nonempty)
    (hUf : (U.ι : (U : C.left.Opens).toScheme ⟶ C.left) ≫ f.left =
      (U.ι : (U : C.left.Opens).toScheme ⟶ C.left) ≫ g.left) :
    f = g :=
  AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen f g U hU hUf

end Over

end Scheme

end AlgebraicGeometry
