/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.RiemannRoch.WeilDivisor
import AlgebraicJacobian.RiemannRoch.CurveKrullDim

/-!
# Dedekind domain structure on affine charts of smooth integral curves

Blueprint: `blueprint/src/chapters/RiemannRoch_CurveChartDedekind.tex`

This file is the **generic-affine** realization of the curve-framed Dedekind theorem:
given an affine integral locally-Noetherian scheme `V` that is regular in codimension
one and whose topological Krull dimension satisfies `Order.krullDim (α := V) ≤ 1`, the
global-section ring `Γ(V, ⊤)` is a Dedekind domain.

The hypothesis `hdim : Order.krullDim (α := V) ≤ 1` is precisely the conclusion of
`AlgebraicGeometry.krullDim_curve_le_one` (from `CurveKrullDim`). The intended consumer
(next iteration) instantiates `V` as an affine open sub-scheme of a smooth curve `C.left`
and supplies `hdim` directly via that theorem.

## Declarations

1. `chart_dimensionLEOne` — `Ring.DimensionLEOne Γ(V, ⊤)` from `hdim`.
   (`lem:chart_dimensionLEOne` in the blueprint.)
2. `chart_isIntegrallyClosed` — `IsIntegrallyClosed Γ(V, ⊤)` via stalk-DVR transport.
   (`lem:chart_isIntegrallyClosed` in the blueprint.)
3. `chart_isDedekindDomain` — `IsDedekindDomain Γ(V, ⊤)` assembled from (1)+(2)+Noetherian.
   (`thm:chart_isDedekindDomain` in the blueprint.)

## References

Blueprint: `blueprint/src/chapters/RiemannRoch_CurveChartDedekind.tex`.
Hartshorne, *Algebraic Geometry*, I §1.6 (Dedekind domains) + II §6 (divisors on curves).
Stacks Project Tag 00P3 (Dedekind domain iff Noetherian dim-1 integrally-closed domain).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

section CurveChartDedekind

variable {V : Scheme.{u}} [IsIntegral V] [IsLocallyNoetherian V] [IsAffine V]
    [Scheme.IsRegularInCodimensionOne V]

-- `Γ(V, ⊤)` is an integral domain: `V` integral + nonempty affine open ⊤.
-- This private instance makes `IsDedekindDomain Γ(V, ⊤)` elaborate without an
-- extra hypothesis, mirroring the `haveI` at CurveKrullDim.lean:305.
private instance instNonemptyTop : Nonempty (⊤ : V.Opens) :=
  ⟨⟨Classical.arbitrary V, trivial⟩⟩

private instance instDomainGlobalSections : IsDomain Γ(V, ⊤) :=
  IsIntegral.component_integral ⊤

/-! ### Lemma 1 — Krull dimension ≤ 1 implies `Ring.DimensionLEOne` -/

/- Planner strategy (`lem:chart_dimensionLEOne`):

**Goal**: `Ring.DimensionLEOne Γ(V, ⊤)` — every nonzero prime of `Γ(V, ⊤)` is maximal.

**Step 1 — Topological → ring dimension.**
`hdim : Order.krullDim (α := V) ≤ 1` is the topological Krull dimension of `V`.
For an affine integral scheme, the topological and ring Krull dimensions coincide:
use `Scheme.krullDim_eq_ringKrullDim_of_isAffine V` (or the equivalent chain of
`ringKrullDim_stalk_eq_coheight` + iSup) to obtain
  `ringKrullDim Γ(V, ⊤) ≤ 1`.

**Step 2 — Ring.DimensionLEOne from ringKrullDim ≤ 1.**
In a Noetherian integral domain of ring Krull dimension ≤ 1, every nonzero prime is
maximal.  Route: `Ring.DimensionLEOne` unfolds to
  `∀ p ≠ ⊥, p.IsPrime → p.IsMaximal`.
Given a nonzero prime `p`, the chain `⊥ ⊊ p` has length 1, so `primeHeight p ≤ 1`.
In a `ringKrullDim ≤ 1` ring, `primeHeight p ≤ 1` forces `p` maximal (otherwise a
proper extension `p ⊊ q` would give `primeHeight p ≥ 2`).
Concretely: search for `Ring.DimensionLEOne.of_ringKrullDim_le_one` or derive via
`ringKrullDim_le_one_iff` / `Ideal.height_le_one_of_ringKrullDim_le_one` —
Mathlib `b80f227` ships both `Ideal.primeHeight_le_ringKrullDim` and
`IsLocalization.AtPrime.ringKrullDim_eq_height`, so a 3-line chain suffices.

