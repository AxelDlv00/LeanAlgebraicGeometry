/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0RankOneCanonicalDivisorStageEngine
import AlgebraicJacobian.Picard.Pic0RankOneCanonicalDivisorStageRank
import AlgebraicJacobian.Picard.Pic0RankOneCanonicalDivisorStageDegree
import AlgebraicJacobian.Cohomology.RankOneFamilyCertificatesActualDatumRank

/-!
# Rank and degree certificates at the finite stage

The expensive engine, base-change comparison, rank transport, and degree transport each live in
their own opaque declaration.  This file only packages those already checked interfaces.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory Opposite TopologicalSpace
open scoped TensorProduct

namespace AlgebraicGeometry

open AlgebraicJacobian

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable {pi : C.left ⟶ P1 k} [IsFinite pi]

noncomputable local instance stageCertOverCleft :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩

namespace PicRankOneNoetherianStage

variable {A : Type u} [CommRing A] [Algebra k A]
variable {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
variable {P : PicRankOneLocalPresentation pi lam}

set_option maxHeartbeats 2000000 in
-- The certificate constructor only invokes opaque finite-stage interfaces.
set_option synthInstance.maxHeartbeats 800000 in
/-- Package the finite-stage rank-one cohomological certificates. -/
theorem certificates (S : PicRankOneNoetherianStage P)
    (hpi : pi ≫ P1.structureMap k = C.hom) :
    RankOneFamilyCertificates (S.D0.baseChange S.A0) := by
  let D : BasicOpenCocycleDatum C S.A0 pi := S.D0.baseChange S.A0
  obtain ⟨h1, hfin, hproj⟩ := S.engine hpi
  have hdegree : ∀ (L : Type u) [Field L] [Algebra k L] [Algebra S.A0 L]
      [IsScalarTower k S.A0 L],
      classDeg L (Scheme.CechPic.map (relCurveMap C S.A0 L) D.cechPicClass)
        = (genus C : ℤ) := S.fibreClassDegree hpi
  have hrank : ∀ p : PrimeSpectrum S.A0,
      Module.rankAtStalk (Sheaf.HModule D.sheaf 0) p = 1 :=
    BasicOpenCocycleDatum.rankAtStalk_hModule_zero_eq_one_of_actualPairH1
      (n := genus C) D (chi_moduleKSheaf C) S.hpair hfin hproj hdegree
  exact ⟨h1, hfin, hproj, hrank⟩

end PicRankOneNoetherianStage

end AlgebraicGeometry
