/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.StableAffineSections
import MilneLib.InvariantQuotientTransitionsOver
import MilneLib.InvariantQuotientOverlap

/-!
# Invariant quotient data from stable affine overlaps

Let a group act on a separated scheme over `Spec k`, preserving the structure
morphism.  This file constructs the algebraic overlap cone used by the affine
invariant-quotient transition API directly from two stable affine opens.  In
particular, its restriction maps and equivariance proofs are derived from the
scheme action; they are not supplied as extra gluing data.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry

namespace MilneLib
namespace StableGroupAction

variable {k G : Type u} [CommRing k] [Group G] {X : Scheme.{u}}
  (act : G →* Aut X)

/-! ## The base algebra on sections -/

/-- The structure map from `k` to the sections of an open in a scheme over
`Spec k`. -/
noncomputable def sectionsAlgebraMapHom
    (p : X ⟶ Spec (CommRingCat.of k)) (U : X.Opens) :
    CommRingCat.of k ⟶ Γ(X, U) :=
  (Scheme.ΓSpecIso (CommRingCat.of k)).inv ≫ p.appLE ⊤ U le_top

/-- The induced `k`-algebra structure on sections of an open. -/
@[reducible]
noncomputable def sectionsAlgebra
    (p : X ⟶ Spec (CommRingCat.of k)) (U : X.Opens) : Algebra k Γ(X, U) :=
  (sectionsAlgebraMapHom p U).hom.toAlgebra

/-- Restriction of sections respects the algebra structure coming from the
structure morphism. -/
lemma sectionsAlgebraMapHom_naturality
    (p : X ⟶ Spec (CommRingCat.of k)) {U V : X.Opens} (hVU : V ≤ U) :
    sectionsAlgebraMapHom p U ≫ X.presheaf.map (homOfLE hVU).op =
      sectionsAlgebraMapHom p V := by
  rw [sectionsAlgebraMapHom, sectionsAlgebraMapHom, Category.assoc,
    Scheme.Hom.appLE_map]

/-- If the scheme action is over `Spec k`, its action on sections fixes the
image of `k`. -/
lemma sectionsAlgebraMapHom_actApp
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    {U : X.Opens} (hU : IsStableOpen act U) (g : G) :
    sectionsAlgebraMapHom p U ≫ actApp act hU g =
      sectionsAlgebraMapHom p U := by
  rw [sectionsAlgebraMapHom, actApp, Category.assoc,
    Scheme.Hom.appLE_comp_appLE, appLE_congr_hom (hact g)]

/-- The group action on sections commutes with scalar multiplication by `k`.
This is a definition rather than an instance because both actions depend on
the chosen stability and structure-map proofs. -/
@[reducible]
noncomputable def sectionsSMulCommClass
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    {U : X.Opens} (hU : IsStableOpen act U) :
    letI := sectionsAlgebra p U
    letI := sectionsMulSemiringAction act hU
    SMulCommClass G k Γ(X, U) := by
  letI := sectionsAlgebra p U
  letI := sectionsMulSemiringAction act hU
  refine ⟨fun g r s => ?_⟩
  change (actApp act hU g⁻¹).hom ((sectionsAlgebraMapHom p U).hom r * s) =
    (sectionsAlgebraMapHom p U).hom r * (actApp act hU g⁻¹).hom s
  rw [map_mul]
  congr 1
  exact DFunLike.congr_fun
    (congrArg CommRingCat.Hom.hom
      (sectionsAlgebraMapHom_actApp act p hact hU g⁻¹)) r

/-- Restriction between opens, regarded as a `k`-algebra homomorphism. -/
noncomputable def sectionsRestrictionAlgHom
    (p : X ⟶ Spec (CommRingCat.of k)) {U V : X.Opens} (hVU : V ≤ U) :
    letI := sectionsAlgebra p U
    letI := sectionsAlgebra p V
    Γ(X, U) →ₐ[k] Γ(X, V) := by
  letI := sectionsAlgebra p U
  letI := sectionsAlgebra p V
  exact AlgHom.mk
    (X.presheaf.map (homOfLE hVU).op).hom
    (fun r => DFunLike.congr_fun
      (congrArg CommRingCat.Hom.hom
        (sectionsAlgebraMapHom_naturality p hVU)) r)

