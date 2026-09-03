/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientOverlap

/-!
# Sections on invariant quotient charts

The structure sheaf on an invariant basic open of `Spec (A^G)` is the
localization of `A^G` at its defining element.  Combining this description
with the fixed-localization theorem identifies its sections with the fixed
subring of the corresponding localization of `A`.

The main results prove that this identification carries actual presheaf
restriction maps to the fixed-localized transition maps constructed in
`InvariantLocalizationTransitions`, and that the affine quotient map on
sections is the inclusion of the fixed subring into the full localization.
-/

set_option autoImplicit false

universe u v

open CategoryTheory AlgebraicGeometry Topology TopologicalSpace

namespace MilneLib
namespace InvariantLocalization

variable {k : Type u} {A : Type v} {G : Type*}
  [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A]

/-- Restriction maps on an affine spectrum commute with the canonical algebra
maps from its coordinate ring. -/
theorem specRestriction_comp_algebraMap
    {R : CommRingCat} {U V : (Spec R).Opens} (hVU : V ≤ U) :
    ((Spec R).presheaf.map (homOfLE hVU).op).hom.comp
        (algebraMap R Γ(Spec R, U)) =
      algebraMap R Γ(Spec R, V) := by
  have hU := AlgebraicGeometry.IsAffineOpen.algebraMap_Spec_obj
    (R := R) (U := U)
  have hV := AlgebraicGeometry.IsAffineOpen.algebraMap_Spec_obj
    (R := R) (U := V)
  have hcat :
      (Scheme.ΓSpecIso R).inv ≫
          (Spec R).presheaf.map
            (homOfLE (show U ≤ (⊤ : (Spec R).Opens) from le_top)).op ≫
          (Spec R).presheaf.map (homOfLE hVU).op =
        (Scheme.ΓSpecIso R).inv ≫
          (Spec R).presheaf.map
            (homOfLE (show V ≤ (⊤ : (Spec R).Opens) from le_top)).op := by
    rw [← Functor.map_comp]
    rfl
  calc
    ((Spec R).presheaf.map (homOfLE hVU).op).hom.comp
        (algebraMap R Γ(Spec R, U)) =
      ((Spec R).presheaf.map (homOfLE hVU).op).hom.comp
        (((Scheme.ΓSpecIso R).inv ≫
          (Spec R).presheaf.map
            (homOfLE (show U ≤ (⊤ : (Spec R).Opens) from le_top)).op).hom) :=
      congrArg ((Spec R).presheaf.map (homOfLE hVU).op).hom.comp hU
    _ = (((Scheme.ΓSpecIso R).inv ≫
          (Spec R).presheaf.map
            (homOfLE (show V ≤ (⊤ : (Spec R).Opens) from le_top)).op).hom) := by
      exact congrArg CommRingCat.Hom.hom hcat
    _ = algebraMap R Γ(Spec R, V) := hV.symm

/-- Sections of the quotient structure sheaf on the invariant basic open
defined by `b`. -/
noncomputable abbrev invariantQuotientBasicOpenSections
    (b : FixedPoints.subalgebra k A G) :=
  Γ(Spec (CommRingCat.of (FixedPoints.subalgebra k A G)),
    (PrimeSpectrum.basicOpen b :
      (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).Opens))

set_option linter.style.longLine false in
noncomputable local instance invariantQuotientBasicOpenSectionsAlgebra
    (b : FixedPoints.subalgebra k A G) :
    Algebra (FixedPoints.subalgebra k A G)
      (invariantQuotientBasicOpenSections b) :=
  @AlgebraicGeometry.IsAffineOpen.instAlgebraCarrierObjOppositeOpensCarrierCarrierCommRingCatSpecPresheafOpOpens
    (CommRingCat.of (FixedPoints.subalgebra k A G))
    (PrimeSpectrum.basicOpen b)

set_option linter.style.longLine false in
local instance invariantQuotientBasicOpenSectionsIsLocalization
    (b : FixedPoints.subalgebra k A G) :
    IsLocalization.Away b (invariantQuotientBasicOpenSections b) :=
  @AlgebraicGeometry.IsAffineOpen.instAwayCarrierObjOppositeOpensCarrierCarrierCommRingCatSpecPresheafOpOpensBasicOpen
    (CommRingCat.of (FixedPoints.subalgebra k A G)) b

