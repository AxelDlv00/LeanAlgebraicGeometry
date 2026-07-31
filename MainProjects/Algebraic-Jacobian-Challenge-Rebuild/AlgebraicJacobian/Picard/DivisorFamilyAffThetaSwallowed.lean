/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyAffThetaFinite
import AlgebraicJacobian.Picard.DivisorFamilyAffThetaCech
import AlgebraicJacobian.Picard.DivisorFamilyAffGlue

/-!
# Intrinsic theta descent on a swallowed widened cover

On a cover `SwallowedBy d`, one affine piece contains the whole divisor support and every
other piece misses it.  The ordinary colength Cech differential is therefore zero.  The same
collapse holds for the intrinsic theta quotients: off the swallowing diagonal the overlap
colength, hence its invertible theta quotient, is trivial; on the diagonal the two restriction
maps agree.

This file records that collapse in the intrinsic, chart-free theta model.  It is the reduction
needed to transport the invertible module on the swallowing piece to the global equalizer,
without a `ChartTyping` or an additional certificate clause.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Opposite TopologicalSpace

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable {pi : C.left ⟶ P1 k} [IsFinite pi] [IsProper C.hom]
variable {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}

namespace AffAdaptation

attribute [local instance] thetaPieceQuotientModule thetaOverlapQuotientModule
  thetaPieceQuotientBaseModule thetaOverlapQuotientBaseModule
  thetaPieceQuotientGluedModule thetaOverlapQuotientGluedModule

/-- On a diagonal overlap, the two intrinsic theta restriction maps agree. -/
theorem thetaToOverlap_diag_eq (A : AffAdaptation D d) (a : Nat) (i : D.index) :
    A.thetaToOverlapLeft (π := pi) a i i =
      A.thetaToOverlapRight (π := pi) a i i := by
  apply DFunLike.ext _ _
  intro x
  induction x using Submodule.Quotient.induction_on with
  | _ s =>
      rw [A.thetaToOverlapLeft_mk, A.thetaToOverlapRight_mk]

/-- On a swallowed cover the intrinsic theta Cech differential is zero. -/
theorem thetaIntrinsicDeltaSub_eq_zero_of_swallowedBy (A : AffAdaptation D d)
    (a : Nat) (h : D.SwallowedBy d) :
    A.thetaIntrinsicDeltaLeftGlued (π := pi) a -
        A.thetaIntrinsicDeltaRightGlued (π := pi) a = 0 := by
  obtain ⟨j0, _, hmiss⟩ := h
  apply LinearMap.ext
  intro s
  funext p
  by_cases hp : p.1 = p.2
  · obtain ⟨i, j⟩ := p
    cases hp
    simp only [LinearMap.sub_apply, thetaIntrinsicDeltaLeftGlued,
      thetaIntrinsicDeltaRightGlued, LinearMap.pi_apply, LinearMap.coe_comp,
      Function.comp_apply, LinearMap.proj_apply, Pi.sub_apply,
      thetaToOverlapLeftGlued, thetaToOverlapRightGlued]
    have hdiag := DFunLike.congr_fun (A.thetaToOverlap_diag_eq a i) (s i)
    exact sub_eq_zero.mpr hdiag
  · haveI : Subsingleton (A.ovlColength p.1 p.2) := by
      by_cases h1 : p.1 = j0
      · exact A.subsingleton_ovlColength_of_swallowedBy hmiss p.1 p.2
          (Or.inr fun h2 => hp (h1.trans h2.symm))
      · exact A.subsingleton_ovlColength_of_swallowedBy hmiss p.1 p.2 (Or.inl h1)
    haveI : Subsingleton (A.ThetaOverlapQuotient (π := pi) a p.1 p.2) :=
      Module.subsingleton (A.ovlColength p.1 p.2)
        (A.ThetaOverlapQuotient (π := pi) a p.1 p.2)
    exact Subsingleton.elim _ _

/-- Hence every family of piece theta quotients satisfies the intrinsic Cech condition. -/
theorem intrinsicThetaGluedKernelOver_eq_top_of_swallowedBy
    (A : AffAdaptation D d) (a : Nat) (h : D.SwallowedBy d) :
    A.intrinsicThetaGluedKernelOver (π := pi) a = ⊤ := by
  rw [intrinsicThetaGluedKernelOver,
    A.thetaIntrinsicDeltaSub_eq_zero_of_swallowedBy a h]
  exact LinearMap.ker_zero

/-- On a swallowed cover, intrinsic theta descent is the whole product of piece quotients. -/
noncomputable def intrinsicThetaGluedOverEquivPieceProdOfSwallowedBy
    (A : AffAdaptation D d) (a : Nat) (h : D.SwallowedBy d) :
    A.IntrinsicThetaGluedOver (π := pi) a ≃ₗ[↥(gluedSubalgebra A)]
      A.ThetaPieceProd (π := pi) a :=
  (LinearEquiv.ofEq _ _ (A.intrinsicThetaGluedOver_eq_ker (π := pi) a)).trans
    ((LinearEquiv.ofEq _ _
      (A.intrinsicThetaGluedKernelOver_eq_top_of_swallowedBy (pi := pi) a h)).trans
      Submodule.topEquiv)

end AffAdaptation

end AlgebraicGeometry
