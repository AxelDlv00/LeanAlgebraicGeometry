/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Quotient.InvariantQuotient
import MilneLib.Quotient.InvariantQuotientTensor
import Mathlib.LinearAlgebra.TensorProduct.Finiteness
import Mathlib.Algebra.Module.Projective
import Mathlib.RingTheory.Flat.Basic

/-!
# Finite projectivity over the invariants of a free action

A preimage of the identity-coordinate function under the action tensor map
gives a finite dual family for the sum-of-translates pairing. Consequently
the algebra is finite projective over its fixed subalgebra. This supplies
flatness in the free-action clause of Milne I.8.10.
-/

set_option autoImplicit false

universe u v w

open scoped TensorProduct

namespace MilneLib

variable (k : Type u) (A : Type v) (G : Type w)
  [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A]

/-- Sum of the translates, with values in the fixed subalgebra. -/
noncomputable def groupTrace [Fintype G] :
    A →ₗ[FixedPoints.subalgebra k A G] FixedPoints.subalgebra k A G where
  toFun a := ⟨∑ g : G, g • a, fun h => by
    simp only [Finset.smul_sum, ← mul_smul]
    exact Equiv.sum_comp (Equiv.mulLeft h) (fun g : G => g • a)⟩
  map_add' a b := Subtype.ext (by simp [smul_add, Finset.sum_add_distrib])
  map_smul' r a := Subtype.ext (by
    change (∑ g : G, g • (r • a)) = r • ∑ g : G, g • a
    simp only [Finset.smul_sum, smul_comm])

@[simp]
theorem groupTrace_coe [Fintype G] (a : A) :
    (groupTrace k A G a : A) = ∑ g : G, g • a := rfl

/-- The tensor preimage of the identity-coordinate function gives a finite
dual family for the group trace pairing. -/
theorem exists_groupTrace_dual_family [Fintype G]
    (hfree : ∀ g : G, g ≠ 1 →
      Ideal.span (Set.range fun a : A => g • a - a) = ⊤) :
    ∃ s : Finset (A × A), ∀ a : A,
      ∑ i ∈ s, groupTrace k A G (i.2 * a) • i.1 = a := by
  classical
  let S := FixedPoints.subalgebra k A G
  obtain ⟨t, ht⟩ := actionTensorMap_surjective S A G hfree
    (fun g => if g = 1 then 1 else 0)
  obtain ⟨s, rfl⟩ := TensorProduct.exists_finset t
  have hcoeff (g : G) : (∑ i ∈ s, i.1 * g • i.2) = if g = 1 then 1 else 0 := by
    simpa [map_sum, actionTensorMap_tmul] using congrFun ht g
  refine ⟨s, fun a => ?_⟩
  calc
    ∑ i ∈ s, groupTrace k A G (i.2 * a) • i.1 =
        ∑ i ∈ s, ∑ g : G, i.1 * (g • i.2 * g • a) := by
      apply Finset.sum_congr rfl
      intro i hi
      simp [Algebra.smul_def, groupTrace_coe, smul_mul', Finset.mul_sum, mul_comm]
    _ = ∑ g : G, (∑ i ∈ s, i.1 * g • i.2) * g • a := by
      rw [Finset.sum_comm]
      simp only [Finset.sum_mul, mul_assoc]
    _ = a := by simp [hcoeff]

/-- A free finite action makes the algebra finite projective over its fixed
subalgebra, without a noetherian or finite-type hypothesis. -/
theorem fixedSubalgebra_finite_projective_of_free [Finite G]
    (hfree : ∀ g : G, g ≠ 1 →
      Ideal.span (Set.range fun a : A => g • a - a) = ⊤) :
    Module.Finite (FixedPoints.subalgebra k A G) A ∧
      Module.Projective (FixedPoints.subalgebra k A G) A := by
  classical
  letI := Fintype.ofFinite G
  let S := FixedPoints.subalgebra k A G
  obtain ⟨s, hs⟩ := exists_groupTrace_dual_family k A G hfree
  let f : A →ₗ[S] (s → S) := LinearMap.pi fun i =>
    (groupTrace k A G).comp (LinearMap.mulLeft S i.1.2)
  let e : (s → S) →ₗ[S] A := ∑ i : s, (LinearMap.proj i).smulRight i.1.1
  have he (a : A) : e (f a) = a := by
    simp only [e, LinearMap.sum_apply, LinearMap.smulRight_apply,
      LinearMap.proj_apply, f, LinearMap.pi_apply, LinearMap.comp_apply,
      LinearMap.mulLeft_apply]
    exact (Finset.sum_coe_sort s
      (fun i : A × A => groupTrace k A G (i.2 * a) • i.1)).trans (hs a)
  exact ⟨Module.Finite.of_surjective e (fun a => ⟨f a, he a⟩),
    Module.Projective.of_split f e (LinearMap.ext he)⟩

/-- The invariant inclusion is flat under a free finite action. -/
theorem fixedSubalgebra_flat_of_free [Finite G]
    (hfree : ∀ g : G, g ≠ 1 →
      Ideal.span (Set.range fun a : A => g • a - a) = ⊤) :
    Module.Flat (FixedPoints.subalgebra k A G) A := by
  letI := (fixedSubalgebra_finite_projective_of_free k A G hfree).2
  infer_instance

end MilneLib