/-- The canonical identification of sections on an invariant quotient basic
open with the corresponding fixed-localized section ring. -/
noncomputable def quotientBasicOpenSectionsEquiv [Finite G]
    (b : FixedPoints.subalgebra k A G) :
    invariantQuotientBasicOpenSections b ≃+* fixedAway (b : A) b.property := by
  letI : Algebra (FixedPoints.subalgebra k A G)
      (fixedAway (b : A) b.property) := fixedAwayAlgebra b
  letI : IsLocalization.Away b (fixedAway (b : A) b.property) :=
    fixedAway_isLocalization b
  exact (IsLocalization.algEquiv (Submonoid.powers b)
    (invariantQuotientBasicOpenSections b)
    (fixedAway (b : A) b.property)).toRingEquiv

@[simp]
theorem quotientBasicOpenSectionsEquiv_algebraMap [Finite G]
    (b a : FixedPoints.subalgebra k A G) :
    quotientBasicOpenSectionsEquiv b
        (algebraMap (FixedPoints.subalgebra k A G)
          (invariantQuotientBasicOpenSections b) a) =
      invariantToFixedAway b a := by
  letI : Algebra (FixedPoints.subalgebra k A G)
      (fixedAway (b : A) b.property) := fixedAwayAlgebra b
  letI : IsLocalization.Away b (fixedAway (b : A) b.property) :=
    fixedAway_isLocalization b
  change (IsLocalization.algEquiv (Submonoid.powers b)
      (invariantQuotientBasicOpenSections b)
      (fixedAway (b : A) b.property))
        (algebraMap (FixedPoints.subalgebra k A G)
          (invariantQuotientBasicOpenSections b) a) =
      algebraMap (FixedPoints.subalgebra k A G)
        (fixedAway (b : A) b.property) a
  exact AlgEquiv.commutes _ a

/-- Ring-hom form of `quotientBasicOpenSectionsEquiv_algebraMap`. -/
theorem quotientBasicOpenSectionsEquiv_comp_algebraMap [Finite G]
    (b : FixedPoints.subalgebra k A G) :
    (quotientBasicOpenSectionsEquiv b).toRingHom.comp
        (algebraMap (FixedPoints.subalgebra k A G)
          (invariantQuotientBasicOpenSections b)) =
      invariantToFixedAway b := by
  ext a
  exact congrArg Subtype.val
    (quotientBasicOpenSectionsEquiv_algebraMap b a)

/-- Structure-sheaf restriction between nested quotient basic opens commutes
with the algebra maps from the invariant ring. -/
theorem invariantQuotientBasicOpen_res_comp_algebraMap
    {b c : FixedPoints.subalgebra k A G}
    (hcb : PrimeSpectrum.basicOpen c ≤ PrimeSpectrum.basicOpen b) :
    ((Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).presheaf.map
          (homOfLE hcb).op).hom.comp
        (algebraMap (FixedPoints.subalgebra k A G)
          (invariantQuotientBasicOpenSections b)) =
      algebraMap (FixedPoints.subalgebra k A G)
        (invariantQuotientBasicOpenSections c) := by
  exact specRestriction_comp_algebraMap hcb