@[simp]
lemma sectionsRestrictionAlgHom_apply
    (p : X ⟶ Spec (CommRingCat.of k)) {U V : X.Opens} (hVU : V ≤ U)
    (s : Γ(X, U)) :
    letI := sectionsAlgebra p U
    letI := sectionsAlgebra p V
    sectionsRestrictionAlgHom p hVU s =
      X.presheaf.map (homOfLE hVU).op s :=
  rfl

/-- Restriction between stable opens is equivariant as a `k`-algebra map. -/
lemma sectionsRestrictionAlgHom_equivariant
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    {U V : X.Opens} (hU : IsStableOpen act U) (hV : IsStableOpen act V)
    (hVU : V ≤ U) (g : G) (s : Γ(X, U)) :
    letI := sectionsAlgebra p U
    letI := sectionsAlgebra p V
    letI := sectionsMulSemiringAction act hU
    letI := sectionsMulSemiringAction act hV
    letI := sectionsSMulCommClass act p hact hU
    letI := sectionsSMulCommClass act p hact hV
    g • sectionsRestrictionAlgHom p hVU s =
      sectionsRestrictionAlgHom p hVU (g • s) := by
  letI := sectionsAlgebra p U
  letI := sectionsAlgebra p V
  letI := sectionsMulSemiringAction act hU
  letI := sectionsMulSemiringAction act hV
  letI := sectionsSMulCommClass act p hact hU
  letI := sectionsSMulCommClass act p hact hV
  change (actApp act hV g⁻¹).hom
      ((X.presheaf.map (homOfLE hVU).op).hom s) =
    (X.presheaf.map (homOfLE hVU).op).hom ((actApp act hU g⁻¹).hom s)
  exact DFunLike.congr_fun
    (congrArg CommRingCat.Hom.hom (actApp_map act hU hV hVU g⁻¹).symm) s

/-! ## Affine coordinates and concrete overlap cones -/

/-- On an affine stable open, the canonical affine-coordinate isomorphism
intertwines the restricted geometric action and the spectrum of its action on
sections. -/
theorem actRes_isoSpec_hom
    {U : X.Opens} (hU : IsStableOpen act U) (hUa : IsAffineOpen U) (g : G) :
    actRes act hU g ≫ hUa.isoSpec.hom =
      hUa.isoSpec.hom ≫ Spec.map (actApp act hU g) := by
  haveI : IsAffine U.toScheme := hUa
  have hiso :
      hUa.isoSpec.hom = U.toScheme.isoSpec.hom ≫ Spec.map U.topIso.inv := rfl
  rw [hiso, ← Category.assoc,
    ← Scheme.isoSpec_hom_naturality (actRes act hU g),
    Category.assoc, Category.assoc, ← Spec.map_comp, ← Spec.map_comp]
  congr 2
  have happ : (actRes act hU g).appTop =
      U.topIso.hom ≫ actApp act hU g ≫ U.topIso.inv :=
    Scheme.Hom.resLE_app_top _ _
  rw [happ, ← Category.assoc, ← Category.assoc,
    Iso.inv_hom_id, Category.id_comp]

/-- In the action convention used by the affine quotient API, the affine
coordinate isomorphism is equivariant. -/
theorem actRes_isoSpec_hom_specAction
    {U : X.Opens} (hU : IsStableOpen act U) (hUa : IsAffineOpen U) (g : G) :
    letI := sectionsMulSemiringAction act hU
    actRes act hU g ≫ hUa.isoSpec.hom =
      hUa.isoSpec.hom ≫ (specAction G Γ(X, U) g).hom := by
  letI := sectionsMulSemiringAction act hU
  rw [specAction_hom]
  have hhom : CommRingCat.ofHom
      (MulSemiringAction.toRingHom G Γ(X, U) g⁻¹) = actApp act hU g := by
    refine CommRingCat.hom_ext (RingHom.ext fun s => ?_)
    change (actApp act hU (g⁻¹)⁻¹).hom s = (actApp act hU g).hom s
    rw [inv_inv]
  rw [hhom]
  exact actRes_isoSpec_hom act hU hUa g

/-- The inverse affine-coordinate isomorphism is equivariant in the opposite
direction. -/
theorem specAction_hom_isoSpec_inv
    {U : X.Opens} (hU : IsStableOpen act U) (hUa : IsAffineOpen U) (g : G) :
    letI := sectionsMulSemiringAction act hU
    (specAction G Γ(X, U) g).hom ≫ hUa.isoSpec.inv =
      hUa.isoSpec.inv ≫ actRes act hU g := by
  letI := sectionsMulSemiringAction act hU
  rw [← cancel_mono hUa.isoSpec.hom]
  simp only [Category.assoc, Iso.inv_hom_id, Category.comp_id]
  rw [actRes_isoSpec_hom_specAction act hU hUa g]
  simp

