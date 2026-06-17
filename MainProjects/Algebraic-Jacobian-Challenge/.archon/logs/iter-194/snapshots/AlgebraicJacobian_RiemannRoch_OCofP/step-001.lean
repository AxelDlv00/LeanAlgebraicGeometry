/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Genus
import AlgebraicJacobian.RiemannRoch.WeilDivisor

/-!
# The line bundle `𝒪_C(P)` of a closed point and its global sections (RR.3)

This file is the **RR.3** sub-build chapter for the project's headline
`genusZero_curve_iso_P1` (the "smooth proper geometrically irreducible
genus-`0` curve over `k̄` is isomorphic to `ℙ¹`" lemma in
`AlgebraicJacobian.AbelianVarietyRigidity`).

The Hartshorne IV.1.3.5 chain for the genus-`0` ↦ `ℙ¹` classification routes
through:

- `RR.1` (`WeilDivisor.lean`): the Weil divisor group `Div(C)` and the
  degree map `deg : Div(C) → ℤ`.
- `RR.2` (`RRFormula.lean`): the Euler-characteristic identity
  `χ(𝒪_C(D)) = deg(D) + 1 − g` and the Riemann–Roch dimension formula
  `ℓ(D) = deg(D) + 1` in genus `0`.
- **`RR.3` (this file)**: the invertible sheaf `𝒪_C(P)` of a closed point
  `P ∈ C`, its `k̄`-vector space of global sections as the
  Riemann–Roch space `L([P])`, the `H¹`-vanishing
  `H¹(C, 𝒪_C(P)) = 0` on a genus-`0` curve, the dimension formula
  `dim_{k̄} H⁰(C, 𝒪_C(P)) = 2`, and the existence of a non-constant
  rational function `f ∈ K(C)` with at most a simple pole at `P`.
- `RR.4` (`RationalCurveIso.lean`, future): the "two-section
  ⇒ `Proj.fromOfGlobalSections` ⇒ `≅ ℙ¹`" classification.

## Status (iter-183 Lane A — sig amend + carrierSet scaffold)

Iter-183 Lane A (re-dispatch from iter-182 deferral) landed:

1. **Sig amend** `lineBundleAtClosedPoint` and `toFunctionField` now take
   the codimension-one witness `(hPcoh : Order.coheight P = 1)` explicitly,
   so the subsheaf-of-`K_C` carrier can read off the order at `P` via the
   prime divisor `⟨P, hPcoh⟩`. The amend matches the blueprint chapter prose
   for the Hartshorne subsheaf-of-`K_C` direct construction (per analogist
   `ocofp-sheaf-internalhom.md`, Decision 3 + Decision 4 verdict
   `ALIGN_WITH_MATHLIB`).
2. **Scaffold** `lineBundleAtClosedPoint.carrierSet` (concrete `Set`-valued
   substantive carrier — the set of rational functions with the order
   conditions on a given open). This is iter-183's substantive
   contribution beyond the sig amend; no new `sorry` introduced.
3. The bodies of `lineBundleAtClosedPoint` (L140) and `toFunctionField`
   (L154) remain typed `sorry` for iter-184+ (the full chain
   `carrierSet → carrierSubmodule (Submodule) → presheaf (Functor) →
   isSheaf (typed sorry) → Sheaf` is ~230-360 LOC; iter-183's helper
   budget = 5 and `sorry` ceiling = 7 forced PARTIAL).

The 5 pinned declarations are:

1. `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint` — the invertible
   sheaf `𝒪_C(P)` associated to a closed point `P` on a smooth proper
   curve `C / k̄`.
2. `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.globalSections_iff`
   — the identification of global sections of `𝒪_C(P)` with the
   Riemann–Roch space
   `L([P]) = {f ∈ K(C)^× | div(f) + [P] ≥ 0} ∪ {0}`,
   expressed as an `Iff`-style characterisation of the order conditions
   `ord_Q(f) ≥ 0` for `Q ≠ P` and `ord_P(f) ≥ −1`.
3. `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.h1_vanishing_genusZero`
   — the cohomological vanishing `H¹(C, 𝒪_C(P)) = 0` on a smooth proper
   geometrically irreducible curve `C / k̄` with `g(C) = 0`, via the long
   exact sequence of the closed-point short exact sequence
   `0 → 𝒪_C → 𝒪_C(P) → k(P) → 0`.
4. `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.dim_eq_two_of_genusZero`
   — the dimension formula `dim_{k̄} H⁰(C, 𝒪_C(P)) = 2` in genus `0`,
   specialising the χ-identity `RR.2` to `D = [P]` and consuming the
   `H¹`-vanishing of pin 3.
5. `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.exists_nonconstant_genusZero`
   — the corollary: a non-constant rational function `f ∈ K(C)` regular
   on `C \ {P}` with at most a simple pole at `P`, obtained as a lift of
   any non-zero element of the quotient
   `H⁰(C, 𝒪_C(P)) / 𝓀̄ · 1`.

## Notation reminders

The line bundle `𝒪_C(P)` is realised as a
`Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} kbar)`,
the same `ModuleCat k̄`-flavoured sheaf category used by the project's
`Scheme.HModule` cohomology pipeline (cf. `AlgebraicJacobian.Genus`).
Its `H⁰` and `H¹` are computed via `Scheme.HModule kbar (·) 0` and
`Scheme.HModule kbar (·) 1`, both of which carry a canonical `Module k̄`
instance.

## References

Blueprint: `blueprint/src/chapters/RiemannRoch_OCofP.tex` (Hartshorne
II.6 / II.7 / IV.1 verbatim quotes; 5 pins). Source: Hartshorne,
*Algebraic Geometry*, II §6 p. 144 (definition of `ℒ(D)`), II §7
Proposition 7.7 p. 157 (global sections of `ℒ(D)` as rational functions
with controlled pole), IV §1 pp. 294–297 (Riemann–Roch and the genus-`0`
specialisation, Example 1.3.5 and Exercise 1.1). Stacks Project tags
01X0 (line bundle of a Cartier divisor), 0BE5 (the global sections
exact sequence), 0AYO (Riemann–Roch).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-! ## §1. The line bundle of a closed point on a smooth proper curve

For a smooth proper geometrically irreducible curve `C / k̄` and a closed
point `P ∈ C`, the local ring `𝒪_{C,P}` is a DVR with maximal ideal
generated by a uniformiser `f_P`. Hartshorne's construction `ℒ(D)`
(II §6 p. 144) applied to the Cartier divisor `[P]` (locally cut out by
`f_P` near `P`, by `1` elsewhere) produces the invertible sheaf `𝒪_C(P)`:
the sub-`𝒪_C`-module of the function-field constant sheaf `𝒦_C ≅ K(C)`
generated locally by `f_P^{-1}` near `P` and by `1` on `C \ {P}`. -/

namespace Scheme

/-! ### Hartshorne subsheaf-of-`K_C` carrier (iter-183 Lane A scaffold)

The substantive iter-183 contribution: a concrete per-open `Set`-valued
carrier of the line bundle `𝒪_C(P)`, realised directly as Hartshorne's
subsheaf of the function-field constant sheaf `K_C` (Hartshorne II §6
p. 144; analogist `ocofp-sheaf-internalhom.md` Decision 3
`ALIGN_WITH_MATHLIB`).

A section of `𝒪_C(P)` over an open `U` is a rational function `f ∈ K(C)`
satisfying the order conditions `ord_Q(f) ≥ 0` for every prime divisor
`Q ≠ P` with `Q.point ∈ U` (regularity on the complement of `P` inside
`U`) and `ord_P(f) ≥ −1` when `P ∈ U` (at most a simple pole at `P`).
The construction is independent of the choice of uniformiser at `P`:
any two uniformisers differ by a unit, so the order-`≥ −1` condition at
`P` is intrinsic.

iter-184+ will upgrade `carrierSet` to a `Submodule kbar K(C)` via the
closure proofs (zero / addition / kbar-scalar), bundle the result as a
presheaf functor (identity-on-`K(C)` restrictions, monotone in `U` via
`carrierSet_mono`), and discharge the sheaf property via gluing-by-
stalks (stalk-locality of the order conditions at each prime divisor). -/

/-- **Carrier set** of `𝒪_C(P)` over an open `U : (Opens C.left)ᵒᵖ`: the
set of rational functions `f ∈ K(C)` satisfying the order conditions
`ord_Q(f) ≥ 0` for every prime divisor `Q` with `Q.point ∈ U.unop`,
`Q.point ≠ P`, and `ord_P(f) ≥ −1` when `P ∈ U.unop`.

