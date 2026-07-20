/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivSchemeRedesignRDNChart
import Mathlib.RingTheory.Support
import Mathlib.RingTheory.LocalRing.Module

/-!
# DD-4 redesign — RD-N the `κ(z)` restatement (I-0305 §recommended route, step 1 / XS)

The 2c stalk bridge (`DivSchemeRedesignSeedFinish.lean`) reduced RD-N proper
`primeIdealOf z ∉ Module.support Γ(V) (N z)` to a **base-fibre** vanishing
`Subsingleton (chartColengthModuleBase K b s ⊗_R κ(p))` at the *comapped* base prime
`p = (primeIdealOf z).comap (algebraMap R Γ(V))`.  I-0304/I-0305 proved that route a **dead
end**: the base-fibre statement demands a *global* fibre divisibility over the whole
`κ(p)`-fibre chart that is FALSE by degree count (`deg E = deg N − g ≥ 2 > 0`, `dim T ≥ 2`
force genuine extra zeros of `read sec z` away from `z`).

This file lands the **corrected single-point reduction** (I-0305 §route step 1):
`Module.mem_support_iff_nontrivial_residueField_tensorProduct` applied directly at the point's
own prime `pz := primeIdealOf z` **over `Γ(V)`** (NOT comapped to `R`), using the landed
`Γ(V)`-finiteness `chartColengthModule_finite` (I-0303).  Because `N z = chartColengthModule K b s`
is already `Module.Finite Γ(V)`, the mathlib support/Nakayama half fires directly, giving

  `primeIdealOf z ∉ Module.support Γ(V) (N z)  ⟺  Subsingleton (N z ⊗_{Γ(V)} κ(z))`,

