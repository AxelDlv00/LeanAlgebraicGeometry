/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientFiniteAtlasFinite
import MilneLib.InvariantQuotientFiniteAtlasOrbit
import MilneLib.InvariantQuotientStableBaseMap
import Mathlib.AlgebraicGeometry.Morphisms.Immersion

/-!
# The finite quotient atlas over its affine base

The canonical finite-cover chart projections and the canonical affine-base
datum assemble into the existing over-base chart-map consumer. This produces
the glued atlas projection together with its base square, finite-type target
properties, and transfer of reducedness, integrality, and separatedness.
The global quotient universal property remains to be constructed.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits AlgebraicGeometry

namespace MilneLib

set_option backward.isDefEq.respectTransparency false in
/-- Separatedness of the source descends through a universally closed,
surjective morphism over the same base. -/
theorem isSeparated_of_comp_of_universallyClosed_surjective
    {X Y S : Scheme.{u}} (q : X ⟶ Y) (p : Y ⟶ S)
    [UniversallyClosed q] [Surjective q] [IsSeparated (q ≫ p)] :
    IsSeparated p := by
  let m := pullback.map (q ≫ p) (q ≫ p) p p q q (𝟙 S) (by simp) (by simp)
  haveI : UniversallyClosed m := by
    exact MorphismProperty.pullbackMap (P := @UniversallyClosed)
      (inferInstance : UniversallyClosed q) (inferInstance : UniversallyClosed q) rfl rfl
  have hm : pullback.diagonal (q ≫ p) ≫ m = q ≫ pullback.diagonal p := by
    apply pullback.hom_ext <;> simp [m, pullback.map]
  haveI : UniversallyClosed (q ≫ pullback.diagonal p) := by
    rw [← hm]
    infer_instance
  haveI : UniversallyClosed (pullback.diagonal p) :=
    UniversallyClosed.of_comp_surjective q _
  exact ⟨IsClosedImmersion.of_isPreimmersion _
    (pullback.diagonal p).isClosedMap.isClosed_range⟩

namespace StableGroupAction
namespace StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] [Finite G]
  {X : Scheme.{u}} (act : G →* Aut X) [X.IsSeparated] [CompactSpace X]

section FiniteCover

variable (p : X ⟶ Spec (CommRingCat.of k))
variable (hact : ∀ g : G, (act g).hom ≫ p = p)
variable (h : OrbitsInAffineOpen act)

