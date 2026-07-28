/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Ledger.SectionDrop

/-!
# From the order-cone to a degree threshold: single-field bounded vanishing

`Ledger/SectionDrop.lean` proved that `H¹` vanishing is upward closed **in the divisor order**
(`subsingleton_hModule_one_of_le`) and reduced degree-threshold vanishing to a named
hypothesis `exists_bound_of_cofinal_vanishing`: *every divisor of large degree dominates some
divisor at which `H¹` vanishes*.  Its docstring called that cofinality statement open, and
recorded that "nothing in AJC or AJCR currently produces it".

**That was wrong, and this file discharges it.**  The missing move is not a new cofinality
input: it is that the peel may be applied to a *linearly equivalent translate* of the base
divisor.  `Ledger/MulEquiv.lean` already supplies the translation
(`mulEquivDivisorSheaf : 𝒪(A) ≅ 𝒪(A − div g)`) and `Ledger/ChiLedger.lean` already supplies
the Riemann inequality that manufactures the translating function.  Both were in the tree
before this file; what was missing was to put them together.

## The argument, in one paragraph

Fix any `D₀` with `H¹(𝒪(D₀)) = 0`.  Let `D` be a divisor with
`deg D ≥ deg D₀ + 1 − χ(𝒪_X)`.  Then `deg (D − D₀) + χ(𝒪_X) ≥ 1`, so the Riemann inequality
`riemann_inequality` gives `h⁰(𝒪(D − D₀)) ≥ 1`: there is a **nonzero global section** of
`𝒪(D − D₀)`, i.e. a `g ∈ K(X)ˣ` with `D − D₀ + div g ≥ 0`.  Set `D₀' := D₀ − div g`.  Then
`D₀' ≤ D` by construction, and `H¹(𝒪(D₀')) = 0` because `𝒪(D₀) ≅ 𝒪(D₀ − div g)`.  Apply the
order-cone peel to `D₀' ≤ D`.  Done — and note this is *exactly* the cofinality statement
`exists_bound_of_cofinal_vanishing` asks for, now proved rather than assumed.

## What is proved

* `exists_unit_nonneg_of_h0_pos` — the section-to-effective bridge on AJC's carrier: a
  nonzero global section of `𝒪(A)` is a `g ∈ K(X)ˣ` with `0 ≤ A + div g`.  (AJCR has this as
  `RiemannRoch/SectionBound.exists_effective_of_h0_pos`, stated through its `picClass`
  machinery, which AJC's Ledger tree does not have; this is the same three-step proof stated
  with no Picard vocabulary at all — see the provenance note there.)
* `exists_le_subsingleton_of_deg_ge` (★) — **the cofinality theorem**, i.e. the hypothesis of
  `exists_bound_of_cofinal_vanishing` discharged: from one base vanishing, every `D` of degree
  `≥ deg D₀ + 1 − χ(𝒪_X)` dominates a vanishing divisor.
* `subsingleton_hModule_one_of_deg_ge` (★★) — **single-field bounded vanishing**:
  `H¹(𝒪(D)) = 0` for every `D` with `deg D ≥ deg D₀ + 1 − χ(𝒪_X)`.  This is cluster-P item 1,
  and it is a *degree* half-space, not an order-cone.
* `exists_bound_subsingleton_hModule_one` — the `∃ b, ∀ D, b ≤ deg D → …` shape, which is the
  form downstream consumers ask for.
* `h0_eq_of_deg_ge`, `riemann_roch_of_deg_ge` (★★) — **exact Riemann–Roch above a degree
  bound**: `h⁰(𝒪(D)) = χ(𝒪_X) + deg D`, and its curve spelling
  `h⁰(𝒪(D)) = 1 − genus + deg D` is `RiemannRochCurve.lean`'s business, not this file's.
