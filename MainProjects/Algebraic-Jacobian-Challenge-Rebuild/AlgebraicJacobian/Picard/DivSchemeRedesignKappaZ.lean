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

end ThetaGeneratorSeed

end AlgebraicGeometry
