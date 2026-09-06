/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientStableGlueData
import MilneLib.InvariantQuotientAtlasMap

/-!
# Maps from stable affine charts to the quotient atlas

This module connects the concrete stable-affine quotient charts to the generic
source-cover descent interface.  The first bridge is the canonical affine
invariant-quotient projection.  Its restriction to an actual chart
intersection factors through the descended quotient overlap.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits AlgebraicGeometry
open MilneLib.InvariantLocalization.EquivariantAffineOverlapOver

namespace MilneLib
namespace StableGroupAction
namespace StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] [Finite G] {X : Scheme.{u}}
  (act : G →* Aut X) [X.IsSeparated]

/-- The canonical affine invariant-quotient projection on a stable affine
chart, transported through the chart's canonical affine presentation. -/
noncomputable def stableAffineQuotientMap
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    i.U.toScheme ⟶
      Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U) G)) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  exact i.affine.isoSpec.hom ≫
    affineInvariantQuotientMap (k := k) (A := Γ(X, i.U)) (G := G)

omit [Finite G] in
/-- Restricting the affine presentation of a stable chart to an intersection
agrees with the coordinate-open presentation used to define its quotient
overlap. -/
theorem homOfLE_comp_stableAffineIsoSpec
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    X.homOfLE inf_le_left ≫ i.affine.isoSpec.hom =
      (overlapCoordinateIso act i j).inv ≫
        (overlapCoordinateOpen act i j).ι := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  rw [← overlapIsoSpec_hom_comp_leftSourceMap act p hact i j]
  change X.homOfLE inf_le_left ≫ i.affine.isoSpec.hom =
    (overlap_affine act i j).isoSpec.hom ≫
      Spec.map (X.presheaf.map (homOfLE inf_le_left).op)
  rw [← cancel_mono i.affine.fromSpec]
  simp only [Category.assoc]
  rw [i.affine.map_fromSpec (overlap_affine act i j)
    (homOfLE inf_le_left).op]
  rw [← (overlap_affine act i j).isoSpec_inv_ι]
  simp only [Iso.hom_inv_id_assoc]
  rw [i.affine.isoSpec_hom, i.affine.toSpecΓ_fromSpec,
    Scheme.homOfLE_ι]

/-- On the intersection of two stable affine charts, the canonical quotient
projection factors through the descended quotient overlap and its inclusion in
the first quotient chart. -/
@[reassoc]
theorem stableAffineQuotientMap_restrict
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    X.homOfLE inf_le_left ≫ stableAffineQuotientMap act p hact i =
      overlapQuotientMap act p hact i j ≫
        quotientOverlapι act p hact i j := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  let q := affineInvariantQuotientMap
    (k := k) (A := Γ(X, i.U)) (G := G)
  calc
    X.homOfLE inf_le_left ≫ stableAffineQuotientMap act p hact i =
        (X.homOfLE inf_le_left ≫ i.affine.isoSpec.hom) ≫ q := by
      simp only [stableAffineQuotientMap, q, Category.assoc]
    _ = ((overlapCoordinateIso act i j).inv ≫
          (overlapCoordinateOpen act i j).ι) ≫ q :=
      congrArg (fun z => z ≫ q)
        (homOfLE_comp_stableAffineIsoSpec act p hact i j)
    _ = overlapQuotientMap act p hact i j ≫
          quotientOverlapι act p hact i j := by
      simpa only [q, Category.assoc] using
        (overlapQuotientMap_fac act p hact i j).symm

