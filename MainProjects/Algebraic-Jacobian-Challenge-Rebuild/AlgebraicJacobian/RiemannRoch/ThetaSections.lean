/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Cohomology.TwistedSheaf
import AlgebraicJacobian.RiemannRoch.FLVFiberToolkit
import AlgebraicJacobian.RiemannRoch.SectionSpaces

/-!
# DD-4 (field level) — the twisted sheaf of `Θⁿ` is the divisor sheaf `𝒪(n·F)`

The W6-lite transport seam of the DAT-D campaign (`informal/dat-d-worksheet.md` §2.1,
§5 DD-4): the `H_A` spaces are *stated* on the divisor sheaf `𝒪(A·F)`
(`F = fiberWeilDivisor π`, the DD-F/P-fib vocabulary), while the relative engine works
on the two-chart twist cocycle `t₀ᴬ` (`RigidEngine4*`, `TwistedSheaf`). This file owns
the bridge, on the curve bundle `Y` over a field `K` with a dominant `π : Y ⟶ ℙ¹`:

* `AlgebraicGeometry.thetaUnit` — the transition unit `t₀|_{V₀ ⊓ V₁} ∈ Γ(Y, V₀ ⊓ V₁)ˣ`
  of the fiber twist, with inverse `t₁|_{V₀ ⊓ V₁}` (`fiberCoord_mul_fiberCoord₁_res`);
  its `n`-th power is the two-cover cocycle of `Θⁿ = fiberTwist π n`.
* `AlgebraicGeometry.thetaTwistSheaf π n := twistSheaf K V₀ V₁ (thetaUnit π ^ n)` —
  the engine-side spelling of `𝒪(Θⁿ)`.
* `AlgebraicGeometry.thetaTwistDivisorSheafIso` —
  **`thetaTwistSheaf π n ≅ Y.divisorSheaf K (n • fiberWeilDivisor π)`**: over a
  nonempty open a matching pair `(s₀, s₁)` corresponds to the rational function
  `u⁻ⁿ · germ_η s₀ = germ_η s₁` (`u = fiberCoordUnit π`), the mirror of
  `MeromorphicPresentation.gluedDivisorSheafIso` on the two-chart carrier.
* `AlgebraicGeometry.thetaTwistH0Equiv` — the `H⁰` reading:
  `H⁰(thetaTwistSheaf π n) ≃ₗ[K] divisorSections K (n • F) ⊤` — the `H_A` spaces in
  DD-F's `divisorSections` spelling.
* `AlgebraicGeometry.subsingleton_hModule_thetaTwistSheaf_one_iff` — the `H¹` vanishing
  transport that lets the DD-0 window ledger fire on the twist sheaf.

The pole-bound bookkeeping runs through the FLV fiber order table
(`fiberWeilDivisor_coeffAt_of_mem_chart₀/₁`) and `Scheme.ord_val_eq`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace

namespace AlgebraicGeometry

open Scheme

attribute [local instance] Scheme.functionFieldOverModule Scheme.overModule

/-- Germs at a point commute with `resHom`: the germ of a restricted section is the germ
of the section (the two-cover mirror of the `GluedDivisorSheaf` helper). -/
private lemma germ_resHom {Y : Scheme.{u}} {V W : Y.Opens} (h : W ≤ V) (x : Y) (hx : x ∈ W)
    (t : Γ(Y, V)) :
    (Y.presheaf.germ W x hx).hom (Y.resHom h t) =
      (Y.presheaf.germ V x (h hx)).hom t :=
  Y.presheaf.germ_res_apply (homOfLE h) x hx t

/-! ## The theta transition unit -/

section Unit

variable {K : Type u} [Field K] {Y : Scheme.{u}} (π : Y ⟶ P1 K)

/-- **The theta transition unit** `t₀|_{V₀ ⊓ V₁} ∈ Γ(Y, V₀ ⊓ V₁)ˣ`: the restriction of
the pulled-back chart-0 coordinate to the two-cover overlap, a unit with explicit
inverse the restricted chart-1 coordinate (`fiberCoord_mul_fiberCoord₁_res`). Its `n`-th
power is the transition cocycle of the fiber twist `Θⁿ` (`fiberDivisor`/`fiberCocycle`
normalization, `RiemannRoch/FiberTwist.lean`). -/
noncomputable def thetaUnit : Γ(Y, fiberChart₀ π ⊓ fiberChart₁ π)ˣ where
  val := (Y.presheaf.map (homOfLE
    (inf_le_left : fiberChart₀ π ⊓ fiberChart₁ π ≤ fiberChart₀ π)).op).hom (fiberCoord π)
  inv := (Y.presheaf.map (homOfLE
    (inf_le_right : fiberChart₀ π ⊓ fiberChart₁ π ≤ fiberChart₁ π)).op).hom (fiberCoord₁ π)
  val_inv := fiberCoord_mul_fiberCoord₁_res π
  inv_val := by rw [mul_comm]; exact fiberCoord_mul_fiberCoord₁_res π

lemma thetaUnit_val : (thetaUnit π : Γ(Y, fiberChart₀ π ⊓ fiberChart₁ π))
    = (Y.presheaf.map (homOfLE
        (inf_le_left : fiberChart₀ π ⊓ fiberChart₁ π ≤ fiberChart₀ π)).op).hom
        (fiberCoord π) := rfl

