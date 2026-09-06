/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientProjective
import MilneLib.FreeAction
import Mathlib.RingTheory.Unramified.Finite
import Mathlib.RingTheory.Finiteness.ModuleFinitePresentation
import Mathlib.AlgebraicGeometry.Morphisms.Etale

/-!
# Etale invariant inclusions for free finite actions

The trace dual family proves that the action tensor map is injective over
the fixed subalgebra. The tensor over the identity-coordinate function then
satisfies the separability criterion for formal unramifiedness. Finite
projectivity gives finite presentation, so the invariant inclusion is etale.
-/

set_option autoImplicit false

universe u v w

open scoped TensorProduct

namespace MilneLib

variable (k : Type u) (A : Type v) (G : Type w)
  [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A] [Finite G]

/-- Over the fixed subalgebra, the tensor map of a free finite action is
injective. The proof uses the finite trace dual family. -/
theorem fixedSubalgebra_actionTensorMap_injective
    (hfree : ∀ g : G, g ≠ 1 →
      Ideal.span (Set.range fun a : A => g • a - a) = ⊤) :
    Function.Injective (actionTensorMap (FixedPoints.subalgebra k A G) A G) := by
  classical
  letI := Fintype.ofFinite G
  let S := FixedPoints.subalgebra k A G
  obtain ⟨s, hs⟩ := exists_groupTrace_dual_family k A G hfree
  have hker (t : A ⊗[S] A) (ht : actionTensorMap S A G t = 0) : t = 0 := by
    obtain ⟨r, rfl⟩ := TensorProduct.exists_finset t
    have hcoeff (g : G) : (∑ p ∈ r, p.1 * g • p.2) = 0 := by
      simpa [map_sum, actionTensorMap_tmul] using congrFun ht g
    have htrace (b : A) :
        (∑ p ∈ r, p.1 * (groupTrace k A G (b * p.2) : A)) = 0 := by
      calc
        _ = ∑ g : G, (g • b) * ∑ p ∈ r, p.1 * g • p.2 := by
          simp only [groupTrace_coe, smul_mul', Finset.mul_sum]
          rw [Finset.sum_comm]
          apply Finset.sum_congr rfl
          intro g hg
          apply Finset.sum_congr rfl
          intro p hp
          ac_rfl
        _ = 0 := by simp [hcoeff]
    calc
      ∑ p ∈ r, p.1 ⊗ₜ[S] p.2 =
          ∑ p ∈ r, ∑ i ∈ s,
            (p.1 * (groupTrace k A G (i.2 * p.2) : A)) ⊗ₜ[S] i.1 := by
        apply Finset.sum_congr rfl
        intro p hp
        conv_lhs => rw [← hs p.2]
        rw [TensorProduct.tmul_sum]
        apply Finset.sum_congr rfl
        intro i hi
        rw [TensorProduct.tmul_smul]
        change ((groupTrace k A G (i.2 * p.2) : A) * p.1) ⊗ₜ[S] i.1 = _
        rw [mul_comm]
      _ = ∑ i ∈ s,
          (∑ p ∈ r, p.1 * (groupTrace k A G (i.2 * p.2) : A)) ⊗ₜ[S] i.1 := by
        rw [Finset.sum_comm]
        simp only [TensorProduct.sum_tmul]
      _ = 0 := by simp only [htrace, TensorProduct.zero_tmul, Finset.sum_const_zero]
  intro t t' htt'
  apply sub_eq_zero.mp
  apply hker
  rw [map_sub, htt', sub_self]

/-- The identity-coordinate tensor satisfies the separability criterion, so
the invariant inclusion of a free finite action is formally unramified. -/
theorem fixedSubalgebra_formallyUnramified_of_free
    (hfree : ∀ g : G, g ≠ 1 →
      Ideal.span (Set.range fun a : A => g • a - a) = ⊤) :
    Algebra.FormallyUnramified (FixedPoints.subalgebra k A G) A := by
  classical
  let S := FixedPoints.subalgebra k A G
  letI : Module.Finite S A := (fixedSubalgebra_finite_projective_of_free k A G hfree).1
  obtain ⟨t, ht⟩ := actionTensorMap_surjective S A G hfree
    (fun g => if g = 1 then 1 else 0)
  apply Algebra.FormallyUnramified.iff_exists_tensorProduct.mpr
  refine ⟨t, ?_, ?_⟩
  · intro a
    apply fixedSubalgebra_actionTensorMap_injective k A G hfree
    ext g
    have ht' := congrFun ht g
    dsimp [S] at ht'
    by_cases hg : g = 1
    · subst g
      simp [map_mul, map_sub, actionTensorMap_tmul]
    · simp [map_mul, map_sub, actionTensorMap_tmul, ht', hg]
  · have hμ (x : A ⊗[S] A) :
        actionTensorMap S A G x 1 = Algebra.TensorProduct.lmul' S x := by
      induction x using TensorProduct.induction_on with
      | zero => simp
      | tmul a b => simp
      | add x y hx hy => simp_all [map_add]
    rw [← hμ, ht]
    simp

/-- An algebra is etale over its invariants under a free finite group action. -/
theorem fixedSubalgebra_etale_of_free
    (hfree : ∀ g : G, g ≠ 1 →
      Ideal.span (Set.range fun a : A => g • a - a) = ⊤) :
    Algebra.Etale (FixedPoints.subalgebra k A G) A := by
  let S := FixedPoints.subalgebra k A G
  have hfp := fixedSubalgebra_finite_projective_of_free k A G hfree
  letI : Module.Finite S A := hfp.1
  letI : Module.Projective S A := hfp.2
  letI : Module.FinitePresentation S A := Module.finitePresentation_of_projective S A
  letI : Module.Flat S A := fixedSubalgebra_flat_of_free k A G hfree
  letI : Algebra.FormallyUnramified S A :=
    fixedSubalgebra_formallyUnramified_of_free k A G hfree
  exact Algebra.Etale.of_formallyUnramified_of_flat

/-- Field-valued freeness makes the actual affine invariant quotient map etale. -/
theorem affineInvariantQuotientMap_etale_of_field_points
    (hfree : ∀ (g : G), g ≠ 1 →
      ∀ (K : Type v) [Field K] (x : A →+* K),
        ∃ a : A, x (g • a) ≠ x a) :
    AlgebraicGeometry.Etale (affineInvariantQuotientMap (k := k) (A := A) (G := G)) := by
  letI : Algebra.Etale (FixedPoints.subalgebra k A G) A :=
    fixedSubalgebra_etale_of_free k A G (fun g hg =>
      ideal_span_smul_sub_eq_top_of_field_points g (hfree g hg))
  unfold affineInvariantQuotientMap
  rw [AlgebraicGeometry.HasRingHomProperty.Spec_iff (P := @AlgebraicGeometry.Etale)]
  exact RingHom.etale_algebraMap.mpr inferInstance

end MilneLib