**Alternative direct route** (if the bridge lemma is absent):
`Order.krullDim_eq_iSup_coheight` + `Scheme.ringKrullDim_stalk_eq_coheight` +
`IsLocalization.AtPrime.ringKrullDim_eq_height` gives `primeHeight p ≤ 1` for
each nonzero prime of `Γ(V, ⊤)`, and then `Ideal.IsMaximal.of_primeHeight_le_one`
(or the converse direction of Dedekind height characterization) closes the goal. -/
omit [IsIntegral V] [IsLocallyNoetherian V] [Scheme.IsRegularInCodimensionOne V] in
/-- **Affine Krull-dimension bridge.** For an affine scheme `V`, the topological
Krull dimension `Order.krullDim (α := V)` (specialisation preorder) equals the ring
Krull dimension of the global sections `Γ(V, ⊤)`.

The underlying space of `V` is homeomorphic to `Spec Γ(V, ⊤) = PrimeSpectrum Γ(V, ⊤)`
via `V.isoSpec`. The scheme's specialisation preorder is the *opposite* of the prime
inclusion order (`PrimeSpectrum.le_iff_specializes`), so the homeomorphism upgrades to
an order isomorphism `V ≃o (PrimeSpectrum Γ(V, ⊤))ᵒᵈ`; `Order.krullDim` is invariant
under order duality. -/
private lemma ringKrullDim_globalSections_eq_krullDim :
    ringKrullDim Γ(V, ⊤) = Order.krullDim (α := V) := by
  -- The carrier-level homeomorphism `V ≃ₜ PrimeSpectrum Γ(V, ⊤)` from `V.isoSpec`.
  let hHomeo : (↥V) ≃ₜ PrimeSpectrum Γ(V, ⊤) :=
    TopCat.homeoOfIso (Scheme.forgetToTop.mapIso V.isoSpec)
  -- Upgrade to an order iso into the order dual of the prime inclusion order.
  let eOrder : V ≃o (PrimeSpectrum Γ(V, ⊤))ᵒᵈ :=
    { toEquiv := hHomeo.toEquiv
      map_rel_iff' := by
        intro a b
        change (hHomeo b) ≤ (hHomeo a) ↔ b ⤳ a
        rw [PrimeSpectrum.le_iff_specializes]
        constructor
        · intro h
          have h2 := h.map hHomeo.symm.continuous
          rwa [hHomeo.symm_apply_apply, hHomeo.symm_apply_apply] at h2
        · intro h
          exact h.map hHomeo.continuous }
  rw [Order.krullDim_eq_of_orderIso eOrder, Order.krullDim_orderDual]
  rfl

omit [IsIntegral V] [IsLocallyNoetherian V] [Scheme.IsRegularInCodimensionOne V] in
/-- The global sections of an affine scheme of topological Krull dimension `≤ 1`
form a ring of Krull dimension `≤ 1`. -/
private lemma ringKrullDim_globalSections_le_one (hdim : Order.krullDim (α := V) ≤ 1) :
    ringKrullDim Γ(V, ⊤) ≤ 1 := by
  rw [ringKrullDim_globalSections_eq_krullDim]; exact hdim

omit [IsLocallyNoetherian V] [Scheme.IsRegularInCodimensionOne V] in
theorem chart_dimensionLEOne (hdim : Order.krullDim (α := V) ≤ 1) :
    Ring.DimensionLEOne Γ(V, ⊤) := by
  -- From `ringKrullDim Γ(V, ⊤) ≤ 1` we obtain `Ring.KrullDimLE 1`, which says every
  -- prime is minimal or maximal. In a domain the unique minimal prime is `⊥`, so every
  -- *nonzero* prime is maximal — exactly `Ring.DimensionLEOne`.
  have hk : Ring.KrullDimLE 1 Γ(V, ⊤) :=
    Ring.krullDimLE_iff.mpr (by exact_mod_cast ringKrullDim_globalSections_le_one hdim)
  apply Ring.DimensionLEOne.mk
  intro p hp_ne hp_prime
  rcases (Ring.krullDimLE_one_iff.mp hk) p hp_prime with hmin | hmax
  · exact absurd (le_antisymm (hmin.2 ⟨Ideal.isPrime_bot, bot_le⟩ bot_le) bot_le) hp_ne
  · exact hmax