/-- The quotient projection from an actual chart intersection is the affine
invariant-quotient projection followed by the fixed-ring presentation of the
descended overlap. -/
theorem overlapQuotientMap_eq_fixedPresentation
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    (overlap_affine act i j).isoSpec.hom ≫
        affineInvariantQuotientMap
          (k := k) (A := Γ(X, i.U ⊓ j.U)) (G := G) ≫
        (fixedOverlapQuotientIso act p hact i j).hom =
      overlapQuotientMap act p hact i j := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  have hnatOver :=
    quotientMap_comp_leftQuotientMap (overlapCone act p hact i j)
  have hnat := congrArg (fun f => Over.Hom.left f) hnatOver
  change affineInvariantQuotientMap
      (k := k) (A := Γ(X, i.U ⊓ j.U)) (G := G) ≫
        (overlapCone act p hact i j).leftQuotientMap.left =
    (overlapCone act p hact i j).leftSourceMap.left ≫
      affineInvariantQuotientMap
        (k := k) (A := Γ(X, i.U)) (G := G) at hnat
  apply (cancel_mono (quotientOverlapι act p hact i j)).1
  simp only [Category.assoc]
  rw [fixedOverlapQuotientIso_hom_comp_ι,
    overlapFixedRestrictionMap_eq_leftQuotientMap,
    overlapQuotientMap_fac]
  calc
    (overlap_affine act i j).isoSpec.hom ≫
        affineInvariantQuotientMap
          (k := k) (A := Γ(X, i.U ⊓ j.U)) (G := G) ≫
        (overlapCone act p hact i j).leftQuotientMap.left =
      (overlap_affine act i j).isoSpec.hom ≫
        (overlapCone act p hact i j).leftSourceMap.left ≫
          affineInvariantQuotientMap
            (k := k) (A := Γ(X, i.U)) (G := G) :=
      congrArg (fun z => (overlap_affine act i j).isoSpec.hom ≫ z) hnat
    _ = (overlapCoordinateIso act i j).inv ≫
        (overlapCoordinateOpen act i j).ι ≫
          affineInvariantQuotientMap
            (k := k) (A := Γ(X, i.U)) (G := G) := by
      rw [← Category.assoc, overlapIsoSpec_hom_comp_leftSourceMap]
      exact Category.assoc _ _ _

/-- Removing the fixed-ring presentation from the descended overlap recovers
the affine invariant-quotient projection on the actual intersection. -/
theorem overlapQuotientMap_comp_fixedPresentation_inv
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    overlapQuotientMap act p hact i j ≫
        (fixedOverlapQuotientIso act p hact i j).inv =
      (overlap_affine act i j).isoSpec.hom ≫
        affineInvariantQuotientMap
          (k := k) (A := Γ(X, i.U ⊓ j.U)) (G := G) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  have hpres := overlapQuotientMap_eq_fixedPresentation act p hact i j
  calc
    overlapQuotientMap act p hact i j ≫
        (fixedOverlapQuotientIso act p hact i j).inv =
      ((overlap_affine act i j).isoSpec.hom ≫
        affineInvariantQuotientMap
          (k := k) (A := Γ(X, i.U ⊓ j.U)) (G := G) ≫
        (fixedOverlapQuotientIso act p hact i j).hom) ≫
          (fixedOverlapQuotientIso act p hact i j).inv :=
      congrArg (fun z => z ≫
        (fixedOverlapQuotientIso act p hact i j).inv) hpres.symm
    _ = (overlap_affine act i j).isoSpec.hom ≫
        affineInvariantQuotientMap
          (k := k) (A := Γ(X, i.U ⊓ j.U)) (G := G) := by
      simp only [Category.assoc, Iso.hom_inv_id, Category.comp_id]

