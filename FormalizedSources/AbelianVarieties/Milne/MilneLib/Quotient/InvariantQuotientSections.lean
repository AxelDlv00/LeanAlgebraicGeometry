/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Affine.InvariantLocalizationTransitions
import MilneLib.Quotient.InvariantQuotientOpen
import MilneLib.Affine.StableAffineSections
import Mathlib.Topology.Sheaves.SheafCondition.UniqueGluing

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
On arbitrary opens, sheaf gluing and the comparison with geometric pullback
identify its image with the fixed subring of actual structure-sheaf sections.
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
  exact congrArg CommRingCat.Hom.hom
    (StructureSheaf.algebraMap_self_map R (Opposite.op V) (Opposite.op U)
      (homOfLE hVU).op)

/-- Pullback along a spectrum map, followed by restriction, agrees with the
given ring map on the images of coordinate-ring elements. -/
theorem specMap_appLE_comp_algebraMap {R S : CommRingCat} (f : R ⟶ S)
    (U : (Spec R).Opens) (V : (Spec S).Opens)
    (h : V ≤ (Spec.map f) ⁻¹ᵁ U) :
    ((Spec.map f).appLE U V h).hom.comp (algebraMap R Γ(Spec R, U)) =
      (algebraMap S Γ(Spec S, V)).comp f.hom := by
  have hc : ((Spec.map f).app U).hom.comp (algebraMap R Γ(Spec R, U)) =
      (algebraMap S Γ(Spec S, (Spec.map f) ⁻¹ᵁ U)).comp f.hom := by
    exact congrArg CommRingCat.Hom.hom (StructureSheaf.toOpen_comp_comap f.hom U)
  change (((Spec S).presheaf.map (homOfLE h).op).hom.comp
      ((Spec.map f).app U).hom).comp (algebraMap R Γ(Spec R, U)) = _
  rw [RingHom.comp_assoc, hc, ← RingHom.comp_assoc,
    specRestriction_comp_algebraMap]

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

