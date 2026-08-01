/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyAffThetaProductBaseChange
import AlgebraicJacobian.Picard.DivisorFamilyAffGlue
import AlgebraicJacobian.Descent.ModuleDescent

/-!
# The left theta face as a descent coaction

The product/base-change file identifies the tensor square of the chart algebra with the
intrinsic right theta Cech face.  This file records the complementary left face as a
chart-product-linear map and transports it back through that equivalence.  The result is the
candidate coaction consumed by `Module.DescentDatum`.

Only the existing certificate `A.IsCertified n` is used.  The counit and coassociativity laws
are intentionally left as separate obligations: recording the coaction and its pointwise
formula makes those laws directly testable without pretending that the left face itself is an
isomorphism under the right-factor scalar action.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Opposite TopologicalSpace
open scoped TensorProduct

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable {π : C.left ⟶ P1 k} [IsFinite π] [IsProper C.hom]
variable {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}

namespace AffAdaptation

attribute [local instance] thetaPieceSectionsModule thetaOverlapSectionsModule
  thetaPieceQuotientModule thetaOverlapQuotientModule
  thetaOverlapQuotientLeftModule thetaOverlapQuotientLeftTower
  thetaPieceQuotientGluedModule thetaOverlapQuotientGluedModule
  chartProdPieceAlgebra chartProdOverlapAlgebra thetaPieceProdADModule
  thetaPieceProdCPModule thetaPieceProdTower thetaOverlapProdOvlModule
  thetaOverlapQuotientCPModule thetaOverlapProdCPModule thetaOverlapProdADModule
  thetaOverlapProdTower

noncomputable section

variable (A : AffAdaptation D d) (a : ℕ)

omit [IsProper C.hom] in
lemma ovlColengthDiagEquiv_toOvlLeft (i : D.index) (x : A.colength i) :
    A.ovlColengthDiagEquiv i (A.toOvlLeft i i x) = x := by
  obtain ⟨r, rfl⟩ := Ideal.Quotient.mk_surjective x
  rw [A.toOvlLeft_mk]
  unfold ovlColengthDiagEquiv
  rw [Ideal.quotientEquivAlg_mk]
  change (Ideal.Quotient.mk (Ideal.span {A.eqn i}))
      ((sectionsInfSelfEquiv i) (relResAlgHom C R inf_le_left r)) = _
  rw [sectionsInfSelfEquiv_relResAlgHom]

omit [IsProper C.hom] in
lemma ovlColengthDiagEquiv_toOvlRight (i : D.index) (x : A.colength i) :
    A.ovlColengthDiagEquiv i (A.toOvlRight i i x) = x := by
  obtain ⟨r, rfl⟩ := Ideal.Quotient.mk_surjective x
  rw [A.toOvlRight_mk]
  unfold ovlColengthDiagEquiv
  rw [Ideal.quotientEquivAlg_mk]
  change (Ideal.Quotient.mk (Ideal.span {A.eqn i}))
      ((sectionsInfSelfEquiv i) (relResAlgHom C R inf_le_right r)) = _
  rw [sectionsInfSelfEquiv_relResAlgHom]

theorem thetaToOverlap_diag_eq (i : D.index) :
    A.thetaToOverlapLeft (π := π) a i i =
      A.thetaToOverlapRight (π := π) a i i := by
  apply DFunLike.ext _ _
  intro x
  induction x using Submodule.Quotient.induction_on with
  | _ s =>
      rw [A.thetaToOverlapLeft_mk, A.thetaToOverlapRight_mk]

/-- The left Cech arrow is linear over the product piece algebra: both the source and the
overlap target use the first piece coordinate. -/
noncomputable def thetaIntrinsicDeltaLeftCP :
    A.ThetaPieceProd (π := π) a →ₗ[A.chartProd]
      A.ThetaOverlapProd (π := π) a where
  toFun := A.thetaIntrinsicDeltaLeftGlued (π := π) a
  map_add' := (A.thetaIntrinsicDeltaLeftGlued (π := π) a).map_add
  map_smul' := by
    intro b s
    funext p
    change A.thetaToOverlapLeft (π := π) a p.1 p.2 (b p.1 • s p.1) =
      A.toOvlLeft p.1 p.2 (b p.1) •
        A.thetaToOverlapLeft (π := π) a p.1 p.2 (s p.1)
    exact A.thetaToOverlapLeft_smul (π := π) a p.1 p.2 (b p.1) (s p.1)

@[simp]
theorem thetaIntrinsicDeltaLeftCP_apply
    (s : A.ThetaPieceProd (π := π) a) (p : D.index × D.index) :
    A.thetaIntrinsicDeltaLeftCP (π := π) a s p =
      A.thetaToOverlapLeft (π := π) a p.1 p.2 (s p.1) := by
  rfl

/- The left face transported through the right tensor comparison is the candidate descent
coaction on the product of local theta lines. -/
noncomputable def thetaDescentCoaction {n : ℕ} (hc : A.IsCertified n) :
    A.ThetaPieceProd (π := π) a →ₗ[A.chartProd]
      A.chartProd ⊗[↥(gluedSubalgebra A)] A.ThetaPieceProd (π := π) a :=
  (A.thetaPieceProdBaseChangeToOverlapEquiv (π := π) a hc).symm.toLinearMap.comp
    (A.thetaIntrinsicDeltaLeftCP (π := π) a)

@[simp]
theorem thetaPieceProdBaseChangeToOverlapEquiv_coaction {n : ℕ}
    (hc : A.IsCertified n) (s : A.ThetaPieceProd (π := π) a) :
    A.thetaPieceProdBaseChangeToOverlapEquiv (π := π) a hc
        (A.thetaDescentCoaction (π := π) a hc s) =
      A.thetaIntrinsicDeltaLeftCP (π := π) a s := by
  simp [thetaDescentCoaction]

@[simp]
theorem thetaPieceProdBaseChangeToOverlapEquiv_coaction_apply {n : ℕ}
    (hc : A.IsCertified n) (s : A.ThetaPieceProd (π := π) a)
    (p : D.index × D.index) :
    A.thetaPieceProdBaseChangeToOverlapEquiv (π := π) a hc
        (A.thetaDescentCoaction (π := π) a hc s) p =
      A.thetaToOverlapLeft (π := π) a p.1 p.2 (s p.1) := by
  rw [thetaPieceProdBaseChangeToOverlapEquiv_coaction]
  rfl

end

end AffAdaptation

end AlgebraicGeometry
