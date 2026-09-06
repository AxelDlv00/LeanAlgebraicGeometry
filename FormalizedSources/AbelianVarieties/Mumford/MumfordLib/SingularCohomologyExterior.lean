/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomologyRing
import MumfordLib.SingularCohomologyExteriorSquare

/-!
# The exterior-algebra cup comparison

Integral degree-one classes have square zero, so their inclusion in the total
singular cohomology ring extends to an algebra homomorphism from the exterior
algebra. Its restriction to each exterior power is homogeneous and evaluates
on wedges as the iterated singular cup product.

This constructs the comparison maps in Mumford, Chapter I, Section 1, p. 3.
Bijectivity for tori requires the separate circle and product calculations.
-/

set_option autoImplicit false

noncomputable section

namespace Mumford.Analytic

variable {X : TopCat}

/-- The cup comparison from the exterior algebra of integral `H¹` to total
integral singular cohomology. -/
def singularCohomologyExteriorAlgebra (X : TopCat) :
    ExteriorAlgebra ℤ (IntegralSingularCohomology X 1) →ₐ[ℤ]
      IntegralSingularCohomologyRing X :=
  ExteriorAlgebra.lift ℤ ⟨DirectSum.lof ℤ ℕ
    (fun n => (IntegralSingularCohomology X n : Type _)) 1, by
    intro c
    rw [singularCohomologyRing_lof_mul_lof X 1 1 2 rfl,
      singularCohomologyCup_one_one, singularCohomologyCupOne_self, map_zero]⟩

@[simp]
theorem singularCohomologyExteriorAlgebra_ι (c : IntegralSingularCohomology X 1) :
    singularCohomologyExteriorAlgebra X (ExteriorAlgebra.ι ℤ c) =
      DirectSum.lof ℤ ℕ (fun n => (IntegralSingularCohomology X n : Type _)) 1 c :=
  ExteriorAlgebra.lift_ι_apply _ _ _ _

/-- The ordered iterated cup of degree-one cohomology classes; the empty cup
is the degree-zero unit. -/
def singularCohomologyIteratedCup (X : TopCat) :
    (n : ℕ) → (Fin n → IntegralSingularCohomology X 1) → IntegralSingularCohomology X n
  | 0, _ => singularCohomologyOne X
  | n + 1, v => singularCohomologyCup X 1 n (n + 1) (Nat.add_comm 1 n)
      (v 0) (singularCohomologyIteratedCup X n (fun i => v i.succ))

/-- A wedge of `n` degree-one classes maps to degree `n`, with coefficient
given by their iterated cup product. -/
theorem singularCohomologyExteriorAlgebra_ιMulti (n : ℕ)
    (v : Fin n → IntegralSingularCohomology X 1) :
    singularCohomologyExteriorAlgebra X (ExteriorAlgebra.ιMulti ℤ n v) =
      DirectSum.lof ℤ ℕ (fun n => (IntegralSingularCohomology X n : Type _)) n
        (singularCohomologyIteratedCup X n v) := by
  induction n with
  | zero =>
    rw [ExteriorAlgebra.ιMulti_zero_apply, map_one]
    exact (singularCohomologyRing_lof_one X).symm
  | succ n ih =>
    rw [ExteriorAlgebra.ιMulti_succ_apply, map_mul,
      singularCohomologyExteriorAlgebra_ι, ih,
      singularCohomologyRing_lof_mul_lof X 1 n (n + 1) (Nat.add_comm 1 n)]
    rfl

/-- The degree-`n` exterior-power cup comparison. -/
def singularCohomologyExteriorPower (X : TopCat) (n : ℕ) :
    (⋀[ℤ]^n (IntegralSingularCohomology X 1)) →ₗ[ℤ]
      IntegralSingularCohomology X n :=
  (DirectSum.component ℤ ℕ (fun n => (IntegralSingularCohomology X n : Type _)) n).comp
    ((singularCohomologyExteriorAlgebra X).toLinearMap.comp
      (Submodule.subtype (⋀[ℤ]^n (IntegralSingularCohomology X 1))))