iter-183 Lane A landed this as a concrete substantive `Set` definition;
no sorry. -/
private noncomputable def lineBundleAtClosedPoint.carrierSet
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsIntegral C.left]
    [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    (P : C.left) (hPcoh : Order.coheight P = 1)
    (U : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ) :
    Set C.left.functionField := by
  let Phat : C.left.PrimeDivisor := ⟨P, hPcoh⟩
  haveI := Scheme.IsRegularInCodimensionOne.instKrullDimLEStalk
    (X := C.left) Phat
  exact { f | (∀ Q : C.left.PrimeDivisor, Q.point ∈ U.unop.1 → Q.point ≠ P →
              0 ≤ Scheme.RationalMap.order Q f) ∧
              (P ∈ U.unop.1 → (-1 : ℤ) ≤ Scheme.RationalMap.order Phat f) }

/-- **Monotonicity of `carrierSet` in `U`**: when `V.unop ⊆ U.unop` (i.e.
the open `V` is contained in the open `U`), the carrier on `U` is
INCLUDED in the carrier on `V` (the order conditions over the smaller
open `V` involve fewer prime divisors, hence are easier to satisfy).

This is the substantive monotonicity that drives the (identity-on-`K(C)`)
restriction map of the would-be `lineBundleAtClosedPoint.presheaf` functor:
in `(Opens C.left)ᵒᵖ`, an arrow `U ⟶ V` corresponds to `V.unop ⊆ U.unop`,
and the restriction map `carrierSet U → carrierSet V` is the inclusion
delivered by this lemma.

iter-183 Lane A landed this as the substantive monotonicity proof; no
sorry. -/
private lemma lineBundleAtClosedPoint.carrierSet_mono
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsIntegral C.left]
    [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    (P : C.left) (hPcoh : Order.coheight P = 1)
    {U V : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ}
    (hUV : V.unop.1 ⊆ U.unop.1) :
    lineBundleAtClosedPoint.carrierSet P hPcoh U
      ⊆ lineBundleAtClosedPoint.carrierSet P hPcoh V := by
  intro f hf
  refine ⟨fun Q hQV hQP => hf.1 Q (hUV hQV) hQP, fun hPV => hf.2 (hUV hPV)⟩

/-- **Nonempty top-open**: for an integral scheme `X`, the top open is
nonempty (its carrier is `Set.univ` and `X` itself is nonempty since
`IsIntegral X ⟹ IrreducibleSpace X ⟹ Nonempty X`). Supplied as an
instance so that the standard Mathlib `Algebra Γ(X, U) X.functionField`
instance fires at `U = ⊤`. -/
instance lineBundleAtClosedPoint.instNonemptyTopOpen
    {X : Scheme.{u}} [IsIntegral X] :
    Nonempty ((⊤ : X.Opens) : Scheme) :=
  (Scheme.Opens.nonempty_iff (U := (⊤ : X.Opens))).mpr
    ⟨(inferInstance : Nonempty X).some, Set.mem_univ _⟩

/-- **`kbar`-algebra structure on the function field `K(C)`**. The
project's `Scheme.toModuleKSheaf.algebraSection` instance gives
`Algebra kbar Γ(C.left, ⊤)`, and Mathlib's standard
`AlgebraicGeometry.instAlgebraCarrierObjOppositeOpens...` gives
`Algebra Γ(C.left, ⊤) K(C)` via `germToFunctionField`. Composing the
two algebra maps via `RingHom.toAlgebra` produces the desired
`Algebra kbar K(C)` instance, which is needed for `Submodule kbar K(C)`
to type-check. -/
noncomputable instance lineBundleAtClosedPoint.instAlgebraKbarFunctionField
    {kbar : Type u} [Field kbar]
    (C : Over (Spec (.of kbar))) [IsIntegral C.left] :
    Algebra kbar C.left.functionField := by
  haveI : Nonempty (⊤ : C.left.Opens) :=
    (AlgebraicGeometry.Scheme.Opens.nonempty_iff
      (X := C.left) (U := (⊤ : C.left.Opens))).mpr
      ⟨(inferInstance : Nonempty C.left).some, Set.mem_univ _⟩
  exact RingHom.toAlgebra
    ((Scheme.germToFunctionField C.left (⊤ : C.left.Opens)).hom.comp
      (Scheme.toModuleKSheaf.kToSection C
        (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat))).hom)

/-- **Carrier submodule** of `𝒪_C(P)` over an open `U`: upgrade of
`carrierSet U` to a `Submodule kbar K(C)` via the three closure proofs
(`0`, `+`, `kbar • _`). The closure proofs rest on the DVR-shipped
`Ring.ordFrac_add` (non-archimedean inequality on the discrete valuation
of a regular-in-codim-1 stalk; iter-186 Step 1 upgraded the carrier class
so this is invocable) and `Ring.ordFrac_of_isUnit` (the scalar from
`kbar` becomes a unit in the stalk, preserving the order under scalar
multiplication).

