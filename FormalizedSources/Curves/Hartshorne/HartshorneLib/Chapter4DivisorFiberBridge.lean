/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4DivisorModuleFiber
import HartshorneLib.Chapter4DivisorModuleFiberLinear

/-!
# Additive descent from a divisor-module stalk to its ordinary fiber

The ordinary fiber of a scheme module is the stalk modulo the action of the
maximal ideal.  This file records the corresponding choice-free factorization
principle for the divisor-module jump map.  The jump quotient is retained as a
`k`-module, so the resulting bridge is intentionally an additive homomorphism;
no residue-field coordinate (and hence no choice-dependent linear structure)
is introduced here.
-/

set_option autoImplicit false

universe u

open scoped TensorProduct
open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

attribute [local instance] functionFieldOverModule Scheme.overModule
attribute [local instance] Scheme.Modules.stalkModule

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]

/-! ## Valuation support for the lower lattice -/

omit [IsAlgClosed k] [IsProper X.hom] in
/-- Multiplication by an element of order at most `ofAdd (-1)` lowers a
point-lattice bound by one.  This is the valuation calculation used when a
maximal-ideal scalar is shown to kill a local jump. -/
lemma pointLattice_mul_mem_sub_one {x : X.left}
    (hx : x ≠ genericPoint X.left) {n : ℤ} {r g : X.left.functionField}
    (hr : orderAt X.hom hx r ≤
      ((Multiplicative.ofAdd (-1 : ℤ) : Multiplicative ℤ) :
        WithZero (Multiplicative ℤ)))
    (hg : g ∈ pointLattice (X := X) hx n) :
    r * g ∈ pointLattice (X := X) hx (n - 1) := by
  rw [mem_pointLattice] at hg ⊢
  rw [map_mul]
  calc
    orderAt X.hom hx r * orderAt X.hom hx g ≤
        ((Multiplicative.ofAdd (-1 : ℤ) : Multiplicative ℤ) :
          WithZero (Multiplicative ℤ)) *
          ((Multiplicative.ofAdd n : Multiplicative ℤ) :
            WithZero (Multiplicative ℤ)) := by
      exact mul_le_mul' hr hg
    _ = ((Multiplicative.ofAdd (n - 1) : Multiplicative ℤ) :
          WithZero (Multiplicative ℤ)) := by
      rw [← WithZero.coe_mul, ← ofAdd_add]
      congr 1
      ring_nf

private lemma ord_lt_one_iff_bridge (z : WithZero (Multiplicative ℤ)) : z < 1 ↔
    z ≤ ((Multiplicative.ofAdd (-1 : ℤ) : Multiplicative ℤ) :
      WithZero (Multiplicative ℤ)) := by
  induction z using WithZero.recZeroCoe with
  | zero => exact iff_of_true zero_lt_one zero_le
  | coe w =>
    rw [← WithZero.coe_one, WithZero.coe_lt_coe, WithZero.coe_le_coe, ← ofAdd_zero,
      ← ofAdd_toAdd w, Multiplicative.ofAdd_lt, Multiplicative.ofAdd_le]
    omega

omit [IsAlgClosed k] [IsProper X.hom] in
/-- A maximal-ideal scalar has order at most `ofAdd (-1)` after passage to the
function field. -/
lemma orderAt_algebraMap_le_neg_one_of_mem_maximalIdeal {x : X.left}
    (hx : x ≠ genericPoint X.left) {r : X.left.presheaf.stalk x}
    (hr : r ∈ IsLocalRing.maximalIdeal (X.left.presheaf.stalk x)) :
    orderAt X.hom hx
        (algebraMap (X.left.presheaf.stalk x) X.left.functionField r) ≤
      ((Multiplicative.ofAdd (-1 : ℤ) : Multiplicative ℤ) :
        WithZero (Multiplicative ℤ)) := by
  letI := smoothCurve_stalk_isDiscreteValuationRing X.hom hx
  letI := smoothCurve_stalk_isDedekindDomain X.hom hx
  set v₀ : IsDedekindDomain.HeightOneSpectrum (X.left.presheaf.stalk x) :=
    stalkHeightOne X.left x with hv₀
  have hord : orderAt X.hom hx = v₀.valuation X.left.functionField := rfl
  apply (ord_lt_one_iff_bridge _).mp
  rw [hord, IsDedekindDomain.HeightOneSpectrum.valuation_lt_one_iff_mem]
  exact hr

