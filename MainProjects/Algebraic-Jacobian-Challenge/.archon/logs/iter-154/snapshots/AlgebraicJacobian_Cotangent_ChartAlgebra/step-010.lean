/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cotangent.ChartAlgebraS3
import AlgebraicJacobian.Cotangent.GrpObj
import AlgebraicJacobian.Rigidity
import Mathlib.RingTheory.IsTensorProduct
import Mathlib.RingTheory.Kaehler.Basic
import Mathlib.RingTheory.Kaehler.Polynomial
import Mathlib.RingTheory.Smooth.StandardSmoothCotangent
import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.RingTheory.Etale.Kaehler
import Mathlib.RingTheory.Kaehler.JacobiZariski
import Mathlib.RingTheory.Smooth.Field
import Mathlib.RingTheory.Flat.FaithfullyFlat.Basic
import Mathlib.FieldTheory.IntermediateField.Adjoin.Basic
import Mathlib.FieldTheory.Perfect

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

## Status (iter-153 prover lane)

* (α) `GrpObj.algebra_isPushout_of_affine_product` — **CLOSED** iter-146;
  signature `Algebra.IsPushout k B₁ B₂ (B₁ ⊗[k] B₂)`, discharged by
  `inferInstance` (Mathlib `TensorProduct.isPushout` under the locally
  re-enabled `Algebra.TensorProduct.rightAlgebra`).
* (β-aux) `constants_integral_over_base_field` — **CLOSED** iter-153.
  Signature `RingHom.range ((X ↘ Spec (.of k)).appTop.hom) = ⊤` for a
  smooth proper geometrically irreducible `X` over an algebraically
  closed field `k` (`[IsAlgClosed k]`). The iter-152 alg-closed pivot
  collapses the proof to three steps: `IsIntegral X` ⟹ `Γ(X,⊤)` a field
  (`isField_of_universallyClosed`), finite over `k`
  (`finite_appTop_of_universallyClosed`), then
  `IsAlgClosed.algebraMap_bijective_of_isIntegral` ⟹ structure ring hom
  surjective. No `ChartAlgebraS3` (S3.*) lemma consumed.