@[simp]
theorem singularCohomologyExteriorPower_ιMulti (n : ℕ)
    (v : Fin n → IntegralSingularCohomology X 1) :
    singularCohomologyExteriorPower X n (exteriorPower.ιMulti ℤ n v) =
      singularCohomologyIteratedCup X n v := by
  change DirectSum.component ℤ ℕ (fun n => (IntegralSingularCohomology X n : Type _)) n
    (singularCohomologyExteriorAlgebra X (ExteriorAlgebra.ιMulti ℤ n v)) = _
  rw [singularCohomologyExteriorAlgebra_ιMulti, DirectSum.component.lof_self]

/-- The algebra comparison sends the whole `n`th exterior power into degree
`n`; projection in the definition of the degreewise comparison loses nothing. -/
theorem singularCohomologyExteriorAlgebra_homogeneous (n : ℕ)
    (x : ⋀[ℤ]^n (IntegralSingularCohomology X 1)) :
    singularCohomologyExteriorAlgebra X x =
      DirectSum.lof ℤ ℕ (fun n => (IntegralSingularCohomology X n : Type _)) n
        (singularCohomologyExteriorPower X n x) := by
  letI : Module ℤ (IntegralSingularCohomologyRing X) := Algebra.toModule
  have h : (singularCohomologyExteriorAlgebra X).toLinearMap.comp
      (Submodule.subtype (⋀[ℤ]^n (IntegralSingularCohomology X 1))) =
      (DirectSum.lof ℤ ℕ (fun n => (IntegralSingularCohomology X n : Type _)) n).comp
        (singularCohomologyExteriorPower X n) := by
    apply exteriorPower.linearMap_ext
    ext v : 1
    change singularCohomologyExteriorAlgebra X (ExteriorAlgebra.ιMulti ℤ n v) =
      DirectSum.lof ℤ ℕ (fun n => (IntegralSingularCohomology X n : Type _)) n
        (singularCohomologyExteriorPower X n (exteriorPower.ιMulti ℤ n v))
    rw [singularCohomologyExteriorAlgebra_ιMulti, singularCohomologyExteriorPower_ιMulti]
  exact DFunLike.congr_fun h x

/-- Iterated integral degree-one cups form an alternating multilinear map. -/
def singularCohomologyIteratedCupAlternating (X : TopCat) (n : ℕ) :
    AlternatingMap ℤ (IntegralSingularCohomology X 1)
      (IntegralSingularCohomology X n) (Fin n) :=
  (singularCohomologyExteriorPower X n).compAlternatingMap (exteriorPower.ιMulti ℤ n)

@[simp]
theorem singularCohomologyIteratedCupAlternating_apply (n : ℕ)
    (v : Fin n → IntegralSingularCohomology X 1) :
    singularCohomologyIteratedCupAlternating X n v =
      singularCohomologyIteratedCup X n v :=
  singularCohomologyExteriorPower_ιMulti n v

/-- The all-degree construction recovers the previously constructed exterior
square comparison. -/
@[simp]
theorem singularCohomologyExteriorPower_two (X : TopCat) :
    singularCohomologyExteriorPower X 2 = singularCohomologyExteriorSquare X := by
  apply exteriorPower.linearMap_ext
  ext v
  change singularCohomologyExteriorPower X 2 (exteriorPower.ιMulti ℤ 2 v) =
    singularCohomologyExteriorSquare X (exteriorPower.ιMulti ℤ 2 v)
  rw [singularCohomologyExteriorPower_ιMulti, singularCohomologyExteriorSquare_ιMulti]
  change singularCohomologyCup X 1 1 2 rfl (v 0)
    (singularCohomologyCup X 1 0 1 rfl (v 1) (singularCohomologyOne X)) = _
  rw [singularCohomologyCup_one_right, singularCohomologyCup_one_one]

end Mumford.Analytic