/-! ## Quotient descent for additive maps -/

/-- Descend an additive map through a submodule quotient when it vanishes on
the submodule.  This is the additive form of the usual first-isomorphism
factorization and does not require a scalar structure on the target. -/
def addHomOfSubmoduleQuotient {R M N : Type u} [Ring R] [AddCommGroup M]
    [Module R M] [AddCommGroup N] (P : Submodule R M) (q : M →+ N)
    (hq : ∀ m : M, m ∈ P → q m = 0) : M ⧸ P →+ N :=
  QuotientAddGroup.lift P.toAddSubgroup q (by
    intro p hp
    exact (AddMonoidHom.mem_ker).2 (hq p hp))

@[simp]
lemma addHomOfSubmoduleQuotient_mk {R M N : Type u} [Ring R] [AddCommGroup M]
    [Module R M] [AddCommGroup N] (P : Submodule R M) (q : M →+ N)
    (hq : ∀ m : M, m ∈ P → q m = 0) (m : M) :
    addHomOfSubmoduleQuotient P q hq (Submodule.Quotient.mk m) = q m := by
  apply QuotientAddGroup.lift_mk'

/-! ## The maximal-ideal action on a divisor stalk -/

/-- The submodule killed by passage from a divisor stalk to its ordinary fiber. -/
noncomputable def divisorStalkMaximalAction {x : X.left}
    (D : CurveDivisor k X) :
    Submodule (X.left.presheaf.stalk x)
      (Scheme.Modules.Stalk (divisorModule D) x) :=
  IsLocalRing.maximalIdeal (X.left.presheaf.stalk x) •
    (⊤ : Submodule (X.left.presheaf.stalk x)
      (Scheme.Modules.Stalk (divisorModule D) x))

/-- The divisor-module jump vanishes on the maximal-ideal action in its stalk.
This is the intrinsic kernel statement needed to descend the jump through the
ordinary scheme-module fiber. -/
lemma stalkJump_zero_of_mem_divisorStalkMaximalAction {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X)
    (m : Scheme.Modules.Stalk (divisorModule D) x)
    (hm : m ∈ divisorStalkMaximalAction (X := X) D) :
    stalkJump hx D m = 0 := by
  rw [stalkJump_eq_zero_iff_mem_lower_lattice hx D]
  refine Submodule.smul_induction_on hm ?_ ?_
  · intro r hr m₀ hm₀
    have hupper : stalkVal D x m₀ ∈
        pointLattice (X := X) hx (CurveDivisor.coeffAt hx D) :=
      stalkVal_mem_pointLattice hx D m₀
    have horder : orderAt X.hom hx
        (algebraMap (X.left.presheaf.stalk x) X.left.functionField r) ≤
          ((Multiplicative.ofAdd (-1 : ℤ) : Multiplicative ℤ) :
            WithZero (Multiplicative ℤ)) :=
      orderAt_algebraMap_le_neg_one_of_mem_maximalIdeal hx hr
    have hprod := pointLattice_mul_mem_sub_one hx horder hupper
    have hlin := (stalkValLinearMap (X := X) D x).map_smul r m₀
    change (stalkValLinearMap (X := X) D x) (r • m₀) ∈
      pointLattice (X := X) hx (CurveDivisor.coeffAt hx D - 1)
    rw [hlin, Algebra.smul_def]
    exact hprod
  · intro y z hy hz
    rw [map_add]
    exact (pointLattice (X := X) hx (CurveDivisor.coeffAt hx D - 1)).add_mem hy hz

/-! ## The bridge and its generator formula -/

/-- Additive descent of the divisor-module stalk jump to the ordinary fiber,
under the exact hypothesis that the jump kills the maximal-ideal action.