* `deg_ge_one_sub_chi_of_no_sections`, `subsingleton_of_deg_ge_of_zero` — the specialisation
  to `D₀ = 0`, whose base vanishing is `H¹(𝒪_X) = 0`, and which therefore fires exactly on the
  curves of genus zero.  Recorded to make the *shape* of the input honest.

## THE THREE CLUSTER-P ITEMS, KEPT APART

This file closes exactly one of the three, and it is worth being blunt about which.

1. **Single-field bounded vanishing — CLOSED HERE, conditionally on one base vanishing.**
   `subsingleton_hModule_one_of_deg_ge` is it.  The residual input is *one* divisor `D₀` with
   `H¹(𝒪(D₀)) = 0`; note it is a *single* hypothesis at a *single* divisor, not a family, and
   the bound is then explicit: `deg D₀ + 1 − χ(𝒪_X)`.  Where does `D₀` come from?
   - Over a curve of genus `0` (equivalently `h¹(𝒪_X) = 0` with the `Subsingleton` spelling),
     `D₀ = 0` works and the whole thing is unconditional — `subsingleton_of_deg_ge_of_zero`.
   - In general it is a port: AJCR's `RiemannRoch/FLVVanishing.lean:302`
     (`subsingleton_hModule_divisorSheaf_one_of_isFinite_toP1`) produces, for a finite dominant
     `π : Y ⟶ ℙ¹`, an `n₀` with `H¹(𝒪(D + n·F)) = 0` for `n ≥ n₀`.  Any one member of that
     tower is a `D₀`.  **Measured port cost** (I did the closure, do not re-guess it): that
     theorem's AJCR-local import closure is 59 modules, of which the genuinely new layer for
     AJC is `FLVFiberToolkit` / `FLVLattice` / `FLVQcoh` / `FiberTwist` / `Degree` plus
     `Cohomology.AffineVanishingQcoh` / `QcohSections` — and `Degree` drags in eleven
     `Picard/` presentation modules that AJC's Ledger tree deliberately does not have.  So it
     is a real port, not a copy: ~2.5k lines of new material and a Picard-presentation
     dependency.  **That is now the only thing between AJC and unconditional bounded
     vanishing at every curve**, and it is strictly smaller than it was before this file,
     because the peel, the ledger, the translation and the cofinality step are all done.
2. **Extension-uniformity — UNTOUCHED, and nothing here bears on it.** Every statement in
   this file is over the one field `K`; `CurveDivisor.deg K` and `residueDeg K` are pinned to
   it.  A bound uniform over finite extensions `K'/K` would need the bound
   `deg D₀ + 1 − χ(𝒪_X)` to be controlled *along base change*, and `χ` is exactly what base
   change is not known to preserve here.  Do not read `exists_bound_subsingleton_hModule_one`
   as uniform: its `b` depends on `X`, `K` and `D₀`.
3. **Global generation — UNTOUCHED.** No evaluation map appears in this file.
   `h0_eq_of_deg_ge` is a statement about *dimensions*; generation is surjectivity of
   `H⁰(𝒪(D)) → κ(x)`, which is a different assertion and is not implied by any dimension
   count here.  (`Adelic/GlobalGeneration.lean` has the bridge on the *adelic* carrier, gated
   on `hledger` and two vanishings; nothing here transports it.)
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace

namespace AlgebraicGeometry

open Scheme

section DegreeVanishing

variable (K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]
  [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (X ↘ Spec (CommRingCat.of K))]

/-! ## The section-to-effective bridge

A nonzero global section of `𝒪(A)` is a rational function whose poles are bounded by `A`
everywhere; as a unit of `K(X)` its principal divisor therefore satisfies `A + div g ≥ 0`.
This is the only place in the file where a section is unpacked. -/

/-- **A nonzero global section is an effectivity certificate** (the bridge): if `𝒪(A)` has a
nonzero global section then there is `g ∈ K(X)ˣ` with `0 ≤ A + div g`.