iter-186 Step 2 (per analogist `ocofp-carrierset-submodule-api.md`
Decision 2): structural skeleton with the load-bearing Mathlib lemmas in
place; bookkeeping `sorry`s remain for the prover phase. -/
private noncomputable def lineBundleAtClosedPoint.carrierSubmodule
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsIntegral C.left]
    [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    (P : C.left) (hPcoh : Order.coheight P = 1)
    (U : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ) :
    Submodule kbar C.left.functionField where
  carrier := lineBundleAtClosedPoint.carrierSet P hPcoh U
  zero_mem' := by
    -- `order Y 0 = WithZero.log (Ring.ordFrac _ 0) = WithZero.log 0 = 0`;
    -- both `0 ≤ 0` and `-1 ≤ 0` hold trivially.
    refine ⟨fun Q _ _ => ?_, fun _ => ?_⟩
    · simp [Scheme.RationalMap.order]
    · simp [Scheme.RationalMap.order]
  add_mem' := by
    -- Case-split on `f + g = 0` (trivial via `WithZero.log_zero`), else
    -- apply `Ring.ordFrac_add` (DVR-shipped, Step 1 unlocks) and
    -- `WithZero.log` monotonicity on the nonzero part.
    rintro a b ⟨ha₁, ha₂⟩ ⟨hb₁, hb₂⟩
    have hMNZ : ∀ (Q : C.left.PrimeDivisor) (x : C.left.functionField),
        x ≠ 0 → Ring.ordFrac (C.left.presheaf.stalk Q.point) x ≠ 0 := by
      intro Q x hx; simp [hx]
    have key : ∀ (Q : C.left.PrimeDivisor) (n : ℤ),
        n ≤ 0 → n ≤ Scheme.RationalMap.order Q a →
          n ≤ Scheme.RationalMap.order Q b →
          n ≤ Scheme.RationalMap.order Q (a + b) := by
      intro Q n hn haₚ hbₚ
      by_cases hab : a + b = 0
      · simpa [hab, Scheme.RationalMap.order] using hn
      by_cases hae : a = 0
      · rw [hae, zero_add]; exact hbₚ
      by_cases hbe : b = 0
      · rw [hbe, add_zero]; exact haₚ
      set R := C.left.presheaf.stalk Q.point
      have hoa : Ring.ordFrac R a ≠ 0 := hMNZ Q a hae
      have hob : Ring.ordFrac R b ≠ 0 := hMNZ Q b hbe
      have hoab : Ring.ordFrac R (a + b) ≠ 0 := hMNZ Q _ hab
      have hmin : Ring.ordFrac R a ⊓ Ring.ordFrac R b ≤ Ring.ordFrac R (a + b) :=
        Ring.ordFrac_add (R := R) a b hab
      have hlog : (Ring.ordFrac R a ⊓ Ring.ordFrac R b).log ≤
          Scheme.RationalMap.order Q (a + b) := by
        rcases min_cases (Ring.ordFrac R a) (Ring.ordFrac R b) with
            ⟨heq, _⟩ | ⟨heq, _⟩
        · rw [heq]; exact (WithZero.log_le_log hoa hoab).mpr (heq ▸ hmin)
        · rw [heq]; exact (WithZero.log_le_log hob hoab).mpr (heq ▸ hmin)
      have hminbd : n ≤ (Ring.ordFrac R a ⊓ Ring.ordFrac R b).log := by
        rcases min_cases (Ring.ordFrac R a) (Ring.ordFrac R b) with
            ⟨heq, _⟩ | ⟨heq, _⟩
        · rw [heq]; exact haₚ
        · rw [heq]; exact hbₚ
      linarith
    refine ⟨fun Q hQU hQP => key Q 0 le_rfl (ha₁ Q hQU hQP) (hb₁ Q hQU hQP),
      fun hPU => key ⟨P, hPcoh⟩ (-1) (by norm_num) (ha₂ hPU) (hb₂ hPU)⟩
  smul_mem' := by
    -- For `c : kbar`, the scalar action `c • f` on `K(C)` factors through
    -- `algebraMap kbar K(C)`. For `c ≠ 0`, `algebraMap kbar K(C) c` lifts to
    -- a nonzero `β` in every stalk via the germ map; `Ring.ordFrac_ge_one_of_ne_zero`
    -- on `β` then gives `order Q (algebraMap c) ≥ 0`, hence `c•x ∈ carrierSet`.
    intro c x ⟨hx₁, hx₂⟩
    rcases eq_or_ne c 0 with rfl | hc
    · -- `c = 0` ⇒ `0 • x = 0` ∈ carrierSet via `zero_mem'`.
      simp only [zero_smul]
      refine ⟨fun Q _ _ => ?_, fun _ => ?_⟩ <;> simp [Scheme.RationalMap.order]
    rcases eq_or_ne x 0 with rfl | hx_ne
    · -- `x = 0` ⇒ `c • 0 = 0` ∈ carrierSet.
      simp only [smul_zero]
      refine ⟨fun Q _ _ => ?_, fun _ => ?_⟩ <;> simp [Scheme.RationalMap.order]
    -- Both `c ≠ 0` and `x ≠ 0`: compute `order Q (c•x)` via multiplicativity.
    have hsmul : c • x = (algebraMap kbar C.left.functionField c) * x :=
      Algebra.smul_def c x
    have hαne : (algebraMap kbar C.left.functionField c) ≠ 0 := by
      have hinj := FaithfulSMul.algebraMap_injective kbar C.left.functionField
      simpa using hinj.ne_iff.mpr hc
    have hMNZ : ∀ (Q : C.left.PrimeDivisor) (y : C.left.functionField),
        y ≠ 0 → Ring.ordFrac (C.left.presheaf.stalk Q.point) y ≠ 0 := by
      intro Q y hy; simp [hy]
    have key_alpha_ge : ∀ (Q : C.left.PrimeDivisor),
        0 ≤ Scheme.RationalMap.order Q
              (algebraMap kbar C.left.functionField c) := by
      intro Q
      set R := C.left.presheaf.stalk Q.point
      let β : R := (C.left.presheaf.germ (⊤ : C.left.Opens) Q.point trivial).hom
        ((Scheme.toModuleKSheaf.kToSection C
            (Opposite.op (⊤ : C.left.Opens))).hom c)
      have hα_eq : (algebraMap kbar C.left.functionField c) =
          algebraMap R C.left.functionField β := by
        change ((Scheme.germToFunctionField C.left (⊤ : C.left.Opens)).hom
            ((Scheme.toModuleKSheaf.kToSection C
                (Opposite.op (⊤ : C.left.Opens))).hom c)) =
            (C.left.presheaf.stalkSpecializes
              ((genericPoint_spec C.left).specializes trivial)).hom β
        rw [← TopCat.Presheaf.germ_stalkSpecializes_apply
          (h := (genericPoint_spec C.left).specializes trivial)]
      have hβne : β ≠ 0 := by
        intro hzero; apply hαne; rw [hα_eq, hzero, map_zero]
      have hαord_ne : Ring.ordFrac R
          (algebraMap kbar C.left.functionField c) ≠ 0 := hMNZ Q _ hαne
      have hge : (1 : WithZero (Multiplicative ℤ)) ≤
          Ring.ordFrac R (algebraMap kbar C.left.functionField c) := by
        rw [hα_eq]; exact Ring.ordFrac_ge_one_of_ne_zero hβne
      unfold Scheme.RationalMap.order
      rw [show (0 : ℤ) = WithZero.log (1 : WithZero (Multiplicative ℤ)) by simp]
      exact (WithZero.log_le_log (by norm_num) hαord_ne).mpr hge
    have key : ∀ (Q : C.left.PrimeDivisor) (n : ℤ),
        n ≤ Scheme.RationalMap.order Q x →
        n ≤ Scheme.RationalMap.order Q (c • x) := by
      intro Q n hxn
      rw [hsmul]
      set R := C.left.presheaf.stalk Q.point
      have hαnez := hMNZ Q _ hαne
      have hxnez := hMNZ Q x hx_ne
      unfold Scheme.RationalMap.order
      rw [map_mul, WithZero.log_mul hαnez hxnez]
      have := key_alpha_ge Q
      unfold Scheme.RationalMap.order at this hxn
      linarith
    refine ⟨fun Q hQU hQP => key Q 0 (hx₁ Q hQU hQP),
      fun hPU => key ⟨P, hPcoh⟩ (-1) (hx₂ hPU)⟩

/-- **Bot-trivialization submodule** (iter-188 Step S1 of the sheaf-property
close): the per-open submodule of `K(C)` that equals `⊥` at `U = ⊥` and
`⊤` otherwise. The factor `carrierSubmodule ⊓ trivAtBot` enforces the
correct sheaf-at-`⊥` semantics (`F(⊥) = 0`), which is required for the
`Opens.grothendieckTopology` sheaf condition (the empty cover of `⊥`
forces `F(⊥) = 0`). -/
private noncomputable def lineBundleAtClosedPoint.trivAtBot
    {kbar : Type u} [Field kbar]
    {C : Over (Spec (.of kbar))} [IsIntegral C.left]
    (U : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ) :
    Submodule kbar C.left.functionField where
  carrier := {f | U.unop ≠ (⊥ : TopologicalSpace.Opens C.left.toTopCat) ∨ f = 0}
  zero_mem' := Or.inr rfl
  add_mem' := by
    rintro a b (ha | ha) (hb | hb)
    · exact Or.inl ha
    · exact Or.inl ha
    · exact Or.inl hb
    · right; rw [ha, hb]; ring
  smul_mem' := by
    rintro c x (hx | hx)
    · exact Or.inl hx
    · right; rw [hx]; simp

/-- **Sheaf-corrected carrier submodule** (iter-188 Step S2 of the sheaf-
property close): the per-open submodule `carrierSubmodule U ⊓ trivAtBot U`.
At `U ≠ ⊥` this equals `carrierSubmodule U` (since `trivAtBot U = ⊤`);
at `U = ⊥` this equals `⊥` (since `trivAtBot ⊥ = ⊥`). The latter is the
correct value for a sheaf in the `Opens.grothendieckTopology`, where the
empty cover of `⊥` forces `F(⊥) = 0`. -/
private noncomputable def lineBundleAtClosedPoint.carrierSubmoduleSheaf
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsIntegral C.left]
    [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    (P : C.left) (hPcoh : Order.coheight P = 1)
    (U : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ) :
    Submodule kbar C.left.functionField :=
  lineBundleAtClosedPoint.carrierSubmodule P hPcoh U ⊓
    lineBundleAtClosedPoint.trivAtBot (C := C) U

/-- **Monotonicity of `carrierSubmoduleSheaf` in `U` when the target `V`
is non-empty**: when `V.unop ⊆ U.unop` and `V.unop ≠ ⊥`, the carrier on
`U` is included in the carrier on `V`. The non-empty hypothesis is
necessary: if `V = ⊥`, the inclusion can fail because nonzero `f`'s in
`carrierSubmoduleSheaf U` need not satisfy the trivAtBot-at-⊥ condition
(only `0` does). -/
private lemma lineBundleAtClosedPoint.carrierSubmoduleSheaf_le
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsIntegral C.left]
    [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    (P : C.left) (hPcoh : Order.coheight P = 1)
    {U V : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ}
    (hUV : V.unop.1 ⊆ U.unop.1)
    (hV : V.unop ≠ (⊥ : TopologicalSpace.Opens C.left.toTopCat)) :
    lineBundleAtClosedPoint.carrierSubmoduleSheaf P hPcoh U
      ≤ lineBundleAtClosedPoint.carrierSubmoduleSheaf P hPcoh V := by
  intro x ⟨hx_carr, _⟩
  refine ⟨lineBundleAtClosedPoint.carrierSet_mono P hPcoh hUV hx_carr, Or.inl hV⟩

/-- **Type-level Subfunctor presentation of the carrier** (iter-189 Subfunctor
restructure). The carrier of `𝒪_C(P)` viewed as a `CategoryTheory.Subfunctor` of
the Type-valued presheaf `TopCat.presheafToType C.left.toTopCat C.left.functionField`
(the presheaf of arbitrary functions to the function field `K(C)`). A section over
an open `U` is a function `g : U.unop → K(C)` that is constant with value
`f ∈ carrierSubmoduleSheaf U`.

This Subfunctor packages the carrier conditions uniformly:
- At `U ≠ ⊥`: a section is a constant function valued in
  `carrierSubmoduleSheaf U = carrierSubmodule U` (so the order conditions hold).
- At `U = ⊥`: the unique empty function (witnessed by `f = 0 ∈ ⊥`).

Mathlib's `CategoryTheory.Subfunctor.isSheaf_iff`, applied against the ambient
sheaf `TopCat.Presheaf.toType_isSheaf` for `presheafToType`, reduces the sheaf
condition for the (type-valued shadow of the) carrier to a stalk-locality check:
every section of `presheafToType K(C)` whose sieve-of-section is covering already
lies in the Subfunctor. On the irreducible scheme `C.left`, this stalk-locality
holds because any two non-empty opens intersect, forcing constant-function gluing
to agree on overlaps, and the per-prime-divisor order conditions transfer from
each open in the cover to their union pointwise. -/
private noncomputable def lineBundleAtClosedPoint.carrierTypeSubfunctor
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsIntegral C.left]
    [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    (P : C.left) (hPcoh : Order.coheight P = 1) :
    CategoryTheory.Subfunctor
      (TopCat.presheafToType C.left.toTopCat C.left.functionField) where
  obj U := { g : U.unop → C.left.functionField |
    ∃ f : C.left.functionField,
      f ∈ lineBundleAtClosedPoint.carrierSubmoduleSheaf P hPcoh U ∧
        g = fun _ => f }
  map := by
    classical
    intro U V i g hg
    obtain ⟨f, hf, hgf⟩ := hg
    by_cases hV : V.unop = (⊥ : TopologicalSpace.Opens C.left.toTopCat)
    · -- `V = ⊥`: `V.unop` is the empty type. Any function with empty domain works;
      -- use the witness `f' = 0 ∈ carrierSubmoduleSheaf ⊥ = ⊥`.
      refine ⟨0, ?_, ?_⟩
      · exact (lineBundleAtClosedPoint.carrierSubmoduleSheaf P hPcoh V).zero_mem
      · funext x
        have hsub : (V.unop : Set C.left.toTopCat) ⊆ ∅ := by
          rw [show V.unop = ⊥ from hV]; simp
        exact absurd x.2 (fun h => hsub h)
    · -- `V ≠ ⊥`: monotonicity (`carrierSubmoduleSheaf_le`) gives `f ∈ carrierSubmoduleSheaf V`.
      refine ⟨f, ?_, ?_⟩
      · exact lineBundleAtClosedPoint.carrierSubmoduleSheaf_le P hPcoh
          (CategoryTheory.leOfHom i.unop) hV hf
      · subst hgf
        rfl

/-- **The carrier presheaf of `𝒪_C(P)`** (iter-187 Step 3 of the
`carrierSet → carrierSubmodule → carrierPresheaf → isSheaf → Sheaf`
recipe from `analogies/ocofp-carrierset-submodule-api.md` Decision 3).

Bundles `carrierSubmoduleSheaf P hPcoh U` as the per-open value of a
functor `(Opens C.left)ᵒᵖ ⥤ ModuleCat kbar`. The restriction map for
`f : U ⟶ V` in `(Opens C.left)ᵒᵖ` is the zero map when `V = ⊥` and
`Submodule.inclusion` (via `carrierSubmoduleSheaf_le`) otherwise. This
case-based restriction is required because, unlike the original
`carrierSubmodule`, the bot-trivialized `carrierSubmoduleSheaf` is not
anti-monotone in the bot-case (an element of `carrierSubmoduleSheaf U`
with `U ≠ ⊥` may be nonzero, but `carrierSubmoduleSheaf ⊥ = ⊥`).

iter-188 Step S3 (sheaf-property close): the `obj` now uses
`carrierSubmoduleSheaf` instead of `carrierSubmodule` to satisfy
`F(⊥) = 0`, which is required by the `Opens.grothendieckTopology` sheaf
condition for the empty cover of `⊥`. -/
private noncomputable def lineBundleAtClosedPoint.carrierPresheaf
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsIntegral C.left]
    [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    (P : C.left) (hPcoh : Order.coheight P = 1) :
    (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ ⥤ ModuleCat.{u} kbar where
  obj U := ModuleCat.of kbar
    ↥(lineBundleAtClosedPoint.carrierSubmoduleSheaf P hPcoh U)
  map {U V} f := ModuleCat.ofHom <| by
    classical
    by_cases hV : V.unop = (⊥ : TopologicalSpace.Opens C.left.toTopCat)
    · exact 0
    · exact Submodule.inclusion
        (lineBundleAtClosedPoint.carrierSubmoduleSheaf_le P hPcoh
          (CategoryTheory.leOfHom f.unop) hV)
  map_id U := by
    classical
    by_cases hU : U.unop = (⊥ : TopologicalSpace.Opens C.left.toTopCat)
    · -- U = ⊥: domain and codomain are both `⊥`, so the only linear map
      -- is `0`, which equals identity on the trivial module.
      ext ⟨x, hx⟩
      simp only [dif_pos hU]
      have h0 : x = 0 := by
        rcases hx.2 with hne | heq
        · exact (hne hU).elim
        · exact heq
      subst h0
      rfl
    · ext ⟨x, _⟩
      simp only [dif_neg hU]
      rfl
  map_comp {U V W} f g := by
    classical
    by_cases hW : W.unop = (⊥ : TopologicalSpace.Opens C.left.toTopCat)
    · -- W = ⊥: both sides are the zero map.
      ext ⟨x, _⟩
      simp only [dif_pos hW]
      by_cases hV : V.unop = (⊥ : TopologicalSpace.Opens C.left.toTopCat)
      · simp only [dif_pos hV]
        rfl
      · simp only [dif_neg hV]
        rfl
    · -- W ≠ ⊥: then V ≠ ⊥ (since W ≤ V) and the composition is inclusion.
      have hVW : W.unop.1 ⊆ V.unop.1 := CategoryTheory.leOfHom g.unop
      have hV : V.unop ≠ (⊥ : TopologicalSpace.Opens C.left.toTopCat) := by
        intro h
        apply hW
        apply le_antisymm
        · rw [← h]; exact CategoryTheory.leOfHom g.unop
        · exact bot_le
      ext ⟨x, _⟩
      simp only [dif_neg hW, dif_neg hV]
      rfl

/-- **Sheaf property of `carrierPresheaf`** (iter-189 Subfunctor restructure).
The Hartshorne subsheaf-of-`K_C` carrier inherits the sheaf condition from the
underlying `Type`-valued sheaf condition on its forget: each `carrierSubmodule U`
is, as a set, a subset of the function field `K(C)` (a constant presheaf on the
irreducible scheme `C.left`), and the per-prime-divisor order conditions are
stalk-local in the open.

iter-189 substrate: `carrierTypeSubfunctor` (above) packages the carrier as a
`CategoryTheory.Subfunctor` of `TopCat.presheafToType C.left.toTopCat K(C)`.
Mathlib's `CategoryTheory.Subfunctor.isSheaf_iff` (applied against the ambient
sheaf `TopCat.Presheaf.toType_isSheaf`) reduces the sheaf condition for the
Subfunctor to the stalk-locality check: every section of `presheafToType K(C)`
whose sieve-of-section is covering already lies in the Subfunctor. On the
irreducible scheme `C.left`, stalk-locality holds because any two non-empty opens
intersect, forcing constant-function gluing values to agree on overlaps, and
the per-prime-divisor order conditions extend from each open in the cover to
their union pointwise.

Proof structure:
- **Case A** (`iSup U = ⊥`, empty cover): the gluing is the zero section, with
  uniqueness and compatibility both deriving from `carrierSubmoduleSheaf ⊥ = ⊥`
  (every element is forced to `0`). Closed axiom-clean in-body via
  `hSubAt0`-style projection.
- **Case B** (nonempty cover, `iSup U ≠ ⊥`): refactored via `carrierTypeSubfunctor`.
  Each `(sf i).1` lifts to a constant-function section of the Subfunctor over
  `op (U i)`. The single typed sorry below carries the substantive
  Subfunctor-glue + stalk-locality close (irreducibility of `C.left.toTopCat`
  forces all the `(sf i).1` to agree on a common value `v`, and `v` then lies
  in `carrierSubmoduleSheaf (op (iSup U))` by per-prime-divisor pointwise
  transfer).

Reference: `lem:carrierPresheaf_isSheaf` (this file's blueprint chapter); the
iter-188 prover forensics in `task_results/.../OCofP.lean.md` document the
subtype-friction failures that motivated the Subfunctor restructure. -/
private lemma lineBundleAtClosedPoint.carrierPresheaf_isSheaf
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsIntegral C.left]
    [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    (P : C.left) (hPcoh : Order.coheight P = 1) :
    Presheaf.IsSheaf (Opens.grothendieckTopology C.left.toTopCat)
      (lineBundleAtClosedPoint.carrierPresheaf P hPcoh) := by
  classical
  apply (TopCat.Presheaf.isSheaf_iff_isSheafUniqueGluing (X := C.left.toTopCat)
    (F := lineBundleAtClosedPoint.carrierPresheaf P hPcoh)).mpr
  intro ι U sf hcompat
  -- Key structural fact: `carrierSubmoduleSheaf (op V) = ⊥` whenever
  -- `V = ⊥`. This makes `F(op ⊥) = ↥⊥` a singleton, which is what the
  -- empty-cover case of the sheaf condition requires.
  have htrivBot : ∀ (V : TopologicalSpace.Opens C.left.toTopCat) (hV : V = ⊥),
      lineBundleAtClosedPoint.trivAtBot (C := C) (Opposite.op V) = ⊥ := by
    intro V hV
    apply Submodule.ext
    intro f
    constructor
    · rintro (h | h)
      · exact (h hV).elim
      · exact h
    · intro h
      change V ≠ ⊥ ∨ f = 0
      exact Or.inr h
  have hcsBot : ∀ (V : TopologicalSpace.Opens C.left.toTopCat) (hV : V = ⊥),
      lineBundleAtClosedPoint.carrierSubmoduleSheaf P hPcoh (Opposite.op V) = ⊥ := by
    intro V hV
    change lineBundleAtClosedPoint.carrierSubmodule _ _ _ ⊓
      lineBundleAtClosedPoint.trivAtBot _ = ⊥
    rw [htrivBot V hV, inf_bot_eq]
  have hSubAt0 : ∀ (V : TopologicalSpace.Opens C.left.toTopCat) (hV : V = ⊥)
      (s : ↥(lineBundleAtClosedPoint.carrierSubmoduleSheaf P hPcoh
              (Opposite.op V))),
      s.1 = 0 := by
    intro V hV s
    have h0 : s.1 ∈ (⊥ : Submodule kbar C.left.functionField) := by
      rw [← hcsBot V hV]; exact s.2
    exact (Submodule.mem_bot kbar).mp h0
  -- Case split.
  by_cases hSup : iSup U = (⊥ : TopologicalSpace.Opens C.left.toTopCat)
  · -- Case A: empty cover.
    have hUi : ∀ i, U i = (⊥ : TopologicalSpace.Opens C.left.toTopCat) := by
      intro i
      apply le_antisymm _ bot_le
      calc U i ≤ iSup U := le_iSup U i
        _ = ⊥ := hSup
    refine ⟨⟨0, ?_⟩, ?_, ?_⟩
    · exact (lineBundleAtClosedPoint.carrierSubmoduleSheaf P hPcoh _).zero_mem
    · -- IsGluing: for each i, since U i = ⊥, both sides are 0.
      intro i
      -- `sf i ∈ F.obj (op (U i))` with `U i = ⊥`, so `(sf i).1 = 0`.
      have hsfi : (sf i).1 = 0 := hSubAt0 (U i) (hUi i) (sf i)
      -- The image `(F.map _).hom ⟨0, _⟩` also has `.1 = 0` (it lives in
      -- the same `↥⊥`-typed value).
      apply Subtype.ext
      rw [hsfi]
      -- Both sides should now be `0` after extracting `.1`.
      change (((lineBundleAtClosedPoint.carrierPresheaf P hPcoh).map
        (homOfLE (le_iSup U i)).op).hom ⟨0, _⟩).1 = 0
      exact hSubAt0 (U i) (hUi i)
        _
    · intro s' _
      apply Subtype.ext
      exact (hSubAt0 _ hSup s').trans rfl
  · -- Case B (iter-189 Subfunctor restructure): nonempty cover (iSup U ≠ ⊥).
    --
    -- Substrate: `lineBundleAtClosedPoint.carrierTypeSubfunctor P hPcoh`, a
    -- `CategoryTheory.Subfunctor` of
    -- `TopCat.presheafToType C.left.toTopCat C.left.functionField` whose sections
    -- over `op (U i)` are constant `↥(U i) → K(C)` functions with value in
    -- `carrierSubmoduleSheaf (op (U i))`. The lift of `(sf i).1` to such a section
    -- is constructed below; the prover phase closes the gluing via Subfunctor +
    -- stalk-locality.
    --
    -- Each `(sf i).1` lifts to a constant-function section of the Subfunctor over
    -- `op (U i)` (membership via the existential witness `⟨(sf i).1, (sf i).2, rfl⟩`).
    -- The lifted family is compatible in the Subfunctor because `hcompat`
    -- (compatibility in `carrierPresheaf`) implies pointwise equality of the
    -- constant values on overlaps.
    have hsub_mem : ∀ i,
        (fun (_ : ↑↑(U i)) => ((sf i).1 : C.left.functionField))
          ∈ (lineBundleAtClosedPoint.carrierTypeSubfunctor P hPcoh).obj
              (Opposite.op (U i)) := fun i => ⟨(sf i).1, (sf i).2, rfl⟩
    -- Strategy for the iter-190+ prover close (single typed sorry below):
    --
    --   1. Apply `CategoryTheory.Subfunctor.isSheaf_iff` against
    --      `TopCat.Presheaf.toType_isSheaf` to glue the family `hsub_mem`
    --      (after compatibility-promoting through the Subfunctor-section structure)
    --      to a section `g : ↥(iSup U) → K(C)` in
    --      `carrierTypeSubfunctor.obj (op (iSup U))`. Stalk-locality holds by
    --      irreducibility of `C.left.toTopCat`: any two non-empty opens of an
    --      irreducible space intersect, forcing all the `(sf i).1` to agree on a
    --      common value `v ∈ K(C)`, and `v` lies in `carrierSubmoduleSheaf
    --      (op (iSup U))` by pointwise transfer of the per-prime-divisor order
    --      conditions (`Q.point ∈ iSup U ⇒ ∃ i, Q.point ∈ U i` via
    --      `TopologicalSpace.Opens.mem_iSup`).
    --   2. Extract the witness `v` from `g`'s Subfunctor membership existential;
    --      the gluing is `⟨v, hv⟩` in `↥(carrierSubmoduleSheaf (op (iSup U)))`.
    --
    -- Helper: when target is non-bot, F.map is Submodule.inclusion (preserves .1).
    have map_val : ∀ {Uo Vo : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ}
        (g : Uo ⟶ Vo) (hV : Vo.unop ≠ ⊥)
        (x : ↥(lineBundleAtClosedPoint.carrierSubmoduleSheaf P hPcoh Uo)),
        (((lineBundleAtClosedPoint.carrierPresheaf P hPcoh).map g).hom x).1 = x.1 := by
      intros Uo Vo g hV x
      simp only [lineBundleAtClosedPoint.carrierPresheaf, dif_neg hV,
        ModuleCat.hom_ofHom]
      rfl
    -- Get a non-empty witness index since iSup U ≠ ⊥.
    have hexists_ne_bot : ∃ i, U i ≠ ⊥ := by
      by_contra h
      exact hSup (iSup_eq_bot.mpr (fun i => not_not.mp (not_exists.mp h i)))
    obtain ⟨i₀, hUi₀⟩ := hexists_ne_bot
    -- Candidate value v ∈ K(C).
    set v : C.left.functionField := (sf i₀).1 with hv_def
    -- Irreducibility gives non-empty intersection for non-empty pair.
    have hIrr : IrreducibleSpace ↑C.left := inferInstance
    have hPre : PreirreducibleSpace ↑C.left := hIrr.toPreirreducibleSpace
    have inter_ne_bot : ∀ i j, U i ≠ ⊥ → U j ≠ ⊥ →
        (U i ⊓ U j : TopologicalSpace.Opens C.left.toTopCat) ≠ ⊥ := by
      intro i j hi hj h
      apply (TopologicalSpace.Opens.not_nonempty_iff_eq_bot _).mpr h
      have ni : ((U i).1).Nonempty := by
        by_contra hh
        exact hi ((TopologicalSpace.Opens.not_nonempty_iff_eq_bot _).mp hh)
      have nj : ((U j).1).Nonempty := by
        by_contra hh
        exact hj ((TopologicalSpace.Opens.not_nonempty_iff_eq_bot _).mp hh)
      exact @nonempty_preirreducible_inter _ _ _ _ hPre
        (U i).isOpen (U j).isOpen ni nj
    -- Uniformity: (sf i).1 = v whenever U i ≠ ⊥.
    have key_val : ∀ i, U i ≠ ⊥ → (sf i).1 = v := by
      intro i hUi
      have hint : (U i ⊓ U i₀ : TopologicalSpace.Opens C.left.toTopCat) ≠ ⊥ :=
        inter_ne_bot i i₀ hUi hUi₀
      have hc := hcompat i i₀
      have h1 : (((lineBundleAtClosedPoint.carrierPresheaf P hPcoh).map
            (TopologicalSpace.Opens.infLELeft (U i) (U i₀)).op).hom (sf i)).1 = (sf i).1 :=
        map_val _ hint (sf i)
      have h2 : (((lineBundleAtClosedPoint.carrierPresheaf P hPcoh).map
            (TopologicalSpace.Opens.infLERight (U i) (U i₀)).op).hom (sf i₀)).1 = (sf i₀).1 :=
        map_val _ hint (sf i₀)
      have hc_val := congr_arg Subtype.val hc
      simp only at hc_val
      rw [h1, h2] at hc_val
      exact hc_val
    -- Show v ∈ carrierSubmoduleSheaf (op (iSup U)).
    have hv_mem : v ∈ lineBundleAtClosedPoint.carrierSubmoduleSheaf P hPcoh
        (Opposite.op (iSup U)) := by
      refine ⟨⟨?_, ?_⟩, Or.inl hSup⟩
      · -- ord_Q(v) ≥ 0 for Q.point ∈ iSup U, Q.point ≠ P.
        intro Q hQ hQP
        obtain ⟨i, hi⟩ := TopologicalSpace.Opens.mem_iSup.mp hQ
        have hUi : U i ≠ ⊥ := by
          intro hh
          rw [hh] at hi
          exact (TopologicalSpace.Opens.mem_bot.mp hi).elim
        have : (sf i).1 = v := key_val i hUi
        rw [← this]
        exact (sf i).2.1.1 Q hi hQP
      · -- ord_P(v) ≥ -1 when P ∈ iSup U.
        intro hP
        obtain ⟨i, hi⟩ := TopologicalSpace.Opens.mem_iSup.mp hP
        have hUi : U i ≠ ⊥ := by
          intro hh
          rw [hh] at hi
          exact (TopologicalSpace.Opens.mem_bot.mp hi).elim
        have : (sf i).1 = v := key_val i hUi
        rw [← this]
        exact (sf i).2.1.2 hi
    -- Build the gluing element and verify uniqueness.
    refine ⟨⟨v, hv_mem⟩, ?_, ?_⟩
    · -- IsGluing: ∀ i, F.map _ ⟨v, hv_mem⟩ = sf i.
      intro i
      apply Subtype.ext
      by_cases hUi : U i = ⊥
      · -- U i = ⊥: image's .1 is 0 (codomain is ↥⊥); also (sf i).1 = 0.
        have hsfi : (sf i).1 = 0 := hSubAt0 (U i) hUi (sf i)
        change (((lineBundleAtClosedPoint.carrierPresheaf P hPcoh).map
          (CategoryTheory.homOfLE (le_iSup U i)).op).hom ⟨v, hv_mem⟩).1 = (sf i).1
        rw [hsfi]
        exact hSubAt0 (U i) hUi _
      · -- U i ≠ ⊥: image's .1 = v = (sf i).1.
        change (((lineBundleAtClosedPoint.carrierPresheaf P hPcoh).map
          (CategoryTheory.homOfLE (le_iSup U i)).op).hom ⟨v, hv_mem⟩).1 = (sf i).1
        rw [map_val _ hUi ⟨v, hv_mem⟩, key_val i hUi]
    · -- Uniqueness: any glue s' must have s'.1 = (sf i₀).1 = v via U i₀ ≠ ⊥.
      intro s' hgluing
      apply Subtype.ext
      have hi₀g := hgluing i₀
      have h_apply :
          (((lineBundleAtClosedPoint.carrierPresheaf P hPcoh).map
              (TopologicalSpace.Opens.leSupr U i₀).op).hom s').1 = s'.1 :=
        map_val _ hUi₀ s'
      have := congr_arg Subtype.val hi₀g
      simp only at this
      rw [h_apply] at this
      exact this

/-- **The line bundle `𝒪_C(P)` of a closed point `P` on a smooth proper
curve `C / k̄`** (Hartshorne II §6, p. 144, Proposition 6.13(a)).

The invertible sheaf cut out (in the dual / `𝒦_C`-subsheaf packaging of
Hartshorne `ℒ(D)`) by `f_P^{-1}` near `P` and by `1` on the complement,
where `f_P ∈ 𝔪_P ∖ 𝔪_P²` is any uniformiser of the DVR `𝒪_{C,P}`. The
result is independent of the choice of uniformiser (two uniformisers
differ by a unit) and is an invertible `𝒪_C`-module of rank one.

The signature returns a `Sheaf (Opens.grothendieckTopology C.left.toTopCat)
(ModuleCat.{u} kbar)`: the same `ModuleCat k̄`-flavoured sheaf
carrier used by the project's `Scheme.HModule` cohomology pipeline (so
that `H⁰` and `H¹` of `𝒪_C(P)` are accessible via
`Scheme.HModule kbar (lineBundleAtClosedPoint P hP) 0/1`).

iter-187 body (per analogist `ocofp-carrierset-submodule-api.md`
Decision 3 + Step 5 of the 5-step recipe): bundle the `carrierPresheaf`
+ `carrierPresheaf_isSheaf` of the iter-186/187 Hartshorne
subsheaf-of-`K_C` direct construction. The two `IsLocallyNoetherian` /
`IsRegularInCodimensionOne` hypotheses propagate from the existing
`namespace lineBundleAtClosedPoint` variable block (already required by
every downstream consumer `globalSections_iff_*`,
`h1_vanishing_genusZero`, `dim_eq_two_of_genusZero`,
`exists_nonconstant_genusZero`).

Blueprint reference: `def:lineBundleAtClosedPoint`
(Hartshorne II §6 p. 144 + Proposition 6.13(a); Stacks tag 01X0). -/
noncomputable def lineBundleAtClosedPoint
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    (P : C.left) (_hP : IsClosed ({P} : Set C.left))
    (hPcoh : Order.coheight P = 1) :
    Sheaf (Opens.grothendieckTopology C.left.toTopCat)
      (ModuleCat.{u} kbar) :=
  ⟨lineBundleAtClosedPoint.carrierPresheaf P hPcoh,
    lineBundleAtClosedPoint.carrierPresheaf_isSheaf P hPcoh⟩

/-- The inclusion `H⁰(C, 𝒪_C(P)) ↪ 𝒦_C ≅ K(C)` of global sections of
`𝒪_C(P)` into the function field, viewing each section as a rational
function via the canonical embedding `𝒪_C(P) ↪ 𝒦_C` (Hartshorne II §6 p.
144).

iter-187 body (per directive Lane A cascade-close): now that
`lineBundleAtClosedPoint` has its substantive body
`⟨carrierPresheaf P hPcoh, carrierPresheaf_isSheaf P hPcoh⟩` (Step 5
of the refactor), a global section
`s : HModule kbar (lineBundleAtClosedPoint P hP hPcoh) 0` is converted
into an element of `K(C)` by:

1. Applying `Scheme.HModule_zero_linearEquiv` to view `s` as a sheaf
   morphism `f : (constantSheaf _).obj (ModuleCat.of kbar kbar) ⟶
   lineBundleAtClosedPoint P hP hPcoh`.
2. Evaluating the underlying presheaf morphism at the top open `⊤`,
   giving a `kbar`-linear map from the constant-sheaf-fibre at `⊤`
   into the carrier submodule on `⊤`.
3. Feeding in the unit-image of `(1 : kbar)` under the
   `constantSheafAdj` adjunction unit (which sends `kbar` into the
   constant-sheaf-fibre at the terminal open `⊤`).
4. Extracting the underlying `K(C)`-value via the `Submodule.subtype`
   coercion `.1`.

iter-183: `hPcoh` threaded through together with the sig amend on
`lineBundleAtClosedPoint`, since the body of `toFunctionField` will
unfold the `carrierSet`-based body of `lineBundleAtClosedPoint` (the
`carrierSet` references `⟨P, hPcoh⟩` as a prime divisor). -/
noncomputable def lineBundleAtClosedPoint.toFunctionField
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    (P : C.left) (hP : IsClosed ({P} : Set C.left))
    (hPcoh : Order.coheight P = 1)
    (s : Scheme.HModule kbar
      (lineBundleAtClosedPoint (C := C) P hP hPcoh) 0) :
    C.left.functionField := by
  -- Terminal-object witness for the constant-sheaf adjunction.
  set hT : Limits.IsTerminal (⊤ : TopologicalSpace.Opens C.left.toTopCat) :=
    Preorder.isTerminalTop _
  -- Step 1: view `s` as a sheaf morphism via the `Ext`-to-`Hom` bridge.
  let f := (Scheme.HModule_zero_linearEquiv kbar
    (lineBundleAtClosedPoint (C := C) P hP hPcoh)) s
  -- Step 2: forget to a presheaf morphism.
  let g := (CategoryTheory.sheafToPresheaf _ _).map f
  -- Step 3: unit-image of `(1 : kbar)` in the constant-sheaf-fibre at `⊤`.
  let one_image :=
    ((CategoryTheory.constantSheafAdj
        (Opens.grothendieckTopology C.left.toTopCat)
        (ModuleCat.{u} kbar) hT).unit.app
      (ModuleCat.of kbar kbar)).hom (1 : kbar)
  -- Step 4: evaluate `g` at `⊤`, apply to `one_image`, extract the underlying
  -- `K(C)`-value from the `carrierSubmodule P hPcoh (op ⊤)` carrier.
  exact ((g.app (Opposite.op
      (⊤ : TopologicalSpace.Opens C.left.toTopCat))).hom one_image).1

namespace lineBundleAtClosedPoint

variable {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
  {C : Over (Spec (.of kbar))} [IsProper C.hom]
  [SmoothOfRelativeDimension 1 C.hom]
  [GeometricallyIrreducible C.hom] [IsIntegral C.left]
  [IsLocallyNoetherian C.left]
  [Scheme.IsRegularInCodimensionOne C.left]

/-! ## §2. Global sections as the Riemann–Roch space `L([P])`

Hartshorne II §7 Proposition 7.7 identifies the global sections of
`ℒ(D_0)` with the rational functions `f ∈ K(X)^×` satisfying
`div(f) ≥ −D_0` (plus the zero section). Specialised to `D_0 = [P]` on a
curve, the condition `div(f) + [P] ≥ 0` rewrites coordinate-wise as
`ord_Q(f) ≥ 0` for every prime divisor `Q ≠ P` and `ord_P(f) ≥ −1`. -/

/-- **Forward direction of `globalSections_iff` (Hartshorne II.7.7(b)).**

Given `f ∈ K(C)^×` with `ord_Q(f) ≥ 0` for every prime divisor `Q ≠ P`
and `ord_P(f) ≥ −1`, the rational function `f` lifts to a global section
`s ∈ H⁰(C, 𝒪_C(P))` whose image under the canonical inclusion
`𝒪_C(P) ↪ 𝒦_C ≅ K(C)` equals `f`. Hartshorne's construction inside the
proof of Proposition 7.7(b) (p. 157) defines this section locally on the
affine cover witnessing the Cartier-divisor structure of `[P]`: on a
neighbourhood `U_i` of `P` the section is `f · f_P` (in
`𝒪_C(P)(U_i) = f_P⁻¹ · 𝒪_C(U_i)`, this is `(f · f_P) · f_P⁻¹ = f`);
on the complement `C ∖ {P}` the section is `f` directly (the order
conditions `ord_Q(f) ≥ 0` for `Q ≠ P` guarantee `f ∈ 𝒪_C(U) = 𝒪_C(P)(U)`
on any affine open `U ⊆ C ∖ {P}`).

**iter-187 closure**: now that `lineBundleAtClosedPoint` has its
substantive body (`⟨carrierPresheaf P hPcoh, carrierPresheaf_isSheaf
P hPcoh⟩`) and `toFunctionField` has its substantive body
(the `HModule_zero_linearEquiv → constantSheafAdj → carrierSubmodule`
chain), the forward direction is constructed via the *reverse* chain:
the order conditions `_hord` express exactly that `f ∈ carrierSubmodule
P hPcoh (op ⊤)`. From the witness `⟨f, hf_in⟩ : ↥(carrierSubmodule ...)`,
we build a `kbar`-linear map `kbar → carrierSubmodule(⊤)` via
`LinearMap.toSpanSingleton` (sending `1 ↦ ⟨f, hf_in⟩`), lift through
`constantSheafAdj.homEquiv.symm` into a sheaf morphism, then through
`HModule_zero_linearEquiv.symm` into the `HModule` element `s`. The
round-trip `toFunctionField s = f` follows from the unit/counit
equation `adj.homEquiv_unit` evaluated at the input `(1 : kbar)`. -/
private lemma globalSections_iff_mp
    [∀ Q : C.left.PrimeDivisor,
        Ring.KrullDimLE 1 (C.left.presheaf.stalk Q.point)]
    (P : C.left) (hP : IsClosed ({P} : Set C.left))
    (f : C.left.functionField) (_hf : f ≠ 0)
    (hPcoh : Order.coheight P = 1)
    (_hord : (∀ Q : C.left.PrimeDivisor, Q.point ≠ P →
        0 ≤ Scheme.RationalMap.order Q f) ∧
      (-1 : ℤ) ≤ Scheme.RationalMap.order ⟨P, hPcoh⟩ f) :
    ∃ s : Scheme.HModule kbar
        (lineBundleAtClosedPoint (C := C) P hP hPcoh) 0,
      lineBundleAtClosedPoint.toFunctionField
        (C := C) P hP hPcoh s = f := by
  set hT : Limits.IsTerminal (⊤ : TopologicalSpace.Opens C.left.toTopCat) :=
    Preorder.isTerminalTop _
  have htop_ne_bot :
      (⊤ : TopologicalSpace.Opens C.left.toTopCat) ≠ ⊥ := by
    intro h
    have hn :
        (((⊤ : TopologicalSpace.Opens C.left.toTopCat) : Set C.left.toTopCat)).Nonempty :=
      ⟨(inferInstance : Nonempty C.left).some, Set.mem_univ _⟩
    rw [h, TopologicalSpace.Opens.coe_bot] at hn
    exact hn.ne_empty rfl
  have hf_in : f ∈ lineBundleAtClosedPoint.carrierSubmoduleSheaf P hPcoh
      (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat)) := by
    refine ⟨⟨fun Q _ hQP => _hord.1 Q hQP, fun _ => _hord.2⟩, Or.inl htop_ne_bot⟩
  set F := lineBundleAtClosedPoint (C := C) P hP hPcoh
  let φ : kbar →ₗ[kbar] ↑(lineBundleAtClosedPoint.carrierSubmoduleSheaf P hPcoh
      (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat))) :=
    LinearMap.toSpanSingleton kbar _ ⟨f, hf_in⟩
  let φ_cat : ModuleCat.of kbar kbar ⟶ F.val.obj
      (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat)) :=
    ModuleCat.ofHom φ
  set adj := (CategoryTheory.constantSheafAdj
    (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} kbar) hT)
  let sheafHom := (adj.homEquiv (ModuleCat.of kbar kbar) F).symm φ_cat
  let s : Scheme.HModule kbar F 0 :=
    (Scheme.HModule_zero_linearEquiv kbar F).symm sheafHom
  refine ⟨s, ?_⟩
  change ((((CategoryTheory.sheafToPresheaf _ _).map
    ((Scheme.HModule_zero_linearEquiv kbar F) s)).app
    (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat))).hom
      ((adj.unit.app (ModuleCat.of kbar kbar)).hom (1 : kbar))).1 = f
  have h1 : (Scheme.HModule_zero_linearEquiv kbar F) s = sheafHom := by simp [s]
  rw [h1]
  have h3 := adj.homEquiv_unit (X := ModuleCat.of kbar kbar) (Y := F) (f := sheafHom)
  have h_simp : (adj.homEquiv (ModuleCat.of kbar kbar) F) sheafHom = φ_cat :=
    (adj.homEquiv _ _).apply_symm_apply _
  rw [h_simp] at h3
  -- `sheafSections.obj.map sheafHom = sheafToPresheaf.map sheafHom .app (op ⊤)`
  -- holds by `rfl` since `sheafSections := sheafToPresheaf.flip`.
  have hrew : ((CategoryTheory.sheafToPresheaf _ _).map sheafHom).app
        (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat)) =
      ((CategoryTheory.sheafSections (Opens.grothendieckTopology C.left.toTopCat)
        (ModuleCat.{u} kbar)).obj
          (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat))).map sheafHom :=
    rfl
  rw [hrew]
  -- Use `h3` and `ModuleCat.comp_apply` to identify the goal's chain with `φ_cat.hom 1`.
  have h_eq : (((CategoryTheory.sheafSections (Opens.grothendieckTopology C.left.toTopCat)
        (ModuleCat.{u} kbar)).obj
          (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat))).map sheafHom).hom
        ((adj.unit.app (ModuleCat.of kbar kbar)).hom (1 : kbar)) = φ_cat.hom 1 := by
    rw [h3]; exact (ModuleCat.comp_apply _ _ _).symm
  -- Reduce to `(φ_cat.hom 1).1 = f` via the equation `h_eq`.
  -- (Direct `rw [h_eq]` fails to match due to subtle `ModuleCat.Hom.hom` vs `.hom`
  -- elaboration; we use `congr_arg Subtype.val h_eq` to lift the equation through
  -- the `↑` coercion explicitly.)
  refine (congr_arg Subtype.val h_eq).trans ?_
  -- Now the goal is `(φ_cat.hom 1).1 = f`. `φ_cat.hom = φ`, and `φ 1 = ⟨f, hf_in⟩`.
  change (φ 1).1 = f
  simp [φ, LinearMap.toSpanSingleton_apply]

