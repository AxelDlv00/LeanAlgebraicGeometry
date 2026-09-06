/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotient
import Mathlib.FieldTheory.Galois.IsGaloisGroup

/-!
# Function fields of finite invariant quotients

The finite-group action on a domain extends canonically to its fraction field,
which is Galois over the fraction field of the fixed subalgebra. Faithfulness
is needed only to identify the Galois group with the original acting group.
-/

set_option autoImplicit false

namespace MilneLib

open scoped Pointwise

variable {k A G : Type*} [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [Finite G] [MulSemiringAction G A] [SMulCommClass G k A]
  [IsDomain A]

noncomputable section

omit [Finite G] [IsDomain A] in
/-- A faithful action is a Galois-group action over the fixed subalgebra. -/
theorem fixedSubalgebra_isGaloisGroup [FaithfulSMul G A] :
    IsGaloisGroup G (FixedPoints.subalgebra k A G) A := by
  exact
    { faithful := inferInstance
      commutes := inferInstance
      isInvariant := fixedSubalgebra_isInvariant }

/-- The action on a domain extends to its fraction field, and the resulting
extension over the fraction field of the fixed subalgebra is Galois with group
`G`. -/
theorem fixedSubalgebra_fractionRing_isGaloisGroup [FaithfulSMul G A] :
    let S := FixedPoints.subalgebra k A G
    letI : Algebra S A := inferInstance
    letI : Algebra (FractionRing S) (FractionRing A) :=
      FractionRing.liftAlgebra S (FractionRing A)
    letI : IsScalarTower S (FractionRing S) (FractionRing A) :=
      FractionRing.isScalarTower_liftAlgebra S (FractionRing A)
    letI : MulSemiringAction G (FractionRing A) :=
      IsFractionRing.mulSemiringAction G S A (FractionRing S) (FractionRing A)
    IsGaloisGroup G (FractionRing S) (FractionRing A) := by
  let S := FixedPoints.subalgebra k A G
  letI : Algebra S A := inferInstance
  letI : Algebra (FractionRing S) (FractionRing A) :=
    FractionRing.liftAlgebra S (FractionRing A)
  letI : IsScalarTower S (FractionRing S) (FractionRing A) :=
    FractionRing.isScalarTower_liftAlgebra S (FractionRing A)
  letI : MulSemiringAction G (FractionRing A) :=
    IsFractionRing.mulSemiringAction G S A (FractionRing S) (FractionRing A)
  letI : IsGaloisGroup G S A := fixedSubalgebra_isGaloisGroup
  exact IsGaloisGroup.to_isFractionRing G S A (FractionRing S) (FractionRing A)

/-- The function field of a finite invariant quotient is a Galois extension of
the function field of the quotient.  The action is replaced internally by its
finite image, so no faithfulness hypothesis on `G` is needed. -/
theorem fixedSubalgebra_fractionRing_isGalois :
    let S := FixedPoints.subalgebra k A G
    letI : Algebra S A := inferInstance
    letI : Algebra (FractionRing S) (FractionRing A) :=
      FractionRing.liftAlgebra S (FractionRing A)
    IsGalois (FractionRing S) (FractionRing A) := by
  let S := FixedPoints.subalgebra k A G
  let H := (MulSemiringAction.toRingAut G A).range
  letI : MulSemiringAction H A := H.mulSemiringAction
  letI : Algebra S A := inferInstance
  letI : Finite H := Finite.of_surjective
    (fun g : G => (⟨MulSemiringAction.toRingAut G A g, ⟨g, rfl⟩⟩ : H)) (by
      rintro ⟨_, ⟨g, rfl⟩⟩
      exact ⟨g, rfl⟩)
  letI : SMulCommClass H S A := ⟨fun (h : H) (s : S) (a : A) => by
    have hs : h • (s : A) = (s : A) := by
      rcases h.property with ⟨g, hg⟩
      rw [Subgroup.smul_def, RingAut.smul_def, ← hg]
      change g • (s : A) = (s : A)
      exact s.property g
    have hs' : h • (algebraMap S A s) = algebraMap S A s := by simpa using hs
    change h • ((algebraMap S A) s * a) = (algebraMap S A) s * (h • a)
    rw [smul_mul', hs']
  ⟩
  letI : IsGaloisGroup H S A := by
    refine { faithful := inferInstance, commutes := inferInstance, isInvariant := ?_ }
    refine ⟨fun a ha => ?_⟩
    have hG : ∀ g : G, g • a = a := fun g => by
      have hh := ha (⟨MulSemiringAction.toRingAut G A g, ⟨g, rfl⟩⟩ : H)
      change (MulSemiringAction.toRingAut G A g) a = a at hh
      simpa [MulSemiringAction.toRingAut_apply, RingAut.smul_def] using hh
    exact (fixedSubalgebra_isInvariant (k := k) (A := A) (G := G)).isInvariant a hG
  letI : Algebra (FractionRing S) (FractionRing A) :=
    FractionRing.liftAlgebra S (FractionRing A)
  letI : IsScalarTower S (FractionRing S) (FractionRing A) :=
    FractionRing.isScalarTower_liftAlgebra S (FractionRing A)
  letI : MulSemiringAction H (FractionRing A) :=
    IsFractionRing.mulSemiringAction H S A (FractionRing S) (FractionRing A)
  letI : IsGaloisGroup H (FractionRing S) (FractionRing A) :=
    IsGaloisGroup.to_isFractionRing H S A (FractionRing S) (FractionRing A)
  exact IsGaloisGroup.isGalois H (FractionRing S) (FractionRing A)

/-- In particular, the function-field extension of a finite invariant quotient
is separable. -/
theorem fixedSubalgebra_fractionRing_isSeparable :
    let S := FixedPoints.subalgebra k A G
    letI : Algebra S A := inferInstance
    letI : Algebra (FractionRing S) (FractionRing A) :=
      FractionRing.liftAlgebra S (FractionRing A)
    Algebra.IsSeparable (FractionRing S) (FractionRing A) := by
  let S := FixedPoints.subalgebra k A G
  letI : Algebra S A := inferInstance
  letI : Algebra (FractionRing S) (FractionRing A) :=
    FractionRing.liftAlgebra S (FractionRing A)
  letI : IsGalois (FractionRing S) (FractionRing A) :=
    fixedSubalgebra_fractionRing_isGalois (k := k) (A := A) (G := G)
  exact IsGalois.to_isSeparable

end

end MilneLib
