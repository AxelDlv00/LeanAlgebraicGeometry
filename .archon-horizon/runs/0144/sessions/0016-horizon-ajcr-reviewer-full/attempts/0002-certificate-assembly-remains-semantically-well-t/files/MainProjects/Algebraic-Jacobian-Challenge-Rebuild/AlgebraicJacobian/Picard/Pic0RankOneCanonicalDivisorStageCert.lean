/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0RankOneCanonicalDivisorStageData
import AlgebraicJacobian.Picard.Pic0RankOneCanonicalDivisorDegree
import AlgebraicJacobian.Picard.Pic0RankOneCanonicalDivisorRank

/-!
# Rank and degree certificates at the finite stage
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory Opposite
open scoped TensorProduct

namespace AlgebraicGeometry

open AlgebraicJacobian

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable {pi : C.left ⟶ P1 k} [IsFinite pi]

noncomputable local instance canonicalStageCertOverCleft :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩

noncomputable local instance (priority := 20000) canonicalStageCertDegreeOver
    (L : Type u) [Field L] [Algebra k L] :
    (relCurve C L).Over (Spec (.of L)) :=
  instOverBaseChange C L

noncomputable local instance canonicalStageCertDegreeSmooth
    (L : Type u) [Field L] [Algebra k L] :
    SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (.of L)) :=
  instSmoothOfRelativeDimensionBaseChange C L

noncomputable local instance canonicalStageCertDegreeIntegral
    (L : Type u) [Field L] [Algebra k L] :
    IsIntegral (relCurve C L) :=
  instIsIntegralBaseChange C L

noncomputable local instance canonicalStageCertDegreeQuasiCompact
    (L : Type u) [Field L] [Algebra k L] :
    QuasiCompact (relCurve C L ↘ Spec (.of L)) :=
  instQuasiCompactBaseChange C L

noncomputable local instance canonicalStageCertDegreeFiniteH0
    (L : Type u) [Field L] [Algebra k L] :
    Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0) :=
  instModuleFiniteHModuleZeroBaseChange C L

noncomputable local instance canonicalStageCertDegreeFiniteH1
    (L : Type u) [Field L] [Algebra k L] :
    Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1) :=
  instModuleFiniteHModuleOneBaseChange C L

namespace PicRankOneNoetherianStage

variable {A : Type u} [CommRing A] [Algebra k A]
variable {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
variable {P : PicRankOneLocalPresentation pi lam}

set_option maxHeartbeats 2000000 in
-- The rigid engine and the comparison with the presentation carrier expand the H0 tower.
set_option synthInstance.maxHeartbeats 800000 in
/-- Finite, projective, rank-one `H^0` certificates for the finite-stage datum. -/
theorem certificates (S : PicRankOneNoetherianStage P)
    (hpi : pi ≫ P1.structureMap k = C.hom) :
    RankOneFamilyCertificates (S.D0.baseChange S.A0) := by
  letI : IsNoetherianRing S.A0 := S.hAnoeth
  letI : Subsingleton (datumPair (S.D0.baseChange S.A0)).H1 := S.hpair
  have hfib : ∀ p : PrimeSpectrum S.A0,
      Subsingleton ((datumPair (S.D0.baseChange S.A0)).H1 ⊗[S.A0]
        p.asIdeal.ResidueField) :=
    fun _ => inferInstance
  obtain ⟨h1, hfin, hproj⟩ := datumRigidEngine (S.D0.baseChange S.A0) hpi hfib
  letI := hfin
  letI := hproj
  have hinj : Function.Injective (algebraMap S.A0 P.cover.Carrier) :=
    fun x y hxy => Subtype.ext hxy
  let eH0 : P.cover.Carrier ⊗[S.A0]
      (Sheaf.HModule (S.D0.baseChange S.A0).sheaf 0) ≃ₗ[P.cover.Carrier]
      Sheaf.HModule P.datum.sheaf 0 :=
    ((S.D0.baseChange S.A0).datumH0BaseChange P.cover.Carrier S.hpair).trans
      (Sheaf.HModule.mapEquiv
        (eqToIso (congrArg
          (fun E : BasicOpenCocycleDatum C P.cover.Carrier pi => E.sheaf) S.hbase)) 0)
  have hrank : ∀ p : PrimeSpectrum S.A0,
      Module.rankAtStalk
        (Sheaf.HModule (S.D0.baseChange S.A0).sheaf 0) p = 1 :=
    rankAtStalk_eq_one_of_injective_baseChange
      (R := S.A0) (S := P.cover.Carrier)
      (M := Sheaf.HModule (S.D0.baseChange S.A0).sheaf 0)
      (N := Sheaf.HModule P.datum.sheaf 0)
      hinj eH0 P.h0_rank_one
  exact ⟨h1, hfin, hproj, hrank⟩

set_option maxHeartbeats 1000000 in
-- Reverse Riemann--Roch is applied at residue fields and then transported to every field.
set_option synthInstance.maxHeartbeats 400000 in
/-- The finite-stage datum has degree `genus C` after every field-valued base change. -/
theorem fibreClassDegree (S : PicRankOneNoetherianStage P)
    (hpi : pi ≫ P1.structureMap k = C.hom) :
    ∀ (K : Type u) [Field K] [Algebra k K] [Algebra S.A0 K]
      [IsScalarTower k S.A0 K],
      classDeg K (Scheme.CechPic.map (relCurveMap C S.A0 K)
        (S.D0.baseChange S.A0).cechPicClass) = (genus C : ℤ) := by
  letI : IsNoetherianRing S.A0 := S.hAnoeth
  have cert : RankOneFamilyCertificates (S.D0.baseChange S.A0) :=
    S.certificates hpi
  letI : Module.Finite S.A0
      (Sheaf.HModule (S.D0.baseChange S.A0).sheaf 0) := cert.h0_finite
  letI : Module.Projective S.A0
      (Sheaf.HModule (S.D0.baseChange S.A0).sheaf 0) := cert.h0_projective
  have hres : ∀ p : PrimeSpectrum S.A0,
      classDeg p.asIdeal.ResidueField
        (Scheme.CechPic.map (relCurveMap C S.A0 p.asIdeal.ResidueField)
          (S.D0.baseChange S.A0).cechPicClass) = (genus C : ℤ) :=
    fun p => stage_classDeg_residueField pi (S.D0.baseChange S.A0)
      S.hpair p (cert.h0_rank_one p)
  intro K _ _ _ _
  exact stage_classDeg_field pi (S.D0.baseChange S.A0) hres K

end PicRankOneNoetherianStage

end AlgebraicGeometry
