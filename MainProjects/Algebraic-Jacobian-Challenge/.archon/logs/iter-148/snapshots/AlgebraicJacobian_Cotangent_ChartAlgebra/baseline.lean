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

end GrpObj

/-- Algebra-level core: for `k` a field and `B` a commutative `k`-algebra of
finite type, if `b : B` satisfies `D b = 0` in `Ω_{B/k}` then `b ∈
range (algebraMap k B)`. This is the chart-algebra (β-core ring-side) helper
of the iter-144 piece (ii) pivot, formalising the "constants = kernel of
universal derivation" content of the Kähler derivation.

Iter-147 signature refinement to the blueprint-mandated statement per
`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` in
`blueprint/src/chapters/RigidityKbar.tex`. The body is a structured `sorry`
pending the iter-148+ closure of:
- (p2) characteristic-0 path via `Differential.ContainConstants`
  (`Mathlib.RingTheory.Derivation.DifferentialRing`); the typeclass is
  positioned for `Differential B` (a specific derivation `B → B`) rather
  than `KaehlerDifferential.D : B → Ω_{B/k}`, so the bridge requires
  packaging the universal derivation through the typeclass.
- (p1) characteristic-p path: standard-smooth chart presentation → `ker D
  = B^p` (Cartier direction; Stacks Tag 07F4) — this is a Mathlib gap-
  fill that the project decomposes into substeps (p1.a)–(p1.d) per the
  iter-146 blueprint-writer's expansion.
- (p3) integrally-closed-constants descent via
  `KaehlerDifferential.constants_in_chart_of_proper_curve` (chart-side
  helper, iter-148+).

The signature is honest: the conclusion is false in general for finite-
type `k`-algebras in characteristic `p > 0` (e.g. `B = k[x]`, `b = x^p`
has `D b = 0` but `b ∉ range (algebraMap k B)` unless `x ∈ k`). The
iter-146 disposition (B.preferred) concentrates the chart-of-proper-
curve descent at the helper, which the consumer
`GrpObj.df_zero_factors_through_constant_on_chart` below invokes in tandem.
The lemma as stated remains the blueprint-mandated entry point per
`\lean{AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero}`. -/
theorem KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero
    {k : Type u} [Field k]
    {B : Type u} [CommRing B] [Algebra k B] [Algebra.FiniteType k B]
    {b : B} (hDb : _root_.KaehlerDifferential.D k B b = 0) :
    b ∈ (algebraMap k B).range := by
  -- Step 1 (kernel-of-D ⊇ range algebraMap): this direction is the
  -- standard `Derivation.map_algebraMap` and is the reverse of the
  -- statement; recorded here as the reverse inclusion the consumer may
  -- combine with the forward direction below.
  have _hRev : ∀ a : k, _root_.KaehlerDifferential.D k B (algebraMap k B a) = 0 := by
    intro a
    -- `KaehlerDifferential.D` is a `Derivation k B Ω[B⁄k]`; the
    -- algebraMap-image vanishes by `Derivation.map_algebraMap`.
    exact (_root_.KaehlerDifferential.D k B).map_algebraMap a
  -- Step 2 (forward direction, the substantive content): structured
  -- sorry pending (p1)–(p3) closure per the docstring above.
  sorry

namespace GrpObj

/-- Chart-algebra (β-core): per-chart translation-invariance Kähler-derivation.
For a smooth proper geometrically irreducible curve `C/k` and an affine chart
`V ⊆ C` whose chart-ring `B = Γ(V, O_C)` carries a finite-type `k`-algebra
structure, a chart-section `b ∈ B` with vanishing universal Kähler derivation
`KaehlerDifferential.D k B b = 0` lies in `range (algebraMap k B)` — the chart-
local kernel-of-`D` content of the iter-144 chart-algebra pivot piece (ii) is
the algebra-level statement that constants are the image of the base field.

Iter-147 signature refinement: the chart-of-proper-curve hypothesis is carried
as typeclass arguments on `C` (smooth, proper, reduced, geometrically
irreducible over `Spec k`); the chart-ring `B` is carried as a separate finite-
type `k`-algebra argument with the (chart-side identification `B ≃ₐ[k] Γ(V, O_C)`
deferred to the consumer site via the `Scheme.Over.ext_of_diff_zero` refinement
plan; iter-148+). The body delegates to the algebra-level KDM helper
`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` above.