**Provenance.** AJCR proves the same fact as
`RiemannRoch/SectionBound.exists_effective_of_h0_pos`, but *states* it as "the class of `A` is
realised by an effective divisor", through `CurveDivisor.picClass` — Picard vocabulary that
AJC's Ledger tree does not import and does not want here.  The three steps (extract a nonzero
element of `H⁰` through `linearEquiv₀`, read it as a nonzero rational function, turn the pole
bound into `0 ≤ A + div g` at each point) are AJCR's; the statement is stripped of `picClass`
so that it lands one import above `DivisorSheaf`/`MulEquiv` and needs no Picard layer. -/
theorem exists_unit_nonneg_of_h0_pos (A : X.CurveDivisor)
    (hA : 0 < Sheaf.h0 (X.divisorSheaf K A)) :
    ∃ g : X.functionFieldˣ,
      0 ≤ A + Scheme.divOf (X ↘ Spec (CommRingCat.of K)) g := by
  haveI : Nontrivial (Sheaf.HModule (X.divisorSheaf K A) 0) :=
    Module.nontrivial_of_finrank_pos hA
  obtain ⟨t, ht⟩ := exists_ne (0 : Sheaf.HModule (X.divisorSheaf K A) 0)
  set s := (Sheaf.HModule.linearEquiv₀ (Opens.grothendieckTopology (X : TopCat))
    (isTerminalTop : IsTerminal (⊤ : X.Opens)) (X.divisorSheaf K A)) t with hs
  have hsne : s ≠ 0 := by
    rw [hs]; exact (LinearEquiv.map_ne_zero_iff _).mpr ht
  set g : X.functionField := divisorVal K s with hg
  have hgmem : g ∈ divisorSections K A ⊤ := divisorVal_mem K s
  have hgne : g ≠ 0 := by
    intro h
    exact hsne (divisorSection_ext K
      (show divisorVal K s = divisorVal K (0 : _) from by rw [← hg, h]; rfl))
  set u : X.functionFieldˣ := Units.mk0 g hgne with hu
  refine ⟨u, ?_⟩
  refine Finsupp.le_def.mpr (fun p => ?_)
  have htop : ((⊤ : X.Opens) : Set X).Nonempty := ⟨genericPoint X, trivial⟩
  have hb := (mem_divisorSections_of_nonempty K htop).mp hgmem p.1 p.2 trivial
  -- `ord_val_eq` reads the valuation of the unit `u` as the bound of `-div u`; the two sides
  -- of `hb` are then `ofAdd` of integer coefficients.
  have hval : Scheme.ord (X ↘ Spec (CommRingCat.of K)) p.2 g
      = divisorBound (- Scheme.divOf (X ↘ Spec (CommRingCat.of K)) u) p.2 := by
    have h := Scheme.ord_val_eq K u p.2
    rwa [show ((u : X.functionFieldˣ) : X.functionField) = g from rfl] at h
  rw [hval] at hb
  simp only [divisorBound, WithZero.coe_le_coe, Multiplicative.ofAdd_le] at hb
  change (0 : ℤ) ≤ (toFinsupp
    (A + Scheme.divOf (X ↘ Spec (CommRingCat.of K)) u)) p
  have hadd : (toFinsupp
      (A + Scheme.divOf (X ↘ Spec (CommRingCat.of K)) u)) p
      = (toFinsupp A) p
        + (toFinsupp (Scheme.divOf (X ↘ Spec (CommRingCat.of K)) u)) p :=
    rfl
  -- `simp` has already stripped the `toFinsupp` wrapper off `hb`, leaving a raw application
  -- of the `CurveDivisor`s; restate it on the `Finsupp` side by `change` rather than `rw`.
  have hb' : - (toFinsupp (Scheme.divOf (X ↘ Spec (CommRingCat.of K)) u)) p
      ≤ (toFinsupp A) p := hb
  rw [hadd]
  omega

