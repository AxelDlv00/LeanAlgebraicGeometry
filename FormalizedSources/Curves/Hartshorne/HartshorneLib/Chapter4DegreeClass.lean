/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4DivisorClass

/-!
# Hartshorne II.6: degree on divisor classes

The geometric assertion that a principal divisor on a complete nonsingular
curve has degree zero is kept as an explicit input here.  Once that input is
available, the already-defined divisor degree descends canonically to the
divisor class group.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open AlgebraicGeometry

namespace Hartshorne

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]

/-! The missing geometric input in the degree descent is isolated explicitly. -/

/-- Every principal divisor has degree zero.

This is the valuation-theoretic statement of Hartshorne II.6.10.  It is an
explicit hypothesis so that the quotient construction below does not conceal
an unproved geometric assertion.
-/
def PrincipalDivisorsHaveDegreeZero : Prop :=
  ∀ g : X.left.functionFieldˣ, CurveDivisor.degree (principalDivisor g) = 0

theorem principalDivisors_le_degreeHom_ker
    (hzero : PrincipalDivisorsHaveDegreeZero (k := k) (X := X)) :
    principalDivisors ≤ (CurveDivisor.degreeHom (k := k) (X := X)).ker := by
  intro D hD
  rw [AddMonoidHom.mem_ker]
  obtain ⟨g, hg⟩ := (mem_principalDivisors_iff D).mp hD
  rw [← hg]
  rw [CurveDivisor.degreeHom_apply]
  exact hzero g

/-- The degree homomorphism induced on the divisor class group. -/
noncomputable def degreeClass
    (hzero : PrincipalDivisorsHaveDegreeZero (k := k) (X := X)) :
    DivisorClassGroup (k := k) (X := X) →+ ℤ :=
  QuotientAddGroup.lift principalDivisors
    (CurveDivisor.degreeHom (k := k) (X := X))
    (principalDivisors_le_degreeHom_ker hzero)

@[simp]
theorem degreeClass_divisorClass
    (hzero : PrincipalDivisorsHaveDegreeZero (k := k) (X := X))
    (D : CurveDivisor k X) :
    degreeClass hzero (divisorClass D) = CurveDivisor.degree D := by
  change (QuotientAddGroup.lift principalDivisors
      (CurveDivisor.degreeHom (k := k) (X := X)) _) 
      (D : CurveDivisor k X ⧸ principalDivisors) = _
  rw [QuotientAddGroup.lift_mk']
  exact CurveDivisor.degreeHom_apply D

@[simp]
theorem degreeClass_zero
    (hzero : PrincipalDivisorsHaveDegreeZero (k := k) (X := X)) :
    degreeClass hzero (0 : DivisorClassGroup (k := k) (X := X)) = 0 :=
  map_zero (degreeClass hzero)

/-! The quotient map sends every principal divisor to the zero class, so the
degree descended above vanishes on principal classes as well. -/

@[simp]
theorem degreeClass_principalDivisor
    (hzero : PrincipalDivisorsHaveDegreeZero (k := k) (X := X))
    (g : X.left.functionFieldˣ) :
    degreeClass hzero (divisorClass (principalDivisor g)) = 0 := by
  rw [divisorClass_principalDivisor, degreeClass_zero]

theorem degreeClass_add
    (hzero : PrincipalDivisorsHaveDegreeZero (k := k) (X := X))
    (a b : DivisorClassGroup (k := k) (X := X)) :
    degreeClass hzero (a + b) = degreeClass hzero a + degreeClass hzero b :=
  map_add (degreeClass hzero) a b

/-- Degree is invariant under linear equivalence once principal divisors have
degree zero. -/
theorem degree_eq_of_linearlyEquivalent
    (hzero : PrincipalDivisorsHaveDegreeZero (k := k) (X := X))
    {D E : CurveDivisor k X} (h : LinearlyEquivalent D E) :
    CurveDivisor.degree D = CurveDivisor.degree E := by
  have hker : D - E ∈
      (CurveDivisor.degreeHom (k := k) (X := X)).ker :=
    principalDivisors_le_degreeHom_ker hzero h
  have hsub : CurveDivisor.degree (D - E) = 0 :=
    (AddMonoidHom.mem_ker.mp hker)
  rw [CurveDivisor.degree_sub] at hsub
  exact sub_eq_zero.mp hsub

/-- The descended degree does not depend on the chosen proof of the geometric
degree-zero assertion. -/
theorem degreeClass_proof_irrel
    (h₁ h₂ : PrincipalDivisorsHaveDegreeZero (k := k) (X := X)) :
    degreeClass h₁ = degreeClass h₂ := by
  apply AddMonoidHom.ext
  intro q
  obtain ⟨D, rfl⟩ := QuotientAddGroup.mk'_surjective principalDivisors q
  change degreeClass h₁ (divisorClass D) = degreeClass h₂ (divisorClass D)
  rw [degreeClass_divisorClass]

end Hartshorne