/-- Under the canonical fixed-localization presentations, structure-sheaf
restriction between invariant quotient basic opens is `fixedAwayTransition`.
This is the basis-level sheaf comparison needed for quotient-chart gluing. -/
theorem quotientBasicOpenSectionsEquiv_naturality [Finite G]
    {b c : FixedPoints.subalgebra k A G}
    (hcb : PrimeSpectrum.basicOpen c ≤ PrimeSpectrum.basicOpen b) :
    (quotientBasicOpenSectionsEquiv c).toRingHom.comp
        ((Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).presheaf.map
          (homOfLE hcb).op).hom =
      (fixedAwayTransition (k := k) (A := A) (G := G) hcb).comp
        (quotientBasicOpenSectionsEquiv b).toRingHom := by
  let res :=
    ((Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).presheaf.map
      (homOfLE hcb).op).hom
  let algebraMapB :=
    algebraMap (FixedPoints.subalgebra k A G)
      (invariantQuotientBasicOpenSections b)
  let algebraMapC :=
    algebraMap (FixedPoints.subalgebra k A G)
      (invariantQuotientBasicOpenSections c)
  refine @IsLocalization.ringHom_ext
    (FixedPoints.subalgebra k A G) inferInstance (Submonoid.powers b)
    (invariantQuotientBasicOpenSections b) inferInstance
    (invariantQuotientBasicOpenSectionsAlgebra b)
    (invariantQuotientBasicOpenSectionsIsLocalization b)
    (fixedAway (c : A) c.property) inferInstance _ _ ?_
  calc
    ((quotientBasicOpenSectionsEquiv c).toRingHom.comp res).comp algebraMapB =
      (quotientBasicOpenSectionsEquiv c).toRingHom.comp
        (res.comp algebraMapB) := RingHom.comp_assoc _ _ _
    _ = (quotientBasicOpenSectionsEquiv c).toRingHom.comp algebraMapC :=
      congrArg (quotientBasicOpenSectionsEquiv c).toRingHom.comp
        (invariantQuotientBasicOpen_res_comp_algebraMap hcb)
    _ = invariantToFixedAway c :=
      quotientBasicOpenSectionsEquiv_comp_algebraMap c
    _ = (fixedAwayTransition (k := k) (A := A) (G := G) hcb).comp
        (invariantToFixedAway b) :=
      (fixedAwayTransition_comp_invariantToFixedAway hcb).symm
    _ = (fixedAwayTransition (k := k) (A := A) (G := G) hcb).comp
        ((quotientBasicOpenSectionsEquiv b).toRingHom.comp algebraMapB) :=
      congrArg (fixedAwayTransition (k := k) (A := A) (G := G) hcb).comp
        (quotientBasicOpenSectionsEquiv_comp_algebraMap b).symm
    _ = ((fixedAwayTransition (k := k) (A := A) (G := G) hcb).comp
        (quotientBasicOpenSectionsEquiv b).toRingHom).comp algebraMapB :=
      (RingHom.comp_assoc _ _ _).symm

/-! ## The quotient map on sections -/

/-- Sections on the source basic open defined by the image of an invariant
element. -/
noncomputable abbrev invariantSourceBasicOpenSections
    (b : FixedPoints.subalgebra k A G) :=
  Γ(Spec (CommRingCat.of A),
    (PrimeSpectrum.basicOpen (b : A) :
      (Spec (CommRingCat.of A)).Opens))