/-! ### Lemma 2 — Integrally closed via stalk-DVR transport -/

/- Planner strategy (`lem:chart_isIntegrallyClosed`):

**Goal**: `IsIntegrallyClosed Γ(V, ⊤)`.

**Key Mathlib lemma**: `IsIntegrallyClosed.of_localization_maximal`
(`Mathlib.RingTheory.LocalProperties.IntegrallyClosed`).  It reduces the global
statement to showing that the localization at every nonzero prime is integrally closed.
Because `Γ(V, ⊤)` is a domain of Krull dimension ≤ 1 (from `chart_dimensionLEOne hdim`),
every nonzero prime `p` is maximal, so `Localization.AtPrime p` is already a local ring
at a *maximal* ideal.

**Step 1 — Localization ≅ stalk.**
Mirror `finite_order_support_affine` (WeilDivisor.lean lines 930–936):
```
  set x : (⊤ : V.Opens) := ⟨p_point, mem_top⟩
  letI : Algebra Γ(V, ⊤) (V.presheaf.stalk p_point) :=
    TopCat.Presheaf.algebra_section_stalk V.presheaf x
  haveI : IsLocalization.AtPrime (V.presheaf.stalk p_point) (hV.primeIdealOf x).asIdeal :=
    hV.isLocalization_stalk x
  haveI : IsScalarTower Γ(V, ⊤) (V.presheaf.stalk p_point) V.functionField :=
    functionField_isScalarTower V ⊤ x
```
where `hV := isAffineOpen_top V`.

**Step 2 — The stalk is a DVR.**
`Scheme.IsRegularInCodimensionOne V` says the stalk at any codimension-1 point is a DVR.
Under `chart_dimensionLEOne hdim` every nonzero prime is codimension 1 (equivalently the
corresponding scheme point has `Order.coheight = 1`), so
`Scheme.IsRegularInCodimensionOne.instIsDiscreteValuationRingStalk` applies.

**Step 3 — DVR → integrally closed.**
A DVR is a PID, hence a Bézout domain, hence integrally closed.
`IsDiscreteValuationRing.isIntegrallyClosed` (or `IsPrincipalIdealRing.isIntegrallyClosed`
+ instance chain) gives `IsIntegrallyClosed (V.presheaf.stalk p_point)`.

**Step 4 — Transport across the localization iso.**
`IsLocalization.isIntegrallyClosed_of_isIntegrallyClosed_localization` (or the
`of_localization_maximal` machinery) lifts integrally-closedness from
`Localization.AtPrime p` back to `Γ(V, ⊤)`.  The localization and the stalk are
canonically isomorphic as `Γ(V, ⊤)`-algebras (both represent `IsLocalization.AtPrime p`),
so `IsIntegrallyClosed` transfers across any ring isomorphism.

