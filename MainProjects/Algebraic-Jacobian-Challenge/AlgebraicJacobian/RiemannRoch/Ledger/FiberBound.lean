/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Ledger.FiberVanishing
import AlgebraicJacobian.RiemannRoch.Ledger.DegreeVanishing
import AlgebraicJacobian.RiemannRoch.Ledger.MapToP1
import AlgebraicJacobian.RiemannRoch.Ledger.GenusBridge

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
2. **Extension-uniformity: OPEN, and untouched *by this file*.**  Every constant below — `n₀`,
   `b`, `deg`, `χ(𝒪_Y)` — lives over the single field `K`.

   **Current status elsewhere, since this paragraph has been the project's index for the gap:**
   `Ledger/ExtensionUniformity.lean` split it and `Ledger/GenusFieldInvariance.lean` closed one
   of the two halves — `genus C_κ = genus C` is a theorem for every field extension, sorry-free.
   What remains open is the *base-divisor* half only: one degree bound `d` with a vanishing
   divisor of degree `≤ d` over every `κ`.  So the sentence "nothing in AJC or AJCR closes this"
   was true when written and is now half wrong; the residue is one named input, not two.  The
   `Classical.choose`/`Nat.find` observation below still describes that surviving half correctly
   (AJCR's `RiemannRoch/WindowFieldTransport.lean` moves vanishing *facts* one field at a time
   because the constant does not move).
3. **Global generation: CLOSED here too, but by an independent route.**
   `exists_bound_generated_of_isFinite_toP1` below is not a corollary of (1): it comes from the
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

/-! ## At AJC's own curve: no `π`, no vanishing, no finiteness hypothesis

The section above still asks the caller for a finite dominant `π` and for
`Module.Finite K (H⁰ 𝒪_Y)`.  On the challenge curve both are **theorems of this project**:
`Ledger/MapToP1.exists_isFinite_isDominant_toP1` constructs the `π` by spreading out a
transcendental rational function, and `Ledger/ChiCurve.lean` discharges both cohomology
finiteness binders.  So on `C` the statements below carry the three curve hypotheses and nothing
else — this is where the layer stops being conditional on anything a caller must supply.

The `letI : C.left.Over _ := .ofHom C.hom` in each statement is the standard `ChiCurve` idiom: it
makes the ambient structure morphism `C.left ↘ Spec k` *definitionally* `C.hom`, so the smoothness
and quasi-compactness binders transfer by `inferInstanceAs` rather than being assumed again. -/

section Curve

variable {k : Type u} [Field k]

/-- **Bounded `H¹` vanishing on the challenge curve** (★): on a smooth proper geometrically
irreducible curve `C/k` there is a degree threshold past which `H¹(𝒪(D)) = 0` for **every** Weil
divisor `D`.  Three curve binders, nothing else: the `π`, the dominance, and both cohomology
finiteness instances are all *synthesised*.

Contrast `Ledger/DegreeVanishing.lean`, whose statements of the same shape carry a base-vanishing
hypothesis that AJC could witness at no proper curve.  This is that gap closed.

