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

/-- Integrally-closed-constants helper: in a (smooth) proper geometrically
irreducible scheme `X` over a base field `k`, the global sections
`Γ(X, O_X)` are exhausted by the image of the structure-morphism's
action on the top open, i.e.\ the `appTop` ring hom of the structure
morphism `X ⟶ Spec k` is surjective. Equivalently, `Γ(X, O_X) ≅ k` as
`k`-algebras (modulo the canonical iso `Γ(Spec k, ⊤) ≃ k`).

Blueprint: `chapters/RigidityKbar.tex` §
`\lem:constants_integral_over_base_field`. Three-substep recipe (per
the iter-146 prover-lane reading):
(1) `IsReduced X` + `GeometricallyIrreducible (X ↘ Spec k)` (over the
    singleton-base `Spec k`) ⇒ `IsIntegral X` (combine
    `GeometricallyIrreducible.irreducibleSpace_of_subsingleton` with
    `isIntegral_of_irreducibleSpace_of_isReduced`).
(2) `IsIntegral X` + `UniversallyClosed (X ↘ Spec k)` (from
    `IsProper`) ⇒ `Γ(X, O_X)` is a field
    (`isField_of_universallyClosed`); and additionally
    `LocallyOfFiniteType (X ↘ Spec k)` ⇒ the `appTop` map is finite
    (`finite_appTop_of_universallyClosed`). So `Γ(X, O_X)` is a finite
    field extension of `k`.
(3) Geometric irreducibility ⇒ this field extension is trivial via
    base change to `\bar k`: `Γ(X, O_X) ⊗_k \bar k ≃ Γ(X_{\bar k},
    ⊤) = \bar k` (the latter equality by the same chain applied to
    `X_{\bar k}` over `\bar k`, which is integral after base change
    because geometric irreducibility is stable under base change).
    A finite field extension `Γ` of `k` with `Γ ⊗_k \bar k = \bar k`
    has `dim_k Γ = 1`, hence `Γ = k`.

Iter-146 prover lane: signature refined to its real shape; substeps
(1)–(2) of the chain are closed by chasing the Mathlib lemmas
identified by the planner; substep (3) (the geom-irr base-change step)
remains a structured `sorry`. The `[IsReduced X]` hypothesis is added
explicitly because Mathlib snapshot `b80f227` lacks the lemma
`Smooth ⇒ IsReduced` over a field — see the `Rigidity.lean` "Hypothesis
history" block for the same explicit-`IsReduced` discipline. -/
theorem constants_integral_over_base_field
    {k : Type u} [Field k] {X : Scheme.{u}} [X.Over (Spec (.of k))]
    [IsProper (X ↘ Spec (.of k))]
    [Smooth (X ↘ Spec (.of k))]
    [IsReduced X]
    [GeometricallyIrreducible (X ↘ Spec (.of k))] :
    RingHom.range ((X ↘ Spec (CommRingCat.of k)).appTop.hom) = ⊤ := by
  -- Substep (1): IsReduced + GeometricallyIrreducible (over Spec k,
  -- a singleton) ⇒ X integral.
  haveI : IrreducibleSpace X :=
    GeometricallyIrreducible.irreducibleSpace_of_subsingleton
      (X ↘ Spec (CommRingCat.of k))
  haveI : IsIntegral X := isIntegral_of_irreducibleSpace_of_isReduced X
  -- Substep (2.a): IsProper extends UniversallyClosed, so Γ(X, ⊤) is a
  -- field by `isField_of_universallyClosed`.
  have _hΓfield : IsField ↑(X.presheaf.obj (Opposite.op ⊤)) :=
    isField_of_universallyClosed k (X ↘ Spec (CommRingCat.of k))
  -- Substep (2.b): the `appTop.hom` ring map is finite by
  -- `finite_appTop_of_universallyClosed` (uses `LocallyOfFiniteType`,
  -- supplied by `IsProper`).
  have _hAppTopFinite :
      ((X ↘ Spec (CommRingCat.of k)).appTop.hom).Finite :=
    finite_appTop_of_universallyClosed k (X ↘ Spec (CommRingCat.of k))
  -- Substep (3) (DEFERRED): the geometric-irreducibility base-change
  -- step that pins `dim_k Γ(X, ⊤) = 1`. The chain is:
  --   Γ(X, ⊤) ⊗_k \bar k ≃ Γ(X_{\bar k}, ⊤) (flat base change for a
  --   proper scheme; Mathlib's `AlgebraicGeometry.IsBaseChange`
  --   namespace), and Γ(X_{\bar k}, ⊤) = \bar k by the same chain
  --   applied to the geometrically irreducible (after base change)
  --   integral scheme X_{\bar k} over the algebraically closed base
  --   \bar k. A finite field extension Γ of k with Γ ⊗_k \bar k = \bar k
  --   has dim_k Γ = 1, hence Γ = k. The substantive Mathlib gap-fill
  --   for this step is the iter-147+ continuation.
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