**Concretely**: apply `IsIntegrallyClosed.of_localization_maximal`; for each maximal
prime `p` (all nonzero primes, by `chart_dimensionLEOne hdim`) construct the stalk
localization data above, invoke `IsDiscreteValuationRing.isIntegrallyClosed` on the
stalk, then transport via `IsLocalization.algebraMap_injective` + integrally-closed
localization transfer. -/
omit [IsLocallyNoetherian V] in
theorem chart_isIntegrallyClosed (hdim : Order.krullDim (α := V) ≤ 1) :
    IsIntegrallyClosed Γ(V, ⊤) := by
  have hV : IsAffineOpen (⊤ : V.Opens) := isAffineOpen_top V
  -- Integral closedness is local at nonzero maximal ideals.
  apply IsIntegrallyClosed.of_localization_maximal
  intro p hp_ne hp_max
  -- The point of `V` corresponding to the prime `p` (via `fromSpec`), and the fact
  -- that the stalk there is the localization of `Γ(V, ⊤)` at `p`.
  haveI hpp : p.IsPrime := hp_max.isPrime
  let P : PrimeSpectrum Γ(V, ⊤) := ⟨p, hpp⟩
  set x : V := hV.fromSpec P with hx
  have hxmem : hV.fromSpec P ∈ (⊤ : V.Opens) := trivial
  letI instAlg : Algebra Γ(V, ⊤) (V.presheaf.stalk x) :=
    TopCat.Presheaf.algebra_section_stalk V.presheaf ⟨x, hxmem⟩
  haveI hloc : IsLocalization.AtPrime (V.presheaf.stalk x) P.asIdeal :=
    hV.isLocalization_stalk' P hxmem
  -- `P.asIdeal = p` has height exactly one: `≤ 1` from the dimension bound, `≥ 1`
  -- because `p ≠ ⊥` is not a minimal prime of the domain `Γ(V, ⊤)`.
  have hheight1 : P.asIdeal.primeHeight = 1 := by
    have hle : P.asIdeal.primeHeight ≤ 1 := by
      have := le_trans (Ideal.primeHeight_le_ringKrullDim (I := P.asIdeal))
        (ringKrullDim_globalSections_le_one hdim)
      exact_mod_cast this
    have hne0 : P.asIdeal.primeHeight ≠ 0 := by
      intro h0
      have hmem := Ideal.primeHeight_eq_zero_iff.mp h0
      exact hp_ne (le_antisymm (hmem.2 ⟨Ideal.isPrime_bot, bot_le⟩ bot_le) bot_le)
    -- In `ℕ∞`, `≤ 1` and `≠ 0` force `= 1`.
    rcases eq_or_lt_of_le hle with h | h
    · exact h
    · exact absurd (by simpa [ENat.lt_one_iff_eq_zero] using h) hne0
  -- Hence the corresponding point has coheight one and is a prime divisor.
  have hco : Order.coheight x = 1 := by
    have e1 : ringKrullDim (V.presheaf.stalk x) = (Order.coheight x : WithBot ℕ∞) :=
      Scheme.ringKrullDim_stalk_eq_coheight V x
    have e2 : ringKrullDim (V.presheaf.stalk x) = (P.asIdeal.height : WithBot ℕ∞) :=
      IsLocalization.AtPrime.ringKrullDim_eq_height P.asIdeal (V.presheaf.stalk x)
    rw [e1, Ideal.height_eq_primeHeight, hheight1] at e2
    exact_mod_cast e2
  -- The stalk at a codimension-one point is a DVR by regularity in codimension one.
  let Y : Scheme.PrimeDivisor V := ⟨x, hco⟩
  haveI hdvr : IsDiscreteValuationRing (V.presheaf.stalk x) :=
    Scheme.IsRegularInCodimensionOne.out Y
  -- Transport the DVR (hence integrally-closed) structure across the canonical iso
  -- `stalk x ≃ₐ[Γ(V,⊤)] Localization.AtPrime p` of localizations at the same prime.
  haveI : IsDomain (Localization.AtPrime p) := inferInstance
  let e : V.presheaf.stalk x ≃ₐ[Γ(V, ⊤)] Localization.AtPrime p :=
    IsLocalization.algEquiv P.asIdeal.primeCompl (V.presheaf.stalk x)
      (Localization.AtPrime p)
  haveI : IsDiscreteValuationRing (Localization.AtPrime p) :=
    IsDiscreteValuationRing.RingEquivClass.isDiscreteValuationRing e
  infer_instance

/-! ### Theorem 3 — Assembling the Dedekind domain -/

/- Planner strategy (`thm:chart_isDedekindDomain`):

**Goal**: `IsDedekindDomain Γ(V, ⊤)`.

`IsDedekindDomain` in Mathlib (Stacks Tag 00P3) unfolds to: Noetherian integral domain
of Krull dimension ≤ 1 that is integrally closed in its fraction field.
Use `(isDedekindRing_iff Γ(V, ⊤) V.functionField).mpr` to reduce to three sub-goals,
or call `IsDedekindDomain.mk` directly.

**Three sub-goals and their provers:**

1. `IsNoetherianRing Γ(V, ⊤)`:
   ```
   IsLocallyNoetherian.component_noetherian ⟨⊤, isAffineOpen_top V⟩
   ```
   This is the same call used in `finite_order_support_affine`
   (WeilDivisor.lean line 906) and requires only `[IsLocallyNoetherian V]`.

2. `Ring.DimensionLEOne Γ(V, ⊤)`:
   ```
   chart_dimensionLEOne hdim
   ```

3. `IsIntegrallyClosed Γ(V, ⊤)` (the "integrally closed in fraction field" conjunct):
   ```
   chart_isIntegrallyClosed hdim
   ```
   Note: `IsFractionRing Γ(V, ⊤) V.functionField` is the fraction-ring witness.
   Provide it via:
   ```
   haveI : IsFractionRing Γ(V, ⊤) V.functionField :=
     functionField_isFractionRing_of_isAffineOpen V ⊤ (isAffineOpen_top V)
   ```
   (WeilDivisor.lean line 908.)  Once the `IsFractionRing` is in scope, Mathlib's
   `IsIntegrallyClosed` → "integrally closed in fraction field" direction is automatic,
   or `isDedekindRing_iff` may bundle the fraction field.

