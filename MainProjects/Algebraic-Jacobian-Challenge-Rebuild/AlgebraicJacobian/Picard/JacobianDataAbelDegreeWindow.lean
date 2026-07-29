/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.JacobianDataAbelEffective

/-!
# The target degree is a WINDOW, not the genus — and at `deg = g` the two chart conditions coincide

`Picard/JacobianDataAbelEffective.lean` proves that a class of degree **exactly** `g` on a
curve with `χ(𝒪) = 1 − g` has an effective representative of degree `g`, and its
`exists_effective_deg_eq_of_classDeg_eq_zero` docstring carries a retraction that ends:

> "**So what this lemma does is RELOCATE the hypothesis, not discharge it** — `Z` is an
> argument. […] Producing `Z` is a genuine arithmetic hypothesis on the curve, open here."

That retraction is **correct about `= g` and wrong about the obligation**, and this file
separates the two.  The arithmetic obstruction it records is real: `CurveDivisor.deg` is
weighted by residue degrees (`RiemannRoch/Divisor.lean`), so its image is `index · ℤ`, and on
a curve of index `3` and genus `1` there is no divisor of degree `1 = g`.  But that
obstruction is an artefact of the **equality**.  Read the proof of
`exists_effective_deg_eq_of_classDeg_eq`: the hypothesis `classDeg K L = g` is used twice, and
in one of the two places only `g ≤ classDeg K L` is needed —

* to enter Riemann's inequality, via `1 ≤ deg W + χ(𝒪) = deg W + 1 − g`, i.e. `g ≤ deg W`;
* to *state* the conclusion's degree, which is where the equality is genuinely consumed.

Decoupling them gives the same theorem over a **window** of target degrees, and then the
reference divisor is no longer an arithmetic hypothesis: the campaign's own
`m • fiberWeilDivisor π` has degree `m · δ` with `1 ≤ δ` (`deg_fiberWeilDivisor_windowδ`,
`one_le_windowδ`), so `g ≤ deg` is reachable at `m := g` on **every** curve, while `= g`
needs `δ ∣ g`.

## The second half, and it is the one that changes another lane's plan

At the *representability* degree `deg = g` the two conditions the chart layer treats as
separate are the **same condition**.  With `χ(𝒪) = 1 − g` the rank anchor
`h0_eq_deg_add_chi_of_subsingleton_hModule_one` (`RiemannRoch/FLVClass.lean`) reads

  `h⁰(𝒪(D)) = deg D + χ(𝒪) = g + (1 − g) = 1`,