/-- Reversing a descended quotient overlap agrees with reversing the actual
source intersection.  This is the source-chart compatibility equation needed
to glue the local quotient projections. -/
@[reassoc]
theorem overlapQuotientMap_comp_swap
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
    overlapQuotientMap act p hact i j ≫
        (quotientOverlapSwapIso act p hact i j).hom =
      (Scheme.isoOfEq X (inf_comm i.U j.U)).hom ≫
        overlapQuotientMap act p hact j i := by
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
  have hinv := overlapQuotientMap_comp_fixedPresentation_inv
    act p hact i j
  have hnatOver :=
    quotientMap_comp_rightQuotientMap (overlapCone act p hact i j)
  have hnat := congrArg (fun f => Over.Hom.left f) hnatOver
  change affineInvariantQuotientMap
      (k := k) (A := Γ(X, i.U ⊓ j.U)) (G := G) ≫
        (overlapCone act p hact i j).rightQuotientMap.left =
    (overlapCone act p hact i j).rightSourceMap.left ≫
      affineInvariantQuotientMap
        (k := k) (A := Γ(X, j.U)) (G := G) at hnat
  apply (cancel_mono (quotientOverlapι act p hact j i)).1
  simp only [Category.assoc]
  rw [quotientOverlapSwapIso_hom_comp_ι_eq_rightQuotientMap]
  calc
    overlapQuotientMap act p hact i j ≫
        (fixedOverlapQuotientIso act p hact i j).inv ≫
        (overlapCone act p hact i j).rightQuotientMap.left =
      (overlapQuotientMap act p hact i j ≫
        (fixedOverlapQuotientIso act p hact i j).inv) ≫
        (overlapCone act p hact i j).rightQuotientMap.left :=
      (Category.assoc _ _ _).symm
    _ = ((overlap_affine act i j).isoSpec.hom ≫
        affineInvariantQuotientMap
          (k := k) (A := Γ(X, i.U ⊓ j.U)) (G := G)) ≫
        (overlapCone act p hact i j).rightQuotientMap.left :=
      congrArg (fun z => z ≫
        (overlapCone act p hact i j).rightQuotientMap.left) hinv
    _ = (overlap_affine act i j).isoSpec.hom ≫
        affineInvariantQuotientMap
          (k := k) (A := Γ(X, i.U ⊓ j.U)) (G := G) ≫
        (overlapCone act p hact i j).rightQuotientMap.left :=
      Category.assoc _ _ _
    _ = (overlap_affine act i j).isoSpec.hom ≫
        (overlapCone act p hact i j).rightSourceMap.left ≫
          affineInvariantQuotientMap
            (k := k) (A := Γ(X, j.U)) (G := G) :=
      congrArg (fun z => (overlap_affine act i j).isoSpec.hom ≫ z) hnat
    _ = (Scheme.isoOfEq X (inf_comm i.U j.U)).hom ≫
        (overlapCoordinateIso act j i).inv ≫
          (overlapCoordinateOpen act j i).ι ≫
            affineInvariantQuotientMap
              (k := k) (A := Γ(X, j.U)) (G := G) := by
      have hsource := overlapIsoSpec_hom_comp_rightSourceMap
        act p hact i j
      calc
        (overlap_affine act i j).isoSpec.hom ≫
            (overlapCone act p hact i j).rightSourceMap.left ≫
              affineInvariantQuotientMap
                (k := k) (A := Γ(X, j.U)) (G := G) =
          ((overlap_affine act i j).isoSpec.hom ≫
            (overlapCone act p hact i j).rightSourceMap.left) ≫
              affineInvariantQuotientMap
                (k := k) (A := Γ(X, j.U)) (G := G) :=
          (Category.assoc _ _ _).symm
        _ = ((Scheme.isoOfEq X (inf_comm i.U j.U)).hom ≫
            (overlapCoordinateIso act j i).inv ≫
              (overlapCoordinateOpen act j i).ι) ≫
                affineInvariantQuotientMap
                  (k := k) (A := Γ(X, j.U)) (G := G) :=
          congrArg (fun z => z ≫ affineInvariantQuotientMap
            (k := k) (A := Γ(X, j.U)) (G := G)) hsource
        _ = (Scheme.isoOfEq X (inf_comm i.U j.U)).hom ≫
            (overlapCoordinateIso act j i).inv ≫
              (overlapCoordinateOpen act j i).ι ≫
                affineInvariantQuotientMap
                  (k := k) (A := Γ(X, j.U)) (G := G) := by
          simp only [Category.assoc]
    _ = (Scheme.isoOfEq X (inf_comm i.U j.U)).hom ≫
        (overlapQuotientMap act p hact j i ≫
          quotientOverlapι act p hact j i) :=
      congrArg (fun z =>
        (Scheme.isoOfEq X (inf_comm i.U j.U)).hom ≫ z)
        (overlapQuotientMap_fac act p hact j i).symm
    _ = ((Scheme.isoOfEq X (inf_comm i.U j.U)).hom ≫
        overlapQuotientMap act p hact j i) ≫
          quotientOverlapι act p hact j i :=
      (Category.assoc _ _ _).symm

