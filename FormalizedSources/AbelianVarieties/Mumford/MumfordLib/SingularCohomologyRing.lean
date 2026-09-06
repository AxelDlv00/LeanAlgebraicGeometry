/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCocycleCupLaws
import MumfordLib.SingularCohomologyCupAll
import Mathlib.Algebra.DirectSum.Algebra

/-!
# The integral singular cohomology ring

The Alexander--Whitney cup product equips the direct sum of integral singular
cohomology groups with its graded ring structure.
-/

set_option autoImplicit false

noncomputable section

open scoped DirectSum

namespace Mumford.Analytic

variable {X : TopCat}

/-- The degree-zero class of the constant-one singular cocycle. -/
def singularCohomologyOne (X : TopCat) : IntegralSingularCohomology X 0 :=
  singularCohomologyClass X 0 (singularCocycleOne X)

/-- The integral singular cup product is associative in all degrees. -/
theorem singularCohomologyCup_assoc {p q r a b n : ℕ}
    (c : IntegralSingularCohomology X p) (d : IntegralSingularCohomology X q)
    (e : IntegralSingularCohomology X r)
    (hpq : p + q = a) (hqr : q + r = b) (har : a + r = n) :
    singularCohomologyCup X a r n har (singularCohomologyCup X p q a hpq c d) e =
      singularCohomologyCup X p b n (by omega) c
        (singularCohomologyCup X q r b hqr d e) := by
  obtain ⟨φ, rfl⟩ := singularCohomologyClass_surjective X p c
  obtain ⟨ψ, rfl⟩ := singularCohomologyClass_surjective X q d
  obtain ⟨χ, rfl⟩ := singularCohomologyClass_surjective X r e
  simp only [singularCohomologyCup_class, singularCocycleCup_assoc φ ψ χ hpq hqr har]

/-- The constant-one cohomology class is a left cup unit. -/
@[simp]
theorem singularCohomologyCup_one_left {p : ℕ} (c : IntegralSingularCohomology X p) :
    singularCohomologyCup X 0 p p (Nat.zero_add p) (singularCohomologyOne X) c = c := by
  obtain ⟨φ, rfl⟩ := singularCohomologyClass_surjective X p c
  simp only [singularCohomologyOne, singularCohomologyCup_class, singularCocycleCup_one_left]

/-- The constant-one cohomology class is a right cup unit. -/
@[simp]
theorem singularCohomologyCup_one_right {p : ℕ} (c : IntegralSingularCohomology X p) :
    singularCohomologyCup X p 0 p rfl c (singularCohomologyOne X) = c := by
  obtain ⟨φ, rfl⟩ := singularCohomologyClass_surjective X p c
  simp only [singularCohomologyOne, singularCohomologyCup_class, singularCocycleCup_one_right]

