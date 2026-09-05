/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientStableOverlapOpenIso
import Mathlib.AlgebraicGeometry.Pullbacks

/-!
# Triple overlaps of stable affine quotient charts

For three stable affine charts, the descended open in one quotient chart is
the intersection of the two pairwise descended opens.  The resulting open
subscheme is therefore the pullback of the pairwise overlap immersions.  This
is the local triple-overlap input for a later global quotient gluing datum.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits AlgebraicGeometry Topology

namespace MilneLib
namespace StableGroupAction
namespace StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] {X : Scheme.{u}}
  (act : G →* Aut X) [X.IsSeparated]

/-- The triple intersection of stable opens is stable. -/
theorem triple_stable (i j l : StableAffineOpen act) :
    IsStableOpen act ((i.U ⊓ j.U) ⊓ (i.U ⊓ l.U)) := by
  intro g
  simp only [Scheme.Hom.preimage_inf, i.stable g, j.stable g, l.stable g]

/-- The triple intersection, written in the affine coordinates of its first
chart. -/
noncomputable def tripleCoordinateOpen (i j l : StableAffineOpen act) :
    (Spec (CommRingCat.of Γ(X, i.U))).Opens :=
  i.affine.isoSpec.inv ⁻¹ᵁ
    (i.U.ι ⁻¹ᵁ ((i.U ⊓ j.U) ⊓ (i.U ⊓ l.U)))

theorem tripleCoordinateOpen_eq_inf (i j l : StableAffineOpen act) :
    tripleCoordinateOpen act i j l =
      overlapCoordinateOpen act i j ⊓ overlapCoordinateOpen act i l := by
  unfold tripleCoordinateOpen overlapCoordinateOpen
  rw [← Scheme.Hom.preimage_inf]
  congr 1

theorem tripleCoordinateOpen_stable (i j l : StableAffineOpen act) :
    letI := sectionsMulSemiringAction act i.stable
    ∀ g : G, (specAction G Γ(X, i.U) g).hom ⁻¹ᵁ
      tripleCoordinateOpen act i j l = tripleCoordinateOpen act i j l := by
  letI := sectionsMulSemiringAction act i.stable
  intro g
  unfold tripleCoordinateOpen
  rw [← Scheme.Hom.comp_preimage,
    specAction_hom_isoSpec_inv act i.stable i.affine g,
    Scheme.Hom.comp_preimage]
  congr 1
  rw [← Scheme.Hom.comp_preimage,
    actRes_ι, Scheme.Hom.comp_preimage, (triple_stable act i j l) g]

/-- The descended quotient open corresponding to the triple intersection, in
the invariant quotient chart of `i`. -/
noncomputable def quotientTripleOpen [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    (Spec (CommRingCat.of
      (FixedPoints.subalgebra k Γ(X, i.U) G))).Opens := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  exact InvariantLocalization.quotientOpenOfStable
    (k := k) (A := Γ(X, i.U)) (G := G)
    (tripleCoordinateOpen act i j l)
    (tripleCoordinateOpen_stable act i j l)

/-- The descended triple open is the intersection of the two pairwise opens
inside the first quotient chart. -/
theorem quotientTripleOpen_eq_inf [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    quotientTripleOpen act p hact i j l =
      quotientOverlapOpen act p hact i j ⊓
        quotientOverlapOpen act p hact i l := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  have h := InvariantLocalization.quotientOpenOfStable_inf
    (k := k) (A := Γ(X, i.U)) (G := G)
    (overlapCoordinateOpen act i j)
    (overlapCoordinateOpen act i l)
    (overlapCoordinateOpen_stable act i j)
    (overlapCoordinateOpen_stable act i l)
  simpa only [quotientTripleOpen, quotientOverlapOpen,
    tripleCoordinateOpen_eq_inf] using h

/-- The open subscheme underlying the descended triple overlap. -/
noncomputable def quotientTriple [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) : Scheme.{u} := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  exact (quotientTripleOpen act p hact i j l).toScheme

/-- The descended triple overlap inclusion into the first quotient chart. -/
noncomputable def quotientTripleι [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    quotientTriple act p hact i j l ⟶
      Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U) G)) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  exact (quotientTripleOpen act p hact i j l).ι