/-- **Backward direction of `globalSections_iff` (Hartshorne II.7.7(a)).**

Given a global section `s ∈ H⁰(C, 𝒪_C(P))` whose image under
`𝒪_C(P) ↪ 𝒦_C ≅ K(C)` equals `f`, the order conditions on `f` follow by
reading off the stalk-by-stalk DVR identification. Concretely:

* At a prime divisor `Q ≠ P`, the stalk `𝒪_C(P)_Q = 𝒪_{C, Q}` agrees with
  the structure sheaf (since `𝒪_C(P)` equals `𝒪_C` on the open
  complement `C ∖ {P}`); the germ of `s` at `Q` lies in `𝒪_{C, Q}`, so
  the image `f = ι(s) ∈ K(C)` has valuation `ord_Q(f) ≥ 0`.
* At `P`, the stalk `𝒪_C(P)_P = f_P⁻¹ · 𝒪_{C, P}` (where `f_P` is a
  uniformiser of the DVR `𝒪_{C, P}`); the germ of `s` at `P` lies in
  this stalk, so `f = ι(s)` satisfies `f_P · f ∈ 𝒪_{C, P}`, i.e.
  `ord_P(f) ≥ −1`.

**iter-187 closure**: now that `lineBundleAtClosedPoint` and
`toFunctionField` both have substantive bodies (Steps 5 of the iter-187
refactor + the prover-phase cascade-close of `toFunctionField` body),
the order conditions on `f` are extracted directly from the
`carrierSubmodule` membership encoded in the underlying
`carrierSet`-element produced by `toFunctionField`'s linearEquiv chain.
Concretely: `toFunctionField s = ((sheafToPresheaf.map (linearEquiv₀ s)).
app(op ⊤) (one_image_of_1)).1`, an element of the function field whose
carrier-submodule membership witness `.2` says exactly that `f` (after
identification with `.1`) satisfies the order conditions on the top
open. Membership in `carrierSubmodule P hPcoh (op ⊤)` unfolds to the
desired pair of order conditions at all prime divisors (with the
`Q.point ∈ Set.univ` premise discharged by `Set.mem_univ _`). -/
private lemma globalSections_iff_mpr
    [∀ Q : C.left.PrimeDivisor,
        Ring.KrullDimLE 1 (C.left.presheaf.stalk Q.point)]
    (P : C.left) (hP : IsClosed ({P} : Set C.left))
    (f : C.left.functionField) (_hf : f ≠ 0)
    (hPcoh : Order.coheight P = 1)
    (_h : ∃ s : Scheme.HModule kbar
        (lineBundleAtClosedPoint (C := C) P hP hPcoh) 0,
        lineBundleAtClosedPoint.toFunctionField
          (C := C) P hP hPcoh s = f) :
    (∀ Q : C.left.PrimeDivisor, Q.point ≠ P →
        0 ≤ Scheme.RationalMap.order Q f) ∧
      (-1 : ℤ) ≤ Scheme.RationalMap.order ⟨P, hPcoh⟩ f := by
  obtain ⟨s, hs⟩ := _h
  set hT : Limits.IsTerminal (⊤ : TopologicalSpace.Opens C.left.toTopCat) :=
    Preorder.isTerminalTop _
  set sheaf_hom := (Scheme.HModule_zero_linearEquiv kbar
    (lineBundleAtClosedPoint (C := C) P hP hPcoh)) s
  set g := (CategoryTheory.sheafToPresheaf _ _).map sheaf_hom
  set one_image := ((CategoryTheory.constantSheafAdj
      (Opens.grothendieckTopology C.left.toTopCat)
      (ModuleCat.{u} kbar) hT).unit.app
    (ModuleCat.of kbar kbar)).hom (1 : kbar)
  set sec :=
    (g.app (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat))).hom one_image
  have hsec_mem : sec.1 ∈ lineBundleAtClosedPoint.carrierSubmoduleSheaf P hPcoh
      (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat)) := sec.2
  have hsec_eq : sec.1 = f := hs
  rw [hsec_eq] at hsec_mem
  -- `hsec_mem.1` projects out the `carrierSubmodule` membership (dropping
  -- the `trivAtBot` factor introduced by `carrierSubmoduleSheaf`).
  exact ⟨fun Q hQP => hsec_mem.1.1 Q (Set.mem_univ _) hQP,
    hsec_mem.1.2 (Set.mem_univ _)⟩

