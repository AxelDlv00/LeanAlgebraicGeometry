/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Ledger.FiberVanishing
import AlgebraicJacobian.RiemannRoch.Ledger.DegreeVanishing

/-!
# The conditional layer discharged: bounded vanishing, Riemann–Roch and generation from `π`

`Ledger/DegreeVanishing.lean` proves the cluster-P statements — bounded `H¹` vanishing on a
degree half-space, exact Riemann–Roch above the bound, the exact section drop, and global
generation at every closed point — each **conditional on one base vanishing**
`Subsingleton H¹(𝒪(D₀))` at one divisor `D₀`.  Its own docstring records that AJC witnessed that
antecedent at no proper curve: the only producer of `Subsingleton H¹(𝒪_X)` in the project carries
`[IsAffine X]`, which a proper curve never satisfies.

This file removes that gap.  `Ledger/FiberVanishing.lean` supplies a base vanishing on a genuine
curve bundle — at `D₀ = n₀ • F` for the fiber divisor `F` of a finite dominant `π : Y ⟶ ℙ¹` — and
composing the two makes every statement above depend only on `(Y, π)`, with no vanishing
hypothesis at all.

## The composition, and why the bound is uniform in `D`

`subsingleton_hModule_divisorSheaf_one_of_isFinite_toP1` gives, for the *fixed* divisor `0`, an
`n₀` with `Subsingleton H¹(𝒪(n • F))` for all `n ≥ n₀`.  Instantiating at `n = n₀` fixes **one**
divisor `D₀ = n₀ • F` depending only on `(Y, π)`.  Feeding that `D₀` to
`DegreeVanishing.exists_bound_subsingleton_hModule_one` yields a threshold

`b = deg (n₀ • F) + 1 − χ(𝒪_Y)`

past which `H¹(𝒪(D)) = 0` for **every** `D`.  The quantifier order is the whole point: `n₀` is
chosen once, before `D` is seen, so `b` does not depend on `D`.  This is why the tower bound of
`FiberVanishing` (per-`D`) upgrades to a degree bound (uniform in `D`) — the degree slack is
carried by the linear-equivalence translate manufactured inside
`DegreeVanishing.exists_le_subsingleton_of_deg_ge`, not by growing the twist.

## WHAT IS STILL OPEN — the three statements, kept apart

1. **Single-field bounded vanishing: CLOSED here**, for a curve bundle admitting a finite
   dominant map to `ℙ¹`, given the two `Module.Finite` binders on `H⁰`/`H¹` of `𝒪_Y`.
2. **Extension-uniformity: OPEN, and untouched.**  Every constant below — `n₀`, `b`, `deg`,
   `χ(𝒪_Y)` — lives over the single field `K`.  A bound serving `C_κ` for every finite `κ/K`
   simultaneously does not follow: `n₀` is produced by `Classical.choose` on a Noetherian
   stabilization that is re-run from scratch at each base field, and the AJCR analogue
   (`RiemannRoch/WindowFieldTransport.lean`) is explicit that per-field ledger constants do not
   transport — it moves vanishing *facts* one field at a time instead.  Nothing in AJC or AJCR
   closes this.
3. **Global generation: CLOSED here too, but by an independent route.**
   `generated_unconditional_of_isFinite_toP1` below is not a corollary of (1): it comes from the
   dévissage slice in `DegreeVanishing`, whose evaluation map *is* the quotient map, and the
   vanishing enters only to make that quotient surjective on `H⁰`.  Neither statement implies the
   other without the exactness input.

## Main declarations

* `AlgebraicGeometry.exists_bound_subsingleton_hModule_one_of_isFinite_toP1` — the uniform
  degree threshold, no vanishing hypothesis.
* `AlgebraicGeometry.exists_bound_h0_eq_of_isFinite_toP1` — exact Riemann–Roch
  `h⁰(𝒪(D)) = χ(𝒪_Y) + deg D` above a threshold.
* `AlgebraicGeometry.exists_bound_section_drop_of_isFinite_toP1` — the exact section drop.
* `AlgebraicGeometry.exists_bound_generated_of_isFinite_toP1` — global generation at every
  closed point above a threshold.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace

namespace AlgebraicGeometry

open Scheme

section Unconditional

variable {K : Type u} [Field K] {Y : Scheme.{u}} [IsIntegral Y]
  [Y.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (Y ↘ Spec (CommRingCat.of K))]
  [LocallyOfFiniteType (Y ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (Y ↘ Spec (CommRingCat.of K))]
  [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 0)]

/-- **A base vanishing at a divisor depending only on `(Y, π)`.**  The fibrewise large-twist
vanishing at `D = 0`, read at its own threshold: there is an `n₀`, chosen before any divisor is
considered, with `H¹(𝒪(n₀ • F)) = 0`.  This is the single fact that discharges the conditional
layer of `Ledger/DegreeVanishing.lean`. -/
theorem exists_base_subsingleton_of_isFinite_toP1
    (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)) :
    ∃ D₀ : Y.CurveDivisor, Subsingleton (Sheaf.HModule (Y.divisorSheaf K D₀) 1) := by
  obtain ⟨n₀, hn₀⟩ :=
    subsingleton_hModule_divisorSheaf_one_of_isFinite_toP1 π hπ (0 : Y.CurveDivisor)
  refine ⟨n₀ • fiberWeilDivisor π, ?_⟩
  have h := hn₀ n₀ le_rfl
  rwa [zero_add] at h

