/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Cohomology.GluedSheafExtraction
import AlgebraicJacobian.Picard.ThetaShift

/-!
# The lambda-tied datum underlying a native rank-one presentation

Every affine Picard value is represented on an etale cover. This file exposes that actual
representative and refines its relative Picard class to a basic-open cocycle datum. The output is
tied to the displayed value; it makes no cohomology, rank, evaluation-divisor, or base-change
claim.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits TopologicalSpace Opposite MonoidalCategory
  CartesianMonoidalCategory

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable {A : Type u} [CommRing A] [Algebra k A]
variable (pi : C.left ⟶ P1 k) [IsFinite pi]

/--
The part of a native presentation forced by the displayed Picard value.

`represents` ties the etale-plus representative to `lam`, while `datum_class` ties the
basic-open cocycle datum to that same representative. The geometric certificates that enrich
this datum are intentionally absent.
-/
structure PicRankOneNativeDatum
    (lam : picDegLayer C (genus C : ℤ) (overSpec k A)) : Type (u + 1) where
  cover : Algebra.EtaleCover A
  representative : descentClasses C cover
  represents :
    PicEtAff.mk C cover representative = picEtAffineEquiv C A lam.1
  datum : BasicOpenCocycleDatum C cover.Carrier pi
  datum_class :
    (representative : relPic C (overSpec k cover.Carrier)) =
      relPicMk C (overSpec k cover.Carrier) datum.cechPicClass

namespace PicRankOneNativeDatum

/-- Every displayed affine Picard value has a tied basic-open cocycle datum.

The proof exposes an etale-plus representative of the displayed value, chooses a Cech
representative of its relative Picard class, and refines that class to a basic-open datum.
-/
theorem nonempty
    (pi : C.left ⟶ P1 k) [IsFinite pi]
    (lam : picDegLayer C (genus C : ℤ) (overSpec k A)) :
    Nonempty (PicRankOneNativeDatum pi lam) := by
  have hplus : ∀ a : PicEtAff C A,
      ∃ (E : Algebra.EtaleCover A) (x : descentClasses C E),
        PicEtAff.mk C E x = a := by
    intro a
    induction a using PicEtAff.ind with
    | mk E x => exact ⟨E, x, rfl⟩
  obtain ⟨E, x, hrep⟩ := hplus (picEtAffineEquiv C A lam.1)
  obtain ⟨c, hc⟩ := relPicMk_surjective C (overSpec k E.Carrier)
    (x : relPic C (overSpec k E.Carrier))
  obtain ⟨D, hD⟩ := BasicOpenCocycleDatum.exists_cechPicClass_eq
    (C := C) (B := E.Carrier) (π := pi) c
  refine ⟨
    { cover := E
      representative := x
      represents := hrep
      datum := D
      datum_class := ?_ }⟩
  calc
    (x : relPic C (overSpec k E.Carrier)) =
        relPicMk C (overSpec k E.Carrier) c := hc.symm
    _ = relPicMk C (overSpec k E.Carrier) D.cechPicClass :=
      congrArg (relPicMk C (overSpec k E.Carrier)) hD.symm

end PicRankOneNativeDatum

end AlgebraicGeometry