/-- **Global sections of `𝒪_C(P)` as rational functions with controlled
pole at `P`** (Hartshorne II §7 Proposition 7.7, p. 157).

For a nonzero rational function `f ∈ K(C)^×`, the following are
equivalent:

* there exists a global section `s ∈ H⁰(C, 𝒪_C(P))` whose image under
  the canonical inclusion `𝒪_C(P) ↪ 𝒦_C ≅ K(C)` equals `f` (formally,
  `lineBundleAtClosedPoint.toFunctionField P hP s = f`);
* the order conditions hold: `ord_Q(f) ≥ 0` for every prime divisor
  `Q ∈ C.PrimeDivisor` whose generic point is not `P`, and
  `ord_P(f) ≥ −1` (where the latter is read off the prime divisor
  `⟨P, h⟩` with `h : Order.coheight P = 1` the codimension-one witness
  automatic for a closed point on a one-dimensional integral scheme).

The iff is the substantive content of Hartshorne's Proposition 7.7(b) /
its proof, specialised to `D_0 = [P]`.

**iter-181 Lane A PARTIAL — directional split landed**: the iff is now
proved by combining the two directional helpers
`globalSections_iff_mp` (Hartshorne II.7.7(b), forward) and
`globalSections_iff_mpr` (Hartshorne II.7.7(a), backward), both of
which carry a single honest typed `sorry` blocked on the body of
`lineBundleAtClosedPoint` (line ~140) and
`lineBundleAtClosedPoint.toFunctionField` (line ~154). The combinator
proof (`⟨mp, mpr⟩`-style) below is kernel-clean modulo those two
upstream sorries; iter-182+ provers can attack each directional helper
independently. The directive's helper budget = 2 is consumed by these
two named helpers.