section StableFamily

variable {J : Type u} [Finite J]

/-- The local quotient projection from a stable affine source chart into the
scheme obtained by gluing the quotient charts. -/
noncomputable def stableQuotientChartProjection
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (C : J → StableAffineOpen act) (i : J) :
    (C i).U.toScheme ⟶ (stableQuotientGlueData act p hact C).glued := by
  letI := sectionsAlgebra p (C i).U
  letI := sectionsMulSemiringAction act (C i).stable
  letI := sectionsSMulCommClass act p hact (C i).stable
  exact stableAffineQuotientMap act p hact (C i) ≫
    (stableQuotientGlueData act p hact C).ι i

/-- The local quotient projections agree on the actual intersection of two
stable affine source charts. -/
theorem stableQuotientChartProjection_inf
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (C : J → StableAffineOpen act) (i j : J) :
    X.homOfLE (show (C i).U ⊓ (C j).U ≤ (C i).U from inf_le_left) ≫
        stableQuotientChartProjection act p hact C i =
      X.homOfLE (show (C i).U ⊓ (C j).U ≤ (C j).U from inf_le_right) ≫
        stableQuotientChartProjection act p hact C j := by
  letI := sectionsAlgebra p (C i).U
  letI := sectionsAlgebra p (C j).U
  letI := sectionsAlgebra p ((C i).U ⊓ (C j).U)
  letI := sectionsAlgebra p ((C j).U ⊓ (C i).U)
  letI := sectionsMulSemiringAction act (C i).stable
  letI := sectionsMulSemiringAction act (C j).stable
  letI := sectionsMulSemiringAction act (overlap_stable act (C i) (C j))
  letI := sectionsMulSemiringAction act (overlap_stable act (C j) (C i))
  letI := sectionsSMulCommClass act p hact (C i).stable
  letI := sectionsSMulCommClass act p hact (C j).stable
  letI := sectionsSMulCommClass act p hact
    (overlap_stable act (C i) (C j))
  letI := sectionsSMulCommClass act p hact
    (overlap_stable act (C j) (C i))
  have hswap :
      (X.isoOfEq (inf_comm (C i).U (C j).U)).hom ≫
          X.homOfLE
            (show (C j).U ⊓ (C i).U ≤ (C j).U from inf_le_left) =
        X.homOfLE
          (show (C i).U ⊓ (C j).U ≤ (C j).U from inf_le_right) := by
    rw [← cancel_mono (C j).U.ι]
    simp
  have hglue := (stableQuotientGlueData act p hact C).glue_condition i j
  change (quotientOverlapSwapIso act p hact (C i) (C j)).hom ≫
      quotientOverlapι act p hact (C j) (C i) ≫
        (stableQuotientGlueData act p hact C).ι j =
    quotientOverlapι act p hact (C i) (C j) ≫
      (stableQuotientGlueData act p hact C).ι i at hglue
  simp only [stableQuotientChartProjection]
  calc
    X.homOfLE inf_le_left ≫
          (stableAffineQuotientMap act p hact (C i) ≫
            (stableQuotientGlueData act p hact C).ι i) =
        (X.homOfLE inf_le_left ≫
            stableAffineQuotientMap act p hact (C i)) ≫
          (stableQuotientGlueData act p hact C).ι i :=
      (Category.assoc _ _ _).symm
    _ = (overlapQuotientMap act p hact (C i) (C j) ≫
          quotientOverlapι act p hact (C i) (C j)) ≫
          (stableQuotientGlueData act p hact C).ι i :=
      congrArg (fun z => z ≫
        (stableQuotientGlueData act p hact C).ι i)
        (stableAffineQuotientMap_restrict act p hact (C i) (C j))
    _ = overlapQuotientMap act p hact (C i) (C j) ≫
          (quotientOverlapι act p hact (C i) (C j) ≫
            (stableQuotientGlueData act p hact C).ι i) :=
      Category.assoc _ _ _
    _ = overlapQuotientMap act p hact (C i) (C j) ≫
          ((quotientOverlapSwapIso act p hact (C i) (C j)).hom ≫
            quotientOverlapι act p hact (C j) (C i) ≫
              (stableQuotientGlueData act p hact C).ι j) :=
      congrArg (fun z =>
        overlapQuotientMap act p hact (C i) (C j) ≫ z) hglue.symm
    _ = (overlapQuotientMap act p hact (C i) (C j) ≫
          (quotientOverlapSwapIso act p hact (C i) (C j)).hom) ≫
            quotientOverlapι act p hact (C j) (C i) ≫
              (stableQuotientGlueData act p hact C).ι j := by
      simp only [Category.assoc]
    _ = ((X.isoOfEq (inf_comm (C i).U (C j).U)).hom ≫
          overlapQuotientMap act p hact (C j) (C i)) ≫
            quotientOverlapι act p hact (C j) (C i) ≫
              (stableQuotientGlueData act p hact C).ι j := by
      rw [overlapQuotientMap_comp_swap]
    _ = ((X.isoOfEq (inf_comm (C i).U (C j).U)).hom ≫
          (overlapQuotientMap act p hact (C j) (C i) ≫
            quotientOverlapι act p hact (C j) (C i))) ≫
              (stableQuotientGlueData act p hact C).ι j := by
      simp only [Category.assoc]
    _ = ((X.isoOfEq (inf_comm (C i).U (C j).U)).hom ≫
          (X.homOfLE inf_le_left ≫
            stableAffineQuotientMap act p hact (C j))) ≫
              (stableQuotientGlueData act p hact C).ι j :=
      congrArg (fun z =>
        ((X.isoOfEq (inf_comm (C i).U (C j).U)).hom ≫ z) ≫
          (stableQuotientGlueData act p hact C).ι j)
        (stableAffineQuotientMap_restrict
          act p hact (C j) (C i)).symm
    _ = (X.homOfLE inf_le_right ≫
          stableAffineQuotientMap act p hact (C j)) ≫
            (stableQuotientGlueData act p hact C).ι j := by
      rw [← Category.assoc, hswap]
    _ = X.homOfLE inf_le_right ≫
          (stableAffineQuotientMap act p hact (C j) ≫
            (stableQuotientGlueData act p hact C).ι j) :=
      Category.assoc _ _ _

/-- The stable-affine quotient projections satisfy the pullback compatibility
equation used by `Scheme.OpenCover.glueMorphisms`. -/
theorem stableQuotientChartProjection_compatible
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (C : J → StableAffineOpen act) (i j : J) :
    pullback.fst (C i).U.ι (C j).U.ι ≫
        stableQuotientChartProjection act p hact C i =
      pullback.snd (C i).U.ι (C j).U.ι ≫
        stableQuotientChartProjection act p hact C j := by
  rw [← cancel_epi
    (isPullback_opens_inf (C i).U (C j).U).isoPullback.hom]
  simpa only [IsPullback.isoPullback_hom_fst_assoc,
    IsPullback.isoPullback_hom_snd_assoc] using
      stableQuotientChartProjection_inf act p hact C i j

end StableFamily

end StableAffineOpen
end StableGroupAction
end MilneLib