private theorem singularCohomologyCup_heq {p q n m : ℕ}
    (c : IntegralSingularCohomology X p) (d : IntegralSingularCohomology X q)
    (h : p + q = n) (h' : p + q = m) :
    HEq (singularCohomologyCup X p q n h c d) (singularCohomologyCup X p q m h' c d) := by
  subst n
  subst m
  rfl

/-- The homogeneous unit of integral singular cohomology. -/
instance integralSingularCohomologyGOne (X : TopCat) :
    GradedMonoid.GOne (fun n => (IntegralSingularCohomology X n : Type _)) where
  one := singularCohomologyOne X

/-- Multiplication of homogeneous integral singular cohomology classes. -/
instance integralSingularCohomologyGMul (X : TopCat) :
    GradedMonoid.GMul (fun n => (IntegralSingularCohomology X n : Type _)) where
  mul {p q} c d := singularCohomologyCup X p q (p + q) rfl c d

/-- The cup product and its unit form a graded ring on integral singular cohomology. -/
instance integralSingularCohomologyGRing (X : TopCat) :
    DirectSum.GRing (fun n => (IntegralSingularCohomology X n : Type _)) where
  mul_zero c := (singularCohomologyCup X _ _ _ rfl c).map_zero
  zero_mul d := by
    change singularCohomologyCup X _ _ _ rfl 0 d = 0
    simp
  mul_add c d e := (singularCohomologyCup X _ _ _ rfl c).map_add d e
  add_mul c d e := congrArg (fun f => f e)
    ((singularCohomologyCup X _ _ _ rfl).map_add c d)
  one_mul := by
    rintro ⟨p, c⟩
    apply Sigma.ext (Nat.zero_add p)
    change HEq (singularCohomologyCup X 0 p (0 + p) rfl (singularCohomologyOne X) c) c
    exact (singularCohomologyCup_heq _ _ rfl (Nat.zero_add p)).trans
      (heq_of_eq (singularCohomologyCup_one_left c))
  mul_one := by
    rintro ⟨p, c⟩
    apply Sigma.ext (Nat.add_zero p)
    exact heq_of_eq (singularCohomologyCup_one_right c)
  mul_assoc := by
    rintro ⟨p, c⟩ ⟨q, d⟩ ⟨r, e⟩
    apply Sigma.ext (Nat.add_assoc p q r)
    change HEq
      (singularCohomologyCup X (p + q) r ((p + q) + r) rfl
        (singularCohomologyCup X p q (p + q) rfl c d) e)
      (singularCohomologyCup X p (q + r) (p + (q + r)) rfl c
        (singularCohomologyCup X q r (q + r) rfl d e))
    exact (heq_of_eq (singularCohomologyCup_assoc c d e rfl rfl rfl)).trans
      (singularCohomologyCup_heq _ _ (by omega) rfl)
  natCast n := n • singularCohomologyOne X
  natCast_zero := zero_smul _ _
  natCast_succ n := succ_nsmul _ _
  intCast
    | .ofNat n => n • singularCohomologyOne X
    | .negSucc n => -((n + 1) • singularCohomologyOne X)
  intCast_ofNat n := rfl
  intCast_negSucc_ofNat n := rfl

private theorem singularCohomologyCup_zsmul_one_left {p : ℕ} (z : ℤ)
    (c : IntegralSingularCohomology X p) :
    singularCohomologyCup X 0 p p (Nat.zero_add p) (z • singularCohomologyOne X) c =
      z • c := by
  have h := (singularCohomologyCup X 0 p p (Nat.zero_add p)).toAddMonoidHom.map_zsmul z
    (singularCohomologyOne X)
  have he := congrArg (fun f => f c) h
  change singularCohomologyCup X 0 p p (Nat.zero_add p) (z • singularCohomologyOne X) c =
    z • singularCohomologyCup X 0 p p (Nat.zero_add p) (singularCohomologyOne X) c at he
  rw [singularCohomologyCup_one_left] at he
  exact he

private theorem singularCohomologyCup_zsmul_one_right {p : ℕ} (z : ℤ)
    (c : IntegralSingularCohomology X p) :
    singularCohomologyCup X p 0 p rfl c (z • singularCohomologyOne X) = z • c := by
  have h := (singularCohomologyCup X p 0 p rfl c).toAddMonoidHom.map_zsmul z
    (singularCohomologyOne X)
  change singularCohomologyCup X p 0 p rfl c (z • singularCohomologyOne X) =
    z • singularCohomologyCup X p 0 p rfl c (singularCohomologyOne X) at h
  rw [singularCohomologyCup_one_right] at h
  exact h

/-- Integer scalars act componentwise on the integral singular cohomology ring. -/
instance integralSingularCohomologyGAlgebra (X : TopCat) :
    DirectSum.GAlgebra ℤ (fun n => (IntegralSingularCohomology X n : Type _)) where
  toFun := zmultiplesHom (IntegralSingularCohomology X 0) (singularCohomologyOne X)
  map_one := one_zsmul _
  map_mul r s := by
    apply Sigma.ext (Nat.zero_add 0).symm
    apply heq_of_eq
    change (r * s) • singularCohomologyOne X =
      singularCohomologyCup X 0 0 0 rfl (r • singularCohomologyOne X)
        (s • singularCohomologyOne X)
    rw [singularCohomologyCup_zsmul_one_left]
    exact mul_zsmul _ _ _
  commutes := by
    rintro r ⟨p, c⟩
    apply Sigma.ext (Nat.zero_add p)
    change HEq
      (singularCohomologyCup X 0 p (0 + p) rfl (r • singularCohomologyOne X) c)
      (singularCohomologyCup X p 0 p rfl c (r • singularCohomologyOne X))
    exact (singularCohomologyCup_heq _ _ rfl (Nat.zero_add p)).trans
      (heq_of_eq ((singularCohomologyCup_zsmul_one_left r c).trans
        (singularCohomologyCup_zsmul_one_right r c).symm))
  smul_def := by
    rintro r ⟨p, c⟩
    apply Sigma.ext (Nat.zero_add p).symm
    refine (heq_of_eq (Int.cast_smul_eq_zsmul ℤ r c)).trans ?_
    exact (heq_of_eq (singularCohomologyCup_zsmul_one_left r c).symm).trans
      (singularCohomologyCup_heq _ _ (Nat.zero_add p) rfl)

/-- The integral singular cohomology ring, graded by cohomological degree. -/
abbrev IntegralSingularCohomologyRing (X : TopCat) :=
  ⨁ n : ℕ, IntegralSingularCohomology X n

/-- Products of homogeneous inclusions are given by the singular cup product. -/
theorem singularCohomologyRing_lof_mul_lof (X : TopCat) (p q n : ℕ) (h : p + q = n)
    (c : IntegralSingularCohomology X p) (d : IntegralSingularCohomology X q) :
    DirectSum.lof ℤ ℕ (fun i => (IntegralSingularCohomology X i : Type _)) p c *
        DirectSum.lof ℤ ℕ (fun i => (IntegralSingularCohomology X i : Type _)) q d =
      DirectSum.lof ℤ ℕ (fun i => (IntegralSingularCohomology X i : Type _)) n
        (singularCohomologyCup X p q n h c d) := by
  subst n
  exact DirectSum.of_mul_of
    (A := fun i => (IntegralSingularCohomology X i : Type _)) c d

/-- The inclusion of the degree-zero cup unit is the cohomology ring unit. -/
@[simp]
theorem singularCohomologyRing_lof_one (X : TopCat) :
    DirectSum.lof ℤ ℕ (fun i => (IntegralSingularCohomology X i : Type _)) 0
        (singularCohomologyOne X) =
      (1 : IntegralSingularCohomologyRing X) := rfl

end Mumford.Analytic