**Assembly**:
```lean
  haveI hnoeth : IsNoetherianRing Γ(V, ⊤) :=
    IsLocallyNoetherian.component_noetherian ⟨⊤, isAffineOpen_top V⟩
  haveI hfrac : IsFractionRing Γ(V, ⊤) V.functionField :=
    functionField_isFractionRing_of_isAffineOpen V ⊤ (isAffineOpen_top V)
  exact (isDedekindRing_iff Γ(V, ⊤) V.functionField).mpr
    ⟨hnoeth, chart_dimensionLEOne hdim, chart_isIntegrallyClosed hdim⟩
```
If `isDedekindRing_iff` is absent or has a different signature (e.g. Mathlib removed it
in a recent bump), fall back to `IsDedekindDomain.mk` directly, passing the three
witnesses above as fields.  The `instDedekindDomainOfIsDomainOfIsDedekindRing`
instance path (or `IsDedekindDomain.of_isNoetherianRing_of_dimensionLEOne_of_isIntegrallyClosed`)
is an alternative if the `_iff` form is absent. -/
theorem chart_isDedekindDomain (hdim : Order.krullDim (α := V) ≤ 1) :
    IsDedekindDomain Γ(V, ⊤) := by
  have hV : IsAffineOpen (⊤ : V.Opens) := isAffineOpen_top V
  haveI hnoeth : IsNoetherianRing Γ(V, ⊤) :=
    IsLocallyNoetherian.component_noetherian ⟨⊤, hV⟩
  haveI hfrac : IsFractionRing Γ(V, ⊤) V.functionField :=
    functionField_isFractionRing_of_isAffineOpen V ⊤ hV
  haveI : IsIntegrallyClosed Γ(V, ⊤) := chart_isIntegrallyClosed hdim
  haveI : IsDedekindRing Γ(V, ⊤) :=
    (isDedekindRing_iff Γ(V, ⊤) V.functionField).mpr
      ⟨hnoeth, chart_dimensionLEOne hdim,
        fun hx => IsIntegrallyClosed.algebraMap_eq_of_integral hx⟩
  infer_instance

/-! ### Algebraic Hartogs on a Dedekind chart -/

/- Planner strategy (`lem:chart_valuation_le_one_of_order_nonneg`):

**Goal**: for a prime divisor `Z` of `V` and the matching height-one prime
`v : HeightOneSpectrum Γ(V, ⊤)` (linked by `hZv`), translate the order condition
`0 ≤ Scheme.RationalMap.order Z g` into the valuation bound
`(HeightOneSpectrum.valuation V.functionField v) g ≤ 1`.

**Step 1 — Unfold order.**
By definition (`Scheme.RationalMap.order`):
  `order Z g = WithZero.log (Ring.ordFrac (V.presheaf.stalk Z.point) g)`.
The stalk is a DVR via `Scheme.IsRegularInCodimensionOne.instIsDiscreteValuationRingStalk`.

**Step 2 — Log-order to ordFrac.**
`WithZero.log` is monotone and satisfies `WithZero.log 1 = 0`, so
  `0 ≤ WithZero.log x ↔ 1 ≤ x` in `WithZero (Multiplicative ℤ)`.
Hence `0 ≤ order Z g` gives `1 ≤ Ring.ordFrac (V.presheaf.stalk Z.point) g`.

**Step 3 — Connect ordFrac to the adic valuation via Mathlib.**
`Ring.ordFrac_eq_inverse_comp_valuation` (Mathlib `Mathlib.RingTheory.OrderOfVanishing.Noetherian`)
states:
  `Ring.ordFrac R = MonoidWithZero.inverse.comp
    (HeightOneSpectrum.valuation K (IsDiscreteValuationRing.maximalIdeal R)).toMonoidWithZeroHom`
Apply with `R := V.presheaf.stalk Z.point` (a DVR), `K := V.functionField`.
The fraction-ring witness `IsFractionRing (V.presheaf.stalk Z.point) V.functionField` is
available from `[IsIntegral V]` (`AlgebraicGeometry.stalkFractionRing`).