/-- Restriction between affine opens induces an open immersion on their affine
spectra. -/
theorem isOpenImmersion_specMap_sectionsRestriction
    {U V : X.Opens} (hU : IsAffineOpen U) (hV : IsAffineOpen V)
    (hVU : V ≤ U) :
    IsOpenImmersion (Spec.map (X.presheaf.map (homOfLE hVU).op)) := by
  let f := Spec.map (X.presheaf.map (homOfLE hVU).op)
  haveI : IsOpenImmersion hU.fromSpec := inferInstance
  have hcomp : IsOpenImmersion (f ≫ hU.fromSpec) := by
    change IsOpenImmersion
      (Spec.map (X.presheaf.map (homOfLE hVU).op) ≫ hU.fromSpec)
    rw [IsAffineOpen.map_fromSpec hU hV (homOfLE hVU).op]
    infer_instance
  letI : IsOpenImmersion (f ≫ hU.fromSpec) := hcomp
  exact IsOpenImmersion.of_comp f hU.fromSpec

namespace StableAffineOpen

variable [X.IsSeparated]

/-- The intersection `i.U ⊓ j.U`, expressed as an open in the affine
coordinate spectrum of `i`. -/
noncomputable def overlapCoordinateOpen (i j : StableAffineOpen act) :
    (Spec (CommRingCat.of Γ(X, i.U))).Opens :=
  i.affine.isoSpec.inv ⁻¹ᵁ (i.U.ι ⁻¹ᵁ (i.U ⊓ j.U))

/-- The coordinate-spectrum presentation of a separated affine-chart
intersection is affine. -/
theorem overlapCoordinateOpen_affine (i j : StableAffineOpen act) :
    IsAffineOpen (overlapCoordinateOpen act i j) := by
  unfold overlapCoordinateOpen
  apply IsAffineOpen.preimage_of_isIso
  apply (overlap_affine act i j).preimage_of_isOpenImmersion
  simp

/-- The coordinate open representing `i.U ⊓ j.U` is stable under the
spectrum action on `Γ(X, i.U)`. -/
theorem overlapCoordinateOpen_stable (i j : StableAffineOpen act) :
    letI := sectionsMulSemiringAction act i.stable
    ∀ g : G, (specAction G Γ(X, i.U) g).hom ⁻¹ᵁ
      overlapCoordinateOpen act i j = overlapCoordinateOpen act i j := by
  letI := sectionsMulSemiringAction act i.stable
  intro g
  unfold overlapCoordinateOpen
  rw [← Scheme.Hom.comp_preimage,
    specAction_hom_isoSpec_inv act i.stable i.affine g,
    Scheme.Hom.comp_preimage]
  congr 1
  rw [← Scheme.Hom.comp_preimage,
    actRes_ι, Scheme.Hom.comp_preimage, (overlap_stable act i j) g]

/-- The coordinate open is canonically isomorphic to the actual chart
intersection. -/
noncomputable def overlapCoordinateIso (i j : StableAffineOpen act) :
    (overlapCoordinateOpen act i j).toScheme ≅ (i.U ⊓ j.U).toScheme :=
  (i.affine.isoSpec.inv.preimageIso (i.U.ι ⁻¹ᵁ (i.U ⊓ j.U))).trans
    (Scheme.Opens.isoOfLE inf_le_left)

/-- The quotient-side open in chart `i` descended from the actual overlap
`i.U ⊓ j.U`. -/
noncomputable def quotientOverlapOpen [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
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
    (overlapCoordinateOpen act i j) (overlapCoordinateOpen_stable act i j)

/-- The open subscheme underlying the descended overlap in quotient chart
`i`. -/
noncomputable def quotientOverlap [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) : Scheme.{u} := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  exact (quotientOverlapOpen act p hact i j).toScheme

/-- The descended overlap inclusion into the invariant quotient chart. -/
noncomputable def quotientOverlapι [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    quotientOverlap act p hact i j ⟶
      Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U) G)) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  exact (quotientOverlapOpen act p hact i j).ι

