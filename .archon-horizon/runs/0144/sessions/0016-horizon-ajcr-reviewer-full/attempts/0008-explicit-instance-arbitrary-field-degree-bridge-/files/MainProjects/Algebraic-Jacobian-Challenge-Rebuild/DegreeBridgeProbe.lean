import AlgebraicJacobian.Picard.Pic0RankOneCanonicalDivisorStageRank
import AlgebraicJacobian.Picard.Pic0RankOneCanonicalDivisorDegree

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

noncomputable local instance probeOverCleft : C.left.Over (Spec (.of k)) := ⟨C.hom⟩
noncomputable local instance (priority := 20000) probeOver
    (L : Type u) [Field L] [Algebra k L] :
    (relCurve C L).Over (Spec (.of L)) := instOverBaseChange C L
noncomputable local instance probeSmooth
    (L : Type u) [Field L] [Algebra k L] :
    SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (.of L)) :=
  instSmoothOfRelativeDimensionBaseChange C L
noncomputable local instance probeIntegral
    (L : Type u) [Field L] [Algebra k L] : IsIntegral (relCurve C L) :=
  instIsIntegralBaseChange C L
noncomputable local instance probeQuasiCompact
    (L : Type u) [Field L] [Algebra k L] :
    QuasiCompact (relCurve C L ↘ Spec (.of L)) :=
  instQuasiCompactBaseChange C L
noncomputable local instance probeFiniteH0
    (L : Type u) [Field L] [Algebra k L] :
    Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0) :=
  instModuleFiniteHModuleZeroBaseChange C L
noncomputable local instance probeFiniteH1
    (L : Type u) [Field L] [Algebra k L] :
    Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1) :=
  instModuleFiniteHModuleOneBaseChange C L

namespace PicRankOneNoetherianStage

variable {A : Type u} [CommRing A] [Algebra k A]
variable {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
variable {P : PicRankOneLocalPresentation pi lam}

set_option maxHeartbeats 1000000 in
set_option synthInstance.maxHeartbeats 400000 in
theorem fieldBridgeProbe (S : PicRankOneNoetherianStage P)
    (hpi : pi ≫ P1.structureMap k = C.hom) :
    ∀ (K : Type u) [Field K] [Algebra k K] [Algebra S.A0 K]
      [IsScalarTower k S.A0 K],
      classDeg K (Scheme.CechPic.map (relCurveMap C S.A0 K)
        (S.D0.baseChange S.A0).cechPicClass) = (genus C : ℤ) := by
  intro K _ _ _ _
  letI : IsNoetherianRing S.A0 := S.hAnoeth
  obtain ⟨-, hfin, hproj⟩ := S.engine hpi
  letI := hfin
  letI := hproj
  have hres : ∀ p : PrimeSpectrum S.A0,
      classDeg p.asIdeal.ResidueField
        (Scheme.CechPic.map (relCurveMap C S.A0 p.asIdeal.ResidueField)
          (S.D0.baseChange S.A0).cechPicClass) = (genus C : ℤ) := by
    intro p
    exact stage_classDeg_residueField pi (S.D0.baseChange S.A0)
      S.hpair p (S.stageRank hpi p)
  exact stage_classDeg_field pi (S.D0.baseChange S.A0) hres K

end PicRankOneNoetherianStage
end AlgebraicGeometry