iter-177+ body intent: unfold `lineBundleAtClosedPoint` as the subsheaf
of `𝒦_C` generated locally by `f_P⁻¹` near `P` and by `1` elsewhere,
then read off the order conditions at each stalk via the DVR valuation
identification.

Blueprint reference: `lem:lineBundleAtClosedPoint_globalSections_iff`
(Hartshorne II.7 Proposition 7.7(b), p. 157). -/
lemma globalSections_iff
    [∀ Q : C.left.PrimeDivisor,
        Ring.KrullDimLE 1 (C.left.presheaf.stalk Q.point)]
    (P : C.left) (hP : IsClosed ({P} : Set C.left))
    (f : C.left.functionField) (hf : f ≠ 0)
    (hPcoh : Order.coheight P = 1) :
    (∀ Q : C.left.PrimeDivisor, Q.point ≠ P →
        0 ≤ Scheme.RationalMap.order Q f) ∧
      (-1 : ℤ) ≤ Scheme.RationalMap.order ⟨P, hPcoh⟩ f
    ↔
    ∃ s : Scheme.HModule kbar
        (lineBundleAtClosedPoint (C := C) P hP hPcoh) 0,
      lineBundleAtClosedPoint.toFunctionField
        (C := C) P hP hPcoh s = f :=
  ⟨globalSections_iff_mp P hP f hf hPcoh,
   globalSections_iff_mpr P hP f hf hPcoh⟩