/-- The canonical finite-cover source maps, now equipped with their affine
base compatibility. -/
noncomputable def finiteStableCanonicalBaseCompatibleChartMaps :
    InvariantLocalization.BaseCompatibleChartMaps.For
      (finiteStableAffineCover act h)
      (finiteStableQuotientCrossChartDatum act p hact h)
      (finiteStableQuotientBaseMapData act p hact h) := by
  refine
    { chartMap := finiteStableQuotientChartMap act p hact h
      compatibility := fun i j => finiteStableProjection_compat act p hact h i j
      sourceBase := p
      baseCompatibility := ?_ }
  intro i
  let C := finiteStableAffineChart act h i
  letI := sectionsAlgebra p C.U
  letI := sectionsMulSemiringAction act C.stable
  letI := sectionsSMulCommClass act p hact C.stable
  have hJ : (finiteStableAffineCover act h).I₀ =
      (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.J := rfl
  have hι :=
    InvariantLocalization.InvariantQuotientCrossChartDatum.BaseMapData.ι_map
      (finiteStableQuotientCrossChartDatum act p hact h)
      (finiteStableQuotientBaseMapData act p hact h) (hJ ▸ i)
  have hι' :
      (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i ≫
          (finiteStableQuotientBaseMapData act p hact h).map
            (finiteStableQuotientCrossChartDatum act p hact h) =
        (finiteStableQuotientBaseMapData act p hact h).chartMap i := by
    simpa using hι
  calc
    (finiteStableQuotientChartMap act p hact h i ≫
        (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i) ≫
        (finiteStableQuotientBaseMapData act p hact h).map
          (finiteStableQuotientCrossChartDatum act p hact h) =
      finiteStableQuotientChartMap act p hact h i ≫
        ((finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i ≫
          (finiteStableQuotientBaseMapData act p hact h).map
            (finiteStableQuotientCrossChartDatum act p hact h)) :=
      Category.assoc _ _ _
    _ = finiteStableQuotientChartMap act p hact h i ≫
        (finiteStableQuotientBaseMapData act p hact h).chartMap i :=
      congrArg (fun z => finiteStableQuotientChartMap act p hact h i ≫ z) hι'
    _ = (finiteStableAffineCover act h).f i ≫ p := by
      dsimp [finiteStableQuotientChartMap, finiteStableAffineCover,
        finiteStableAffineChart]
      change stableAffineQuotientMap act p hact C ≫
          affineInvariantQuotientBaseMap
            (k := k) (A := Γ(X, C.U)) (G := G) = C.U.ι ≫ p
      exact stableAffineQuotientMap_comp_base act p hact C

/-- The global projection obtained from the canonical finite atlas, viewed over
the selected affine base. -/
noncomputable def finiteStableCanonicalQuotientProjectionOver :
    X ⟶ (finiteStableQuotientGlueData act p hact h).glued :=
  InvariantLocalization.BaseCompatibleChartMaps.globalMap
    (finiteStableAffineCover act h)
    (finiteStableQuotientCrossChartDatum act p hact h)
    (finiteStableQuotientBaseMapData act p hact h)
    (finiteStableCanonicalBaseCompatibleChartMaps act p hact h)

@[reassoc (attr := simp)]
theorem finiteStableCanonicalQuotientProjectionOver_comp_base :
    finiteStableCanonicalQuotientProjectionOver act p hact h ≫
        (finiteStableQuotientBaseMapData act p hact h).map
          (finiteStableQuotientCrossChartDatum act p hact h) = p := by
  exact InvariantLocalization.BaseCompatibleChartMaps.globalMap_comp_base
    (finiteStableAffineCover act h)
    (finiteStableQuotientCrossChartDatum act p hact h)
    (finiteStableQuotientBaseMapData act p hact h)
    (finiteStableCanonicalBaseCompatibleChartMaps act p hact h)

@[reassoc (attr := simp)]
theorem finiteStableAffineCover_f_finiteStableCanonicalQuotientProjectionOver
    (i : (finiteStableAffineCover act h).I₀) :
    (finiteStableAffineCover act h).f i ≫
        finiteStableCanonicalQuotientProjectionOver act p hact h =
      finiteStableQuotientChartMap act p hact h i ≫
        (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i := by
  exact InvariantLocalization.BaseCompatibleChartMaps.f_globalMap
    (finiteStableAffineCover act h)
    (finiteStableQuotientCrossChartDatum act p hact h)
    (finiteStableQuotientBaseMapData act p hact h)
    (finiteStableCanonicalBaseCompatibleChartMaps act p hact h) i

set_option backward.isDefEq.respectTransparency false in
/-- The glued quotient target is locally of finite type over a noetherian
affine base whenever the source is. -/
theorem finiteStableQuotientBaseMap_locallyOfFiniteType
    [IsNoetherianRing k] [LocallyOfFiniteType p] :
    LocallyOfFiniteType
      ((finiteStableQuotientBaseMapData act p hact h).map
        (finiteStableQuotientCrossChartDatum act p hact h)) := by
  let D := finiteStableQuotientCrossChartDatum act p hact h
  let B := finiteStableQuotientBaseMapData act p hact h
  apply IsZariskiLocalAtSource.of_openCover (P := @LocallyOfFiniteType)
    D.toGlueData.openCover
  intro i
  change LocallyOfFiniteType (D.toGlueData.ι i ≫ B.map D)
  rw [InvariantLocalization.InvariantQuotientCrossChartDatum.BaseMapData.ι_map]
  let C := finiteStableAffineChart act h i
  letI := sectionsAlgebra p C.U
  letI := sectionsMulSemiringAction act C.stable
  letI := sectionsSMulCommClass act p hact C.stable
  letI : Algebra.FiniteType k Γ(X, C.U) :=
    sectionsAlgebra_finiteType_of_locallyOfFiniteType p C.U C.affine
  letI : Algebra.FiniteType k (FixedPoints.subalgebra k Γ(X, C.U) G) :=
    fixedSubalgebra_finiteType_over_base
  change LocallyOfFiniteType
    (Spec.map (CommRingCat.ofHom
      (algebraMap k (FixedPoints.subalgebra k Γ(X, C.U) G))))
  exact (HasRingHomProperty.Spec_iff (P := @LocallyOfFiniteType)).mpr
    (RingHom.finiteType_algebraMap.mpr inferInstance)

/-- The finite stable-cover quotient target is quasi-compact: it is a
continuous image of the compact source. -/
theorem finiteStableQuotientGlueData_compactSpace :
    CompactSpace (finiteStableQuotientGlueData act p hact h).glued := by
  exact Function.Surjective.compactSpace
    (finiteStableCanonicalQuotientProjection act p hact h).continuous
    (finiteStableCanonicalQuotientProjection act p hact h).surjective

/-- The structure map of the glued quotient target is quasi-compact. Together
with `finiteStableQuotientBaseMap_locallyOfFiniteType`, this gives a finite-type
quotient target over a noetherian affine base. -/
theorem finiteStableQuotientBaseMap_quasiCompact :
    QuasiCompact
      ((finiteStableQuotientBaseMapData act p hact h).map
        (finiteStableQuotientCrossChartDatum act p hact h)) := by
  letI := finiteStableQuotientGlueData_compactSpace act p hact h
  infer_instance

/-- A reduced source gives a reduced quotient target, since every quotient
chart is the spectrum of a subring of a reduced section ring. -/
theorem finiteStableQuotientGlueData_isReduced [IsReduced X] :
    IsReduced (finiteStableQuotientGlueData act p hact h).glued := by
  let D := finiteStableQuotientGlueData act p hact h
  letI (i : D.openCover.I₀) : IsReduced (D.openCover.X i) := by
    let C := finiteStableAffineChart act h i
    letI := sectionsAlgebra p C.U
    letI := sectionsMulSemiringAction act C.stable
    letI := sectionsSMulCommClass act p hact C.stable
    letI : _root_.IsReduced (FixedPoints.subalgebra k Γ(X, C.U) G) :=
      isReduced_of_injective (FixedPoints.subalgebra k Γ(X, C.U) G).val
        Subtype.val_injective
    change IsReduced (Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, C.U) G)))
    infer_instance
  exact IsReduced.of_openCover D.glued D.openCover

/-- The quotient target of an irreducible source is irreducible, as the
continuous image of the source under the surjective projection. -/
theorem finiteStableQuotientGlueData_irreducibleSpace [IrreducibleSpace X] :
    IrreducibleSpace (finiteStableQuotientGlueData act p hact h).glued :=
  Function.Surjective.irreducibleSpace
    (finiteStableCanonicalQuotientProjection act p hact h).continuous
    (finiteStableCanonicalQuotientProjection_surjective act p hact h)

/-- The quotient target of an integral source is integral. -/
theorem finiteStableQuotientGlueData_isIntegral [AlgebraicGeometry.IsIntegral X] :
    AlgebraicGeometry.IsIntegral (finiteStableQuotientGlueData act p hact h).glued := by
  letI := finiteStableQuotientGlueData_isReduced act p hact h
  letI := finiteStableQuotientGlueData_irreducibleSpace act p hact h
  exact isIntegral_of_irreducibleSpace_of_isReduced _

/-- The canonical finite-group quotient is separated over its affine base.
The finite, surjective projection transfers the separated source diagonal
to the quotient diagonal. -/
theorem finiteStableQuotientBaseMap_isSeparated [LocallyOfFiniteType p] :
    IsSeparated
      ((finiteStableQuotientBaseMapData act p hact h).map
        (finiteStableQuotientCrossChartDatum act p hact h)) := by
  let q := finiteStableCanonicalQuotientProjection act p hact h
  let b := (finiteStableQuotientBaseMapData act p hact h).map
    (finiteStableQuotientCrossChartDatum act p hact h)
  haveI : UniversallyClosed q :=
    finiteStableCanonicalQuotientProjection_isUniversallyClosed act p hact h
  haveI : Surjective q := ⟨finiteStableCanonicalQuotientProjection_surjective act p hact h⟩
  have hq : q ≫ b = p := by
    exact finiteStableCanonicalQuotientProjectionOver_comp_base act p hact h
  haveI : IsSeparated (q ≫ b) := by
    rw [hq]
    infer_instance
  exact isSeparated_of_comp_of_universallyClosed_surjective q b

end FiniteCover

end StableAffineOpen
end StableGroupAction
end MilneLib