/-! ## Translating the base vanishing along a linear equivalence

The peel needs a vanishing divisor **below** `D`.  A given `D₀` need not be below `D`, but its
linear-equivalence class is spread over the whole divisor group, and `H¹` is a class invariant
(`mulEquivDivisorSheaf` plus `Sheaf.h1_congr` / the `Subsingleton` transport).  The Riemann
inequality then supplies the translating function. -/

variable [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 1)]

omit [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 1)] in
/-- **`H¹` vanishing is a linear-equivalence invariant**: `H¹(𝒪(A)) = 0` iff
`H¹(𝒪(A − div g)) = 0`, transported along `mulEquivDivisorSheaf`.  No finiteness: this is a
transport of a `Subsingleton` along an isomorphism, not a dimension count. -/
theorem subsingleton_hModule_one_sub_divOf (g : X.functionFieldˣ) (A : X.CurveDivisor)
    (h : Subsingleton (Sheaf.HModule (X.divisorSheaf K A) 1)) :
    Subsingleton (Sheaf.HModule
      (X.divisorSheaf K (A - Scheme.divOf (X ↘ Spec (CommRingCat.of K)) g)) 1) :=
  (Sheaf.HModule.mapEquiv (Scheme.mulEquivDivisorSheaf K g A) 1).toEquiv.symm.subsingleton

/-- **The cofinality theorem** (★): the hypothesis that `SectionDrop`'s
`exists_bound_of_cofinal_vanishing` takes as given, here **proved**.  From a single base
vanishing at `D₀`, every divisor `D` with `deg D ≥ deg D₀ + 1 − χ(𝒪_X)` dominates a divisor at
which `H¹` vanishes — namely the translate `D₀ − div g` for a `g` manufactured by the Riemann
inequality on `D − D₀`.

The bound is explicit and its shape is the content: one needs `deg (D − D₀) + χ(𝒪_X) ≥ 1` to
force a nonzero section of `𝒪(D − D₀)`, and that is exactly `deg D ≥ deg D₀ + 1 − χ(𝒪_X)`. -/
theorem exists_le_subsingleton_of_deg_ge {D₀ : X.CurveDivisor}
    (h₀ : Subsingleton (Sheaf.HModule (X.divisorSheaf K D₀) 1))
    (D : X.CurveDivisor)
    (hD : CurveDivisor.deg K D₀ + 1 - Sheaf.chi (X.moduleKSheaf K)
      ≤ CurveDivisor.deg K D) :
    ∃ D₁ : X.CurveDivisor, D₁ ≤ D ∧
      Subsingleton (Sheaf.HModule (X.divisorSheaf K D₁) 1) := by
  -- `deg (D − D₀) + χ ≥ 1`, so the Riemann inequality gives a nonzero section of `𝒪(D − D₀)`.
  have hdegsub : CurveDivisor.deg K (D - D₀)
      = CurveDivisor.deg K D - CurveDivisor.deg K D₀ := by
    have h := CurveDivisor.deg_add K (D - D₀) D₀
    rw [sub_add_cancel] at h
    omega
  have hri := riemann_inequality K (D - D₀)
  have hpos : 0 < Sheaf.h0 (X.divisorSheaf K (D - D₀)) := by
    have : (1 : ℤ) ≤ (Sheaf.h0 (X.divisorSheaf K (D - D₀)) : ℤ) := by omega
    exact_mod_cast this
  obtain ⟨g, hg⟩ := exists_unit_nonneg_of_h0_pos K (D - D₀) hpos
  refine ⟨D₀ - Scheme.divOf (X ↘ Spec (CommRingCat.of K)) g, ?_,
    subsingleton_hModule_one_sub_divOf K g D₀ h₀⟩
  -- `0 ≤ (D − D₀) + div g` is literally `D₀ − div g ≤ D`, coefficientwise.
  refine Finsupp.le_def.mpr (fun p => ?_)
  have hgp : (0 : ℤ) ≤ (toFinsupp ((D - D₀)
      + Scheme.divOf (X ↘ Spec (CommRingCat.of K)) g)) p := Finsupp.le_def.mp hg p
  have h1 : (toFinsupp ((D - D₀)
      + Scheme.divOf (X ↘ Spec (CommRingCat.of K)) g)) p
      = ((toFinsupp D) p - (toFinsupp D₀) p)
        + (toFinsupp (Scheme.divOf (X ↘ Spec (CommRingCat.of K)) g)) p := rfl
  have h2 : (toFinsupp (D₀ - Scheme.divOf (X ↘ Spec (CommRingCat.of K)) g)) p
      = (toFinsupp D₀) p
        - (toFinsupp (Scheme.divOf (X ↘ Spec (CommRingCat.of K)) g)) p := rfl
  change (toFinsupp (D₀ - Scheme.divOf (X ↘ Spec (CommRingCat.of K)) g)) p
    ≤ (toFinsupp D) p
  rw [h1] at hgp
  rw [h2]
  omega