**Step 4 — Match the DVR maximal ideal to `v`.**
The stalk `V.presheaf.stalk Z.point` is the localization of `Γ(V, ⊤)` at
`(isAffineOpen_top V).primeIdealOf ⟨Z.point, trivial⟩` via
`IsAffineOpen.isLocalization_stalk`. The maximal ideal of this localization (= the
unique maximal of `IsLocalization.AtPrime`) corresponds to `v.asIdeal` (given by `hZv`).
So `IsDiscreteValuationRing.maximalIdeal (V.presheaf.stalk Z.point)` and `v` define the
same valuation on `V.functionField` up to the localization algebra iso.

**Step 5 — ordFrac ≥ 1 gives valuation ≤ 1.**
Since `ordFrac = MonoidWithZero.inverse ∘ valuation` and `MonoidWithZero.inverse` is
the reciprocal in `WithZero (Multiplicative ℤ)`, `ordFrac g ≥ 1` iff `valuation g ≤ 1`. -/
private lemma chart_valuation_le_one_of_order_nonneg
    [IsDedekindDomain Γ(V, ⊤)] [IsFractionRing Γ(V, ⊤) V.functionField]
    (hdim : Order.krullDim (α := V) ≤ 1) (g : V.functionField)
    (Z : V.PrimeDivisor) (v : IsDedekindDomain.HeightOneSpectrum Γ(V, ⊤))
    (hZv : v.asIdeal = ((isAffineOpen_top V).primeIdealOf ⟨Z.point, trivial⟩).asIdeal)
    (hZ : 0 ≤ Scheme.RationalMap.order Z g) :
    (IsDedekindDomain.HeightOneSpectrum.valuation V.functionField v) g ≤ 1 := by
  classical
  have hV : IsAffineOpen (⊤ : V.Opens) := isAffineOpen_top V
  set S := V.presheaf.stalk Z.point with hS
  -- The stalk at the codimension-one point `Z.point` is a discrete valuation ring.
  haveI hdvr : IsDiscreteValuationRing S := Scheme.IsRegularInCodimensionOne.out Z
  -- Localization data: the stalk `S` is the localization of `A = Γ(V, ⊤)` at the
  -- height-one prime corresponding to `Z` (which is `v.asIdeal` by `hZv`).
  set x : (⊤ : V.Opens) := ⟨Z.point, trivial⟩ with hx
  letI instAlg : Algebra Γ(V, ⊤) S := TopCat.Presheaf.algebra_section_stalk V.presheaf x
  haveI hloc : IsLocalization.AtPrime S (hV.primeIdealOf x).asIdeal :=
    hV.isLocalization_stalk x
  haveI hST : IsScalarTower Γ(V, ⊤) S V.functionField := functionField_isScalarTower V ⊤ x
  by_cases hg : g = 0
  · subst hg; simp
  -- **Step A.** From `0 ≤ ord_Z g = log (ordFrac S g)` and `g ≠ 0`, get `1 ≤ ordFrac S g`.
  have hord_ne : Ring.ordFrac S g ≠ 0 := by
    intro h0; exact hg (MonoidWithZeroHom.map_eq_zero_iff.mp h0)
  have hlog : (0 : ℤ) ≤ WithZero.log (Ring.ordFrac S g) := hZ
  have hge : (1 : WithZero (Multiplicative ℤ)) ≤ Ring.ordFrac S g :=
    (WithZero.log_le_log one_ne_zero hord_ne).mp (by rw [WithZero.log_one]; exact hlog)
  -- **Step B.** Rewrite `ordFrac = inverse ∘ valuation` to get `valuation_S g ≤ 1`.
  have hvalS : (IsDiscreteValuationRing.maximalIdeal S).valuation V.functionField g ≤ 1 := by
    rw [Ring.ordFrac_eq_valuation_inv] at hge
    simpa using inv_le_one_of_one_le₀ hge
  -- **Step C.** A DVR-valuation `≤ 1` element of `K` lifts to the stalk `S`.
  obtain ⟨s, hs⟩ := IsDiscreteValuationRing.exists_lift_of_le_one hvalS
  -- **Step D.** Write `s = a / d` in the localization (`d ∉ v.asIdeal`) and bound the
  -- `v`-adic valuation of `g = algebraMap S K s`.
  obtain ⟨⟨a, d⟩, hmk⟩ := IsLocalization.mk'_surjective (hV.primeIdealOf x).asIdeal.primeCompl s
  -- `mk'_spec`: `s * algebraMap A S d = algebraMap A S a`.
  have hspec : s * algebraMap Γ(V, ⊤) S (d : Γ(V, ⊤)) = algebraMap Γ(V, ⊤) S a := by
    rw [← hmk]; exact IsLocalization.mk'_spec S a d
  -- Push to `K`: `g * algebraMap A K d = algebraMap A K a`.
  have hgK : g * algebraMap Γ(V, ⊤) V.functionField (d : Γ(V, ⊤))
      = algebraMap Γ(V, ⊤) V.functionField a := by
    have := congrArg (algebraMap S V.functionField) hspec
    rw [map_mul, hs, ← IsScalarTower.algebraMap_apply Γ(V, ⊤) S V.functionField (d : Γ(V, ⊤)),
      ← IsScalarTower.algebraMap_apply Γ(V, ⊤) S V.functionField a] at this
    exact this
  -- `d ∉ v.asIdeal`, so `intValuation v d = 1`.
  have hd_mem : (d : Γ(V, ⊤)) ∈ v.asIdeal.primeCompl := by
    change (d : Γ(V, ⊤)) ∉ v.asIdeal
    rw [hZv]; exact d.2
  have hvd : v.intValuation (d : Γ(V, ⊤)) = 1 :=
    (IsDedekindDomain.HeightOneSpectrum.intValuation_eq_one_iff_mem_primeCompl v (d : Γ(V, ⊤))).mpr
      hd_mem
  -- Apply `v.valuation` to `hgK` and simplify.
  have := congrArg (IsDedekindDomain.HeightOneSpectrum.valuation V.functionField v) hgK
  rw [map_mul, IsDedekindDomain.HeightOneSpectrum.valuation_of_algebraMap,
    IsDedekindDomain.HeightOneSpectrum.valuation_of_algebraMap, hvd, mul_one] at this
  rw [this]
  exact IsDedekindDomain.HeightOneSpectrum.intValuation_le_one v a

