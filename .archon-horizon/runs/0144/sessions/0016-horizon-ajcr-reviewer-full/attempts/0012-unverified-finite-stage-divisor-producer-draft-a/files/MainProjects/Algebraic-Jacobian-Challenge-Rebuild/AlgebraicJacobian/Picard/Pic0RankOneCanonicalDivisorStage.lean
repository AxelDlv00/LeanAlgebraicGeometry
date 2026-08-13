/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0RankOneCanonicalDivisorStageCert
import AlgebraicJacobian.Picard.Pic0RankOneDatumGluedDivisor

/-!
# A divisor on the carrier of a rank-one presentation

The cocycle datum of a rank-one local presentation lives over an arbitrary etale carrier.
This module descends it to a finite Noetherian stage, constructs the genus-degree divisor
there, and pushes the divisor back to the presentation carrier.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
open scoped TensorProduct

namespace AlgebraicGeometry

open AlgebraicJacobian

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable {pi : C.left ⟶ P1 k} [IsFinite pi]

noncomputable local instance canonicalStageOverCleft :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩

namespace PicRankOneNoetherianStage

set_option maxHeartbeats 2000000 in
-- The Noetherian datum-level glue is applied after installing the stored stage instances.
set_option synthInstance.maxHeartbeats 800000 in
/-- Produce a divisor on the finite stage in the same relative Picard class as its datum. -/
theorem exists_stage_divFamZarAff
    {A : Type u} [CommRing A] [Algebra k A]
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
    {P : PicRankOneLocalPresentation pi lam}
    (S : PicRankOneNoetherianStage P)
    (hpi : pi ≫ P1.structureMap k = C.hom) :
    ∃ F : DivFamZarAff C S.A0 (genus C),
      relPicMk C (overSpec k S.A0) F.picClass =
        relPicMk C (overSpec k S.A0) (S.D0.baseChange S.A0).cechPicClass := by
  letI : IsNoetherianRing S.A0 := S.hAnoeth
  letI : Subsingleton (datumPair (S.D0.baseChange S.A0)).H1 := S.hpair
  have hfib : ∀ p : PrimeSpectrum S.A0,
      Subsingleton ((datumPair (S.D0.baseChange S.A0)).H1 ⊗[S.A0]
        p.asIdeal.ResidueField) :=
    fun _ => inferInstance
  have hwit : ∀ p : PrimeSpectrum S.A0,
      (S.D0.baseChange S.A0).HasWitnessH1Vanishing p.asIdeal.ResidueField :=
    fun p => ((S.D0.baseChange S.A0).hasWitnessH1Vanishing_iff_subsingleton
      p.asIdeal.ResidueField).mpr (hfib p)
  exact (S.D0.baseChange S.A0).exists_glued_divFamZarAff_of_admissible_fibre
    hpi hwit (S.fibreClassDegree hpi)

end PicRankOneNoetherianStage

set_option maxHeartbeats 2000000 in
-- The stage divisor is transported through the nested subalgebra tower to the carrier.
set_option synthInstance.maxHeartbeats 800000 in
/-- A rank-one presentation has an Abel-correct divisor on its etale carrier, without a
Noetherian hypothesis on that carrier. -/
theorem PicRankOneLocalPresentation.exists_cover_divFamZarAff
    {A : Type u} [CommRing A] [Algebra k A]
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
    (P : PicRankOneLocalPresentation pi lam)
    (hpi : pi ≫ P1.structureMap k = C.hom) :
    ∃ F : DivFamZarAff C P.cover.Carrier (genus C),
      abelDivAffPlus C P.cover.Carrier F =
        PicEtAff.unit C P.cover.Carrier
          (P.representative : relPic C (overSpec k P.cover.Carrier)) := by
  classical
  obtain ⟨S⟩ := P.nonempty_noetherianStage hpi
  obtain ⟨F, hFrel⟩ := S.exists_stage_divFamZarAff hpi
  set F' : DivFamZarAff C P.cover.Carrier (genus C) :=
    DivFamZarAff.mapAlgHom (IsScalarTower.toAlgHom k S.A0 P.cover.Carrier) F with hF'def
  have hF'pic : F'.picClass
      = Scheme.CechPic.map (relCurveMap C S.A0 P.cover.Carrier) F.picClass := by
    rw [hF'def, DivFamZarAff.mapAlgHom_eq_mapAlg
      (IsScalarTower.toAlgHom k S.A0 P.cover.Carrier) (fun _ => rfl),
      DivFamZarAff.picClass_mapAlg]
  have hcurveB : (C ◁ Over.overSpecMap
      (IsScalarTower.toAlgHom k S.A0 P.cover.Carrier)).left
      = relCurveMap C S.A0 P.cover.Carrier := by
    refine congrArg
      (fun t : overSpec k P.cover.Carrier ⟶ overSpec k S.A0 => (C ◁ t).left) ?_
    exact Over.OverMorphism.ext rfl
  have hclassB : P.datum.cechPicClass
      = Scheme.CechPic.map (relCurveMap C S.A0 P.cover.Carrier)
          (S.D0.baseChange S.A0).cechPicClass := by
    rw [← S.hbase]
    exact (S.D0.baseChange S.A0).cechPicClass_baseChange P.cover.Carrier
  have hrelB : relPicMk C (overSpec k P.cover.Carrier) F'.picClass
      = relPicMk C (overSpec k P.cover.Carrier) P.datum.cechPicClass := by
    have h := congrArg (relPicAlgMap C
      (IsScalarTower.toAlgHom k S.A0 P.cover.Carrier)) hFrel
    rw [relPicAlgMap_mk, relPicAlgMap_mk, hcurveB] at h
    rw [hF'pic, hclassB]
    exact h
  refine ⟨F', ?_⟩
  calc abelDivAffPlus C P.cover.Carrier F'
      = PicEtAff.unit C P.cover.Carrier
          (relPicMk C (overSpec k P.cover.Carrier) F'.picClass) := rfl
    _ = PicEtAff.unit C P.cover.Carrier
          (relPicMk C (overSpec k P.cover.Carrier) P.datum.cechPicClass) := by
        rw [hrelB]
    _ = PicEtAff.unit C P.cover.Carrier
          (P.representative : relPic C (overSpec k P.cover.Carrier)) := by
        rw [← P.datum_class]

end AlgebraicGeometry