/-! ## §3. Cohomological vanishing in genus zero

Specialise Hartshorne IV.1 Theorem 1.3's inductive step at `D = 0`. The
standard short exact sequence
`0 → 𝒪_C(−[P]) → 𝒪_C → k(P) → 0` (Hartshorne II.6.18: the ideal sheaf
of the locally principal closed subscheme `P` is `𝒪_C(−[P])`; the
quotient is the skyscraper `k(P) ≅ k̄` at `P`) tensored by the locally
free rank-`1` sheaf `𝒪_C([P])` (left rigid, so preserves exactness and
leaves the skyscraper invariant) becomes
`0 → 𝒪_C → 𝒪_C(P) → k(P) → 0` in `Coh(C)`. The associated long exact
sequence of sheaf cohomology, combined with `H¹(C, 𝒪_C) = 0`
(genus-`0` hypothesis: `g(C) = dim_{k̄} H¹(C, 𝒪_C)`) and
`H¹(C, k(P)) = 0` (skyscraper / flasque), kills `H¹(C, 𝒪_C(P))`. -/

/-- **Vanishing of `H¹(C, 𝒪_C(P))` on a smooth proper geometrically
irreducible curve of genus `0`** (Hartshorne IV §1 p. 296, the
inductive step of Theorem 1.3 specialised to `D = 0`).