/-- **The engine-side spelling of `𝒪(Θⁿ)`**: the cocycle-glued twisted sheaf of the
`n`-th power of the theta transition unit on the pinned two-cover. -/
noncomputable def thetaTwistSheaf [Y.Over (Spec (CommRingCat.of K))] (n : ℕ) :
    Sheaf (Opens.grothendieckTopology (Y : TopCat)) (ModuleCat.{u} K) :=
  twistSheaf K (fiberChart₀ π) (fiberChart₁ π) (thetaUnit π ^ n)

end Unit

/-! ## The value of a twisted section -/

section Value

variable (K : Type u) [Field K] {Y : Scheme.{u}} [Y.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (Y ↘ Spec (CommRingCat.of K))] [IsIntegral Y]
  [LocallyOfFiniteType (Y ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (Y ↘ Spec (CommRingCat.of K))]
  (π : Y ⟶ P1 K) [IsDominant π] (n : ℕ)

omit [Y.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (Y ↘ Spec (CommRingCat.of K))]
  [LocallyOfFiniteType (Y ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (Y ↘ Spec (CommRingCat.of K))] in
/-- The germ at `η` of the theta unit is the fiber unit `u`. -/
lemma germ_thetaUnit_val :
    (Y.presheaf.germ (fiberChart₀ π ⊓ fiberChart₁ π) (genericPoint Y)
        (genericPoint_mem_preimage_inf π)).hom (thetaUnit π : Γ(Y, _)) =
      (fiberCoordUnit π : Y.functionField) := by
  rw [thetaUnit_val, Y.presheaf.germ_res_apply]
  rfl

omit [Y.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (Y ↘ Spec (CommRingCat.of K))]
  [LocallyOfFiniteType (Y ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (Y ↘ Spec (CommRingCat.of K))] in
/-- The germ at `η` of the `n`-th power of the theta unit is `uⁿ`. -/
lemma germ_thetaUnit_pow_val :
    (Y.presheaf.germ (fiberChart₀ π ⊓ fiberChart₁ π) (genericPoint Y)
        (genericPoint_mem_preimage_inf π)).hom
        ((thetaUnit π ^ n : Γ(Y, fiberChart₀ π ⊓ fiberChart₁ π)ˣ) : Γ(Y, _)) =
      ((fiberCoordUnit π ^ n : Y.functionFieldˣ) : Y.functionField) := by
  rw [Units.val_pow_eq_pow_val, Units.val_pow_eq_pow_val, map_pow,
    germ_thetaUnit_val K π]

/-- **The value of a twisted section** over a nonempty open: the germ at `η` of the
chart-0 component, divided by `uⁿ`. This is the mirror of
`MeromorphicPresentation.gluedVal` on the two-chart carrier. -/
noncomputable def thetaVal {W : Y.Opens} (hηW : genericPoint Y ∈ W)
    (p : ↥(twistSubmodule K (fiberChart₀ π) (fiberChart₁ π) (thetaUnit π ^ n) W)) :
    Y.functionField :=
  (((fiberCoordUnit π ^ n)⁻¹ : Y.functionFieldˣ) : Y.functionField) *
    (Y.presheaf.germ (W ⊓ fiberChart₀ π) (genericPoint Y)
      ⟨hηW, (genericPoint_mem_preimage_inf π).1⟩).hom p.val.1

omit [SmoothOfRelativeDimension 1 (Y ↘ Spec (CommRingCat.of K))]
  [LocallyOfFiniteType (Y ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (Y ↘ Spec (CommRingCat.of K))] in
/-- **The value read on the second chart**: the matching relation pushed to `η` cancels
the `uⁿ` factor, so `thetaVal p = germ_η p.2`. -/
lemma thetaVal_eq_germ_snd {W : Y.Opens} (hηW : genericPoint Y ∈ W)
    (p : ↥(twistSubmodule K (fiberChart₀ π) (fiberChart₁ π) (thetaUnit π ^ n) W)) :
    thetaVal K π n hηW p =
      (Y.presheaf.germ (W ⊓ fiberChart₁ π) (genericPoint Y)
        ⟨hηW, (genericPoint_mem_preimage_inf π).2⟩).hom p.val.2 := by
  have hηT : genericPoint Y ∈ W ⊓ fiberChart₀ π ⊓ fiberChart₁ π :=
    ⟨⟨hηW, (genericPoint_mem_preimage_inf π).1⟩, (genericPoint_mem_preimage_inf π).2⟩
  have hmatch := (mem_twistSubmodule_iff K (fiberChart₀ π) (fiberChart₁ π)
    (thetaUnit π ^ n) p.val).mp p.property
  have hg := congrArg
    (Y.presheaf.germ (W ⊓ fiberChart₀ π ⊓ fiberChart₁ π) (genericPoint Y) hηT).hom hmatch
  -- identify the three germs: `s₀`, `g^n ↦ uⁿ`, and `s₁`, all through `germ_resHom`
  rw [map_mul, germ_resHom, germ_resHom, germ_resHom, germ_thetaUnit_pow_val K π n] at hg
  -- `thetaVal = u⁻ⁿ · germ_η s₀`; substitute `germ_η s₀ = uⁿ · germ_η s₁` and cancel
  change (((fiberCoordUnit π ^ n)⁻¹ : Y.functionFieldˣ) : Y.functionField) *
      (Y.presheaf.germ (W ⊓ fiberChart₀ π) (genericPoint Y)
        ⟨hηW, (genericPoint_mem_preimage_inf π).1⟩).hom p.val.1 =
      (Y.presheaf.germ (W ⊓ fiberChart₁ π) (genericPoint Y) _).hom p.val.2
  rw [hg, ← mul_assoc, Units.inv_mul, one_mul]

end Value

end AlgebraicGeometry