/-- Sections on the exact preimage of an invariant quotient basic open. -/
noncomputable abbrev invariantSourceBasicOpenPreimageSections
    (b : FixedPoints.subalgebra k A G) :=
  Γ(Spec (CommRingCat.of A),
    (affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ
      (PrimeSpectrum.basicOpen b :
        (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).Opens))

set_option linter.style.longLine false in
noncomputable local instance invariantSourceBasicOpenSectionsAlgebra
    (b : FixedPoints.subalgebra k A G) :
    Algebra A (invariantSourceBasicOpenSections b) :=
  @AlgebraicGeometry.IsAffineOpen.instAlgebraCarrierObjOppositeOpensCarrierCarrierCommRingCatSpecPresheafOpOpens
    (CommRingCat.of A) (PrimeSpectrum.basicOpen (b : A))

set_option linter.style.longLine false in
local instance invariantSourceBasicOpenSectionsIsLocalization
    (b : FixedPoints.subalgebra k A G) :
    IsLocalization.Away (b : A) (invariantSourceBasicOpenSections b) :=
  @AlgebraicGeometry.IsAffineOpen.instAwayCarrierObjOppositeOpensCarrierCarrierCommRingCatSpecPresheafOpOpensBasicOpen
    (CommRingCat.of A) (b : A)

set_option linter.style.longLine false in
noncomputable local instance invariantSourceBasicOpenPreimageSectionsAlgebra
    (b : FixedPoints.subalgebra k A G) :
    Algebra A (invariantSourceBasicOpenPreimageSections b) :=
  @AlgebraicGeometry.IsAffineOpen.instAlgebraCarrierObjOppositeOpensCarrierCarrierCommRingCatSpecPresheafOpOpens
    (CommRingCat.of A)
    ((affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ
      (PrimeSpectrum.basicOpen b :
        (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).Opens))

/-- Transport sections on the exact preimage of `D(b)` to sections on the
equal source basic open `D((b : A))`. -/
noncomputable def invariantSourceBasicOpenPreimageEquiv
    (b : FixedPoints.subalgebra k A G) :
    invariantSourceBasicOpenPreimageSections b ≃+*
      invariantSourceBasicOpenSections b :=
  ((Spec (CommRingCat.of A)).presheaf.mapIso
    (eqToIso (affineInvariantQuotientMap_preimage_basicOpen_fixed
      (k := k) (A := A) (G := G) b)).op).commRingCatIsoToRingEquiv

theorem invariantSourceBasicOpenPreimageEquiv_comp_algebraMap
    (b : FixedPoints.subalgebra k A G) :
    (invariantSourceBasicOpenPreimageEquiv b).toRingHom.comp
        (algebraMap A (invariantSourceBasicOpenPreimageSections b)) =
      algebraMap A (invariantSourceBasicOpenSections b) := by
  let h := affineInvariantQuotientMap_preimage_basicOpen_fixed
    (k := k) (A := A) (G := G) b
  change ((Spec (CommRingCat.of A)).presheaf.map
      (eqToIso h).op.hom).hom.comp
        (algebraMap A (invariantSourceBasicOpenPreimageSections b)) =
      algebraMap A (invariantSourceBasicOpenSections b)
  rw [show (eqToIso h).op.hom = (homOfLE h.ge).op from Subsingleton.elim _ _]
  exact specRestriction_comp_algebraMap h.ge

/-- The canonical localization presentation of sections on the source basic
open `D((b : A))`. -/
noncomputable def sourceBasicOpenSectionsEquiv
    (b : FixedPoints.subalgebra k A G) :
    invariantSourceBasicOpenSections b ≃+* Localization.Away (b : A) :=
  (IsLocalization.algEquiv (Submonoid.powers (b : A))
    (invariantSourceBasicOpenSections b)
    (Localization.Away (b : A))).toRingEquiv

@[simp]
theorem sourceBasicOpenSectionsEquiv_algebraMap
    (b : FixedPoints.subalgebra k A G) (a : A) :
    sourceBasicOpenSectionsEquiv b
        (algebraMap A (invariantSourceBasicOpenSections b) a) =
      algebraMap A (Localization.Away (b : A)) a := by
  change (IsLocalization.algEquiv (Submonoid.powers (b : A))
      (invariantSourceBasicOpenSections b) (Localization.Away (b : A)))
        (algebraMap A (invariantSourceBasicOpenSections b) a) =
    algebraMap A (Localization.Away (b : A)) a
  exact AlgEquiv.commutes _ a

/-- Ring-hom form of `sourceBasicOpenSectionsEquiv_algebraMap`. -/
theorem sourceBasicOpenSectionsEquiv_comp_algebraMap
    (b : FixedPoints.subalgebra k A G) :
    (sourceBasicOpenSectionsEquiv b).toRingHom.comp
        (algebraMap A (invariantSourceBasicOpenSections b)) =
      algebraMap A (Localization.Away (b : A)) := by
  ext a
  exact sourceBasicOpenSectionsEquiv_algebraMap b a

/-- The localization presentation of sections on the exact preimage of an
invariant quotient basic open. -/
noncomputable def invariantSourceBasicOpenPreimageSectionsEquiv
    (b : FixedPoints.subalgebra k A G) :
    invariantSourceBasicOpenPreimageSections b ≃+*
      Localization.Away (b : A) :=
  (invariantSourceBasicOpenPreimageEquiv b).trans
    (sourceBasicOpenSectionsEquiv b)

theorem invariantSourceBasicOpenPreimageSectionsEquiv_comp_algebraMap
    (b : FixedPoints.subalgebra k A G) :
    (invariantSourceBasicOpenPreimageSectionsEquiv b).toRingHom.comp
        (algebraMap A (invariantSourceBasicOpenPreimageSections b)) =
      algebraMap A (Localization.Away (b : A)) := by
  change (sourceBasicOpenSectionsEquiv b).toRingHom.comp
      ((invariantSourceBasicOpenPreimageEquiv b).toRingHom.comp
        (algebraMap A (invariantSourceBasicOpenPreimageSections b))) =
    algebraMap A (Localization.Away (b : A))
  rw [invariantSourceBasicOpenPreimageEquiv_comp_algebraMap,
    sourceBasicOpenSectionsEquiv_comp_algebraMap]

/-- On an invariant basic open, the affine quotient map on structure-sheaf
sections commutes with the coordinate-ring inclusion. -/
theorem affineInvariantQuotientMap_app_basicOpen_comp_algebraMap
    (b : FixedPoints.subalgebra k A G) :
    ((affineInvariantQuotientMap (k := k) (A := A) (G := G)).app
        (PrimeSpectrum.basicOpen b)).hom.comp
      (algebraMap (FixedPoints.subalgebra k A G)
        (invariantQuotientBasicOpenSections b)) =
    (algebraMap A (invariantSourceBasicOpenPreimageSections b)).comp
      (algebraMap (FixedPoints.subalgebra k A G) A) := by
  have h := StructureSheaf.toOpen_comp_comap
    (algebraMap (FixedPoints.subalgebra k A G) A)
    (PrimeSpectrum.basicOpen b)
  change (StructureSheaf.comap
      (algebraMap (FixedPoints.subalgebra k A G) A)
      (PrimeSpectrum.basicOpen b)
      ((Opens.map (Spec.map (CommRingCat.ofHom
        (algebraMap (FixedPoints.subalgebra k A G) A))).base).obj
          (PrimeSpectrum.basicOpen b)) _).comp
      (algebraMap (FixedPoints.subalgebra k A G)
        (invariantQuotientBasicOpenSections b)) =
    (algebraMap A (invariantSourceBasicOpenPreimageSections b)).comp
      (algebraMap (FixedPoints.subalgebra k A G) A)
  convert congrArg CommRingCat.Hom.hom h using 1 <;> rfl

/-- Under the canonical localization presentations on an invariant basic open,
the affine quotient map on actual structure-sheaf sections is the inclusion of
the fixed subring into the full localization. -/
theorem affineInvariantQuotientMap_app_basicOpen_fixed [Finite G]
    (b : FixedPoints.subalgebra k A G) :
    (invariantSourceBasicOpenPreimageSectionsEquiv b).toRingHom.comp
        ((affineInvariantQuotientMap (k := k) (A := A) (G := G)).app
          (PrimeSpectrum.basicOpen b)).hom =
      (fixedAway (b : A) b.property).subtype.comp
        (quotientBasicOpenSectionsEquiv b).toRingHom := by
  let qApp :=
    ((affineInvariantQuotientMap (k := k) (A := A) (G := G)).app
      (PrimeSpectrum.basicOpen b)).hom
  let algebraMapQ :=
    algebraMap (FixedPoints.subalgebra k A G)
      (invariantQuotientBasicOpenSections b)
  let algebraMapPreimage :=
    algebraMap A (invariantSourceBasicOpenPreimageSections b)
  let invariantInclusion :=
    algebraMap (FixedPoints.subalgebra k A G) A
  refine @IsLocalization.ringHom_ext
    (FixedPoints.subalgebra k A G) inferInstance (Submonoid.powers b)
    (invariantQuotientBasicOpenSections b) inferInstance
    (invariantQuotientBasicOpenSectionsAlgebra b)
    (invariantQuotientBasicOpenSectionsIsLocalization b)
    (Localization.Away (b : A)) inferInstance _ _ ?_
  calc
    ((invariantSourceBasicOpenPreimageSectionsEquiv b).toRingHom.comp qApp).comp
        algebraMapQ =
      (invariantSourceBasicOpenPreimageSectionsEquiv b).toRingHom.comp
        (qApp.comp algebraMapQ) := RingHom.comp_assoc _ _ _
    _ = (invariantSourceBasicOpenPreimageSectionsEquiv b).toRingHom.comp
        (algebraMapPreimage.comp invariantInclusion) :=
      congrArg (invariantSourceBasicOpenPreimageSectionsEquiv b).toRingHom.comp
        (affineInvariantQuotientMap_app_basicOpen_comp_algebraMap b)
    _ = ((invariantSourceBasicOpenPreimageSectionsEquiv b).toRingHom.comp
        algebraMapPreimage).comp invariantInclusion :=
      (RingHom.comp_assoc _ _ _).symm
    _ = (algebraMap A (Localization.Away (b : A))).comp
        invariantInclusion :=
      congrArg (fun f => f.comp invariantInclusion)
        (invariantSourceBasicOpenPreimageSectionsEquiv_comp_algebraMap b)
    _ = (fixedAway (b : A) b.property).subtype.comp
        (invariantToFixedAway b) := by rfl
    _ = (fixedAway (b : A) b.property).subtype.comp
        ((quotientBasicOpenSectionsEquiv b).toRingHom.comp algebraMapQ) :=
      congrArg (fixedAway (b : A) b.property).subtype.comp
        (quotientBasicOpenSectionsEquiv_comp_algebraMap b).symm
    _ = ((fixedAway (b : A) b.property).subtype.comp
        (quotientBasicOpenSectionsEquiv b).toRingHom).comp algebraMapQ :=
      (RingHom.comp_assoc _ _ _).symm

end InvariantLocalization
end MilneLib