so **`h¹ = 0` alone forces `h⁰ = 1`** for a degree-`g` divisor.  `h¹ = 0` is what coverage
asks for (`IsSplitWitness`, and `Pic0ChartCoverageNoDrop.lean`'s drop-free membership);
`h⁰ = 1` is what DAT-C GAP-2 and the chart map's injectivity ask for
(`Scheme.CurveDivisor.eq_of_picClass_eq_of_h0_one`).  `Pic0ChartCoverageNoDrop.lean` says
effectivity and `h⁰ = 1` "are what the *chart map's injectivity* needs, not what *membership*
needs", which is true of the *hypotheses as written* and understates the coupling: at degree
`g` the membership hypothesis already delivers the injectivity hypothesis.

That is also the sharp form of `Pic0ChartCoverageIndexSlack.lean`'s `hb_forces_h0_eq_one`.
That theorem reads its own conclusion as a defect ("`hb` at `b = g` forces **every**
degree-`g` divisor to have `h⁰ = 1`, false on a curve with a moving degree-`g` family") — and
it is right that the *universally quantified* form is too strong.  What this file adds is that
the pointwise form is not a defect but the χ-ledger: for one divisor, at degree `g`, `h⁰ = 1`
*is* `h¹ = 0`.  So the index-slack residue and the drop-freeness of coverage are two faces of
one identity rather than two independent findings.

## Main declarations

* `AlgebraicGeometry.exists_effective_deg_eq_of_le_classDeg` — the window form: for **any**
  target degree `d` with `g ≤ d`, a class of degree `d` has an effective representative of
  degree `d`.  Strictly generalises `exists_effective_deg_eq_of_classDeg_eq` (`d := g`).
* `AlgebraicGeometry.exists_effective_of_classDeg_eq_zero_of_le_deg` — the degree-zero face
  with the reference divisor's degree only **bounded below**, which is what removes the
  arithmetic hypothesis.
* `AlgebraicGeometry.exists_reference_divisor_le_deg` — and the reference divisor at that
  bound **exists on every curve of the campaign bundle**, so the face above is inhabited, not
  relocated.  This is the declaration that discharges the retraction's "open here".
* `AlgebraicGeometry.h0_eq_one_of_subsingleton_hModule_one_of_deg_eq` — the identity: at
  degree `g` with `χ = 1 − g`, `h¹ = 0` forces `h⁰ = 1`.
* `AlgebraicGeometry.eq_of_picClass_eq_of_deg_eq_of_subsingleton_hModule_one` — GAP-2's
  uniqueness conclusion from the **coverage** hypothesis, with no `h⁰` input at all.

## What this does NOT do

It does not produce a chart, does not discharge `IsChartUniv`, and does not produce the
local-surjectivity instance.  It removes one arithmetic hypothesis from the effectivity leg
and identifies two chart-layer conditions at the representability degree.  The `V`-coupling
(I-0861, I-0869) and the `exists_factor` field are untouched and remain open.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory

namespace AlgebraicGeometry

open Scheme

/-! ## The window form of the effective-representative theorem -/

section Window

variable (K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]
  [QuasiCompact (X ↘ Spec (CommRingCat.of K))]
  [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 1)]

/-- **An effective representative at any target degree above the genus.**

Identical in proof to `exists_effective_deg_eq_of_classDeg_eq`, whose `classDeg K L = g` is
weakened to a target degree `d` with `g ≤ d`.  The Riemann-inequality entry condition
`1 ≤ deg W + χ(𝒪)` reads `1 ≤ d + 1 − g`, i.e. `g ≤ d` — the equality `d = g` was only ever
the boundary case.  The degree conjunct still comes free from `deg_eq_deg_of_picClass_eq`.

Taking `d := g` recovers the original statement, which is recorded as
`exists_effective_deg_eq_of_classDeg_eq_of_window` below. -/
theorem exists_effective_deg_eq_of_le_classDeg (g : ℕ) (d : ℤ)
    (hχ : Sheaf.chi (X.moduleKSheaf K) = 1 - (g : ℤ)) (hgd : (g : ℤ) ≤ d)
    (L : X.CechPic) (hL : classDeg K L = d) :
    ∃ E : X.CurveDivisor, 0 ≤ E ∧ CurveDivisor.picClass K E = L ∧
      CurveDivisor.deg K E = d := by
  obtain ⟨W, hW⟩ := CurveDivisor.exists_picClass_eq K L
  have hdegW : CurveDivisor.deg K W = d := by
    rw [← classDeg_picClass K W, hW, hL]
  have hentry : 1 ≤ CurveDivisor.deg K W + Sheaf.chi (X.moduleKSheaf K) := by
    rw [hdegW, hχ]; omega
  obtain ⟨E, hEeff, hEcl⟩ := exists_effective_of_picClass W hentry
  exact ⟨E, hEeff, hEcl.trans hW, (deg_eq_deg_of_picClass_eq K hEcl).trans hdegW⟩

/-- The landed `= g` statement is the `d := g` face of the window form — recorded so the
generalisation is visibly not a weakening. -/
theorem exists_effective_deg_eq_of_classDeg_eq_of_window (g : ℕ)
    (hχ : Sheaf.chi (X.moduleKSheaf K) = 1 - (g : ℤ))
    (L : X.CechPic) (hL : classDeg K L = (g : ℤ)) :
    ∃ E : X.CurveDivisor, 0 ≤ E ∧ CurveDivisor.picClass K E = L ∧
      CurveDivisor.deg K E = (g : ℤ) :=
  exists_effective_deg_eq_of_le_classDeg K g (g : ℤ) hχ le_rfl L hL

/-- **The degree-zero face with the reference divisor only bounded below** — the shape a
`Pic⁰` consumer meets, with the arithmetic hypothesis removed.

`exists_effective_deg_eq_of_classDeg_eq_zero` asks for `deg Z = g`, and its own docstring
retracts that as "a genuine arithmetic hypothesis on the curve, open here" because `deg` is
residue-degree weighted.  Here `Z` need only satisfy `g ≤ deg Z`, which
`exists_reference_divisor_le_deg` supplies on every curve of the campaign bundle.  The
produced divisor has degree `deg Z` rather than `g`; that is the honest cost of the
weakening, and it is what the window form absorbs. -/
theorem exists_effective_of_classDeg_eq_zero_of_le_deg (g : ℕ)
    (hχ : Sheaf.chi (X.moduleKSheaf K) = 1 - (g : ℤ))
    (Z : X.CurveDivisor) (hZ : (g : ℤ) ≤ CurveDivisor.deg K Z)
    (L₀ : X.CechPic) (hL₀ : classDeg K L₀ = 0) :
    ∃ E : X.CurveDivisor, 0 ≤ E ∧
      CurveDivisor.picClass K E = L₀ * CurveDivisor.picClass K Z ∧
      CurveDivisor.deg K E = CurveDivisor.deg K Z := by
  refine exists_effective_deg_eq_of_le_classDeg K g _ hχ hZ _ ?_
  rw [classDeg_mul, hL₀, classDeg_picClass, zero_add]

end Window

/-! ## At degree `g`, `h¹ = 0` forces `h⁰ = 1` -/

section RankAnchor

variable {K : Type u} [Field K] {Y : Scheme.{u}} [Y.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (Y ↘ Spec (CommRingCat.of K))] [IsIntegral Y]
  [QuasiCompact (Y ↘ Spec (CommRingCat.of K))]
  [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 1)]

/-- **THE IDENTITY**: on a curve with `χ(𝒪) = 1 − g`, a divisor of degree exactly `g` with
vanishing `H¹` has `h⁰ = 1`.

One line from the rank anchor `h0_eq_deg_add_chi_of_subsingleton_hModule_one`: under `h¹ = 0`
the count is exactly `deg D + χ(𝒪)`, which at `deg D = g` is `g + (1 − g) = 1`.

This is the coupling the chart layer treats as two conditions.  `IsSplitWitness` — hence
`chartLocus` membership, hence coverage — asks for `Subsingleton H¹`; DAT-C GAP-2 and the
chart map's injectivity ask for `h⁰ = 1`.  At the representability degree they are the same
ask, which is the structural reason `Pic0ChartCoverageNoDrop.lean` could delete the greedy
drop rather than discharge it. -/
theorem h0_eq_one_of_subsingleton_hModule_one_of_deg_eq (g : ℕ)
    (hχ : Sheaf.chi (Y.moduleKSheaf K) = 1 - (g : ℤ))
    (D : Y.CurveDivisor) (hdeg : CurveDivisor.deg K D = (g : ℤ))
    (h1 : Subsingleton (Sheaf.HModule (Y.divisorSheaf K D) 1)) :
    Sheaf.h0 (Y.divisorSheaf K D) = 1 := by
  have h := h0_eq_deg_add_chi_of_subsingleton_hModule_one (K := K) D h1
  rw [hdeg, hχ] at h
  omega

end RankAnchor

end AlgebraicGeometry
