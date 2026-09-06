/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientFiniteAtlasMap

/-!
# The affine base map of the stable quotient atlas

Each invariant quotient chart has its canonical map to `Spec k`.  The overlap
reversal respects these maps, so the chart family supplies the generic
`BaseMapData` consumed by the over-base descent interface.  This is only the
structure morphism of the atlas candidate; it does not assert a quotient
universal property or the missing sheaf/finiteness statements.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits AlgebraicGeometry

namespace MilneLib
namespace StableGroupAction
namespace StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] {X : Scheme.{u}}
  (act : G →* Aut X) [X.IsSeparated]

/-- The quotient-overlap reversal is a morphism over the affine base. -/
theorem quotientOverlapSwapIso_hom_comp_base [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsMulSemiringAction act (overlap_stable act j i)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
    (quotientOverlapSwapIso act p hact i j).hom ≫
        quotientOverlapι act p hact j i ≫
          affineInvariantQuotientBaseMap
            (k := k) (A := Γ(X, j.U)) (G := G) =
      quotientOverlapι act p hact i j ≫
        affineInvariantQuotientBaseMap
          (k := k) (A := Γ(X, i.U)) (G := G) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsAlgebra p (j.U ⊓ i.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsMulSemiringAction act (overlap_stable act j i)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
  let F := fixedOverlapQuotientIso act p hact i j
  have ht := quotientOverlapSwapIso_hom_comp_ι_eq_rightQuotientMap
    act p hact i j
  have hl := Over.w (overlapCone act p hact i j).leftQuotientMap
  have hr := Over.w (overlapCone act p hact i j).rightQuotientMap
  have hlegs :
      (overlapCone act p hact i j).rightQuotientMap.left ≫
          affineInvariantQuotientBaseMap
            (k := k) (A := Γ(X, j.U)) (G := G) =
        (F.hom ≫ quotientOverlapι act p hact i j) ≫
          affineInvariantQuotientBaseMap
            (k := k) (A := Γ(X, i.U)) (G := G) := by
    rw [fixedOverlapQuotientIso_hom_comp_ι,
      overlapFixedRestrictionMap_eq_leftQuotientMap]
    exact hr.trans hl.symm
  calc
    (quotientOverlapSwapIso act p hact i j).hom ≫
        quotientOverlapι act p hact j i ≫
          affineInvariantQuotientBaseMap
            (k := k) (A := Γ(X, j.U)) (G := G) =
      ((quotientOverlapSwapIso act p hact i j).hom ≫
        quotientOverlapι act p hact j i) ≫
          affineInvariantQuotientBaseMap
            (k := k) (A := Γ(X, j.U)) (G := G) :=
      (Category.assoc _ _ _).symm
    _ = (F.inv ≫ (overlapCone act p hact i j).rightQuotientMap.left) ≫
          affineInvariantQuotientBaseMap
            (k := k) (A := Γ(X, j.U)) (G := G) :=
      congrArg (fun z => z ≫ affineInvariantQuotientBaseMap
        (k := k) (A := Γ(X, j.U)) (G := G)) ht
    _ = F.inv ≫
          ((overlapCone act p hact i j).rightQuotientMap.left ≫
            affineInvariantQuotientBaseMap
              (k := k) (A := Γ(X, j.U)) (G := G)) :=
      Category.assoc _ _ _
    _ = F.inv ≫
          ((F.hom ≫ quotientOverlapι act p hact i j) ≫
            affineInvariantQuotientBaseMap
              (k := k) (A := Γ(X, i.U)) (G := G)) :=
      congrArg (fun z => F.inv ≫ z) hlegs
    _ = quotientOverlapι act p hact i j ≫
          affineInvariantQuotientBaseMap
            (k := k) (A := Γ(X, i.U)) (G := G) := by
      simp only [Category.assoc, Iso.inv_hom_id_assoc]

/-- The canonical quotient projection of a stable affine chart is over the
given affine base. -/
theorem stableAffineQuotientMap_comp_base [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    stableAffineQuotientMap act p hact i ≫
        affineInvariantQuotientBaseMap
          (k := k) (A := Γ(X, i.U)) (G := G) =
      i.U.ι ≫ p := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  change (i.affine.isoSpec.hom ≫
      affineInvariantQuotientMap
        (k := k) (A := Γ(X, i.U)) (G := G)) ≫
      affineInvariantQuotientBaseMap
        (k := k) (A := Γ(X, i.U)) (G := G) =
    i.U.ι ≫ p
  have hqOver := affineInvariantQuotientMapOver_isOver
    (k := k) (A := Γ(X, i.U)) (G := G)
  have hq := hqOver
  change affineInvariantQuotientMap
      (k := k) (A := Γ(X, i.U)) (G := G) ≫
        affineInvariantQuotientBaseMap
          (k := k) (A := Γ(X, i.U)) (G := G) =
      affineSpecToBase (k := k) (A := Γ(X, i.U)) at hq
  calc
    (i.affine.isoSpec.hom ≫
        affineInvariantQuotientMap
          (k := k) (A := Γ(X, i.U)) (G := G)) ≫
        affineInvariantQuotientBaseMap
          (k := k) (A := Γ(X, i.U)) (G := G) =
      i.affine.isoSpec.hom ≫
        (affineInvariantQuotientMap
          (k := k) (A := Γ(X, i.U)) (G := G) ≫
          affineInvariantQuotientBaseMap
            (k := k) (A := Γ(X, i.U)) (G := G)) :=
      Category.assoc _ _ _
    _ = i.affine.isoSpec.hom ≫
        affineSpecToBase (k := k) (A := Γ(X, i.U)) :=
      congrArg (fun z => i.affine.isoSpec.hom ≫ z) hq
    _ = i.U.ι ≫ p := by
      suffices h : i.affine.isoSpec.hom ≫
          Spec.map (p.appLE ⊤ i.U le_top) ≫
            Spec.map (Scheme.ΓSpecIso (CommRingCat.of k)).inv =
          i.U.ι ≫ p by
        simpa [i.affine.isoSpec_hom, affineSpecToBase,
          sectionsAlgebraMapHom, Scheme.Hom.appLE,
          RingHom.algebraMap_toAlgebra] using h
      rw [i.affine.isoSpec_hom]
      have hn := Scheme.Opens.toSpecΓ_SpecMap_appLE p ⊤ i.U le_top
      calc
        i.U.toSpecΓ ≫ Spec.map (p.appLE ⊤ i.U le_top) ≫
              Spec.map (Scheme.ΓSpecIso (CommRingCat.of k)).inv =
            (p.resLE ⊤ i.U le_top ≫
              (⊤ : (Spec (CommRingCat.of k)).Opens).toSpecΓ) ≫
              Spec.map (Scheme.ΓSpecIso (CommRingCat.of k)).inv :=
          congrArg (fun z => z ≫
            Spec.map (Scheme.ΓSpecIso (CommRingCat.of k)).inv) hn
        _ = i.U.ι ≫ p := by
          rw [Category.assoc]
          simp

section StableFamily

variable [Finite G] {J : Type u} [Finite J]

/-- The canonical affine-base structure maps on a finite stable quotient atlas. -/
noncomputable def stableQuotientBaseMapData
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (C : J → StableAffineOpen act) :
    InvariantLocalization.InvariantQuotientCrossChartDatum.BaseMapData
      (stableQuotientCrossChartDatum act p hact C) (k := k) := by
  letI (i : J) : Algebra k Γ(X, (C i).U) :=
    sectionsAlgebra p (C i).U
  letI (i : J) : MulSemiringAction G Γ(X, (C i).U) :=
    sectionsMulSemiringAction act (C i).stable
  letI (i : J) : SMulCommClass G k Γ(X, (C i).U) :=
    sectionsSMulCommClass act p hact (C i).stable
  refine
    { chartMap := fun i =>
        affineInvariantQuotientBaseMap
          (k := k) (A := Γ(X, (C i).U)) (G := G)
      compatibility := ?_ }
  intro i j
  change quotientOverlapι act p hact (C i) (C j) ≫
      affineInvariantQuotientBaseMap
        (k := k) (A := Γ(X, (C i).U)) (G := G) =
    ((quotientOverlapSwapIso act p hact (C i) (C j)).hom ≫
        quotientOverlapι act p hact (C j) (C i)) ≫
      affineInvariantQuotientBaseMap
        (k := k) (A := Γ(X, (C j).U)) (G := G)
  exact (quotientOverlapSwapIso_hom_comp_base
    act p hact (C i) (C j)).symm

end StableFamily

section FiniteCover

variable [Finite G] [CompactSpace X]

/-- The canonical base datum for the compact finite stable-affine cover. -/
noncomputable def finiteStableQuotientBaseMapData
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (h : OrbitsInAffineOpen act) :
    InvariantLocalization.InvariantQuotientCrossChartDatum.BaseMapData
      (finiteStableQuotientCrossChartDatum act p hact h) (k := k) :=
  stableQuotientBaseMapData act p hact (finiteStableAffineChart act h)

end FiniteCover

end StableAffineOpen
end StableGroupAction
end MilneLib
