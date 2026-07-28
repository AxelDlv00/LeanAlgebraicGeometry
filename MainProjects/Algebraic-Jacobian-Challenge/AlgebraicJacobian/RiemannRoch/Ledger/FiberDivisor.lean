/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Ledger.FiberChart
import AlgebraicJacobian.RiemannRoch.Ledger.MulEquiv
import AlgebraicJacobian.RiemannRoch.Ledger.ResidueDegree

/-!
# The fiber Weil divisor `F` of a dominant map to the projective line

For a curve bundle `Y` over `K` with a dominant `π : Y ⟶ ℙ¹`, the pulled-back chart-0
coordinate `t₀` has a germ at the generic point which is a **unit** `u ∈ K(Y)ˣ` (its
overlap-inverse is the chart-1 coordinate `t₁`).  Its principal divisor `div u` is nonnegative on
`V₀`, nonpositive on `V₁`, and at least `1` at every point of `V₀ ∖ V₁` — the fiber of `π` over
`[1 : 0]`.  The **fiber Weil divisor** is its positive part

`F = (div u)⁺ = Finsupp.mapRange (max · 0) (div u)`,

an effective divisor supported on that fiber.  `F` is the direction in which the twist
`D + n·F` grows in the fibrewise large-twist vanishing (`Ledger/FiberVanishing.lean`): the order
table below is exactly what makes the section lattice over `V₀` grow with `n` while the one over
`V₁` stays fixed.

## The `coeffAt` calculus

The first section ports the small transport calculus for the coefficient function
`AlgebraicGeometry.coeffAt` of `Ledger/Devissage.lean` — values on `0`, `+`, `-`, `-·-`,
one-point divisors, and principal divisors.  AJC had `coeffAt` but none of these lemmas: in AJCR
they live in `Picard/PresentationDivisor.lean`, whose *other* half is the meromorphic-presentation
bridge and whose import edge is what pulls the `Picard.*` cone into the FLV closure.  The calculus
half is pure `Finsupp` bookkeeping with no Picard content, so it is ported here instead of taking
that edge.  Bodies are AJCR's unchanged.

## Provenance

Everything after the calculus section is AJCR `RiemannRoch/FLVFiberToolkit.lean`, bodies
unchanged, with the chart-1 coordinate and the overlap identity from its `section Cover` and the
order table and `fiberWeilDivisor` from its `section Main`.  The only omissions are AJCR's
`fiberWeilDivisor_deg_nonneg`-adjacent class statements that mention `picClass`; the degree
statements kept here (`fiberWeilDivisor_deg_nonneg`,
`fiberWeilDivisor_deg_pos_of_notMem_chart₁`) are stated with `CurveDivisor.deg` and are
Picard-free.

## Main declarations

* `AlgebraicGeometry.fiberCoord₁` — the pulled-back chart-1 coordinate `t₁`.
* `AlgebraicGeometry.fiberCoord_mul_fiberCoord₁_res` — `t₀ · t₁ = 1` on the overlap.
* `AlgebraicGeometry.fiberCoordUnit` — the fiber unit `u = germ_η t₀ ∈ K(Y)ˣ`.
* the order table: `fiberCoordUnit_coeffAt_divOf_nonneg_of_mem_chart₀`,
  `fiberCoordUnit_coeffAt_divOf_nonpos_of_mem_chart₁`,
  `one_le_fiberCoordUnit_coeffAt_divOf_of_notMem_chart₁`.
* `AlgebraicGeometry.fiberWeilDivisor` — the effective fiber divisor `F`, with
  `fiberWeilDivisor_nonneg`, its vanishing on `V₁`, its agreement with `div u` on `V₀`, and
  positivity of its degree given a fiber witness.
-/

set_option autoImplicit false
/- Scheme-theoretic unification (mixing `P1 K` with `Proj 𝒜`, `Γ(Y, U)` with functor
applications) needs defeq checks through semireducible definitions, as in mathlib's own
algebraic-geometry files. -/
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory MvPolynomial HomogeneousLocalization TopologicalSpace Opposite

namespace AlgebraicGeometry

open Scheme

/-! ## The `coeffAt` calculus for Weil divisors

`CurveDivisor` is a sealed `Finsupp`; these lemmas keep raw `Finsupp` projections out of
downstream proofs.  Ported from AJCR `Picard/PresentationDivisor.lean` (its calculus half only —
see the module docstring). -/

namespace Scheme.CurveDivisor

variable {X : Scheme.{u}} [IsIntegral X]

