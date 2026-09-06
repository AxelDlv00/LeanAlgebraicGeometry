/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.RingTheory.TensorProduct.Maps
import Mathlib.Algebra.Algebra.Pi
import Mathlib.RingTheory.Invariant.Defs
import Mathlib.RingTheory.Ideal.Quotient.Operations

/-!
# The tensor map for a free finite action

The map from `A ⊗[R] A` to the product of copies of `A` indexed by the group
sends `a ⊗ b` to `(a * g • b) g`. When the differences `g • a - a` generate
the unit ideal for every nonidentity element, its component kernels are
pairwise coprime. The Chinese remainder theorem then proves surjectivity.
This is an algebraic step toward the free-action clause of Milne I.8.10.
-/

set_option autoImplicit false

universe u v w

open scoped TensorProduct

namespace MilneLib

variable (R : Type u) (A : Type v) (G : Type w)
  [CommRing R] [CommRing A] [Algebra R A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G R A]

/-- Evaluation along the graph of a group element. -/
noncomputable def actionTensorComponent (g : G) : A ⊗[R] A →ₐ[A] A :=
  Algebra.TensorProduct.lift (AlgHom.id A A)
    (MulSemiringAction.toAlgHom R A g) (fun _ _ => Commute.all _ _)

@[simp]
theorem actionTensorComponent_tmul (g : G) (a b : A) :
    actionTensorComponent R A G g (a ⊗ₜ[R] b) = a * g • b := rfl

/-- The canonical tensor map associated to the action. -/
noncomputable def actionTensorMap : A ⊗[R] A →ₐ[A] (G → A) :=
  Pi.algHom A (fun _ : G => A) (fun g => actionTensorComponent R A G g)

@[simp]
theorem actionTensorMap_tmul (a b : A) (g : G) :
    actionTensorMap R A G (a ⊗ₜ[R] b) g = a * g • b := rfl

/-- Each component of the tensor map is surjective. -/
theorem actionTensorComponent_surjective (g : G) :
    Function.Surjective (actionTensorComponent R A G g) := by
  intro a
  exact ⟨a ⊗ₜ[R] 1, by simp⟩

/-- Distinct action graphs have coprime ideals when every nonidentity
element has unit difference ideal. -/
theorem actionTensorComponent_pairwise_isCoprime
    (hfree : ∀ g : G, g ≠ 1 →
      Ideal.span (Set.range fun a : A => g • a - a) = ⊤) :
    Pairwise (fun g h : G => IsCoprime
      (RingHom.ker (actionTensorComponent R A G g))
      (RingHom.ker (actionTensorComponent R A G h))) := by
  intro g h hgh
  rw [Ideal.isCoprime_iff_sup_eq, Ideal.eq_top_iff_one]
  let I := RingHom.ker (actionTensorComponent R A G g) ⊔
    RingHom.ker (actionTensorComponent R A G h)
  let ι : A →ₐ[A] A ⊗[R] A := Algebra.TensorProduct.includeLeft
  have hle : Ideal.span (Set.range fun a : A => (g * h⁻¹) • a - a) ≤
      Ideal.comap ι I := by
    apply Ideal.span_le.mpr
    rintro _ ⟨a, rfl⟩
    change ι ((g * h⁻¹) • a - a) ∈ I
    have h₁ : ι (g • (h⁻¹ • a)) - (1 ⊗ₜ[R] (h⁻¹ • a)) ∈
        RingHom.ker (actionTensorComponent R A G g) := by
      simp [RingHom.mem_ker, ι, Algebra.TensorProduct.includeLeft_apply]
    have h₂ : (1 ⊗ₜ[R] (h⁻¹ • a)) - ι a ∈
        RingHom.ker (actionTensorComponent R A G h) := by
      simp [RingHom.mem_ker, ι, Algebra.TensorProduct.includeLeft_apply]
    have hsum := I.add_mem (show _ ∈ I from Ideal.mem_sup_left h₁)
      (show _ ∈ I from Ideal.mem_sup_right h₂)
    simpa only [map_sub, mul_smul, sub_add_sub_cancel] using hsum
  have htop := hfree (g * h⁻¹) (by rwa [ne_eq, mul_inv_eq_one])
  have hone := hle (show (1 : A) ∈ Ideal.span
    (Set.range fun a : A => (g * h⁻¹) • a - a) by rw [htop]; trivial)
  simpa using hone

/-- The tensor map is surjective for a finite action whose nonidentity
elements have unit difference ideals. -/
theorem actionTensorMap_surjective [Finite G]
    (hfree : ∀ g : G, g ≠ 1 →
      Ideal.span (Set.range fun a : A => g • a - a) = ⊤) :
    Function.Surjective (actionTensorMap R A G) := by
  intro f
  obtain ⟨t, ht⟩ := Ideal.pi_quotient_surjective
    (actionTensorComponent_pairwise_isCoprime R A G hfree)
    (fun g => Ideal.Quotient.mk (RingHom.ker (actionTensorComponent R A G g))
      (f g ⊗ₜ[R] (1 : A)))
  refine ⟨t, funext fun g => ?_⟩
  have hker := Ideal.Quotient.eq.mp (ht g)
  rw [RingHom.mem_ker, map_sub, sub_eq_zero] at hker
  simpa [actionTensorMap] using hker

end MilneLib
