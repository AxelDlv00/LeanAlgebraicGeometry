/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import Mathlib.AlgebraicGeometry.FunctionField

/-!
# Hartshorne IV.1: divisors on an integral curve

This file records the finite-formal-sum model of divisors used for curves.  The
degree is the unweighted sum of coefficients, matching Hartshorne's convention
over an algebraically closed base field.
-/

set_option autoImplicit false

universe u

namespace Hartshorne

/-- A divisor on an integral curve, represented as a finite integer linear
combination of its non-generic points. -/
def CurveDivisor (X : AlgebraicGeometry.Scheme.{u}) [AlgebraicGeometry.IsIntegral X] :
    Type u :=
  {x : X // x ≠ genericPoint X} →₀ ℤ

namespace CurveDivisor

variable {X : AlgebraicGeometry.Scheme.{u}} [AlgebraicGeometry.IsIntegral X]

noncomputable instance : AddCommGroup (CurveDivisor X) :=
  inferInstanceAs (AddCommGroup ({x : X // x ≠ genericPoint X} →₀ ℤ))

instance : PartialOrder (CurveDivisor X) :=
  inferInstanceAs (PartialOrder ({x : X // x ≠ genericPoint X} →₀ ℤ))

/-- The unweighted degree, appropriate over an algebraically closed base field. -/
noncomputable def degree (D : CurveDivisor X) : ℤ :=
  D.sum fun _ n => n

/-- Degree as an additive homomorphism. -/
noncomputable def degreeHom : CurveDivisor X →+ ℤ :=
  Finsupp.liftAddHom fun _ => AddMonoidHom.id ℤ

@[simp]
theorem degreeHom_apply (D : CurveDivisor X) : degreeHom D = degree D :=
  Finsupp.liftAddHom_apply
    (α := {x : X // x ≠ genericPoint X}) (M := ℤ) (N := ℤ)
    (fun _ => AddMonoidHom.id ℤ) D

@[simp]
theorem degree_zero : degree (0 : CurveDivisor X) = 0 := by
  rw [← degreeHom_apply]
  exact map_zero degreeHom

theorem degree_add (D E : CurveDivisor X) :
    degree (D + E) = degree D + degree E := by
  rw [← degreeHom_apply, ← degreeHom_apply, ← degreeHom_apply]
  exact map_add degreeHom D E

@[simp]
theorem degree_neg (D : CurveDivisor X) : degree (-D) = -degree D := by
  rw [← degreeHom_apply, ← degreeHom_apply]
  exact map_neg degreeHom D

theorem degree_sub (D E : CurveDivisor X) :
    degree (D - E) = degree D - degree E := by
  rw [← degreeHom_apply, ← degreeHom_apply, ← degreeHom_apply]
  exact map_sub degreeHom D E

@[simp]
theorem degree_single (x : {x : X // x ≠ genericPoint X}) (n : ℤ) :
    degree (Finsupp.single x n : CurveDivisor X) = n := by
  simp [degree]

end CurveDivisor

end Hartshorne