instance quotientTripleι_isOpenImmersion [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    IsOpenImmersion (quotientTripleι act p hact i j l) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  unfold quotientTripleι quotientTriple quotientTripleOpen
  infer_instance

/-- The affine-coordinate presentation of the source triple intersection. -/
noncomputable def tripleCoordinateIso (i j l : StableAffineOpen act) :
    (tripleCoordinateOpen act i j l).toScheme ≅
      ((i.U ⊓ j.U) ⊓ (i.U ⊓ l.U)).toScheme :=
  (i.affine.isoSpec.inv.preimageIso
      (i.U.ι ⁻¹ᵁ ((i.U ⊓ j.U) ⊓ (i.U ⊓ l.U)))).trans
    (Scheme.Opens.isoOfLE
      (show ((i.U ⊓ j.U) ⊓ (i.U ⊓ l.U)) ≤ i.U from
        (inf_le_left.trans inf_le_left)))

/-- The affine invariant quotient map on the coordinate triple open. -/
noncomputable def tripleCoordinateQuotientMap [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    (tripleCoordinateOpen act i j l).toScheme ⟶
      quotientTriple act p hact i j l := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  exact InvariantLocalization.affineInvariantQuotientMapRestrictStable
    (k := k) (A := Γ(X, i.U)) (G := G)
    (tripleCoordinateOpen act i j l)
    (tripleCoordinateOpen_stable act i j l)

@[reassoc]
theorem tripleCoordinateQuotientMap_fac [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    tripleCoordinateQuotientMap act p hact i j l ≫
        quotientTripleι act p hact i j l =
      (tripleCoordinateOpen act i j l).ι ≫
        affineInvariantQuotientMap
          (k := k) (A := Γ(X, i.U)) (G := G) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  exact InvariantLocalization.affineInvariantQuotientMapRestrictStable_fac
    (k := k) (A := Γ(X, i.U)) (G := G)
    (tripleCoordinateOpen act i j l)
    (tripleCoordinateOpen_stable act i j l)

/-- The quotient projection from the actual source triple intersection. -/
noncomputable def tripleQuotientMap [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    ((i.U ⊓ j.U) ⊓ (i.U ⊓ l.U)).toScheme ⟶
      quotientTriple act p hact i j l := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  exact (tripleCoordinateIso act i j l).inv ≫
    tripleCoordinateQuotientMap act p hact i j l

@[reassoc]
theorem tripleQuotientMap_fac [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    tripleQuotientMap act p hact i j l ≫
        quotientTripleι act p hact i j l =
      (tripleCoordinateIso act i j l).inv ≫
        (tripleCoordinateOpen act i j l).ι ≫
          affineInvariantQuotientMap
            (k := k) (A := Γ(X, i.U)) (G := G) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  rw [tripleQuotientMap, Category.assoc,
    tripleCoordinateQuotientMap_fac]

theorem quotientTripleOpen_le_overlapLeft [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    quotientTripleOpen act p hact i j l ≤
      quotientOverlapOpen act p hact i j := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  rw [quotientTripleOpen_eq_inf]
  exact inf_le_left

theorem quotientTripleOpen_le_overlapRight [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    quotientTripleOpen act p hact i j l ≤
      quotientOverlapOpen act p hact i l := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  rw [quotientTripleOpen_eq_inf]
  exact inf_le_right

/-- Restriction from the triple overlap to its first pairwise overlap. -/
noncomputable def tripleToOverlapLeft [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    quotientTriple act p hact i j l ⟶ quotientOverlap act p hact i j := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  unfold quotientTriple quotientOverlap
  exact Scheme.homOfLE _ (quotientTripleOpen_le_overlapLeft act p hact i j l)

@[reassoc]
theorem tripleToOverlapLeft_fac [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    tripleToOverlapLeft act p hact i j l ≫
        quotientOverlapι act p hact i j =
      quotientTripleι act p hact i j l := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  unfold tripleToOverlapLeft quotientOverlapι quotientTripleι
    quotientOverlap quotientTriple
  exact Scheme.homOfLE_ι _ (quotientTripleOpen_le_overlapLeft act p hact i j l)

/-- Restriction from the triple overlap to its second pairwise overlap. -/
noncomputable def tripleToOverlapRight [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    quotientTriple act p hact i j l ⟶ quotientOverlap act p hact i l := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  unfold quotientTriple quotientOverlap
  exact Scheme.homOfLE _ (quotientTripleOpen_le_overlapRight act p hact i j l)

@[reassoc]
theorem tripleToOverlapRight_fac [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    tripleToOverlapRight act p hact i j l ≫
        quotientOverlapι act p hact i l =
      quotientTripleι act p hact i j l := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  unfold tripleToOverlapRight quotientOverlapι quotientTripleι
    quotientOverlap quotientTriple
  exact Scheme.homOfLE_ι _ (quotientTripleOpen_le_overlapRight act p hact i j l)

/-- The pullback of the two pairwise quotient opens in chart `i` is the
descended triple open. -/
noncomputable def pullbackOverlapIsoTriple [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    pullback (quotientOverlapι act p hact i j)
        (quotientOverlapι act p hact i l) ≅
      quotientTriple act p hact i j l := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  let A := quotientOverlapOpen act p hact i j
  let B := quotientOverlapOpen act p hact i l
  let Q := Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U) G))
  have himage : A.ι ''ᵁ (A.ι ⁻¹ᵁ B) = A ⊓ B := by
    rw [Scheme.Hom.image_preimage_eq_opensRange_inf,
      Scheme.Opens.opensRange_ι]
  have hinf : quotientTripleOpen act p hact i j l = A ⊓ B := by
    exact quotientTripleOpen_eq_inf act p hact i j l
  exact pullbackRestrictIsoRestrict A.ι B ≪≫
    A.ι.isoImage (A.ι ⁻¹ᵁ B) ≪≫
    Q.isoOfEq himage ≪≫
    Q.isoOfEq hinf.symm

@[reassoc]
theorem pullbackOverlapIsoTriple_hom_fst [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    (pullbackOverlapIsoTriple act p hact i j l).hom ≫
        tripleToOverlapLeft act p hact i j l =
      pullback.fst (quotientOverlapι act p hact i j)
        (quotientOverlapι act p hact i l) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  rw [← cancel_mono (quotientOverlapι act p hact i j)]
  rw [Category.assoc, tripleToOverlapLeft_fac]
  unfold pullbackOverlapIsoTriple quotientTripleι quotientOverlapι
    quotientTriple quotientOverlap
  simp

@[reassoc]
theorem pullbackOverlapIsoTriple_hom_snd [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j l : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    (pullbackOverlapIsoTriple act p hact i j l).hom ≫
        tripleToOverlapRight act p hact i j l =
      pullback.snd (quotientOverlapι act p hact i j)
        (quotientOverlapι act p hact i l) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  rw [← cancel_mono (quotientOverlapι act p hact i l)]
  rw [Category.assoc, tripleToOverlapRight_fac]
  unfold pullbackOverlapIsoTriple quotientTripleι quotientOverlapι
    quotientTriple quotientOverlap
  simpa using (pullback.condition :
    pullback.fst
        (quotientOverlapOpen act p hact i j).ι
        (quotientOverlapOpen act p hact i l).ι ≫
      (quotientOverlapOpen act p hact i j).ι =
    pullback.snd
        (quotientOverlapOpen act p hact i j).ι
        (quotientOverlapOpen act p hact i l).ι ≫
      (quotientOverlapOpen act p hact i l).ι)

end StableAffineOpen
end StableGroupAction
end MilneLib