Scope unchanged and worth repeating: the threshold is over the single field `k`. See the module
docstring, item 2 — extension-uniformity does not follow. -/
theorem exists_bound_subsingleton_hModule_one_curve (C : Over (Spec (CommRingCat.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
    ∃ b : ℤ, ∀ D : C.left.CurveDivisor, b ≤ CurveDivisor.deg k D →
      Subsingleton (Sheaf.HModule (C.left.divisorSheaf k D) 1) := by
  letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
  haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
  haveI : QuasiCompact (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (QuasiCompact C.hom)
  haveI : LocallyOfFiniteType (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (LocallyOfFiniteType C.hom)
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0) :=
    moduleFinite_hModule_zero C
  obtain ⟨π, hfin, hdom, hcomp⟩ := exists_isFinite_isDominant_toP1 (k := k) (C := C)
  haveI := hfin
  haveI := hdom
  exact exists_bound_subsingleton_hModule_one_of_isFinite_toP1 π hcomp

/-- **Exact Riemann–Roch on the challenge curve** (★★): `h⁰(𝒪(D)) = 1 − genus C + deg D` for
every divisor of large enough degree, on three curve binders.

The equality is the `χ`-ledger's `χ(𝒪(D)) = 1 − genus C + deg D`
(`Ledger/GenusBridge.chi_divisorSheaf_genus`) with `h¹` known to vanish, so `χ = h⁰`. -/
theorem exists_bound_h0_eq_genus_curve (C : Over (Spec (CommRingCat.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
    ∃ b : ℤ, ∀ D : C.left.CurveDivisor, b ≤ CurveDivisor.deg k D →
      (Sheaf.h0 (C.left.divisorSheaf k D) : ℤ) = 1 - genus C + CurveDivisor.deg k D := by
  letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
  haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
  obtain ⟨b, hb⟩ := exists_bound_subsingleton_hModule_one_curve C
  refine ⟨b, fun D hD => ?_⟩
  haveI := hb D hD
  have hchi : Sheaf.chi (C.left.divisorSheaf k D) = 1 - genus C + CurveDivisor.deg k D :=
    chi_divisorSheaf_genus C D
  have h1 : Sheaf.h1 (C.left.divisorSheaf k D) = 0 := Sheaf.h1_eq_zero (hb D hD)
  rw [Sheaf.chi, h1] at hchi
  omega

end Curve

/-! ## Extension-uniformity: exactly which half is free, and which is open

The scope note (item 2) says extension-uniformity does not follow.  That is worth making precise
rather than leaving as a disclaimer, because the two halves of it have very different costs, and
conflating them is how the gap gets mis-priced.

**The free half — PER-FIELD vanishing over every extension.**  All three binders of
`exists_bound_subsingleton_hModule_one_curve` are stable under base change along a field
extension `κ/k`: properness and smoothness of relative dimension one by their mathlib
`IsStableUnderBaseChange` instances, and `GeometricallyIrreducible` likewise (checked: mathlib
provides that instance directly).  So the theorem re-fires at `C_κ` for **every** `κ`, and one
gets a threshold `b κ` for each — with no new mathematics whatsoever.
`baseChange_binders_stable` below records the stability, which is the whole of the free half.

**SUPERSEDED — read `Ledger/ExtensionUniformity.lean` instead.**  The sentence above is wrong in
a way worth stating rather than quietly editing: class stability is *not* the whole of the free
half, because a class being stable under base change says nothing until some **object** is
exhibited carrying the base-changed instances in the spelling the consuming theorem elaborates
against.  `baseChange_binders_stable` never mentions `C_κ`, so it does not witness the re-firing
it is claimed to record.  `ExtensionUniformity.vanishing_baseChangeField` and
`riemannRoch_baseChangeField` are the actual free half, stated at `Scheme.baseChangeField C κ`;
what was needed was one missing named instance (`GeometricallyIrreducible` on that carrier),
after which the theorems above apply verbatim.

The open-half paragraph that follows is also **mis-priced**, in the same file's own terms: the
threshold is existential and monotone in `b`, so `n₀(κ)` never has to transport.  See
`ExtensionUniformity.lean`, which decomposes `b κ` into a genus scalar plus a base-divisor
degree and retracts the `2g − 1` shortcut (Serre duality, which this workspace does not have).

**The open half — a threshold chosen BEFORE `κ`.**  Uniformity asks for a single `b` with
`∀ κ, ∀ D on C_κ, b ≤ deg_κ D → H¹ = 0`.  What blocks it is not the binders but that the `b κ`
above are produced independently: `b κ = deg_κ (n₀(κ) • F_κ) + 1 − χ(𝒪_{C_κ})`, where `n₀(κ)`
comes from a `Classical.choose` on the Noetherian stabilization of the fiber ladder over `κ`, and
that stabilization is re-run from scratch at each base field.  Nothing relates `n₀(κ)` to `n₀(k)`.
This is the same obstruction AJCR names on its own carrier: its `windowM_choice` is a `Nat.find`
per field (`RiemannRoch/WindowLedger.lean:186`), which is why
`RiemannRoch/WindowFieldTransport.lean` transports vanishing *facts* one field at a time instead
of transporting the constant.

So the honest statement of the residue is **not** "vanishing over extensions is unavailable" — it
is "the constant does not transport".  The two named inputs that would fix it are unchanged: flat
base change for the section spaces (`Γ(C_κ, 𝒪(D_κ)) ≃ Γ(C, 𝒪(D)) ⊗_k κ`, so the `κ`-dimensions
are comparable to the `k`-dimensions) and a `WeilDivisor` pullback along `C_κ ⟶ C` (hard: closed
points split).  With those, `b k` itself would serve as the uniform bound; without them, no
amount of re-firing the theorem produces one. -/

section ExtensionUniformity

/-- **The curve binders are stable under field base change.**

Kept as a true statement about morphism classes, but **do not read it as the free half of
extension-uniformity** — that is what its previous docstring claimed and it does not follow.
Nothing here mentions the base-changed curve, so nothing here witnesses the vanishing theorem
re-firing anywhere.  For the free half proper, stated at `Scheme.baseChangeField C κ`, use
`Ledger/ExtensionUniformity.vanishing_baseChangeField`. -/
theorem baseChange_binders_stable :
    MorphismProperty.IsStableUnderBaseChange @IsProper ∧
      MorphismProperty.IsStableUnderBaseChange (@SmoothOfRelativeDimension 1) ∧
        MorphismProperty.IsStableUnderBaseChange @GeometricallyIrreducible :=
  ⟨inferInstance, smoothOfRelativeDimension_isStableUnderBaseChange 1, inferInstance⟩

end ExtensionUniformity

end AlgebraicGeometry