/-- The localization presentation intertwines geometric section pullback with
the localized ring action. The inverse occurs because `Spec` is contravariant. -/
theorem invariantSourceBasicOpenPreimageSectionsEquiv_actApp
    (b : FixedPoints.subalgebra k A G)
    (hU : StableGroupAction.IsStableOpen (specAction G A)
      ((affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ
        PrimeSpectrum.basicOpen b)) (g : G) :
    (invariantSourceBasicOpenPreimageSectionsEquiv b).toRingHom.comp
        (StableGroupAction.actApp (specAction G A) hU g).hom =
      (awayMap (b : A) b.property g⁻¹).comp
        (invariantSourceBasicOpenPreimageSectionsEquiv b).toRingHom := by
  let U := (affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ
    PrimeSpectrum.basicOpen b
  have he (a : A) : invariantSourceBasicOpenPreimageSectionsEquiv b
      (algebraMap A (invariantSourceBasicOpenPreimageSections b) a) =
      algebraMap A (Localization.Away (b : A)) a :=
    RingHom.congr_fun (invariantSourceBasicOpenPreimageSectionsEquiv_comp_algebraMap b) a
  let e : invariantSourceBasicOpenPreimageSections b ≃ₐ[A] Localization.Away (b : A) :=
    { invariantSourceBasicOpenPreimageSectionsEquiv b with commutes' := he }
  letI : IsLocalization.Away (b : A) (invariantSourceBasicOpenPreimageSections b) :=
    IsLocalization.isLocalization_of_algEquiv (Submonoid.powers (b : A)) e.symm
  have hc := specMap_appLE_comp_algebraMap
    (CommRingCat.ofHom (MulSemiringAction.toRingHom G A g⁻¹)) U U (hU g).ge
  refine IsLocalization.ringHom_ext (Submonoid.powers (b : A)) ?_
  ext a
  change invariantSourceBasicOpenPreimageSectionsEquiv b
      ((StableGroupAction.actApp (specAction G A) hU g).hom
        (algebraMap A (invariantSourceBasicOpenPreimageSections b) a)) =
    awayMap (b : A) b.property g⁻¹
      (invariantSourceBasicOpenPreimageSectionsEquiv b
        (algebraMap A (invariantSourceBasicOpenPreimageSections b) a))
  rw [show (StableGroupAction.actApp (specAction G A) hU g).hom
      (algebraMap A (invariantSourceBasicOpenPreimageSections b) a) =
      algebraMap A (invariantSourceBasicOpenPreimageSections b) (g⁻¹ • a) from
    RingHom.congr_fun hc a]
  rw [he, he, awayMap_algebraMap]

/-- Fixed elements in the localization presentation are exactly the sections
fixed by geometric pullback on the corresponding stable open. -/
theorem invariantSourceBasicOpenPreimageSectionsEquiv_mem_fixedAway_iff
    (b : FixedPoints.subalgebra k A G)
    (hU : StableGroupAction.IsStableOpen (specAction G A)
      ((affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ
        PrimeSpectrum.basicOpen b))
    (s : invariantSourceBasicOpenPreimageSections b) :
    invariantSourceBasicOpenPreimageSectionsEquiv b s ∈ fixedAway (b : A) b.property ↔
      ∀ g : G, (StableGroupAction.actApp (specAction G A) hU g).hom s = s := by
  rw [mem_fixedAway]
  have he (g : G) := RingHom.congr_fun
    (invariantSourceBasicOpenPreimageSectionsEquiv_actApp b hU g) s
  constructor
  · intro hs g
    apply (invariantSourceBasicOpenPreimageSectionsEquiv b).injective
    exact (he g).trans (hs g⁻¹)
  · intro hs g
    have h := (he g⁻¹).symm.trans
      (congrArg (invariantSourceBasicOpenPreimageSectionsEquiv b) (hs g⁻¹))
    simpa only [inv_inv, RingHom.comp_apply, RingEquiv.toRingHom_eq_coe,
      RingEquiv.coe_toRingHom] using h

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

/-- Pullback along the affine quotient is injective on sections of each
principal open, since its localization presentation is a fixed-subring inclusion. -/
theorem affineInvariantQuotientMap_app_basicOpen_injective [Finite G]
    (b : FixedPoints.subalgebra k A G) :
    Function.Injective ((affineInvariantQuotientMap (k := k) (A := A) (G := G)).app
      (PrimeSpectrum.basicOpen b)).hom := by
  intro s t hst
  apply (quotientBasicOpenSectionsEquiv b).injective
  apply Subtype.val_injective
  have hs := RingHom.congr_fun (affineInvariantQuotientMap_app_basicOpen_fixed b) s
  have ht := RingHom.congr_fun (affineInvariantQuotientMap_app_basicOpen_fixed b) t
  exact hs.symm.trans ((congrArg (invariantSourceBasicOpenPreimageSectionsEquiv b) hst).trans ht)

/-- The image of pullback on an invariant quotient basic open is exactly the
fixed subring inside the corresponding source localization.  This is the
chartwise section-image statement used by the later sheaf descent argument. -/
theorem affineInvariantQuotientMap_app_basicOpen_range [Finite G]
    (b : FixedPoints.subalgebra k A G) :
    Set.range ((affineInvariantQuotientMap (k := k) (A := A) (G := G)).app
      (PrimeSpectrum.basicOpen b)).hom =
      {x | invariantSourceBasicOpenPreimageSectionsEquiv b x ∈
        fixedAway (b : A) b.property} := by
  ext x
  constructor
  · rintro ⟨s, rfl⟩
    let hb : ∀ g : G, g • (b : A) = b := b.property
    have h := congrArg (fun z => z s)
      (affineInvariantQuotientMap_app_basicOpen_fixed b)
    have h' : (invariantSourceBasicOpenPreimageSectionsEquiv b).toRingHom
          (((affineInvariantQuotientMap (k := k) (A := A) (G := G)).app
            (PrimeSpectrum.basicOpen b)).hom s) =
        (fixedAway (b : A) b.property).subtype
          ((quotientBasicOpenSectionsEquiv b).toRingHom s) := by
      simpa only [RingHom.comp_apply] using h
    change (invariantSourceBasicOpenPreimageSectionsEquiv b).toRingHom
        (((affineInvariantQuotientMap (k := k) (A := A) (G := G)).app
          (PrimeSpectrum.basicOpen b)).hom s) ∈
      fixedAway (b : A) hb
    rw [h']
    exact (quotientBasicOpenSectionsEquiv b s).property
  · intro hx
    let y : fixedAway (b : A) b.property :=
      ⟨invariantSourceBasicOpenPreimageSectionsEquiv b x, hx⟩
    let s : invariantQuotientBasicOpenSections b :=
      (quotientBasicOpenSectionsEquiv b).symm y
    refine ⟨s, ?_⟩
    apply (invariantSourceBasicOpenPreimageSectionsEquiv b).injective
    have h' := congrArg (fun z => z s)
      (affineInvariantQuotientMap_app_basicOpen_fixed b)
    have h'' : (invariantSourceBasicOpenPreimageSectionsEquiv b).toRingHom
          (((affineInvariantQuotientMap (k := k) (A := A) (G := G)).app
            (PrimeSpectrum.basicOpen b)).hom s) =
        (fixedAway (b : A) b.property).subtype
          ((quotientBasicOpenSectionsEquiv b).toRingHom s) := by
      simpa only [RingHom.comp_apply] using h'
    change (invariantSourceBasicOpenPreimageSectionsEquiv b).toRingHom
        (((affineInvariantQuotientMap (k := k) (A := A) (G := G)).app
          (PrimeSpectrum.basicOpen b)).hom s) =
      (invariantSourceBasicOpenPreimageSectionsEquiv b).toRingHom x
    rw [h'']
    exact congrArg Subtype.val
      ((quotientBasicOpenSectionsEquiv b).apply_symm_apply y)

/-- Pullback of structure-sheaf sections along the affine quotient is injective
on every open.  Equality is checked locally on principal opens, where the
fixed-localization calculation identifies pullback with an inclusion. -/
theorem affineInvariantQuotientMap_app_injective [Finite G]
    (U : (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).Opens) :
    Function.Injective
      ((affineInvariantQuotientMap (k := k) (A := A) (G := G)).app U).hom := by
  let q := affineInvariantQuotientMap (k := k) (A := A) (G := G)
  intro s t hst
  apply TopCat.Presheaf.IsSheaf.section_ext
    (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).sheaf.2
  intro x hx
  obtain ⟨_, ⟨b, rfl⟩, hbx, hbU⟩ :=
    PrimeSpectrum.isTopologicalBasis_basic_opens.mem_nhds_iff.mp (U.isOpen.mem_nhds hx)
  refine ⟨PrimeSpectrum.basicOpen b, hbU, hbx, ?_⟩
  apply affineInvariantQuotientMap_app_basicOpen_injective b
  have hn := q.naturality (homOfLE hbU).op
  exact (congrArg (fun f => f.hom s) hn).trans
    ((congrArg (fun z =>
      ((Spec (CommRingCat.of A)).presheaf.map
        ((Opens.map q.base).map (homOfLE hbU)).op).hom z) hst).trans
      (congrArg (fun f => f.hom t) hn).symm)

/-- A section over the inverse image of an open lifts from the quotient
exactly when its restrictions over all contained principal opens lift. -/
theorem affineInvariantQuotientMap_mem_range_app_iff_basicOpen [Finite G]
    (U : (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).Opens)
    (s : Γ(Spec (CommRingCat.of A),
      (affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ U)) :
    s ∈ Set.range ((affineInvariantQuotientMap (k := k) (A := A) (G := G)).app U).hom ↔
      ∀ (b : FixedPoints.subalgebra k A G) (hb : PrimeSpectrum.basicOpen b ≤ U),
        ((Spec (CommRingCat.of A)).presheaf.map
          ((Opens.map (affineInvariantQuotientMap (k := k) (A := A) (G := G)).base).map
            (homOfLE hb)).op).hom s ∈
          Set.range ((affineInvariantQuotientMap (k := k) (A := A) (G := G)).app
            (PrimeSpectrum.basicOpen b)).hom := by
  classical
  let X := Spec (CommRingCat.of A)
  let Y := Spec (CommRingCat.of (FixedPoints.subalgebra k A G))
  let q : X ⟶ Y := affineInvariantQuotientMap (k := k) (A := A) (G := G)
  have hn (V W : Y.Opens) (hWV : W ≤ V) (t : Γ(Y, V)) :
      (q.app W).hom ((Y.presheaf.map (homOfLE hWV).op).hom t) =
        (X.presheaf.map ((Opens.map q.base).map (homOfLE hWV)).op).hom
          ((q.app V).hom t) :=
    congrArg (fun f => f.hom t) (q.naturality (homOfLE hWV).op)
  constructor
  · rintro ⟨t, rfl⟩ b hb
    exact ⟨(Y.presheaf.map (homOfLE hb).op).hom t, hn U _ hb t⟩
  · intro hs
    let I := {b : FixedPoints.subalgebra k A G // PrimeSpectrum.basicOpen b ≤ U}
    let V : I → Y.Opens := fun b => PrimeSpectrum.basicOpen b.val
    have hcover : U ≤ ⨆ b, V b := by
      intro y hy
      obtain ⟨_, ⟨b, rfl⟩, hby, hbU⟩ :=
        PrimeSpectrum.isTopologicalBasis_basic_opens.mem_nhds_iff.mp
          (U.isOpen.mem_nhds hy)
      exact Opens.mem_iSup.mpr ⟨⟨b, hbU⟩, hby⟩
    have hl : ∀ b : I, ∃ t : Γ(Y, V b), (q.app (V b)).hom t =
        (X.presheaf.map ((Opens.map q.base).map (homOfLE b.property)).op).hom s :=
      fun b => hs b.val b.property
    choose t ht using hl
    have hcpt : TopCat.Presheaf.IsCompatible Y.presheaf V t := by
      intro i j
      apply affineInvariantQuotientMap_app_injective (V i ⊓ V j)
      change (q.app (V i ⊓ V j)).hom
          ((Y.presheaf.map (homOfLE inf_le_left).op).hom (t i)) =
        (q.app (V i ⊓ V j)).hom
          ((Y.presheaf.map (homOfLE inf_le_right).op).hom (t j))
      rw [hn, hn, ht, ht]
      simp only [← CommRingCat.comp_apply, ← X.presheaf.map_comp]
      rfl
    obtain ⟨a, ha, _⟩ := Y.sheaf.existsUnique_gluing' V U
      (fun b => homOfLE b.property) hcover t hcpt
    refine ⟨a, ?_⟩
    apply TopCat.Presheaf.IsSheaf.section_ext X.sheaf.2
    intro x hx
    obtain ⟨_, ⟨b, rfl⟩, hbx, hbU⟩ :=
      PrimeSpectrum.isTopologicalBasis_basic_opens.mem_nhds_iff.mp
        (U.isOpen.mem_nhds hx)
    refine ⟨q ⁻¹ᵁ PrimeSpectrum.basicOpen b,
      (Opens.map q.base).monotone hbU, hbx, ?_⟩
    have hnat := hn U (PrimeSpectrum.basicOpen b) hbU a
    have ha' : (Y.presheaf.map (homOfLE hbU).op).hom a = t ⟨b, hbU⟩ :=
      ha ⟨b, hbU⟩
    exact hnat.symm.trans
      ((congrArg (q.app (PrimeSpectrum.basicOpen b)).hom ha').trans (ht ⟨b, hbU⟩))

/-- The all-open lifting criterion expressed in the fixed-localization
presentations of the principal-open restrictions. -/
theorem affineInvariantQuotientMap_mem_range_app_iff_fixed_basicOpen [Finite G]
    (U : (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).Opens)
    (s : Γ(Spec (CommRingCat.of A),
      (affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ U)) :
    s ∈ Set.range ((affineInvariantQuotientMap (k := k) (A := A) (G := G)).app U).hom ↔
      ∀ (b : FixedPoints.subalgebra k A G) (hb : PrimeSpectrum.basicOpen b ≤ U),
        invariantSourceBasicOpenPreimageSectionsEquiv b
          (((Spec (CommRingCat.of A)).presheaf.map
            ((Opens.map (affineInvariantQuotientMap (k := k) (A := A) (G := G)).base).map
              (homOfLE hb)).op).hom s) ∈ fixedAway (b : A) b.property := by
  rw [affineInvariantQuotientMap_mem_range_app_iff_basicOpen]
  apply forall_congr' fun b => forall_congr' fun hb => ?_
  rw [affineInvariantQuotientMap_app_basicOpen_range (k := k) (A := A) (G := G) b]
  rfl

/-- Every inverse image of an open in the affine invariant quotient is stable. -/
theorem affineInvariantQuotientMap_preimage_isStableOpen
    (U : (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).Opens) :
    StableGroupAction.IsStableOpen (specAction G A)
      ((affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ U) :=
  StableGroupAction.isStableOpen_preimage_of_invariant (specAction G A)
    affineInvariantQuotientMap specAction_hom_affineInvariantQuotientMap U

/-- On every open of the affine quotient, the image of section pullback is
exactly the sections fixed by the geometric group action. -/
theorem affineInvariantQuotientMap_mem_range_app_iff_actApp [Finite G]
    (U : (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).Opens)
    (s : Γ(Spec (CommRingCat.of A),
      (affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ U)) :
    s ∈ Set.range ((affineInvariantQuotientMap (k := k) (A := A) (G := G)).app U).hom ↔
      ∀ g : G, (StableGroupAction.actApp (specAction G A)
        (affineInvariantQuotientMap_preimage_isStableOpen U) g).hom s = s := by
  let X := Spec (CommRingCat.of A)
  let q := affineInvariantQuotientMap (k := k) (A := A) (G := G)
  constructor
  · rintro ⟨t, rfl⟩ g
    exact congrArg (fun f => f.hom t)
      (StableGroupAction.app_actApp_of_invariant (specAction G A) q
        specAction_hom_affineInvariantQuotientMap U g)
  · intro hs
    apply (affineInvariantQuotientMap_mem_range_app_iff_fixed_basicOpen U s).mpr
    intro b hb
    apply (invariantSourceBasicOpenPreimageSectionsEquiv_mem_fixedAway_iff b
      (affineInvariantQuotientMap_preimage_isStableOpen (PrimeSpectrum.basicOpen b)) _).mpr
    intro g
    have hn := congrArg (fun f => f.hom s)
      (StableGroupAction.actApp_map (specAction G A)
        (affineInvariantQuotientMap_preimage_isStableOpen U)
        (affineInvariantQuotientMap_preimage_isStableOpen (PrimeSpectrum.basicOpen b))
        ((Opens.map q.base).monotone hb) g)
    exact hn.symm.trans
      (congrArg (X.presheaf.map ((Opens.map q.base).map (homOfLE hb)).op).hom (hs g))

/-- The section-image statement as equality with the intrinsic fixed subring
for the left action on sections. -/
theorem affineInvariantQuotientMap_app_range [Finite G]
    (U : (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).Opens) :
    letI := StableGroupAction.sectionsMulSemiringAction (specAction G A)
      (affineInvariantQuotientMap_preimage_isStableOpen U)
    ((affineInvariantQuotientMap (k := k) (A := A) (G := G)).app U).hom.range =
      FixedPoints.subring Γ(Spec (CommRingCat.of A),
        (affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ U) G := by
  letI := StableGroupAction.sectionsMulSemiringAction (specAction G A)
    (affineInvariantQuotientMap_preimage_isStableOpen U)
  ext s
  change s ∈ Set.range ((affineInvariantQuotientMap (k := k) (A := A) (G := G)).app U).hom ↔
    ∀ g : G, (StableGroupAction.actApp (specAction G A)
      (affineInvariantQuotientMap_preimage_isStableOpen U) g⁻¹).hom s = s
  rw [affineInvariantQuotientMap_mem_range_app_iff_actApp]
  constructor
  · intro hs g
    exact hs g⁻¹
  · intro hs g
    simpa only [inv_inv] using hs g⁻¹

end InvariantLocalization
end MilneLib