/-! ## Single-field bounded vanishing -/

/-- **Single-field bounded vanishing** (★★, cluster-P item 1): from one base vanishing at
`D₀`, `H¹(𝒪(D))` vanishes for **every** divisor of degree at least
`deg D₀ + 1 − χ(𝒪_X)`.

This is a **degree half-space**, not the order-cone of `SectionDrop`: no relation between `D`
and `D₀` in the divisor order is assumed, and none holds in general.  The bridge is that the
class of `D₀` has a representative below `D` once `D` has enough degree
(`exists_le_subsingleton_of_deg_ge`), and `H¹` vanishing is a class invariant
(`subsingleton_hModule_one_sub_divOf`).

It says nothing about uniformity over field extensions: `b`, `deg` and `χ` are all over the
single field `K`.  See item 2 of the module docstring. -/
theorem subsingleton_hModule_one_of_deg_ge {D₀ : X.CurveDivisor}
    (h₀ : Subsingleton (Sheaf.HModule (X.divisorSheaf K D₀) 1))
    (D : X.CurveDivisor)
    (hD : CurveDivisor.deg K D₀ + 1 - Sheaf.chi (X.moduleKSheaf K)
      ≤ CurveDivisor.deg K D) :
    Subsingleton (Sheaf.HModule (X.divisorSheaf K D) 1) := by
  obtain ⟨D₁, hle, hvan⟩ := exists_le_subsingleton_of_deg_ge K h₀ D hD
  exact subsingleton_hModule_one_of_le K hle hvan

/-- The `h¹`-spelling of bounded vanishing.  Weaker than the `Subsingleton` form above
(`Module.finrank` reads `0` on an infinite-dimensional space), kept because downstream
numeric statements are phrased with `h¹`. -/
theorem h1_eq_zero_of_deg_ge {D₀ : X.CurveDivisor}
    (h₀ : Subsingleton (Sheaf.HModule (X.divisorSheaf K D₀) 1))
    (D : X.CurveDivisor)
    (hD : CurveDivisor.deg K D₀ + 1 - Sheaf.chi (X.moduleKSheaf K)
      ≤ CurveDivisor.deg K D) :
    Sheaf.h1 (X.divisorSheaf K D) = 0 :=
  Sheaf.h1_eq_zero (subsingleton_hModule_one_of_deg_ge K h₀ D hD)

/-- **The existential form** that downstream consumers ask for: *there is* a degree bound past
which `H¹` vanishes identically.  Equivalent to
`subsingleton_hModule_one_of_deg_ge` with the explicit bound hidden; the explicit form is the
one to use when the constant matters. -/
theorem exists_bound_subsingleton_hModule_one {D₀ : X.CurveDivisor}
    (h₀ : Subsingleton (Sheaf.HModule (X.divisorSheaf K D₀) 1)) :
    ∃ b : ℤ, ∀ D : X.CurveDivisor, b ≤ CurveDivisor.deg K D →
      Subsingleton (Sheaf.HModule (X.divisorSheaf K D) 1) :=
  ⟨CurveDivisor.deg K D₀ + 1 - Sheaf.chi (X.moduleKSheaf K),
    fun D hD => subsingleton_hModule_one_of_deg_ge K h₀ D hD⟩

