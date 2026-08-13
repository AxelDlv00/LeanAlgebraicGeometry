/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0RankOneCanonicalDivisorStageRank
import AlgebraicJacobian.Picard.Pic0RankOneCanonicalDivisorDegree

/-!
# Residue-fibre degree certificates at the finite stage

The glued-divisor consumer only needs the degree law on residue fibres of the Noetherian stage.
Keeping that law separate avoids re-running arbitrary field transport while the public datum
certificate is assembled.
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

noncomputable local instance stageDegreeOverCleft :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩

noncomputable local instance (priority := 20000) stageDegreeOver
    (L : Type u) [Field L] [Algebra k L] :
    (relCurve C L).Over (Spec (.of L)) :=
  instOverBaseChange C L

noncomputable local instance stageDegreeSmooth
    (L : Type u) [Field L] [Algebra k L] :
    SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (.of L)) :=
  instSmoothOfRelativeDimensionBaseChange C L

noncomputable local instance stageDegreeIntegral
    (L : Type u) [Field L] [Algebra k L] :
    IsIntegral (relCurve C L) :=
  instIsIntegralBaseChange C L

noncomputable local instance stageDegreeQuasiCompact
    (L : Type u) [Field L] [Algebra k L] :
    QuasiCompact (relCurve C L ↘ Spec (.of L)) :=
  instQuasiCompactBaseChange C L

noncomputable local instance stageDegreeFiniteH0
    (L : Type u) [Field L] [Algebra k L] :
    Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0) :=
  instModuleFiniteHModuleZeroBaseChange C L

noncomputable local instance stageDegreeFiniteH1
    (L : Type u) [Field L] [Algebra k L] :
    Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1) :=
  instModuleFiniteHModuleOneBaseChange C L

namespace PicRankOneNoetherianStage

variable {A : Type u} [CommRing A] [Algebra k A]
variable {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
variable {P : PicRankOneLocalPresentation pi lam}

set_option maxHeartbeats 1000000 in
-- Reverse Riemann--Roch is applied only at stage residue fields.
set_option synthInstance.maxHeartbeats 400000 in
/-- The finite-stage datum has genus degree on every residue fibre. -/
theorem fibreClassDegree (S : PicRankOneNoetherianStage P)
    (hpi : pi ≫ P1.structureMap k = C.hom) :
  ∀ p : PrimeSpectrum S.A0,
      classDeg p.asIdeal.ResidueField
        (Scheme.CechPic.map (relCurveMap C S.A0 p.asIdeal.ResidueField)
          (S.D0.baseChange S.A0).cechPicClass) = (genus C : ℤ) := by
  letI : IsNoetherianRing S.A0 := S.hAnoeth
  obtain ⟨-, hfin, hproj⟩ := S.engine hpi
  letI := hfin
  letI := hproj
  intro p
  exact stage_classDeg_residueField pi (S.D0.baseChange S.A0)
    S.hpair p (S.stageRank hpi p)

end PicRankOneNoetherianStage

end AlgebraicGeometry