/-- Two Weil divisors with the same coefficient at every closed point are equal. -/
lemma ext_coeffAt {D D' : X.CurveDivisor}
    (h : ∀ (x : X) (hx : x ≠ genericPoint X), coeffAt hx D = coeffAt hx D') : D = D' :=
  Finsupp.ext fun p => h p.1 p.2

variable {x : X} (hx : x ≠ genericPoint X)

@[simp]
lemma coeffAt_zero : coeffAt hx (0 : X.CurveDivisor) = 0 :=
  rfl

@[simp]
lemma coeffAt_add (D D' : X.CurveDivisor) :
    coeffAt hx (D + D') = coeffAt hx D + coeffAt hx D' :=
  Finsupp.add_apply _ _ _

@[simp]
lemma coeffAt_neg (D : X.CurveDivisor) : coeffAt hx (-D) = -coeffAt hx D :=
  Finsupp.neg_apply _ _

@[simp]
lemma coeffAt_sub (D D' : X.CurveDivisor) :
    coeffAt hx (D - D') = coeffAt hx D - coeffAt hx D' :=
  Finsupp.sub_apply _ _ _

/-- The coefficient of the one-point divisor `n · x` at `x` is `n`. -/
@[simp]
lemma coeffAt_single_self (n : ℤ) : coeffAt hx (CurveDivisor.single hx n) = n :=
  Finsupp.single_eq_same

/-- The coefficient of the one-point divisor `n · x` at a closed point `z ≠ x` is `0`. -/
lemma coeffAt_single_of_ne {z : X} (hz : z ≠ genericPoint X) (hzx : z ≠ x) (n : ℤ) :
    coeffAt hz (CurveDivisor.single hx n) = 0 :=
  Finsupp.single_eq_of_ne fun h => hzx (Subtype.mk_eq_mk.mp h)

/-- One-point divisors negate their multiplicities. -/
lemma single_neg (n : ℤ) :
    CurveDivisor.single hx (-n) = -CurveDivisor.single hx n :=
  Finsupp.single_neg _ _

/-- The coefficient of a principal divisor at a closed point is the order of vanishing
there. -/
lemma coeffAt_divOf {K : Type u} [Field K] {X : Scheme.{u}}
    (f : X ⟶ Spec (CommRingCat.of K)) [SmoothOfRelativeDimension 1 f] [IsIntegral X]
    [LocallyOfFiniteType f] [QuasiCompact f] (g : X.functionFieldˣ) {x : X}
    (hx : x ≠ genericPoint X) :
    coeffAt hx (Scheme.divOf f g) = Multiplicative.toAdd (Scheme.ordZ f hx g) :=
  rfl

end Scheme.CurveDivisor

/-! ## The chart-1 coordinate and the overlap identity -/

section Cover

variable {K : Type u} [Field K] {Y : Scheme.{u}} (π : Y ⟶ P1 K)

/-- The standard grading of `K[X₀, X₁]`, the graded ring underlying `P1 K`. -/
local notation "𝒜" => homogeneousSubmodule (Fin 2) K

/-- The two-cover overlap `V₀ ⊓ V₁`, abbreviated for the order table. -/
local notation "ov" => fiberChart₀ π ⊓ fiberChart₁ π

/-- **The pulled-back chart-1 coordinate** `t₁ = π* (X₀/X₁) ∈ Γ(Y, V₁)`: the image under `π`'s
section map of the chart-1 coordinate of `ℙ¹`. Regular on all of `V₁ = π⁻¹ D₊(X₁)`, and the
overlap-inverse of the chart-0 coordinate `fiberCoord π = t₀`
(`fiberCoord_mul_fiberCoord₁_res`). -/
noncomputable def fiberCoord₁ : Γ(Y, fiberChart₁ π) :=
  (π.app (P1.chartOpen K 1)).hom ((Proj.awayToSection 𝒜 (X 1)).hom (P1.chartCoord K 1 0))

/-- `V₀ ⊓ V₁ = π⁻¹ D₊(X₀X₁)`: the overlap is the preimage of the `ℙ¹`-chart overlap. -/
private lemma preimage_overlap_eq :
    ov = π ⁻¹ᵁ Proj.basicOpen 𝒜 (X 0 * X 1) := by
  rw [← Scheme.Hom.preimage_inf, P1.chartOpen_inf K]

private lemma preimage_overlap_le : ov ≤ π ⁻¹ᵁ Proj.basicOpen 𝒜 (X 0 * X 1) :=
  (preimage_overlap_eq π).le

/-- **The two coordinates multiply to `1` on the overlap.** The restrictions of `t₀` and of `t₁`
to `V₀ ⊓ V₁` are inverse sections: the `ℙ¹`-side identity `awayToOverlap_mul_eq_one` pulled back
along `π`'s section map on the chart overlap. -/
theorem fiberCoord_mul_fiberCoord₁_res :
    (Y.presheaf.map (homOfLE (inf_le_left : ov ≤ fiberChart₀ π)).op).hom (fiberCoord π)
        * (Y.presheaf.map (homOfLE (inf_le_right : ov ≤ fiberChart₁ π)).op).hom (fiberCoord₁ π)
      = 1 := by
  set ρ := (π.appLE (Proj.basicOpen 𝒜 (X 0 * X 1)) ov (preimage_overlap_le π)).hom with hρ
  have hleft : (Y.presheaf.map (homOfLE (inf_le_left : ov ≤ fiberChart₀ π)).op).hom (fiberCoord π)
      = ρ ((Proj.awayToSection 𝒜 (X 0 * X 1)).hom
          (P1.awayToOverlapLeft K (P1.chartCoord K 0 1))) := by
    rw [← P1.res_awayToSection_left K]
    symm
    calc ρ (((P1 K).presheaf.map (homOfLE (P1.overlap_le_left K)).op).hom
            ((Proj.awayToSection 𝒜 (X 0)).hom (P1.chartCoord K 0 1)))
        = ((P1 K).presheaf.map (homOfLE (P1.overlap_le_left K)).op ≫
            π.appLE (Proj.basicOpen 𝒜 (X 0 * X 1)) ov (preimage_overlap_le π)).hom
            ((Proj.awayToSection 𝒜 (X 0)).hom (P1.chartCoord K 0 1)) := rfl
      _ = (π.appLE (P1.chartOpen K 0) ov ((preimage_overlap_le π).trans
            ((Opens.map π.base).map (homOfLE (P1.overlap_le_left K))).le)).hom
            ((Proj.awayToSection 𝒜 (X 0)).hom (P1.chartCoord K 0 1)) := by
          rw [Scheme.Hom.map_appLE]
      _ = (π.app (P1.chartOpen K 0) ≫
            Y.presheaf.map (homOfLE (inf_le_left : ov ≤ fiberChart₀ π)).op).hom
            ((Proj.awayToSection 𝒜 (X 0)).hom (P1.chartCoord K 0 1)) := by
          rw [Scheme.Hom.app_eq_appLE, Scheme.Hom.appLE_map]
      _ = _ := rfl
  have hright : (Y.presheaf.map (homOfLE (inf_le_right : ov ≤ fiberChart₁ π)).op).hom
        (fiberCoord₁ π)
      = ρ ((Proj.awayToSection 𝒜 (X 0 * X 1)).hom
          (P1.awayToOverlapRight K (P1.chartCoord K 1 0))) := by
    rw [← P1.res_awayToSection_right K]
    symm
    calc ρ (((P1 K).presheaf.map (homOfLE (P1.overlap_le_right K)).op).hom
            ((Proj.awayToSection 𝒜 (X 1)).hom (P1.chartCoord K 1 0)))
        = ((P1 K).presheaf.map (homOfLE (P1.overlap_le_right K)).op ≫
            π.appLE (Proj.basicOpen 𝒜 (X 0 * X 1)) ov (preimage_overlap_le π)).hom
            ((Proj.awayToSection 𝒜 (X 1)).hom (P1.chartCoord K 1 0)) := rfl
      _ = (π.appLE (P1.chartOpen K 1) ov ((preimage_overlap_le π).trans
            ((Opens.map π.base).map (homOfLE (P1.overlap_le_right K))).le)).hom
            ((Proj.awayToSection 𝒜 (X 1)).hom (P1.chartCoord K 1 0)) := by
          rw [Scheme.Hom.map_appLE]
      _ = (π.app (P1.chartOpen K 1) ≫
            Y.presheaf.map (homOfLE (inf_le_right : ov ≤ fiberChart₁ π)).op).hom
            ((Proj.awayToSection 𝒜 (X 1)).hom (P1.chartCoord K 1 0)) := by
          rw [Scheme.Hom.app_eq_appLE, Scheme.Hom.appLE_map]
      _ = _ := rfl
  have hP1 : (Proj.awayToSection 𝒜 (X 0 * X 1)).hom (P1.awayToOverlapLeft K (P1.chartCoord K 0 1))
        * (Proj.awayToSection 𝒜 (X 0 * X 1)).hom (P1.awayToOverlapRight K (P1.chartCoord K 1 0))
      = 1 := by
    rw [← map_mul, P1.awayToOverlap_mul_eq_one K, map_one]
  rw [hleft, hright, ← map_mul, hP1, map_one]

end Cover

-- PLACEHOLDER-ORDER-TABLE

end AlgebraicGeometry