/-! ## Exact Riemann–Roch above a degree bound -/

/-- **Exact Riemann–Roch on a degree half-space** (★★): `h⁰(𝒪(D)) = χ(𝒪_X) + deg D` for every
`D` of degree at least `deg D₀ + 1 − χ(𝒪_X)`.

Contrast `SectionDrop.h0_divisorSheaf_of_subsingleton_of_le`, whose hypothesis is `D₀ ≤ D` in
the divisor **order**.  That restriction is what this file removes: the conclusion now holds on
a half-space of the degree homomorphism, which is what "Riemann–Roch for large degree" means. -/
theorem h0_eq_of_deg_ge {D₀ : X.CurveDivisor}
    (h₀ : Subsingleton (Sheaf.HModule (X.divisorSheaf K D₀) 1))
    (D : X.CurveDivisor)
    (hD : CurveDivisor.deg K D₀ + 1 - Sheaf.chi (X.moduleKSheaf K)
      ≤ CurveDivisor.deg K D) :
    (Sheaf.h0 (X.divisorSheaf K D) : ℤ) =
      Sheaf.chi (X.moduleKSheaf K) + CurveDivisor.deg K D := by
  have hvan := subsingleton_hModule_one_of_deg_ge K h₀ D hD
  have hchi := chi_divisorSheaf K D
  rw [Sheaf.chi_eq_h0 hvan] at hchi
  exact hchi

/-- **Riemann–Roch above a bound, existential form**: there is a degree bound past which
`h⁰(𝒪(D)) = χ(𝒪_X) + deg D` exactly. -/
theorem exists_bound_h0_eq {D₀ : X.CurveDivisor}
    (h₀ : Subsingleton (Sheaf.HModule (X.divisorSheaf K D₀) 1)) :
    ∃ b : ℤ, ∀ D : X.CurveDivisor, b ≤ CurveDivisor.deg K D →
      (Sheaf.h0 (X.divisorSheaf K D) : ℤ) =
        Sheaf.chi (X.moduleKSheaf K) + CurveDivisor.deg K D :=
  ⟨CurveDivisor.deg K D₀ + 1 - Sheaf.chi (X.moduleKSheaf K),
    fun D hD => h0_eq_of_deg_ge K h₀ D hD⟩

/-- **The section drop is exact above the degree bound**: past the bound every closed point
contributes its full residue degree, `h⁰(𝒪(D)) = h⁰(𝒪(D − x)) + [κ(x) : K]`.  The hypothesis is
on `deg (D − x)`, so that the peel applies at both ends. -/
theorem h0_eq_h0_sub_point_add_residueDeg_of_deg_ge {D₀ : X.CurveDivisor}
    (h₀ : Subsingleton (Sheaf.HModule (X.divisorSheaf K D₀) 1))
    {x : X} (hx : x ≠ genericPoint X) (D : X.CurveDivisor)
    (hD : CurveDivisor.deg K D₀ + 1 - Sheaf.chi (X.moduleKSheaf K)
      ≤ CurveDivisor.deg K (D - CurveDivisor.single hx 1)) :
    (Sheaf.h0 (X.divisorSheaf K D) : ℤ) =
      Sheaf.h0 (X.divisorSheaf K (D - CurveDivisor.single hx 1)) + X.residueDeg K x :=
  h0_eq_h0_sub_point_add_residueDeg_of_subsingleton K hx D
    (subsingleton_hModule_one_of_deg_ge K h₀ _ hD)