/- Planner strategy (`thm:chart_mem_range_of_forall_order_nonneg`):

**Goal**: `g ∈ (algebraMap Γ(V, ⊤) V.functionField).range` — algebraic Hartogs: a
rational function that is regular (order ≥ 0) at every prime divisor is a global section.

**Step 1 — Dedekind + fraction-field setup.**
```lean
  haveI hDed : IsDedekindDomain Γ(V, ⊤) := chart_isDedekindDomain hdim
  haveI hFR  : IsFractionRing Γ(V, ⊤) V.functionField :=
    functionField_isFractionRing_of_isAffineOpen V ⊤ (isAffineOpen_top V)
```
Both witnesses are needed to invoke the Mathlib Hartogs lemma in Step 2.

**Step 2 — Apply Mathlib's algebraic Hartogs.**
`IsDedekindDomain.HeightOneSpectrum.mem_integers_of_valuation_le_one`
(`Mathlib.RingTheory.DedekindDomain.AdicValuation`) has type:
  `(x : K) → (∀ v : HeightOneSpectrum R, (valuation K v) x ≤ 1) → x ∈ (algebraMap R K).range`
Apply it with `R := Γ(V, ⊤)`, `K := V.functionField`, `x := g`.
This reduces the goal to: `∀ v : HeightOneSpectrum Γ(V, ⊤), (valuation V.functionField v) g ≤ 1`.

**Step 3 — Per height-one-prime: find matching prime divisor and apply Decl 2.**
For each `v : HeightOneSpectrum Γ(V, ⊤)`:
- Obtain the corresponding point `p := hV.fromSpec ⟨v.asIdeal, inferInstance⟩ : V`
  where `hV := isAffineOpen_top V` (mirrors `chart_isIntegrallyClosed` above at line 204).
- Check `Order.coheight p = 1` via the same height–coheight bridge used in
  `chart_isIntegrallyClosed` (lines 213–232), using `v.asIdeal.primeHeight = 1`
  (`IsDedekindDomain.HeightOneSpectrum.isPrime_asIdeal` + dimension bound `hdim`).
- Construct `Z : V.PrimeDivisor := ⟨p, hco⟩`.
- Apply `chart_valuation_le_one_of_order_nonneg hdim g Z v hZv (h Z)` where
  `hZv` follows from `hV.fromSpec_primeIdealOf` (mirrors line 965 of WeilDivisor.lean).