instance quotientOverlapι_isOpenImmersion [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    IsOpenImmersion (quotientOverlapι act p hact i j) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  unfold quotientOverlapι quotientOverlap quotientOverlapOpen
  infer_instance

/-- The affine invariant-quotient map restricted from the coordinate overlap
to its descended quotient open. -/
noncomputable def overlapCoordinateQuotientMap [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    (overlapCoordinateOpen act i j).toScheme ⟶
      quotientOverlap act p hact i j := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  exact InvariantLocalization.affineInvariantQuotientMapRestrictStable
    (k := k) (A := Γ(X, i.U)) (G := G)
    (overlapCoordinateOpen act i j) (overlapCoordinateOpen_stable act i j)

/-- The restricted quotient map followed by the descended-open inclusion is
the ambient affine invariant quotient map on the coordinate overlap. -/
@[reassoc]
theorem overlapCoordinateQuotientMap_fac [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    overlapCoordinateQuotientMap act p hact i j ≫
        quotientOverlapι act p hact i j =
      (overlapCoordinateOpen act i j).ι ≫
        affineInvariantQuotientMap
          (k := k) (A := Γ(X, i.U)) (G := G) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  exact InvariantLocalization.affineInvariantQuotientMapRestrictStable_fac
    (k := k) (A := Γ(X, i.U)) (G := G)
    (overlapCoordinateOpen act i j) (overlapCoordinateOpen_stable act i j)

/-- The restricted coordinate-overlap quotient map is surjective onto the
descended quotient open. -/
theorem overlapCoordinateQuotientMap_surjective [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    Function.Surjective
      (overlapCoordinateQuotientMap act p hact i j).base := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  exact
    InvariantLocalization.affineInvariantQuotientMapRestrictStable_surjective
      (k := k) (A := Γ(X, i.U)) (G := G)
      (overlapCoordinateOpen act i j) (overlapCoordinateOpen_stable act i j)

/-- The quotient map from the actual intersection `i.U ⊓ j.U`, transported
through its affine coordinate-open presentation. -/
noncomputable def overlapQuotientMap [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    (i.U ⊓ j.U).toScheme ⟶ quotientOverlap act p hact i j := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  exact (overlapCoordinateIso act i j).inv ≫
    overlapCoordinateQuotientMap act p hact i j

/-- After inclusion in quotient chart `i`, the actual-overlap quotient map is
the affine quotient projection restricted through the coordinate-open
isomorphism. -/
@[reassoc]
theorem overlapQuotientMap_fac [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    overlapQuotientMap act p hact i j ≫ quotientOverlapι act p hact i j =
      (overlapCoordinateIso act i j).inv ≫
        (overlapCoordinateOpen act i j).ι ≫
          affineInvariantQuotientMap
            (k := k) (A := Γ(X, i.U)) (G := G) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  rw [overlapQuotientMap, Category.assoc,
    overlapCoordinateQuotientMap_fac]

/-- The equivariant affine algebra cone associated canonically to the
intersection of two stable affine charts. -/
noncomputable def overlapCone
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
    InvariantLocalization.EquivariantAffineOverlapOver
      (k := k) (G := G) (A := Γ(X, i.U)) (B := Γ(X, j.U))
      (C := Γ(X, i.U ⊓ j.U)) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  exact
    { left := sectionsRestrictionAlgHom p inf_le_left
      right := sectionsRestrictionAlgHom p inf_le_right
      left_equivariant :=
        sectionsRestrictionAlgHom_equivariant act p hact i.stable
          (overlap_stable act i j) inf_le_left
      right_equivariant :=
        sectionsRestrictionAlgHom_equivariant act p hact j.stable
          (overlap_stable act i j) inf_le_right }

/-- The left source leg of the canonical affine overlap cone is an open
immersion. -/
theorem overlapCone_leftSourceMap_isOpenImmersion
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
    IsOpenImmersion
      ((overlapCone act p hact i j).leftSourceMap.left) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  change IsOpenImmersion
    (Spec.map (X.presheaf.map (homOfLE inf_le_left).op))
  exact isOpenImmersion_specMap_sectionsRestriction
    i.affine (overlap_affine act i j) inf_le_left

/-- The right source leg of the canonical affine overlap cone is an open
immersion. -/
theorem overlapCone_rightSourceMap_isOpenImmersion
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
    IsOpenImmersion
      ((overlapCone act p hact i j).rightSourceMap.left) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  change IsOpenImmersion
    (Spec.map (X.presheaf.map (homOfLE inf_le_right).op))
  exact isOpenImmersion_specMap_sectionsRestriction
    j.affine (overlap_affine act i j) inf_le_right

end StableAffineOpen

end StableGroupAction
end MilneLib