/-- **Bounded `H¹` vanishing, no vanishing hypothesis** (cluster-P item 1, unconditional form):
for a curve bundle carrying a finite dominant `π : Y ⟶ ℙ¹`, there is a degree threshold `b`
depending only on `(Y, π)` past which `H¹(𝒪(D))` vanishes for **every** Weil divisor `D`.

Read the module docstring on scope before consuming this: the threshold is over the single field
`K` and says nothing about uniformity across field extensions. -/
theorem exists_bound_subsingleton_hModule_one_of_isFinite_toP1
    (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)) :
    ∃ b : ℤ, ∀ D : Y.CurveDivisor, b ≤ CurveDivisor.deg K D →
      Subsingleton (Sheaf.HModule (Y.divisorSheaf K D) 1) := by
  haveI : Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 1) :=
    moduleFinite_hModule_one_of_isFinite_toP1 π hπ
  obtain ⟨D₀, hD₀⟩ := exists_base_subsingleton_of_isFinite_toP1 π hπ
  exact exists_bound_subsingleton_hModule_one K hD₀

/-- **Exact Riemann–Roch above a threshold, no vanishing hypothesis** (cluster-P item 2):
`h⁰(𝒪(D)) = χ(𝒪_Y) + deg D` for every `D` of large enough degree. -/
theorem exists_bound_h0_eq_of_isFinite_toP1
    (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)) :
    ∃ b : ℤ, ∀ D : Y.CurveDivisor, b ≤ CurveDivisor.deg K D →
      (Sheaf.h0 (Y.divisorSheaf K D) : ℤ) =
        Sheaf.chi (Y.moduleKSheaf K) + CurveDivisor.deg K D := by
  haveI : Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 1) :=
    moduleFinite_hModule_one_of_isFinite_toP1 π hπ
  obtain ⟨D₀, hD₀⟩ := exists_base_subsingleton_of_isFinite_toP1 π hπ
  exact exists_bound_h0_eq K hD₀

/-- **The exact section drop above a threshold, no vanishing hypothesis** (cluster-P item 2,
point form): past the threshold every closed point contributes its full residue degree to `h⁰`,
`h⁰(𝒪(D)) = h⁰(𝒪(D − x)) + [κ(x) : K]`.  The hypothesis is on `deg (D − x)`, so the peel applies
at both ends. -/
theorem exists_bound_section_drop_of_isFinite_toP1
    (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)) :
    ∃ b : ℤ, ∀ {x : Y} (hx : x ≠ genericPoint Y) (D : Y.CurveDivisor),
      b ≤ CurveDivisor.deg K (D - CurveDivisor.single hx 1) →
      (Sheaf.h0 (Y.divisorSheaf K D) : ℤ) =
        Sheaf.h0 (Y.divisorSheaf K (D - CurveDivisor.single hx 1)) + Y.residueDeg K x := by
  haveI : Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 1) :=
    moduleFinite_hModule_one_of_isFinite_toP1 π hπ
  obtain ⟨D₀, hD₀⟩ := exists_base_subsingleton_of_isFinite_toP1 π hπ
  refine ⟨CurveDivisor.deg K D₀ + 1 - Sheaf.chi (Y.moduleKSheaf K), fun hx D hD => ?_⟩
  exact h0_eq_h0_sub_point_add_residueDeg_of_deg_ge K hD₀ hx D hD

/-- **Global generation above a threshold, no vanishing hypothesis** (cluster-P item 3): past the
threshold the dévissage evaluation map at every closed point is surjective on `H⁰` — the sections
of `𝒪(D)` fill the fibre at `x`.

Not a corollary of the vanishing statements above: this comes from the dévissage slice, whose
quotient map *is* the evaluation, and the vanishing enters only to make that quotient surjective
on `H⁰` (see `Ledger/DegreeVanishing.lean` item 3, and the scope note in this file's module
docstring). -/
theorem exists_bound_generated_of_isFinite_toP1
    (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)) :
    ∃ b : ℤ, ∀ {x : Y} (hx : x ≠ genericPoint Y) (D : Y.CurveDivisor),
      b ≤ CurveDivisor.deg K (D - CurveDivisor.single hx 1) →
      Function.Surjective (Sheaf.HModule.map (devissageSES K hx D).g 0) := by
  haveI : Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 1) :=
    moduleFinite_hModule_one_of_isFinite_toP1 π hπ
  obtain ⟨D₀, hD₀⟩ := exists_base_subsingleton_of_isFinite_toP1 π hπ
  refine ⟨CurveDivisor.deg K D₀ + 1 - Sheaf.chi (Y.moduleKSheaf K), fun hx D hD => ?_⟩
  exact surjective_eval_of_deg_ge K hD₀ hx D hD

end Unconditional

end AlgebraicGeometry
