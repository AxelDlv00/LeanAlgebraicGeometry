/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyAffThetaProductBaseChange
import AlgebraicJacobian.Picard.DivisorFamilyAffThetaTripleBaseChange
import AlgebraicJacobian.Picard.DivisorSubschemeTensorTriple

/-!
# Product base change to intrinsic triple theta quotients

The first pairwise theta quotient restricts to a triple intersection by base change.
The affine divisor pushout square identifies the same triple coefficient ring with the
base change of the pairwise coefficient ring along the third piece.  Combining these
facts gives, for every triple,

`colength l ⊗[gluedSubalgebra A] ThetaOverlapQuotient i j ≃ ThetaTripleQuotient i j l`.

This is the component comparison used to test equality of the two base-changed Cech
faces.  It uses only the existing certification of the widened affine adaptation.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
universe u

open CategoryTheory Opposite TopologicalSpace
open CategoryTheory.Limits
open scoped TensorProduct

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable {π : C.left ⟶ P1 k} [IsFinite π] [IsProper C.hom]
variable {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}

namespace AffAdaptation

attribute [local instance] thetaOverlapQuotientModule thetaTripleQuotientModule
  thetaOverlapQuotientGluedModule overlap12ToTripleAlgebra
  gluedSubalgebraTripleAlgebra

noncomputable section

variable (A : AffAdaptation D d) (a : ℕ)

/-- The triple coefficient ring as an algebra over its third piece. -/
@[reducible]
noncomputable def pieceThirdToTripleAlgebra (i j l : D.index) :
    Algebra (A.colength l) (A.tripleColength i j l) :=
  (A.pieceToTripleThird i j l).toRingHom.toAlgebra

attribute [local instance] pieceThirdToTripleAlgebra

set_option synthInstance.maxHeartbeats 100000 in
-- The dependent overlap and triple algebras require a larger synthesis budget.
/-- The global-to-overlap-to-triple scalar tower is the chosen global algebra structure
on the triple ring. -/
@[reducible]
noncomputable def gluedOverlapTripleTower (i j l : D.index) :
    IsScalarTower (gluedSubalgebra A) (A.ovlColength i j)
      (A.tripleColength i j l) :=
  IsScalarTower.of_algebraMap_eq fun _ => rfl

attribute [local instance] gluedOverlapTripleTower

set_option synthInstance.maxHeartbeats 100000 in
-- The dependent piece and triple algebras require a larger synthesis budget.
/-- Commutativity of the geometric pushout square supplies the other scalar tower. -/
@[reducible]
noncomputable def IsCertified.gluedPieceThirdTripleTower {n : ℕ}
    (hc : A.IsCertified n) (i j l : D.index) :
    IsScalarTower (gluedSubalgebra A) (A.colength l)
      (A.tripleColength i j l) := by
  apply IsScalarTower.of_algebraMap_eq
  intro c
  exact congrArg (fun f => f.hom c)
    (hc.isPushout_gluedSubalgebraOverlapPieceMaps A i j l).w

/-- The triple quotient restricted to the third piece coefficient ring. -/
@[reducible]
noncomputable def thetaTripleQuotientPieceThirdModule (i j l : D.index) :
    Module (A.colength l) (A.ThetaTripleQuotient (π := π) a i j l) :=
  Module.compHom _ (A.pieceToTripleThird i j l).toRingHom

attribute [local instance] thetaTripleQuotientPieceThirdModule

/-- The third-piece/triple-ring scalar tower on the intrinsic triple quotient. -/
@[reducible]
noncomputable def pieceThirdTripleThetaTower (i j l : D.index) :
    IsScalarTower (A.colength l) (A.tripleColength i j l)
      (A.ThetaTripleQuotient (π := π) a i j l) :=
  IsScalarTower.of_algebraMap_smul fun _ _ => rfl

attribute [local instance] pieceThirdTripleThetaTower

set_option synthInstance.maxHeartbeats 100000 in
-- The dependent overlap algebra and quotient module require a larger synthesis budget.
/-- The global/overlap scalar tower on a pairwise theta quotient. -/
@[reducible]
noncomputable def gluedOverlapThetaTower (i j : D.index) :
    IsScalarTower (gluedSubalgebra A) (A.ovlColength i j)
      (A.ThetaOverlapQuotient (π := π) a i j) :=
  IsScalarTower.of_algebraMap_smul fun _ _ => rfl

attribute [local instance] gluedOverlapThetaTower

set_option synthInstance.maxHeartbeats 500000 in
-- Four dependent coefficient algebras meet in the pushout comparison.
/-- Base change of a pairwise theta quotient along a third divisor piece is the
intrinsic theta quotient on the corresponding triple intersection. -/
noncomputable def IsCertified.thetaOverlapBaseChangeToTripleCoord {n : ℕ}
    (hc : A.IsCertified n) (i j l : D.index) :
    A.colength l ⊗[gluedSubalgebra A]
        A.ThetaOverlapQuotient (π := π) a i j
      ≃ₗ[A.colength l]
        A.ThetaTripleQuotient (π := π) a i j l := by
  letI := hc.gluedPieceThirdTripleTower A i j l
  let hpush : Algebra.IsPushout (gluedSubalgebra A) (A.ovlColength i j)
      (A.colength l) (A.tripleColength i j l) :=
    CommRingCat.isPushout_iff_isPushout.mp
      (hc.isPushout_gluedSubalgebraOverlapPieceMaps A i j l)
  letI : Algebra.IsPushout (gluedSubalgebra A) (A.colength l)
      (A.ovlColength i j) (A.tripleColength i j l) :=
    Algebra.IsPushout.symm hpush
  let e := (Algebra.IsPushout.cancelBaseChange
    (gluedSubalgebra A) (A.colength l) (A.ovlColength i j)
      (A.tripleColength i j l)
      (A.ThetaOverlapQuotient (π := π) a i j)).symm
  exact e.trans ((A.thetaOverlap12BaseChangeToTripleEquiv
    (π := π) a i j l).restrictScalars (A.colength l))

set_option synthInstance.maxHeartbeats 500000 in
-- Elaborating the dependent pure tensor repeats the pushout instance search.
@[simp]
theorem IsCertified.thetaOverlapBaseChangeToTripleCoord_tmul {n : ℕ}
    (hc : A.IsCertified n) (i j l : D.index) (c : A.colength l)
    (x : A.ThetaOverlapQuotient (π := π) a i j) :
    hc.thetaOverlapBaseChangeToTripleCoord A a i j l
        (c ⊗ₜ[gluedSubalgebra A] x) =
      A.pieceToTripleThird i j l c •
        A.thetaOverlapToTriple (π := π) a i j i j l
          (A.thetaTripleOpen_le_pair12 i j l) x := by
  simp only [IsCertified.thetaOverlapBaseChangeToTripleCoord,
    LinearEquiv.trans_apply, LinearEquiv.restrictScalars_apply,
    Algebra.IsPushout.cancelBaseChange_symm_tmul,
    thetaOverlap12BaseChangeToTripleEquiv_tmul]
  rfl

end

end AffAdaptation

end AlgebraicGeometry
