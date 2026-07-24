/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/

import AlgebraicJacobian.Picard.DivSchemeAdaptationFibreRegular
import AlgebraicJacobian.Picard.DivSchemeFibrePointRead
import AlgebraicJacobian.Picard.DivSchemeSeedUnivPointwiseFibreCore
import AlgebraicJacobian.Picard.DivSchemeSeedUnivPointwiseGenerator

/-!
# Pulled pointwise-seed equations on residue fibres

This file identifies the germ of the pulled presentation equation associated to the
pointwise generator seed with the canonical residue-fibre window reading.
-/

set_option autoImplicit false
set_option quotPrecheck false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 8
set_option maxRecDepth 16000
set_option linter.unusedSectionVars false

universe u

open CategoryTheory Limits TopologicalSpace Opposite
open scoped TensorProduct

namespace AlgebraicGeometry

open Scheme Grassmannian ThetaGeneratorSeed

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
  Scheme.functionFieldOverModule
attribute [local instance 10000] relCurve.instOver

namespace PointwiseAchiever

section SeedContext

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable {pi : C.left ⟶ P1 k} [IsFinite pi] [IsDominant pi]

noncomputable local instance instOverCleftPulledDegree :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k))] [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (.of k))]
  [QuasiCompact (C.left ↘ Spec (.of k))]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hpi : pi ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))
variable (g r1 r2 : Nat)
variable (b1 : Module.Basis (Fin r1) k
  ↥(Scheme.divisorSections k (windowM_choice pi hpi g • fiberWeilDivisor pi) ⊤))
variable (b2 : Module.Basis (Fin r2) k
  ↥(Scheme.divisorSections k ((windowS_choice pi hpi g • fiberWeilDivisor pi)
    + (windowM_choice pi hpi g • fiberWeilDivisor pi)) ⊤))
variable (i : (glueData k g r1).J) (j : (glueData k g r2).J)
variable (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
  (hchi : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))

noncomputable local instance instIsIntegralRelCurvePulledDegree
    (L : Type u) [Field L] [Algebra k L] : IsIntegral (relCurve C L) :=
  instIsIntegralBaseChange C L

noncomputable local instance instSmoothRelCurvePulledDegree
    (L : Type u) [Field L] [Algebra k L] :
    SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L)) :=
  instSmoothOfRelativeDimensionBaseChange C L

noncomputable local instance instQCRelCurvePulledDegree
    (L : Type u) [Field L] [Algebra k L] :
    QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L)) :=
  instQuasiCompactBaseChange C L

noncomputable local instance instLFTRelCurvePulledDegree
    (L : Type u) [Field L] [Algebra k L] :
    LocallyOfFiniteType (relCurve C L ↘ Spec (CommRingCat.of L)) :=
  haveI : Smooth (relCurve C L ↘ Spec (CommRingCat.of L)) :=
    SmoothOfRelativeDimension.smooth 1 _
  inferInstance

local notation "RZ" => seedChartRing C hpi g r1 r2 b1 b2 i j

set_option maxHeartbeats 8000000 in
-- The dependent seed, local-equation cover, and residue-field germ elaborate together.
set_option synthInstance.maxHeartbeats 800000 in
/-- The pulled local equation of the pointwise generator seed reads, at the canonical
residue-fibre point, as the compared pointwise window vector. -/
theorem germ_pullbackEqn_pointwiseGeneratorSeed_eq_pointwiseFibreReadGerm
    (hrdn : PointwiseSeedRDN C hpi g r1 r2 b1 b2 i j hO hchi)
    (z : relCurve C RZ) :
    let p := relCurveBasePoint C RZ z
    let K := p.asIdeal.ResidueField
    let zK := relCurveResiduePoint C RZ z
    let D := pointwiseGeneratorSeed C hpi g r1 r2 b1 b2 i j hO hchi hrdn
    let hD := isGenerator_pointwiseGeneratorSeed
      C hpi g r1 r2 b1 b2 i j hO hchi hrdn
    ((relCurve C K).presheaf.germ
        (((D.localEquations hD).cover.pullback (relCurveMap C RZ K)).opens zK) zK
        (((D.localEquations hD).cover.pullback
          (relCurveMap C RZ K)).mem_opens zK)).hom
        (Scheme.LocalEquations.pullbackEqn
          (relCurveMap C RZ K) (D.localEquations hD) zK) =
      pointwiseFibreReadGerm C hpi g r1 r2 b1 b2 i j z
        (pointwiseSide C hpi g r1 r2 b1 b2 i j z)
        (pointwiseSide_mem C hpi g r1 r2 b1 b2 i j z)
        (pointwiseSectionVector C hpi g r1 r2 b1 b2 i j hO hchi z) := by
  dsimp only
  let p := relCurveBasePoint C RZ z
  let K := p.asIdeal.ResidueField
  let zK := relCurveResiduePoint C RZ z
  let D := pointwiseGeneratorSeed C hpi g r1 r2 b1 b2 i j hO hchi hrdn
  let hD := isGenerator_pointwiseGeneratorSeed
    C hpi g r1 r2 b1 b2 i j hO hchi hrdn
  have hbase : (relCurveMap C RZ K).base zK = z := by
    simpa only [K, p, zK] using relCurveMap_relCurveResiduePoint C RZ z
  have hzPiece : zK ∈ (relCurve C K).basicOpen
      (relPinnedSectionsMap C RZ K pi (D.side z) (D.h z)) := by
    rw [relPinnedSectionsMap_basicOpen]
    change (relCurveMap C RZ K).base zK ∈ (relCurve C RZ).basicOpen (D.h z)
    rw [hbase]
    exact D.mem_basicOpen z
  have hzSide : zK ∈ relPinnedChart C K pi (D.side z) := by
    change zK ∈ relPinnedChart C K pi
      (pointwiseSide C hpi g r1 r2 b1 b2 i j z)
    simpa only [K, p, zK] using relCurveResiduePoint_mem_relPinnedChart C RZ
      (π := pi) (pointwiseSide C hpi g r1 r2 b1 b2 i j z)
      (pointwiseSide_mem C hpi g r1 r2 b1 b2 i j z)
  have hpull := D.germ_self_pullbackEqn_eq_germ_relPinnedSectionsMap_of_map_eq
    hD p zK z hbase hzPiece hzSide
  rw [hpull]
  convert germ_relPinnedSectionsMap_relThetaResSide_windowEquiv_at_relCurveResiduePoint
    C RZ (π := pi) (windowM_choice pi hpi g)
    (relThetaPairH1_windowM C pi hpi g)
    (pointwiseSide C hpi g r1 r2 b1 b2 i j z)
    (pointwiseSide_mem C hpi g r1 r2 b1 b2 i j z)
    (pointwiseSectionVector C hpi g r1 r2 b1 b2 i j hO hchi z) using 1 <;> rfl

end SeedContext

end PointwiseAchiever

end AlgebraicGeometry