The hypothesis is exposed rather than hidden in a typeclass: proving it is the
substantive local compatibility statement, while this declaration packages its
formal consequence. -/
def stalkJumpFiberAddHom {x : X.left} (hx : x ≠ genericPoint X.left)
    (D : CurveDivisor k X)
    (hkill : ∀ m : Scheme.Modules.Stalk (divisorModule D) x,
      m ∈ divisorStalkMaximalAction (X := X) D →
      stalkJump hx D m = 0) :
    Scheme.Modules.stalkFiber (divisorModule D) x →+ jumpModule hx D :=
  (addHomOfSubmoduleQuotient
      (divisorStalkMaximalAction (X := X) D)
      (stalkJump hx D) hkill).comp
    (Scheme.Modules.stalkFiberEquivQuotient (divisorModule D) x).toAddEquiv.toAddMonoidHom

@[simp]
lemma stalkJumpFiberAddHom_one_tmul {x : X.left} (hx : x ≠ genericPoint X.left)
    (D : CurveDivisor k X)
    (hkill : ∀ m : Scheme.Modules.Stalk (divisorModule D) x,
      m ∈ divisorStalkMaximalAction (X := X) D →
      stalkJump hx D m = 0)
    (m : Scheme.Modules.Stalk (divisorModule D) x) :
    stalkJumpFiberAddHom hx D hkill
      (1 ⊗ₜ[X.left.presheaf.stalk x] m) = stalkJump hx D m := by
  change addHomOfSubmoduleQuotient
      (divisorStalkMaximalAction (X := X) D)
      (stalkJump hx D) hkill
      ((Scheme.Modules.stalkFiberEquivQuotient (divisorModule D) x)
        (1 ⊗ₜ[X.left.presheaf.stalk x] m)) = stalkJump hx D m
  rw [Scheme.Modules.stalkFiberEquivQuotient_one_tmul]
  unfold addHomOfSubmoduleQuotient
  apply QuotientAddGroup.lift_mk'

/-! ## Factorization statement -/

/-- The bridge composed with the canonical stalk class recovers the stalk jump.
This is the quotient universal property in the form used by divisor sections. -/
def divisorStalkFiberClass {x : X.left} (D : CurveDivisor k X) :
    Scheme.Modules.Stalk (divisorModule D) x →+
      Scheme.Modules.stalkFiber (divisorModule D) x :=
  (Scheme.Modules.stalkFiberEquivQuotient (divisorModule D) x).symm.toAddEquiv.toAddMonoidHom.comp
    (Submodule.mkQ (divisorStalkMaximalAction (X := X) D)).toAddMonoidHom

lemma stalkJumpFiberAddHom_comp_divisorStalkFiberClass
    {x : X.left} (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X)
    (hkill : ∀ m : Scheme.Modules.Stalk (divisorModule D) x,
      m ∈ divisorStalkMaximalAction (X := X) D →
      stalkJump hx D m = 0) :
    (stalkJumpFiberAddHom hx D hkill).comp
        (divisorStalkFiberClass (X := X) D) = stalkJump hx D := by
  apply AddMonoidHom.ext
  intro m
  change addHomOfSubmoduleQuotient
      (divisorStalkMaximalAction (X := X) D)
      (stalkJump hx D) hkill
      ((Scheme.Modules.stalkFiberEquivQuotient (divisorModule D) x)
        ((Scheme.Modules.stalkFiberEquivQuotient (divisorModule D) x).symm
          ((divisorStalkMaximalAction (X := X) D).mkQ m))) = stalkJump hx D m
  rw [LinearEquiv.apply_symm_apply]
  unfold addHomOfSubmoduleQuotient
  apply QuotientAddGroup.lift_mk'

/-! ## Global-section evaluation -/

lemma stalkJumpFiberAddHom_fiberEvaluation
    {x : X.left} (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X)
    (hkill : ∀ m : Scheme.Modules.Stalk (divisorModule D) x,
      m ∈ divisorStalkMaximalAction (X := X) D →
      stalkJump hx D m = 0)
    (s : Γ(divisorModule D, (⊤ : X.left.Opens))) :
    stalkJumpFiberAddHom hx D hkill
        (Scheme.Modules.fiberEvaluation (divisorModule D) x s) =
      stalkJump hx D
        (ConcreteCategory.hom
          (TopCat.Presheaf.germ (divisorModule D).val.presheaf
            (⊤ : X.left.Opens) x trivial) s) := by
  rw [Scheme.Modules.fiberEvaluation_apply]
  exact stalkJumpFiberAddHom_one_tmul hx D hkill _

end
end Hartshorne