Concretely, the finite-dimensional `k̄`-vector space
`Scheme.HModule kbar (lineBundleAtClosedPoint P hP) 1` has dimension
`0`, i.e. is the trivial vector space.

iter-177+ body: assemble the closed-point short exact sequence
`0 → 𝒪_C → 𝒪_C(P) → k(P) → 0`, feed it to the long exact sequence of
`Module k̄`-flavoured cohomology (the project's
`Scheme.HModule k̄`-bridge inherits the LES by forget-functor
naturality from
`CategoryTheory.Abelian.Ext.covariantSequence_exact`), substitute
`H¹(C, 𝒪_C) = 0` (the genus-`0` hypothesis, unfolding
`AlgebraicGeometry.genus`) and `H¹(C, k(P)) = 0` (skyscraper sheaf /
flasque cohomology, Hartshorne III.2.5), and collapse the segment to
`0 → H¹(C, 𝒪_C(P)) → 0`.

Blueprint reference: `lem:H1_vanishing_lineBundleAtClosedPoint_genusZero`
(Hartshorne IV.1 p. 296). -/
lemma h1_vanishing_genusZero
    (P : C.left) (hP : IsClosed ({P} : Set C.left))
    (hPcoh : Order.coheight P = 1)
    (_hg : AlgebraicGeometry.genus C = 0) :
    Module.finrank kbar
        (Scheme.HModule kbar
          (lineBundleAtClosedPoint (C := C) P hP hPcoh) 1) = 0 := by
  sorry

/-! ## §4. The dimension formula `dim H⁰(C, 𝒪_C(P)) = 2` in genus zero

Specialise the Euler-characteristic identity
`χ(𝒪_C(D)) = deg(D) + 1 − g` of `RR.2`
(`Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus`) to
`D = [P]`. Since `deg([P]) = 1` (every closed point contributes degree
`1` over `k̄`) and `g(C) = 0`, this gives `χ(𝒪_C(P)) = 2`. Unfolding
`χ` as `dim H⁰ − dim H¹` and substituting the `H¹`-vanishing of §3
yields `dim H⁰(C, 𝒪_C(P)) = 2`. -/

/-- **The dimension formula `dim_{k̄} H⁰(C, 𝒪_C(P)) = 2` on a smooth
proper geometrically irreducible genus-`0` curve over `k̄`**
(Hartshorne IV §1 Example 1.3.5, p. 297).

iter-177+ body: invoke
`Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus` on the
`ModuleCat k̄`-valued sheaf `lineBundleAtClosedPoint P hP` (matching the
χ-identity through a bridge identifying
`lineBundleAtClosedPoint P hP` with
`WeilDivisor.sheafOf (ofClosedPoint P hP)`), evaluate the right-hand
side `deg([P]) + 1 − g(C) = 1 + 1 − 0 = 2`, unfold
`Scheme.eulerCharacteristic` as
`(Module.finrank kbar H⁰) − (Module.finrank kbar H¹)`, substitute
`Module.finrank kbar H¹ = 0` from `h1_vanishing_genusZero`, and read
off `Module.finrank kbar H⁰ = 2`.

Blueprint reference: `thm:lineBundleAtClosedPoint_dim_eq_two_of_genusZero`
(Hartshorne IV.1 Example 1.3.5, p. 297).

iter-194 Lane A first body push: the body is now mechanical arithmetic
(finrank H⁰ - finrank H¹ = 2 with H¹ = 0 gives H⁰ = 2) on top of two
named substrate helpers:
* `h1_vanishing_genusZero` (already in this file) — supplies finrank H¹ = 0.
* `eulerCharacteristic_lineBundleAtClosedPoint_eq_two` (named helper below) —
  supplies χ(𝒪_C(P)) = 2 from RR.2's χ-identity at `D = [P]`. -/
theorem dim_eq_two_of_genusZero
    (P : C.left) (hP : IsClosed ({P} : Set C.left))
    (hPcoh : Order.coheight P = 1)
    (_hg : AlgebraicGeometry.genus C = 0) :
    Module.finrank kbar
        (Scheme.HModule kbar
          (lineBundleAtClosedPoint (C := C) P hP hPcoh) 0) = 2 := by
  -- Step 1: H¹(𝒪_C(P)) = 0 via the genus-0 SES.
  have hH1 :
      Module.finrank kbar
        (Scheme.HModule kbar
          (lineBundleAtClosedPoint (C := C) P hP hPcoh) 1) = 0 :=
    h1_vanishing_genusZero P hP hPcoh _hg
  -- Step 2: χ(𝒪_C(P)) = 2 via the RR.2 χ-identity at `D = [P]`.
  have hχ : Scheme.eulerCharacteristic C
      (lineBundleAtClosedPoint (C := C) P hP hPcoh) = 2 :=
    eulerCharacteristic_lineBundleAtClosedPoint_eq_two P hP hPcoh _hg
  -- Step 3: unfold `χ = (H⁰ : ℤ) - (H¹ : ℤ)`, substitute H¹ = 0, read off H⁰.
  unfold Scheme.eulerCharacteristic at hχ
  rw [hH1, Nat.cast_zero, sub_zero] at hχ
  exact_mod_cast hχ

/-! ## §5. A non-constant rational function with at most a simple pole at `P`

The two-dimensionality of `H⁰(C, 𝒪_C(P))` and the one-dimensional
constant subspace `k̄ · 1` give a non-zero quotient `H⁰/k̄`. Any lift
of a non-zero element of the quotient is, under the identification of
`globalSections_iff`, a non-constant rational function `f ∈ K(C)` with
the order conditions `ord_Q(f) ≥ 0` for `Q ≠ P` and `ord_P(f) ≥ −1`.
This is the seed of `RR.4` (the morphism `C → ℙ¹` produced by
`Proj.fromOfGlobalSections` from the basis `(1, f)`). -/

/-- **Existence of a non-constant rational function regular on `C ∖ {P}`
with at most a simple pole at `P`** (Hartshorne IV §1 Exercise 1.1,
p. 297, the genus-`0` specialisation).

Concretely, there exists `f ∈ K(C)` such that:

* `f ≠ 0`;
* `f ∉ k̄` (i.e. `f` is non-constant — for instance, it does not lie
  in the image of the structural inclusion of constants);
* `ord_Q(f) ≥ 0` for every prime divisor `Q ∈ C.PrimeDivisor` whose
  generic point is not `P`;
* `ord_P(f) ≥ −1` (at most a simple pole at `P`).

iter-177+ body: use `dim_eq_two_of_genusZero` to get
`dim_{k̄} H⁰(C, 𝒪_C(P)) = 2`. The image of `1 ∈ H⁰(C, 𝒪_C) ≅ k̄`
under the structural inclusion `𝒪_C ↪ 𝒪_C(P)` spans a one-dimensional
subspace of `H⁰(C, 𝒪_C(P))`; choose any section `s ∈ H⁰(C, 𝒪_C(P))`
not in this constant subspace (non-empty because `dim H⁰ = 2 > 1`),
then take `f := lineBundleAtClosedPoint.toFunctionField P hP s` and
verify the four bullets via `globalSections_iff` applied to `f`
(the forward direction supplies the order conditions from the existence
witness `⟨s, rfl⟩`). The chosen `f` is non-constant because `s` is not
in the constant subspace and `toFunctionField` is `k̄`-linear and
injective on global sections.

The principal-divisor-non-zero formulation `Scheme.WeilDivisor.principal
f hf ≠ 0` follows from non-constancy plus the fact that constant
functions have principal divisor zero (the converse — `div(f) = 0`
⇒ `f` constant — uses the integrality of `C` and is the Stacks 02P0
"functions with no zeros and poles are constant" type statement).

Blueprint reference:
`cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero` (alias
`cor:nonconstant_function_genus_zero` consumed by `RR.4`)
(Hartshorne IV.1 Exercise 1.1, p. 297). -/
theorem exists_nonconstant_genusZero
    [∀ Q : C.left.PrimeDivisor,
        Ring.KrullDimLE 1 (C.left.presheaf.stalk Q.point)]
    (P : C.left) (_hP : IsClosed ({P} : Set C.left))
    (hPcoh : Order.coheight P = 1)
    (_hg : AlgebraicGeometry.genus C = 0) :
    ∃ (f : C.left.functionField) (hf : f ≠ 0),
      (∀ Q : C.left.PrimeDivisor, Q.point ≠ P →
          0 ≤ Scheme.RationalMap.order Q f) ∧
      (-1 : ℤ) ≤ Scheme.RationalMap.order ⟨P, hPcoh⟩ f ∧
      Scheme.WeilDivisor.principal (X := C.left) f hf ≠ 0 := by
  sorry

end lineBundleAtClosedPoint

end Scheme

end AlgebraicGeometry
