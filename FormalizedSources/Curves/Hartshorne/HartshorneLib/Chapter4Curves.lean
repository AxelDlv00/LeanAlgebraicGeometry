/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import Mathlib.AlgebraicGeometry.FunctionField
import Mathlib.AlgebraicGeometry.Morphisms.Proper
import Mathlib.AlgebraicGeometry.Morphisms.Smooth
import Mathlib.FieldTheory.IsAlgClosed.Basic

/-!
# Hartshorne IV.1: divisors on an integral curve

This file records the finite-formal-sum model of divisors used for curves.  The
degree is the unweighted sum of coefficients, matching Hartshorne's convention
over an algebraically closed base field.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open AlgebraicGeometry

namespace Hartshorne

/-- A finite integer linear combination of the non-generic points of an
integral scheme. -/
def PointDivisor (X : Scheme.{u}) [IsIntegral X] : Type u :=
  {x : X // x ≠ genericPoint X} →₀ ℤ

/-- A divisor on a complete nonsingular integral curve over an algebraically
closed field. -/
def CurveDivisor (k : Type u) [Field k] [IsAlgClosed k]
    (X : Over (Spec (.of k))) [IsIntegral X.left]
    [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom] : Type u :=
  PointDivisor X.left

namespace CurveDivisor

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]

noncomputable instance : AddCommGroup (CurveDivisor k X) :=
  inferInstanceAs (AddCommGroup ({x : X.left // x ≠ genericPoint X.left} →₀ ℤ))

instance : PartialOrder (CurveDivisor k X) :=
  inferInstanceAs (PartialOrder ({x : X.left // x ≠ genericPoint X.left} →₀ ℤ))

/-- The unweighted degree, appropriate over an algebraically closed base field. -/
noncomputable def degree (D : CurveDivisor k X) : ℤ :=
  D.sum fun _ n => n

/-- Degree as an additive homomorphism. -/
noncomputable def degreeHom : CurveDivisor k X →+ ℤ :=
  Finsupp.liftAddHom fun _ => AddMonoidHom.id ℤ

@[simp]
theorem degreeHom_apply (D : CurveDivisor k X) : degreeHom D = degree D :=
  Finsupp.liftAddHom_apply
    (α := {x : X.left // x ≠ genericPoint X.left}) (M := ℤ) (N := ℤ)
    (fun _ => AddMonoidHom.id ℤ) D

@[simp]
theorem degree_zero : degree (0 : CurveDivisor k X) = 0 := by
  rw [← degreeHom_apply]
  exact map_zero degreeHom

theorem degree_add (D E : CurveDivisor k X) :
    degree (D + E) = degree D + degree E := by
  rw [← degreeHom_apply, ← degreeHom_apply, ← degreeHom_apply]
  exact map_add degreeHom D E

@[simp]
theorem degree_neg (D : CurveDivisor k X) : degree (-D) = -degree D := by
  rw [← degreeHom_apply, ← degreeHom_apply]
  exact map_neg degreeHom D

theorem degree_sub (D E : CurveDivisor k X) :
    degree (D - E) = degree D - degree E := by
  rw [← degreeHom_apply, ← degreeHom_apply, ← degreeHom_apply]
  exact map_sub degreeHom D E

@[simp]
theorem degree_single (x : {x : X.left // x ≠ genericPoint X.left}) (n : ℤ) :
    degree (Finsupp.single x n : CurveDivisor k X) = n := by
  simp [degree]

end CurveDivisor

end Hartshorne