* (KDM ring-side) `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
  — corrected iter-152 to `[IsAlgClosed k] [CharZero k] [IsDomain B]`
  (the bare B-only form is false; see the in-body counterexample note).
  Residual structured `sorry` = blueprint step (FT.3), the
  separable-field-extension kernel-of-`d` fact, confirmed ABSENT from
  Mathlib at iter-153 (see the BRIGHT-LINE note at the `sorry`). The
  (C.a)-(C.c) FREE-CASE `_mvPoly_*` helpers + `_hFunct` functoriality
  reduction remain valid and reusable.
* (β-core) `GrpObj.df_zero_factors_through_constant_on_chart` —
  one-line delegate to the corrected KDM (inherits its hypotheses).
* (lift) `Scheme.Over.ext_of_diff_zero` — **CLOSED** iter-146;
  delegates to the iter-125 `Scheme.Over.ext_of_eqOnOpen`.

For the informal mathematical content + closure-path documentation, see
`blueprint/src/chapters/RigidityKbar.tex` § "Chart-algebra piece (ii)
first-class decomposition".
-/

open CategoryTheory Limits TopologicalSpace
open scoped IntermediateField TensorProduct

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

/-- (FT.3 base case) The universal Kähler derivation does not kill the
transcendental generator: `D (X) ≠ 0` in `Ω[Frac(k[X])⁄k]`. Verified route
(analogist iter-154): `Ω[Frac(k[X])⁄k]` is the localization of `Ω[k[X]⁄k]`
(`KaehlerDifferential.isLocalizedModule_map`, formally-étale localization),
so `D X = 0` would give `c • D_{k[X]} X = 0` for some non-zero-divisor `c`;
transporting along the `k[X]`-linear iso `polynomialEquiv` (with
`polynomialEquiv_D` ↦ `derivative X = 1`) yields `c • 1 = 0`, contradicting
`nonZeroDivisors.coe_ne_zero`. -/
private lemma _ratfunc_D_X_ne_zero {k : Type*} [Field k] :
    _root_.KaehlerDifferential.D k (FractionRing (Polynomial k))
      (algebraMap (Polynomial k) (FractionRing (Polynomial k)) Polynomial.X) ≠ 0 := by
  intro h
  have hmap : _root_.KaehlerDifferential.map k k (Polynomial k)
      (FractionRing (Polynomial k))
      (_root_.KaehlerDifferential.D k (Polynomial k) Polynomial.X) = 0 := by
    rw [_root_.KaehlerDifferential.map_D]; exact h
  haveI : IsLocalizedModule (nonZeroDivisors (Polynomial k))
      (_root_.KaehlerDifferential.map k k (Polynomial k)
        (FractionRing (Polynomial k))) :=
    _root_.KaehlerDifferential.isLocalizedModule_map k (Polynomial k)
      (FractionRing (Polynomial k)) (nonZeroDivisors (Polynomial k))
  rw [IsLocalizedModule.eq_zero_iff (nonZeroDivisors (Polynomial k))] at hmap
  obtain ⟨c, hc⟩ := hmap
  rw [Submonoid.smul_def] at hc
  have hc1 := congrArg (_root_.KaehlerDifferential.polynomialEquiv (R := k)) hc
  rw [map_smul, _root_.KaehlerDifferential.polynomialEquiv_D, Polynomial.derivative_X,
    map_zero, smul_eq_mul, mul_one] at hc1
  exact nonZeroDivisors.coe_ne_zero c hc1

/-- (FT.3 closer) Over an algebraically closed base field `k`, an element of a
`k`-algebra field `K` that is algebraic over `k` lies in the image of
`algebraMap k K`. Verified route (analogist iter-154): `k⟮b⟯` is finite over `k`
(`IntermediateField.adjoin.finiteDimensional`), hence integral, so
`IsAlgClosed.algebraMap_bijective_of_isIntegral` makes `algebraMap k k⟮b⟯`
surjective; pull the generator back. -/
private lemma _algebraic_mem_range {k K : Type*} [Field k] [Field K] [IsAlgClosed k]
    [Algebra k K] {b : K} (hb : IsAlgebraic k b) :
    b ∈ (algebraMap k K).range := by
  haveI : FiniteDimensional k k⟮b⟯ := IntermediateField.adjoin.finiteDimensional hb.isIntegral
  haveI : Algebra.IsIntegral k k⟮b⟯ := Algebra.IsIntegral.of_finite k k⟮b⟯
  obtain ⟨c, hc⟩ :=
    (IsAlgClosed.algebraMap_bijective_of_isIntegral (k := k) (K := k⟮b⟯)).surjective
      (IntermediateField.AdjoinSimple.gen k b)
  exact ⟨c, by
    have := congrArg (algebraMap k⟮b⟯ K) hc
    rwa [← IsScalarTower.algebraMap_apply, IntermediateField.AdjoinSimple.algebraMap_gen]
      at this⟩

/-- Algebra-level core (KDM): for `k` an algebraically closed field of
characteristic 0 (`[IsAlgClosed k] [CharZero k]`) and `B` a finite-type
`k`-algebra that is an integral domain (`[IsDomain B]`), if `b : B` satisfies
`D b = 0` in `Ω[B⁄k]` then `b ∈ range (algebraMap k B)`. This is the
chart-algebra (β-core ring-side) helper of the iter-144 piece (ii) pivot,
formalising the "constants = kernel of the universal derivation" content of
the Kähler derivation in characteristic 0.

The JOINT `[IsAlgClosed k]` + `[IsDomain B]` hypotheses are essential — the
bare `B`-only form is FALSE (counterexamples: `B = k × k` killed by
`[IsDomain B]`; `B = ℚ(√2)/ℚ` killed by `[IsAlgClosed k]`).

CLOSED iter-154 via the verified single-element / perfect-field /
Jacobi–Zariski `H1Cotangent` route (analogist `ftthree-kernel`,
`analogies/ftthree-kernel-iter154.md`; blueprint `RigidityKbar.tex` § FT):
* (FT.1) push `D_B b = 0` to the fraction field `K = Frac B` via
  `KaehlerDifferential.map_D`; it suffices to put `algebraMap B K b` in
  `range (algebraMap k K)` and pull back along the injective `B ↪ K`;
* (FT.2) reduce to `IsAlgebraic k (algebraMap B K b)`: if it were
  transcendental, embed `F = Frac(k[X]) ↪ K` (`X ↦ bK`); char-0 ⟹
  `PerfectField F`, and `K` is `EssFiniteType` over `F`, so
  `Algebra.FormallySmooth.of_perfectField` gives `FormallySmooth F K`, hence
  `Subsingleton (H1Cotangent F K)`; the Jacobi–Zariski exact sequence
  (`Algebra.H1Cotangent.exact_δ_mapBaseChange`) then makes `mapBaseChange k F K`
  injective, and `mapBaseChange (1 ⊗ D_F X_F) = D_K bK = 0` ⟹ (faithful
  flatness, `Module.FaithfullyFlat.one_tmul_eq_zero_iff`) `D_F X_F = 0`;
* (FT.3) the base case `_ratfunc_D_X_ne_zero` (`D_F X ≠ 0` via the localized
  Kähler module + `polynomialEquiv_D`) contradicts that, so `bK` is algebraic;
  `_algebraic_mem_range` (alg-closed `k`) then lands `bK ∈ range`.

The standard-smooth / relative-dimension hypotheses (`n`,
`[IsStandardSmoothOfRelativeDimension n k B]`) are NOT used by this route —
only `[IsDomain B]` + `[Algebra.FiniteType k B]` to build `K` and the
`EssFiniteType k K` chain — but they are retained on the signature (frozen,
harmless) for the downstream consumer.

Reverse inclusion: `_hRev` records that `D ∘ algebraMap k B = 0` so the
forward direction stated here is the substantive content. Downstream
consumer: `GrpObj.df_zero_factors_through_constant_on_chart` below. -/
theorem KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    {B : Type u} [CommRing B] [IsDomain B] [Algebra k B] [Algebra.FiniteType k B]
    {n : ℕ} [Algebra.IsStandardSmoothOfRelativeDimension n k B]
    {b : B} (hDb : _root_.KaehlerDifferential.D k B b = 0) :
    b ∈ (algebraMap k B).range := by
  classical
  -- Reverse inclusion (recorded for downstream symmetry):
  -- `D : Derivation k B Ω[B⁄k]` vanishes on the algebraMap image by
  -- `Derivation.map_algebraMap`.
  have _hRev : ∀ a : k, _root_.KaehlerDifferential.D k B (algebraMap k B a) = 0 :=
    fun a => (_root_.KaehlerDifferential.D k B).map_algebraMap a
  -- ===========================================================================
  -- iter-154 closure: the verified single-element / perfect-field /
  -- Jacobi–Zariski `H1Cotangent` route (analogist `ftthree-kernel`,
  -- `analogies/ftthree-kernel-iter154.md`). The standard-smooth structure is
  -- NOT used by this argument (only `[IsDomain B]` + `[FiniteType k B]` to
  -- build `K = Frac B` and `EssFiniteType k K`); `n` and standard-smoothness
  -- remain harmless ambient hypotheses.
  -- ===========================================================================
  -- (FT.1) Push `D_B b = 0` forward to the fraction field `K = Frac B`.
  set K := FractionRing B with hK
  have hDbK : _root_.KaehlerDifferential.D k K (algebraMap B K b) = 0 := by
    rw [← _root_.KaehlerDifferential.map_D k k B K b, hDb, map_zero]
  -- It suffices to put `algebraMap B K b ∈ range(algebraMap k K)`; pull back
  -- along the injective `algebraMap B K` (domain ↪ fraction field).
  suffices hbK : algebraMap B K b ∈ (algebraMap k K).range by
    obtain ⟨c, hc⟩ := hbK
    refine ⟨c, ?_⟩
    apply IsFractionRing.injective B K
    rw [← IsScalarTower.algebraMap_apply k B K]
    exact hc
  -- Reduce to algebraicity of `bK := algebraMap B K b` over `k`, then close
  -- with `_algebraic_mem_range` (alg-closed `k`).
  apply _algebraic_mem_range
  -- (FT.2) Suppose, for contradiction, that `bK` is transcendental over `k`.
  by_contra hCon
  have hTr : Transcendental k (algebraMap B K b) := hCon
  have hInj : Function.Injective ⇑(Polynomial.aeval (algebraMap B K b)) :=
    transcendental_iff_injective.mp hTr
  -- Embed `F = Frac(k[X])` into `K` by `X ↦ bK` via `IsFractionRing.lift`.
  set F := FractionRing (Polynomial k) with hF
  have hg : Function.Injective ⇑((Polynomial.aeval (algebraMap B K b)).toRingHom) := hInj
  letI algFK : Algebra F K := (IsFractionRing.lift hg).toAlgebra
  have hψ : ∀ x : Polynomial k,
      algebraMap F K (algebraMap (Polynomial k) F x) =
        (Polynomial.aeval (algebraMap B K b)).toRingHom x :=
    fun x => IsFractionRing.lift_algebraMap hg x
  -- Scalar tower `k → F → K`: `algebraMap F K ∘ algebraMap k F = algebraMap k K`.
  haveI : IsScalarTower k F K := by
    refine IsScalarTower.of_algebraMap_eq (fun x => ?_)
    rw [IsScalarTower.algebraMap_apply k (Polynomial k) F x, hψ]
    change algebraMap k K x =
      (Polynomial.aeval (algebraMap B K b)) (algebraMap k (Polynomial k) x)
    rw [Polynomial.algebraMap_eq, Polynomial.aeval_C]
  -- `K` is essentially of finite type over `F` (via `EssFiniteType k K`).
  haveI : Algebra.EssFiniteType k K := Algebra.EssFiniteType.comp k B (FractionRing B)
  haveI : Algebra.EssFiniteType F K := Algebra.EssFiniteType.of_comp k F K
  -- `F` is a perfect field (char 0) ⟹ `K/F` formally smooth ⟹ `H¹` vanishes.
  haveI : PerfectField F := PerfectField.ofCharZero
  haveI : Algebra.FormallySmooth F K := Algebra.FormallySmooth.of_perfectField
  -- (FT.2 core) `mapBaseChange k F K` is injective via the Jacobi–Zariski
  -- exact sequence + `Subsingleton (H1Cotangent F K)` from formal smoothness.
  have hMapInj : Function.Injective (_root_.KaehlerDifferential.mapBaseChange k F K) := by
    rw [injective_iff_map_eq_zero]
    intro x hx
    obtain ⟨y, rfl⟩ := (Algebra.H1Cotangent.exact_δ_mapBaseChange k F K x).mp hx
    rw [Subsingleton.elim y 0, map_zero]
  -- `algebraMap F K (image of X) = bK`.
  have hbKeq : algebraMap F K (algebraMap (Polynomial k) F Polynomial.X) =
      algebraMap B K b := by
    rw [hψ]; exact Polynomial.aeval_X _
  -- `mapBaseChange (1 ⊗ D_F X_F) = D_K (algebraMap F K X_F) = D_K bK = 0`.
  have hident : _root_.KaehlerDifferential.mapBaseChange k F K
      (1 ⊗ₜ _root_.KaehlerDifferential.D k F
        (algebraMap (Polynomial k) F Polynomial.X)) =
      _root_.KaehlerDifferential.D k K
        (algebraMap F K (algebraMap (Polynomial k) F Polynomial.X)) := by
    rw [_root_.KaehlerDifferential.mapBaseChange_tmul, one_smul,
      _root_.KaehlerDifferential.map_D]
  have h1tmul : (1 ⊗ₜ _root_.KaehlerDifferential.D k F
      (algebraMap (Polynomial k) F Polynomial.X) : K ⊗[F] Ω[F⁄k]) = 0 := by
    apply hMapInj
    rw [map_zero, hident, hbKeq]
    exact hDbK
  -- Faithful flatness of the field extension `F → K` cancels the `1 ⊗ -`.
  have hDFX : _root_.KaehlerDifferential.D k F
      (algebraMap (Polynomial k) F Polynomial.X) = 0 :=
    (Module.FaithfullyFlat.one_tmul_eq_zero_iff F (Ω[F⁄k]) _).mp h1tmul
  -- (FT.3 base case) But `D_F X_F ≠ 0` — contradiction.
  exact _ratfunc_D_X_ne_zero hDFX

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
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    {C : Scheme.{u}} [C.Over (Spec (CommRingCat.of k))]
    [IsProper (C ↘ Spec (CommRingCat.of k))]
    [Smooth (C ↘ Spec (CommRingCat.of k))]
    [IsReduced C]
    [GeometricallyIrreducible (C ↘ Spec (CommRingCat.of k))]
    {B : Type u} [CommRing B] [IsDomain B] [Algebra k B] [Algebra.FiniteType k B]
    {n : ℕ} [Algebra.IsStandardSmoothOfRelativeDimension n k B]
    {b : B} (hDb : _root_.KaehlerDifferential.D k B b = 0) :
    b ∈ (algebraMap k B).range :=
  -- Iter-149 signature inflation: `[CharZero k]` and
  -- `[Algebra.IsStandardSmoothOfRelativeDimension n k B]` propagated
  -- from the KDM (p2) bridge directive in `PROGRESS.md` § "Iter-149
  -- Lane 2". Char-p alternative (p1) path is deferred. The scheme-
  -- level chart-of-proper-curve hypotheses on `C` remain the
  -- standing premise for a future char-p reactivation if the
  -- project widens the KDM commitment.
  AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero (n := n) hDb

end GrpObj

/-- Integrally-closed-constants helper: in a (smooth) proper geometrically
irreducible scheme `X` over a base field `k`, the global sections
`Γ(X, O_X)` are exhausted by the image of the structure-morphism's
action on the top open, i.e.\ the `appTop` ring hom of the structure
morphism `X ⟶ Spec k` is surjective. Equivalently, `Γ(X, O_X) ≅ k` as
`k`-algebras (modulo the canonical iso `Γ(Spec k, ⊤) ≃ k`).

Blueprint: `chapters/RigidityKbar.tex` §
`\lem:constants_integral_over_base_field`. CLOSED iter-153 under the
iter-152 alg-closed pivot (`[IsAlgClosed k]`); the proof is three steps:
(1) `IsReduced X` + `GeometricallyIrreducible (X ↘ Spec k)` (over the
    singleton-base `Spec k`) ⇒ `IrreducibleSpace X`
    (`GeometricallyIrreducible.irreducibleSpace_of_subsingleton`) ⇒
    `IsIntegral X` (`isIntegral_of_irreducibleSpace_of_isReduced`);
    `IsProper` ⇒ `UniversallyClosed` ⇒ `Γ(X, O_X)` is a field
    (`isField_of_universallyClosed`).
(2) `IsProper` (⇒ `UniversallyClosed` + `LocallyOfFiniteType`) ⇒ the
    structure-morphism `appTop` ring hom `k → Γ(X, O_X)` is finite
    (`finite_appTop_of_universallyClosed`), hence `Γ(X, O_X)` is
    integral over `k`.
(3) `k` algebraically closed ⇒ an integral extension is trivial:
    `IsAlgClosed.algebraMap_bijective_of_isIntegral` gives
    `algebraMap k Γ(X, O_X)` bijective, hence surjective, i.e.
    `RingHom.range (appTop.hom) = ⊤`. (Under `[IsAlgClosed k]` the
    former base-change-to-`\bar k` substep collapses entirely — no
    `ChartAlgebraS3` separability/inseparability factorisation is used.)

The `[IsReduced X]` hypothesis is added explicitly because Mathlib
snapshot `b80f227` lacks the lemma `Smooth ⇒ IsReduced` over a field —
see the `Rigidity.lean` "Hypothesis history" block for the same
explicit-`IsReduced` discipline. -/
theorem constants_integral_over_base_field
    {k : Type u} [Field k] [IsAlgClosed k] {X : Scheme.{u}} [X.Over (Spec (.of k))]
    [IsProper (X ↘ Spec (.of k))]
    [Smooth (X ↘ Spec (.of k))]
    [IsReduced X]
    [GeometricallyIrreducible (X ↘ Spec (.of k))] :
    RingHom.range ((X ↘ Spec (CommRingCat.of k)).appTop.hom) = ⊤ := by
  -- Iter-153 alg-closed closure. Under `[IsAlgClosed k]` the proof
  -- collapses to three steps: (1) `X` integral ⟹ `Γ(X, O_X)` a field;
  -- (2) properness ⟹ `Γ(X, O_X)` finite (hence integral) over `k`;
  -- (3) `IsAlgClosed.algebraMap_bijective_of_isIntegral` gives the
  -- structure ring hom `k → Γ(X, O_X)` bijective, hence surjective,
  -- which is the displayed `range = ⊤`.
  set f := X ↘ Spec (CommRingCat.of k) with hf
  -- (1) `X` is integral: smoothness gives `IsReduced X`, geometric
  -- irreducibility over the singleton base `Spec k` gives `IrreducibleSpace X`,
  -- and the two combine to `IsIntegral X`.
  haveI : IrreducibleSpace X :=
    GeometricallyIrreducible.irreducibleSpace_of_subsingleton f
  haveI : IsIntegral X := isIntegral_of_irreducibleSpace_of_isReduced X
  -- (1, cont.) properness ⟹ universally closed ⟹ `Γ(X, ⊤)` is a field.
  letI : Field Γ(X, ⊤) := (isField_of_universallyClosed k f).toField
  -- (2) The composite `F : k → Γ(X, ⊤)` (structure map through the
  -- canonical `ΓSpecIso`) is finite, hence integral over `k`.
  let F := (Scheme.ΓSpecIso (CommRingCat.of k)).inv ≫ f.appTop
  have hFinF : F.hom.Finite := by
    apply RingHom.finite_respectsIso.2
      (e := (Scheme.ΓSpecIso (CommRingCat.of k)).symm.commRingCatIsoToRingEquiv)
    exact finite_appTop_of_universallyClosed k f
  letI : Algebra k Γ(X, ⊤) := F.hom.toAlgebra
  haveI : Module.Finite k Γ(X, ⊤) := hFinF
  haveI : Algebra.IsIntegral k Γ(X, ⊤) := Algebra.IsIntegral.of_finite k Γ(X, ⊤)
  -- (3) `k` algebraically closed ⟹ `algebraMap k Γ(X, ⊤) = F.hom` is
  -- bijective, hence surjective.
  have hbij : Function.Bijective (algebraMap k Γ(X, ⊤)) :=
    IsAlgClosed.algebraMap_bijective_of_isIntegral
  -- Convert the range goal to surjectivity of `f.appTop.hom`; since
  -- `F.hom = f.appTop.hom ∘ (ΓSpecIso).inv.hom` is surjective, so is
  -- `f.appTop.hom`.
  rw [RingHom.range_eq_top]
  have hFsurj : Function.Surjective ⇑F.hom := hbij.surjective
  have hcomp : F.hom = f.appTop.hom.comp (Scheme.ΓSpecIso (CommRingCat.of k)).inv.hom := rfl
  rw [hcomp, RingHom.coe_comp] at hFsurj
  exact hFsurj.of_comp

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