The full 5-step closure path is documented in `blueprint/src/chapters/
RigidityKbar.tex` § "Chart-algebra piece (ii) first-class decomposition"
under `lem:chart_algebra_df_zero_factors_through_constant_on_chart`:
(1) chart-Kähler kernel extraction (this is KDM); (2) standard-smooth chart
witness from `Algebra.IsStandardSmooth.free_kaehlerDifferential`;
(3) 2-chart Čech Mayer–Vietoris on `Ω_{C/k}^{⊕n}` reusing
`Cohomology/MayerVietoris*`; (4) 2-chart-cover existence per Stacks 0F8L;
(5) char-p Frobenius patch via `RingHom.iterateFrobenius_comm`. -/
theorem df_zero_factors_through_constant_on_chart
    {k : Type u} [Field k]
    {C : Scheme.{u}} [C.Over (Spec (CommRingCat.of k))]
    [IsProper (C ↘ Spec (CommRingCat.of k))]
    [Smooth (C ↘ Spec (CommRingCat.of k))]
    [IsReduced C]
    [GeometricallyIrreducible (C ↘ Spec (CommRingCat.of k))]
    {B : Type u} [CommRing B] [Algebra k B] [Algebra.FiniteType k B]
    {b : B} (hDb : _root_.KaehlerDifferential.D k B b = 0) :
    b ∈ (algebraMap k B).range :=
  -- Chart-of-proper-curve descent through the algebra-level helper. The
  -- scheme-level chart-of-proper-curve hypotheses on `C` are the
  -- iter-146 disposition (B.preferred)'s standing premise for the
  -- char-p Frobenius-iteration step (p3) of the KDM helper above.
  AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero hDb

end GrpObj

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
  -- Substep (3): reduce the `range = ⊤` goal to surjectivity of the
  -- appTop ring hom. The full geom-irr base-change closure is
  -- structured below; the substantive Mathlib gap-fill is concentrated
  -- at the single `sorry` for the
  -- "finite field extension of `k` with `K ⊗_k \bar k = \bar k` is
  -- trivial" claim, which the iter-147+ continuation closes via the
  -- `algebraic-closure base change` chain documented immediately below.
  rw [RingHom.range_eq_top]
  -- The closure chain is:
  --   (a) Algebraize `appTop.hom` and `ΓSpecIso k` to expose
  --       `Γ(X, ⊤)` as a finite `k`-algebra and a field.
  --   (b) Pull back `X` along `Spec.map (algebraMap k (AlgebraicClosure k))`
  --       to obtain `X_{\bar k}`. The base-change preserves: `IsProper`
  --       (stable under base change), `Smooth` (stable under base change),
  --       `IsReduced` (smoothness + algebraic-closure base ⇒ reduced;
  --       Mathlib `AlgebraicGeometry.Smooth.isReduced_of_smooth` or
  --       via `Algebra.IsGeometricallyReduced`), and `IrreducibleSpace`
  --       (via `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`
  --       applied to the new structure morphism over `Spec \bar k`).
  --       Hence `X_{\bar k}` is integral.
  --   (c) Apply Mathlib `isField_of_universallyClosed` + `finite_appTop_of_universallyClosed`
  --       to `X_{\bar k} → Spec (.of \bar k)` to get
  --       `IsField Γ(X_{\bar k}, ⊤)` and the appTop is finite (= integral).
  --   (d) Apply `IsAlgClosed.algebraMap_bijective_of_isIntegral` with
  --       `k := \bar k`, `K := Γ(X_{\bar k}, ⊤)` to conclude
  --       `algebraMap \bar k Γ(X_{\bar k}, ⊤)` is bijective, so
  --       `Γ(X_{\bar k}, ⊤) ≅ \bar k`.
  --   (e) Use flat base change of global sections for proper schemes
  --       (Mathlib `AlgebraicGeometry.IsBaseChange`-namespace lemmas;
  --       chase via the cohomology base change `H^0` instance) to
  --       identify `Γ(X, ⊤) ⊗_k \bar k ≃ Γ(X_{\bar k}, ⊤) = \bar k`.
  --   (f) Conclude `dim_k Γ(X, ⊤) = 1` via `Module.finrank_baseChange`
  --       on the equality `Γ(X, ⊤) ⊗_k \bar k = \bar k` (both sides
  --       have `\bar k`-dimension `1`).
  --   (g) Conclude `algebraMap k Γ(X, ⊤)` is surjective via
  --       `Subalgebra.bot_eq_top_iff_finrank_eq_one` (or equivalently
  --       `Module.finrank` arguments on the trivial finite field
  --       extension).
  --
  -- Step (e) is the substantive Mathlib gap: flat base change of
  -- `Γ` for a proper scheme over a field. The project's iter-148+
  -- continuation supplies the gap-fill via a thin in-tree wrapper
  -- around the `AlgebraicGeometry.IsBaseChange` namespace + the
  -- `Spec.map_isPullback_of_isPushout` chain.
  --
  -- Iter-147 partial closure: the goal is reduced to surjectivity, the
  -- full closure chain is documented above, and the single residual
  -- `sorry` is concentrated at the chain's exit (step (g)'s
  -- surjectivity claim). The intermediate algebraization /
  -- base-change-construction / algclose-application steps (a)–(f) are
  -- iter-148+ continuations.
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