`κ(z) := (primeIdealOf z).asIdeal.ResidueField` = the scheme residue field at the point `z`.
This is a **single-point** condition: extra zeros of `read sec z` at other points `w ≠ z` do
not touch this fibre, so the §2 degree obstruction never fires.  The one-point stalk Nakayama
(`DivSchemeRedesignSeedFinish`'s successor) feeds the `Subsingleton (N z ⊗ κ(z))` input.

Certificate-free, `IsGenerator`-free; consumes only the landed `chartColengthModule` +
`chartColengthModule_finite` + mathlib support theory.  The `κ(p)` 2c bridge is a valid but
inapplicable reduction — it is left intact and NOT consumed here.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory TopologicalSpace Opposite
open scoped TensorProduct

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable {π : C.left ⟶ P1 k} [IsFinite π] {a : ℕ}

namespace ThetaGeneratorSeed

set_option maxHeartbeats 2400000 in
-- the point's residue-field tower `Γ(V) → κ(pz)` and the finite-`Γ(V)`-module support/Nakayama
-- theory over the heavy `relCurve` chart section-ring colength re-elaborate past the defaults
set_option synthInstance.maxHeartbeats 800000 in
set_option maxSynthPendingDepth 8 in
set_option maxRecDepth 8000 in
/-- **RD-N the `κ(z)` restatement** (I-0305 §route step 1 / XS): at a point `z` in the chart
`V = relPinnedChart C R π b`, if the **single-point** residue-field fibre
`chartColengthModule K b s ⊗_{Γ(V)} κ(z)` of the `Γ(V)`-colength vanishes at the point's own
prime `pz = primeIdealOf z` (with `κ(z) := pz.asIdeal.ResidueField` the scheme residue field
at `z`), then **RD-N proper** holds:
`primeIdealOf z ∉ Module.support Γ(V) (chartColengthModule K b s)`.

This is the corrected reduction of I-0305: apply
`Module.mem_support_iff_nontrivial_residueField_tensorProduct` at `pz` **over `Γ(V)`** (the
landed `chartColengthModule_finite` supplies `Module.Finite Γ(V) (N z)`), NOT comapped to the
base `R` as the dead-end 2c bridge did.  The tensor is a single-point fibre, so the degree
obstruction (I-0305 §2, which kills the *global* `κ(p)` base-fibre) never fires. -/
theorem notMem_support_chartColengthModule_of_subsingleton_tmul_residueField_kappaZ
    (K : Submodule R (relThetaSections C R π a)) (b : Bool)
    (s : relThetaSections C R π a) [Module.Finite R ↥K]
    {z : relCurve C R} (hz : z ∈ relPinnedChart C R π b)
    (hfib : Subsingleton (↥(chartColengthModule K b s) ⊗[Γ(relCurve C R, relPinnedChart C R π b)]
      ((isAffineOpen_relPinnedChart C R π b).primeIdealOf ⟨z, hz⟩).asIdeal.ResidueField)) :
    (isAffineOpen_relPinnedChart C R π b).primeIdealOf ⟨z, hz⟩ ∉
      Module.support Γ(relCurve C R, relPinnedChart C R π b) ↥(chartColengthModule K b s) := by
  haveI := chartColengthModule_finite K b s
  rw [Module.mem_support_iff_nontrivial_residueField_tensorProduct,
    not_nontrivial_iff_subsingleton]
  haveI := hfib
  exact (TensorProduct.comm Γ(relCurve C R, relPinnedChart C R π b)
    (↥(chartColengthModule K b s)) _).symm.toEquiv.subsingleton

set_option maxHeartbeats 2400000 in
-- the point's prime `pz` and the finite-`Γ(V)`-module support machinery over the heavy
-- `relCurve` chart section-ring colength re-elaborate the module instances past the defaults
set_option synthInstance.maxHeartbeats 800000 in
set_option maxSynthPendingDepth 8 in
set_option maxRecDepth 8000 in
/-- **RD-N from single-point local reading-divisibility** (I-0305 §route step 2 (iii), the
`fibre→stalk` reduction, pure module algebra): at a point `z` in the chart
`V = relPinnedChart C R π b`, if for every `ψ ∈ K` the reading `read ψ` is a multiple of
`read s` *locally at `z`* — i.e. there is `r ∉ pz` (`pz = primeIdealOf z`) with
`r · read ψ ∈ ⟨read s⟩` in `Γ(V)`, equivalently `read ψ ∈ ⟨read s⟩` in the stalk
`𝒪_z = Γ(V)_{pz}` — then **RD-N proper** holds:
`primeIdealOf z ∉ Module.support Γ(V) (chartColengthModule K b s)`.

This is the honest single-point target the achiever feeds: `read sec z` attains the base
multiplicity at `z` (I-0291), so in the fibre DVR at `z` it has minimal order, hence divides
every reading `read ψ` there; the `isLocalization_stalk` unpacking of that fibre divisibility
supplies the local cofactor `r ∉ pz`.  No comap to `R`, no `κ(p)` global fibre — the input is
per-point at `z`, so the degree obstruction (I-0305 §2) never fires.  The proof is the
finite-module support characterization `Module.notMem_support_iff'` (`∀ m, ∃ r ∉ pz, r • m = 0`)
propagated over the `Γ(V)`-span generators by the submodule closure (`pz` prime for the sum,
`1 ∉ pz` for `0`). -/
theorem notMem_support_chartColengthModule_of_forall_exists_notMem_mul_read_mem_span
    (K : Submodule R (relThetaSections C R π a)) (b : Bool)
    (s : relThetaSections C R π a) [Module.Finite R ↥K]
    {z : relCurve C R} (hz : z ∈ relPinnedChart C R π b)
    (hgen : ∀ ⦃ψ : relThetaSections C R π a⦄, ψ ∈ K →
      ∃ r ∉ ((isAffineOpen_relPinnedChart C R π b).primeIdealOf ⟨z, hz⟩).asIdeal,
        r * relThetaResSide a b (le_rfl) ψ
          ∈ Ideal.span {relThetaResSide a b (le_rfl) s}) :
    (isAffineOpen_relPinnedChart C R π b).primeIdealOf ⟨z, hz⟩ ∉
      Module.support Γ(relCurve C R, relPinnedChart C R π b) ↥(chartColengthModule K b s) := by
  set I := Ideal.span {relThetaResSide a b (le_rfl) s} with hI
  set pz := (isAffineOpen_relPinnedChart C R π b).primeIdealOf ⟨z, hz⟩ with hpz
  rw [Module.notMem_support_iff']
  intro m
  suffices h : ∃ r ∉ pz.asIdeal,
      r • (m : Γ(relCurve C R, relPinnedChart C R π b) ⧸ I) = 0 by
    obtain ⟨r, hr, hr0⟩ := h
    exact ⟨r, hr, Subtype.ext (by simpa using hr0)⟩
  refine Submodule.span_induction
    (p := fun y _ => ∃ r ∉ pz.asIdeal, r • y = 0) ?_ ?_ ?_ ?_ m.2
  · rintro y ⟨⟨ψ, hψ⟩, rfl⟩
    obtain ⟨r, hr, hmem⟩ := hgen hψ
    refine ⟨r, hr, ?_⟩
    change r • Ideal.Quotient.mk I (relThetaResSide a b (le_rfl) ψ) = 0
    rw [show r • Ideal.Quotient.mk I (relThetaResSide a b (le_rfl) ψ)
          = Ideal.Quotient.mk I (r * relThetaResSide a b (le_rfl) ψ) by
        rw [Algebra.smul_def, Ideal.Quotient.algebraMap_eq, ← map_mul]]
    exact (Ideal.Quotient.eq_zero_iff_mem).mpr hmem
  · exact ⟨1, (Ideal.ne_top_iff_one _).mp pz.isPrime.ne_top, smul_zero 1⟩
  · rintro y₁ y₂ _ _ ⟨r₁, hr₁, h₁⟩ ⟨r₂, hr₂, h₂⟩
    refine ⟨r₁ * r₂, fun hmul => (pz.isPrime.mem_or_mem hmul).elim hr₁ hr₂, ?_⟩
    have e₁ : (r₁ * r₂) • y₁ = 0 := by rw [mul_comm, mul_smul, h₁, smul_zero]
    have e₂ : (r₁ * r₂) • y₂ = 0 := by rw [mul_smul, h₂, smul_zero]
    rw [smul_add, e₁, e₂, add_zero]
  · rintro c y _ ⟨r, hr, h⟩
    exact ⟨r, hr, by rw [smul_comm, h, smul_zero]⟩

end ThetaGeneratorSeed

end AlgebraicGeometry
