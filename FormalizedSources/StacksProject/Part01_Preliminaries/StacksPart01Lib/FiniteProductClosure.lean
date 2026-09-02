/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import StacksPart01Lib.FiniteProduct

/-!
# Integral closures in finite dependent products

For a finite family of component maps with varying source rings, membership
in the integral closure of the product map is equivalent to componentwise
membership in the corresponding integral closures.
-/

namespace StacksPart01

/-! [Stacks tag 0CY9] -/

/-- Membership in the integral closure of a finite dependent product map is
componentwise membership in the integral closures of the component maps. -/
theorem mem_integralClosure_piMap_iff
    {ι : Type*} {R S : ι → Type*} [Finite ι]
    [∀ i, CommRing (R i)] [∀ i, CommRing (S i)]
    (f : ∀ i, R i →+* S i) (x : ∀ i, S i) :
    x ∈ @integralClosure (∀ i, R i) (∀ i, S i) _ _ (RingHom.piMap f).toAlgebra ↔
      ∀ i, x i ∈ @integralClosure (R i) (S i) _ _ (f i).toAlgebra := by
  rw [@mem_integralClosure_iff (∀ i, R i) (∀ i, S i) _ _
      (RingHom.piMap f).toAlgebra]
  simp only [@mem_integralClosure_iff]
  exact isIntegralElem_piMap_iff f x

namespace Subring

/-- The coordinatewise product of subrings in a dependent product ring. -/
def pi {ι : Type u} {S : ι → Type v} [∀ i, NonAssocRing (S i)]
    (T : ∀ i, _root_.Subring (S i)) : _root_.Subring (∀ i, S i) :=
  _root_.Subring.mk
    { carrier := {x | ∀ i, x i ∈ T i}
      one_mem' := by
        intro i
        exact (T i).one_mem
      mul_mem' := by
        intro a b ha hb i
        exact (T i).mul_mem (ha i) (hb i)
      zero_mem' := by
        intro i
        exact (T i).zero_mem
      add_mem' := by
        intro a b ha hb i
        exact (T i).add_mem (ha i) (hb i) }
    (by
      intro x hx i
      exact (T i).neg_mem (hx i))

end Subring

/-- The integral closure of a finite dependent product map, viewed as a
subring of the target product, is the coordinatewise product of the
component integral closures. -/
theorem integralClosure_piMap_toSubring
    {ι : Type*} {R S : ι → Type*} [Finite ι]
    [∀ i, CommRing (R i)] [∀ i, CommRing (S i)]
    (f : ∀ i, R i →+* S i) :
    @Subalgebra.toSubring (∀ i, R i) (∀ i, S i) _ _
        (RingHom.piMap f).toAlgebra
        (@integralClosure (∀ i, R i) (∀ i, S i) _ _ (RingHom.piMap f).toAlgebra) =
      Subring.pi (fun i =>
        @Subalgebra.toSubring (R i) (S i) _ _ (f i).toAlgebra
          (@integralClosure (R i) (S i) _ _ (f i).toAlgebra)) := by
  apply _root_.Subring.ext
  intro x
  exact mem_integralClosure_piMap_iff f x

end StacksPart01