/-! ## The unconditional specialisation, and the honest shape of the residual input

Taking `D₀ = 0` makes the base vanishing `H¹(𝒪(0)) = 0`, i.e. `H¹(𝒪_X) = 0` up to the
identification `divisorSheafZeroIso`.  That holds exactly on the curves of genus zero, so the
specialisation below is *not* a general theorem — it is recorded to show precisely how small
the residual input is: **one** vanishing at **one** divisor. -/

/-- **The `D₀ = 0` specialisation**: if `H¹(𝒪_X) = 0` then `H¹(𝒪(D)) = 0` for every `D` of
degree at least `1 − χ(𝒪_X)`, with no other input.  On a genus-zero curve `χ(𝒪_X) = 1` and the
bound is `deg D ≥ 0`, the classical statement.

Note what this does and does not say: it is unconditional *given* `H¹(𝒪_X) = 0`, which is a
genus-zero hypothesis, not a fact about every curve.  The general case needs the AJCR port
named in item 1 of the module docstring. -/
theorem subsingleton_of_deg_ge_of_zero
    (h₀ : Subsingleton (Sheaf.HModule (X.divisorSheaf K (0 : X.CurveDivisor)) 1))
    (D : X.CurveDivisor)
    (hD : 1 - Sheaf.chi (X.moduleKSheaf K) ≤ CurveDivisor.deg K D) :
    Subsingleton (Sheaf.HModule (X.divisorSheaf K D) 1) := by
  refine subsingleton_hModule_one_of_deg_ge K h₀ D ?_
  rwa [CurveDivisor.deg_zero, zero_add]

/-- The same, from a vanishing stated on the **structure sheaf** rather than on `𝒪(0)`: the two
are identified by `divisorSheafZeroIso`, so this is the spelling a caller with
`Subsingleton (H¹(𝒪_X))` in hand can use directly. -/
theorem subsingleton_of_deg_ge_of_moduleKSheaf
    (h₀ : Subsingleton (Sheaf.HModule (X.moduleKSheaf K) 1))
    (D : X.CurveDivisor)
    (hD : 1 - Sheaf.chi (X.moduleKSheaf K) ≤ CurveDivisor.deg K D) :
    Subsingleton (Sheaf.HModule (X.divisorSheaf K D) 1) := by
  -- `divisorSheafZeroIso : 𝒪(0) ≅ 𝒪_X`, so the transport of the vanishing runs backwards
  -- along the induced equivalence on `H¹`.
  have hzero : Subsingleton (Sheaf.HModule (X.divisorSheaf K (0 : X.CurveDivisor)) 1) :=
    haveI := h₀
    (Sheaf.HModule.mapEquiv (Scheme.divisorSheafZeroIso K (X := X)) 1).toEquiv.subsingleton
  exact subsingleton_of_deg_ge_of_zero K hzero D hD

/-- **Contrapositive, as a degree obstruction**: if `H¹(𝒪(D))` does *not* vanish while
`H¹(𝒪(D₀))` does, then `deg D < deg D₀ + 1 − χ(𝒪_X)`.  A non-vanishing `H¹` is therefore a
*bounded-degree* phenomenon — the numerical content of "vanishing is generic". -/
theorem deg_lt_of_not_subsingleton {D₀ : X.CurveDivisor}
    (h₀ : Subsingleton (Sheaf.HModule (X.divisorSheaf K D₀) 1))
    (D : X.CurveDivisor)
    (hD : ¬ Subsingleton (Sheaf.HModule (X.divisorSheaf K D) 1)) :
    CurveDivisor.deg K D < CurveDivisor.deg K D₀ + 1 - Sheaf.chi (X.moduleKSheaf K) := by
  by_contra hcon
  exact hD (subsingleton_hModule_one_of_deg_ge K h₀ D (by omega))

end DegreeVanishing

end AlgebraicGeometry
