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

The main result proves that this identification carries actual presheaf
restriction maps to the fixed-localized transition maps constructed in
`InvariantLocalizationTransitions`.
-/

set_option autoImplicit false

universe u v

open CategoryTheory AlgebraicGeometry Topology TopologicalSpace

namespace MilneLib
namespace InvariantLocalization

variable {k : Type u} {A : Type v} {G : Type*}
  [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A]

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
  let res :=
    ((Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).presheaf.map
      (homOfLE hcb).op).hom
  have hb := AlgebraicGeometry.IsAffineOpen.algebraMap_Spec_obj
    (R := CommRingCat.of (FixedPoints.subalgebra k A G))
    (U := PrimeSpectrum.basicOpen b)
  have hc := AlgebraicGeometry.IsAffineOpen.algebraMap_Spec_obj
    (R := CommRingCat.of (FixedPoints.subalgebra k A G))
    (U := PrimeSpectrum.basicOpen c)
  have hcat :
      (Scheme.ΓSpecIso (CommRingCat.of
          (FixedPoints.subalgebra k A G))).inv ≫
          (Spec (CommRingCat.of
            (FixedPoints.subalgebra k A G))).presheaf.map
              (homOfLE (show PrimeSpectrum.basicOpen b ≤
                (⊤ : (Spec (CommRingCat.of
                  (FixedPoints.subalgebra k A G))).Opens) from le_top)).op ≫
          (Spec (CommRingCat.of
            (FixedPoints.subalgebra k A G))).presheaf.map
              (homOfLE hcb).op =
        (Scheme.ΓSpecIso (CommRingCat.of
          (FixedPoints.subalgebra k A G))).inv ≫
          (Spec (CommRingCat.of
            (FixedPoints.subalgebra k A G))).presheaf.map
              (homOfLE (show PrimeSpectrum.basicOpen c ≤
                (⊤ : (Spec (CommRingCat.of
                  (FixedPoints.subalgebra k A G))).Opens) from le_top)).op := by
    rw [← Functor.map_comp]
    rfl
  calc
    res.comp (algebraMap (FixedPoints.subalgebra k A G)
        (invariantQuotientBasicOpenSections b)) =
      res.comp (((Scheme.ΓSpecIso (CommRingCat.of
          (FixedPoints.subalgebra k A G))).inv ≫
        (Spec (CommRingCat.of
          (FixedPoints.subalgebra k A G))).presheaf.map
            (homOfLE (show PrimeSpectrum.basicOpen b ≤
              (⊤ : (Spec (CommRingCat.of
                (FixedPoints.subalgebra k A G))).Opens) from le_top)).op).hom) :=
      congrArg res.comp hb
    _ = (((Scheme.ΓSpecIso (CommRingCat.of
          (FixedPoints.subalgebra k A G))).inv ≫
        (Spec (CommRingCat.of
          (FixedPoints.subalgebra k A G))).presheaf.map
            (homOfLE (show PrimeSpectrum.basicOpen c ≤
              (⊤ : (Spec (CommRingCat.of
                (FixedPoints.subalgebra k A G))).Opens) from le_top)).op).hom) := by
      exact congrArg CommRingCat.Hom.hom hcat
    _ = algebraMap (FixedPoints.subalgebra k A G)
        (invariantQuotientBasicOpenSections c) := hc.symm

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

end InvariantLocalization
end MilneLib
