/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotient
import MilneLib.StableAffineCover

/-!
# Invariant principal neighborhoods in affine quotients

For a finite group acting on an affine scheme, invariant principal opens form a basis
inside every stable open. The invariant equation is obtained by taking the product of
one equation over the group orbit.
-/

set_option autoImplicit false

universe u v

open AlgebraicGeometry TopologicalSpace
open scoped BigOperators

namespace MilneLib
namespace InvariantLocalization

variable {k : Type u} {A : Type v} {G : Type*}
  [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A]

/-- Every point of a stable open in an affine scheme has a principal neighborhood,
still contained in that open, whose equation belongs to the fixed subring. -/
theorem exists_invariant_basicOpen_le [Finite G]
    (U : (Spec (CommRingCat.of A)).Opens)
    (hU : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ U = U)
    (x : PrimeSpectrum A) (hx : x ∈ U) :
    ∃ b : FixedPoints.subalgebra k A G,
      x ∈ PrimeSpectrum.basicOpen (b : A) ∧
        PrimeSpectrum.basicOpen (b : A) ≤ U := by
  classical
  letI : Fintype G := Fintype.ofFinite G
  obtain ⟨f, hf, hfU⟩ :=
    exists_mem_basicOpen_le_of_finite U
      (fun g : G => (specAction G A g).hom.base x) (fun g => by
        have hx' : x ∈ (specAction G A g).hom ⁻¹ᵁ U := by
          rw [hU g]
          exact hx
        exact hx')
  let b0 : A := ∏ g : G, g • f
  have hb0 : ∀ h : G, h • b0 = b0 := by
    intro h
    dsimp [b0]
    change (MulSemiringAction.toRingHom G A h) (∏ g : G, g • f) =
      ∏ g : G, g • f
    calc
      _ = ∏ g : G, h • (g • f) := by
        rw [map_prod]
        apply Fintype.prod_congr
        intro g
        rfl
      _ = ∏ g : G, (h * g) • f := by
        congr 1
        funext g
        exact (mul_smul h g f).symm
      _ = ∏ g : G, g • f :=
        Fintype.prod_equiv (Equiv.mulLeft h) _ _ (fun _ => rfl)
  let b : FixedPoints.subalgebra k A G := ⟨b0, hb0⟩
  refine ⟨b, ?_, ?_⟩
  · change b0 ∉ x.asIdeal
    dsimp [b0]
    letI : x.asIdeal.IsPrime := x.isPrime
    rw [Ideal.IsPrime.prod_mem_iff]
    push Not
    intro g _
    have hxg := hf (g⁻¹)
    rw [specAction_hom] at hxg
    change f ∉ Ideal.comap
      (MulSemiringAction.toRingHom G A ((g⁻¹)⁻¹)) x.asIdeal at hxg
    simpa only [Ideal.mem_comap, inv_inv,
      MulSemiringAction.toRingHom_apply] using hxg
  · intro y hy
    apply hfU
    change b0 ∉ y.asIdeal at hy
    change f ∉ y.asIdeal
    intro hfy
    apply hy
    dsimp [b0]
    exact Ideal.prod_mem y.asIdeal (Finset.mem_univ 1) (by
      simpa only [one_smul] using hfy)

/-- Fixed equations whose principal opens are contained in `U`. -/
def InvariantBasicOpenIndex
    (U : (Spec (CommRingCat.of A)).Opens) : Type v :=
  {b : FixedPoints.subalgebra k A G //
    PrimeSpectrum.basicOpen (b : A) ≤ U}

/-- A principal open cut out by a fixed element is stable under the group action. -/
theorem invariantBasicOpen_isStable (b : FixedPoints.subalgebra k A G) (g : G) :
    (specAction G A g).hom ⁻¹ᵁ PrimeSpectrum.basicOpen (b : A) =
      PrimeSpectrum.basicOpen (b : A) := by
  rw [specAction_hom, AlgebraicGeometry.SpecMap_preimage_basicOpen]
  change PrimeSpectrum.basicOpen (g⁻¹ • (b : A)) =
    PrimeSpectrum.basicOpen (b : A)
  rw [b.property]

/-- Invariant principal opens contained in a stable open cover that open. -/
theorem iSup_invariantBasicOpen_eq [Finite G]
    (U : (Spec (CommRingCat.of A)).Opens)
    (hU : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ U = U) :
    (⨆ i : InvariantBasicOpenIndex (k := k) (G := G) U,
      PrimeSpectrum.basicOpen (i.1 : A)) = U := by
  apply le_antisymm
  · exact iSup_le fun i => i.2
  · intro x hx
    obtain ⟨b, hxb, hbU⟩ :=
      exists_invariant_basicOpen_le (k := k) (G := G) U hU x hx
    rw [Opens.mem_iSup]
    exact ⟨⟨b, hbU⟩, hxb⟩

end InvariantLocalization
end MilneLib
