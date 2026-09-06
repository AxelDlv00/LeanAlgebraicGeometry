/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientEtale
import Mathlib.RingTheory.Nullstellensatz

/-!
# Rational-point freeness and affine quotients

For a finite type algebra over an algebraically closed field, the weak
Nullstellensatz lets rational points detect whether action differences
generate the unit ideal. This connects the affine etale quotient theorem to
the rational-point convention for varieties.
-/

set_option autoImplicit false

namespace MilneLib

universe u v w

variable (k : Type u) (A : Type v) (G : Type w) [Field k] [IsAlgClosed k]
  [CommRing A] [Algebra k A] [Algebra.FiniteType k A]
  [Group G] [MulSemiringAction G A]

/-- Over an algebraically closed field, rational-point separation detects the
unit difference ideal in a finite type algebra. -/
theorem ideal_span_smul_sub_eq_top_of_rational_points (g : G)
    (hfree : ∀ x : A →ₐ[k] k, ∃ a : A, x (g • a) ≠ x a) :
    Ideal.span (Set.range (fun a : A => g • a - a)) = ⊤ := by
  by_contra hspan
  obtain ⟨M, hM, hspanM⟩ := Ideal.ne_top_iff_exists_maximal.mp hspan
  letI : Field (A ⧸ M) := Ideal.Quotient.field M
  haveI : Algebra.FiniteType k (A ⧸ M) :=
    Algebra.FiniteType.of_surjective (Ideal.Quotient.mkₐ k M)
      (Ideal.Quotient.mkₐ_surjective k M)
  haveI : Module.Finite k (A ⧸ M) :=
    finite_of_finite_type_of_isJacobsonRing k (A ⧸ M)
  let e : k ≃ₐ[k] (A ⧸ M) := AlgEquiv.ofBijective (Algebra.ofId k (A ⧸ M))
    IsAlgClosed.algebraMap_bijective_of_isIntegral
  let x : A →ₐ[k] k := e.symm.toAlgHom.comp (Ideal.Quotient.mkₐ k M)
  obtain ⟨a, ha⟩ := hfree x
  apply ha
  apply sub_eq_zero.mp
  rw [← map_sub]
  change e.symm (Ideal.Quotient.mk M (g • a - a)) = 0
  rw [Ideal.Quotient.eq_zero_iff_mem.mpr (hspanM (Ideal.subset_span ⟨a, rfl⟩))]
  exact map_zero _

/-- A finite action free on rational points has an etale affine invariant
quotient over an algebraically closed field. -/
theorem affineInvariantQuotientMap_etale_of_rational_points
    [SMulCommClass G k A] [Finite G]
    (hfree : ∀ (g : G), g ≠ 1 →
      ∀ x : A →ₐ[k] k, ∃ a : A, x (g • a) ≠ x a) :
    AlgebraicGeometry.Etale (affineInvariantQuotientMap (k := k) (A := A) (G := G)) := by
  apply affineInvariantQuotientMap_etale_of_field_points k A G
  intro g hg K _ x
  exact field_points_of_ideal_span_smul_sub_eq_top g
    (ideal_span_smul_sub_eq_top_of_rational_points k A G g (hfree g hg)) K x

end MilneLib
