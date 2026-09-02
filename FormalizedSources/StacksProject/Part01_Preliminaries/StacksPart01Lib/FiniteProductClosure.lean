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

/-- A finite dependent product extension is integrally closed exactly when
each component extension is integrally closed. -/
theorem isIntegrallyClosedIn_piMap_iff
    {ι : Type*} {R S : ι → Type*} [Finite ι]
    [∀ i, CommRing (R i)] [∀ i, CommRing (S i)]
    (f : ∀ i, R i →+* S i) :
    @IsIntegrallyClosedIn (∀ i, R i) (∀ i, S i) _ _ (RingHom.piMap f).toAlgebra ↔
      ∀ i, @IsIntegrallyClosedIn (R i) (S i) _ _ (f i).toAlgebra := by
  classical
  rw [@isIntegrallyClosedIn_iff (∀ i, R i) _ (∀ i, S i) _
      (RingHom.piMap f).toAlgebra]
  constructor
  · intro h i
    rw [@isIntegrallyClosedIn_iff (R i) _ (S i) _ (f i).toAlgebra]
    letI : Algebra (R i) (S i) := (f i).toAlgebra
    constructor
    · intro a b hab
      let aa : ∀ j, R j := Function.update (fun _ => 0) i a
      let bb : ∀ j, R j := Function.update (fun _ => 0) i b
      have hmap : RingHom.piMap f aa = RingHom.piMap f bb := by
        ext j
        by_cases hji : j = i
        · subst j
          change f i (aa i) = f i (bb i)
          simpa [aa, bb, RingHom.algebraMap_toAlgebra] using hab
        · simp [RingHom.piMap, aa, bb, hji]
      have hcoord := congrArg (fun z => z i) (h.1 hmap)
      simpa [aa, bb] using hcoord
    · intro a ha
      change (f i).IsIntegralElem a at ha
      let z : ∀ j, S j := Function.update (fun _ => 0) i a
      have hcomp : ∀ j, (f j).IsIntegralElem (z j) := by
        intro j
        by_cases hji : j = i
        · subst j
          simpa [z] using ha
        · simpa [z, hji] using (RingHom.isIntegralElem_zero (f j))
      letI : Algebra (∀ j, R j) (∀ j, S j) := (RingHom.piMap f).toAlgebra
      have hz : IsIntegral (∀ j, R j) z := by
        change (RingHom.piMap f).IsIntegralElem z
        exact (isIntegralElem_piMap_iff f z).mpr hcomp
      obtain ⟨x, hx⟩ := h.2 hz
      refine ⟨x i, ?_⟩
      change f i (x i) = a
      have hcoord := congrArg (fun z => z i) hx
      change (RingHom.piMap f) x i = z i at hcoord
      simpa [RingHom.piMap, z] using hcoord
  · intro h
    have hc : ∀ i, Function.Injective (f i) ∧
        ∀ {x : S i}, (f i).IsIntegralElem x → ∃ y, f i y = x := by
      intro i
      letI : Algebra (R i) (S i) := (f i).toAlgebra
      have hi := (@isIntegrallyClosedIn_iff (R i) _ (S i) _ (f i).toAlgebra).mp (h i)
      constructor
      · intro a b hab
        apply hi.1
        simpa only [RingHom.algebraMap_toAlgebra] using hab
      · intro x hx
        have hx' : IsIntegral (R i) x := hx
        obtain ⟨y, hy⟩ := hi.2 hx'
        refine ⟨y, ?_⟩
        simpa only [RingHom.algebraMap_toAlgebra] using hy
    constructor
    · intro a b hab
      have hab' : (RingHom.piMap f) a = (RingHom.piMap f) b := by
        simpa only [RingHom.algebraMap_toAlgebra] using hab
      funext i
      apply (hc i).1
      exact congrArg (fun z => z i) hab'
    · intro x hx
      letI : Algebra (∀ j, R j) (∀ j, S j) := (RingHom.piMap f).toAlgebra
      change (RingHom.piMap f).IsIntegralElem x at hx
      have hxi : ∀ i, (f i).IsIntegralElem (x i) :=
        (isIntegralElem_piMap_iff f x).mp hx
      choose y hy using fun i => (hc i).2 (hxi i)
      refine ⟨y, ?_⟩
      change (RingHom.piMap f) y = x
      funext i
      exact hy i

end StacksPart01