The PrimeDivisor ↔ HeightOneSpectrum bijection + per-point localization data
mirrors `finite_order_support_affine` (WeilDivisor.lean L892–968). -/
theorem chart_mem_range_of_forall_order_nonneg
    (hdim : Order.krullDim (α := V) ≤ 1)
    (g : V.functionField)
    (h : ∀ Z : V.PrimeDivisor, 0 ≤ Scheme.RationalMap.order Z g) :
    g ∈ (algebraMap Γ(V, ⊤) V.functionField).range := by
  classical
  have hV : IsAffineOpen (⊤ : V.Opens) := isAffineOpen_top V
  haveI hDed : IsDedekindDomain Γ(V, ⊤) := chart_isDedekindDomain hdim
  haveI hFR : IsFractionRing Γ(V, ⊤) V.functionField :=
    functionField_isFractionRing_of_isAffineOpen V ⊤ hV
  -- Algebraic Hartogs: it suffices to bound the `v`-adic valuation by `1` at every
  -- height-one prime `v` of the Dedekind chart `Γ(V, ⊤)`.
  apply IsDedekindDomain.HeightOneSpectrum.mem_integers_of_valuation_le_one V.functionField g
  intro v
  -- The point of `V` corresponding to the height-one prime `v`.
  haveI hvp : v.asIdeal.IsPrime := v.isPrime
  let P : PrimeSpectrum Γ(V, ⊤) := ⟨v.asIdeal, hvp⟩
  set y : V := hV.fromSpec P with hy
  have hymem : hV.fromSpec P ∈ (⊤ : V.Opens) := trivial
  letI instAlg : Algebra Γ(V, ⊤) (V.presheaf.stalk y) :=
    TopCat.Presheaf.algebra_section_stalk V.presheaf ⟨y, hymem⟩
  haveI hloc : IsLocalization.AtPrime (V.presheaf.stalk y) P.asIdeal :=
    hV.isLocalization_stalk' P hymem
  -- `v.asIdeal` has height one: `≤ 1` from the dimension bound, `≠ 0` from `v.ne_bot`.
  have hheight1 : P.asIdeal.primeHeight = 1 := by
    have hle : P.asIdeal.primeHeight ≤ 1 := by
      have := le_trans (Ideal.primeHeight_le_ringKrullDim (I := P.asIdeal))
        (ringKrullDim_globalSections_le_one hdim)
      exact_mod_cast this
    have hne0 : P.asIdeal.primeHeight ≠ 0 := by
      intro h0
      have hmem := Ideal.primeHeight_eq_zero_iff.mp h0
      exact v.ne_bot (le_antisymm (hmem.2 ⟨Ideal.isPrime_bot, bot_le⟩ bot_le) bot_le)
    rcases eq_or_lt_of_le hle with h' | h'
    · exact h'
    · exact absurd (by simpa [ENat.lt_one_iff_eq_zero] using h') hne0
  -- Hence the point has coheight one and is a prime divisor.
  have hco : Order.coheight y = 1 := by
    have e1 : ringKrullDim (V.presheaf.stalk y) = (Order.coheight y : WithBot ℕ∞) :=
      Scheme.ringKrullDim_stalk_eq_coheight V y
    have e2 : ringKrullDim (V.presheaf.stalk y) = (P.asIdeal.height : WithBot ℕ∞) :=
      IsLocalization.AtPrime.ringKrullDim_eq_height P.asIdeal (V.presheaf.stalk y)
    rw [e1, Ideal.height_eq_primeHeight, hheight1] at e2
    exact_mod_cast e2
  let Z : Scheme.PrimeDivisor V := ⟨y, hco⟩
  -- The prime corresponding to `Z.point` is `v.asIdeal` again (round-trip of the
  -- `fromSpec`/`primeIdealOf` bijection on the affine chart).
  have hround : hV.primeIdealOf ⟨hV.fromSpec P, hymem⟩ = P := by
    apply hV.fromSpec.isOpenEmbedding.injective
    rw [hV.fromSpec_primeIdealOf]
  have hZv : v.asIdeal = (hV.primeIdealOf ⟨Z.point, trivial⟩).asIdeal := by
    change v.asIdeal = (hV.primeIdealOf ⟨y, trivial⟩).asIdeal
    rw [hy, hround]
  exact chart_valuation_le_one_of_order_nonneg hdim g Z v hZv (h Z)

end CurveChartDedekind

end AlgebraicGeometry
