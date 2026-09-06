/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.AlgebraicGeometry.Limits
import Mathlib.CategoryTheory.Limits.Shapes.SingleObj
import Mathlib.CategoryTheory.Limits.MorphismProperty
import Mathlib.AlgebraicGeometry.Morphisms.FiniteType
import Mathlib.AlgebraicGeometry.Morphisms.Separated
import MilneLib.StableAffineCover

/-!
# Relative symmetric powers: the categorical interface

Milne III.3, Proposition 3.1, constructs the symmetric power of a variety over
a field by affine invariant rings and gluing.  For a base scheme `S`, the
correct product is the product in `Over S`: after specializing `S` to the
spectrum of a field, this is the fibre power over that field, not the absolute
product of the underlying schemes.

Mathlib does not provide Milne's construction for arbitrary varieties.  This
file therefore records only the construction-independent categorical part: a
relative symmetric power is explicit quotient data with its universal
property.  Its existence is either supplied as data or assumed through the
corresponding colimit.  No global quotient or existence instance is added.

The zeroth and first relative powers are constructed unconditionally.  The
zeroth carrier is the empty product in `Over S`, hence a chosen terminal object
of the slice and therefore a model of the base `S`, as required.
-/

set_option autoImplicit false

universe u

open CategoryTheory CategoryTheory.Limits
open AlgebraicGeometry

namespace MilneLib

/-! ## The relative product and the permutation action -/

/-- The `n`-fold relative product of an `S`-scheme, computed in `Over S`.
When `S = Spec(k)`, this is the fibre power `V^n` over `k`. -/
noncomputable abbrev relativePower {S : Scheme.{u}} (V : Over S) (n : ℕ) : Over S :=
  ∏ᶜ (fun _ : Fin n => V)

private theorem relativePower_property {S : Scheme.{u}}
    (P : MorphismProperty Scheme.{u}) [P.IsMultiplicative]
    [P.IsStableUnderBaseChange] [P.HasOfPostcompProperty P]
    (V : Over S) (n : ℕ) (hV : P V.hom) : P (relativePower V n).hom := by
  let V' : P.Over ⊤ S := MorphismProperty.Over.mk ⊤ V.hom hV
  let D := Discrete.functor (fun _ : Fin n => V')
  let F := MorphismProperty.Over.forget P ⊤ S
  let e := preservesLimitIso F D
  exact (P.over_iso_iff e).mp (limit D).prop

/-- A finite relative power is locally of finite type whenever its factor is. -/
theorem relativePower_locallyOfFiniteType {S : Scheme.{u}} (V : Over S) (n : ℕ)
    [LocallyOfFiniteType V.hom] : LocallyOfFiniteType (relativePower V n).hom := by
  letI : MorphismProperty.HasOfPostcompProperty
      (@LocallyOfFiniteType) (@LocallyOfFiniteType) := {
    of_postcomp := fun f g _ hfg => by
      letI := hfg
      exact locallyOfFiniteType_of_comp f g }
  exact relativePower_property (@LocallyOfFiniteType) V n inferInstance

/-- Finite relative powers preserve quasi-compact, quasi-separated structure
morphisms. -/
theorem relativePower_quasiCompact {S : Scheme.{u}} (V : Over S) (n : ℕ)
    [QuasiCompact V.hom] [QuasiSeparated V.hom] :
    QuasiCompact (relativePower V n).hom := by
  let P : MorphismProperty Scheme.{u} := (@QuasiCompact) ⊓ (@QuasiSeparated)
  letI : P.HasOfPostcompProperty P := {
    of_postcomp := fun f g hg hfg => by
      letI := hg.2
      letI := hfg.1
      letI := hfg.2
      exact ⟨QuasiCompact.of_comp f g, QuasiSeparated.of_comp f g⟩ }
  exact (relativePower_property P V n ⟨inferInstance, inferInstance⟩).1

/-- A finite relative power of a separated morphism is separated over the base. -/
theorem relativePower_isSeparated {S : Scheme.{u}} (V : Over S) (n : ℕ)
    [IsSeparated V.hom] : IsSeparated (relativePower V n).hom := by
  letI : MorphismProperty.HasOfPostcompProperty (@IsSeparated) (@IsSeparated) :=
    MorphismProperty.HasOfPostcompProperty.of_le _ ⊤ le_top
  exact relativePower_property (@IsSeparated) V n inferInstance

/-! The affine case of the relative product is available directly from the
wide-pullback presentation used to construct products in `Over`. -/

/-- A finite relative power of an affine scheme over an affine base is affine.

The proof transports the `Over`-product limit cone to its underlying
wide-pullback cone and applies the affine-limit theorem.  No quotient
existence or geometric finiteness hypothesis is used here. -/
theorem relativePower_isAffine {S : Scheme.{u}} (V : Over S) (n : ℕ)
    [IsAffine S] [IsAffine V.left] : IsAffine (relativePower V n).left := by
  let F : Discrete (Fin n) ⥤ Over S := Discrete.functor (fun _ => V)
  let D := CategoryTheory.Over.ConstructProducts.widePullbackDiagramOfDiagramOver S F
  let cF := limit.cone F
  let cW := CategoryTheory.Over.ConstructProducts.conesEquivInverseObj S F cF
  have hcF : IsLimit cF := limit.isLimit F
  have hcW : IsLimit cW :=
    (IsLimit.ofConeEquiv
      (CategoryTheory.Over.ConstructProducts.conesEquiv S F).symm).symm hcF
  letI : ∀ j, IsAffine (D.obj j) := by
    intro j
    cases j with
    | none =>
      change IsAffine S
      infer_instance
    | some i =>
      change IsAffine V.left
      infer_instance
  exact Scheme.isAffine_of_isLimit cW hcW

/-- Permute the factors of the relative power.  The convention is
`permute σ ≫ π i = π (σ i)`. -/
noncomputable def permute {S : Scheme.{u}} (V : Over S) (n : ℕ)
    (σ : Equiv.Perm (Fin n)) : relativePower V n ⟶ relativePower V n :=
  Pi.lift (fun i => Pi.π (fun _ : Fin n => V) (σ i))

@[reassoc (attr := simp)]
theorem permute_comp_projection {S : Scheme.{u}} (V : Over S) (n : ℕ)
    (σ : Equiv.Perm (Fin n)) (i : Fin n) :
    permute V n σ ≫ Pi.π (fun _ : Fin n => V) i =
      Pi.π (fun _ : Fin n => V) (σ i) := by
  change (Pi.lift (fun i => Pi.π (fun _ : Fin n => V) (σ i))) ≫
      Pi.π (fun _ : Fin n => V) i = _
  rw [Pi.lift_π]

/-! ### The permutation maps are automorphisms -/

/-- Composition of factor permutations in the relative product. -/
theorem permute_comp {S : Scheme.{u}} (V : Over S) (n : ℕ)
    (σ τ : Equiv.Perm (Fin n)) :
    permute V n σ ≫ permute V n τ = permute V n (σ * τ) := by
  apply Pi.hom_ext
  intro i
  rw [Category.assoc, permute_comp_projection, permute_comp_projection,
    permute_comp_projection]
  rfl

@[simp]
theorem permute_one {S : Scheme.{u}} (V : Over S) (n : ℕ) :
    permute V n (1 : Equiv.Perm (Fin n)) = 𝟙 _ := by
  apply Pi.hom_ext
  intro i
  rw [permute_comp_projection, Category.id_comp]
  rfl

/-- The factor permutation bundled as an automorphism; its inverse is the
permutation by `σ⁻¹`. -/
noncomputable def permuteIso {S : Scheme.{u}} (V : Over S) (n : ℕ)
    (σ : Equiv.Perm (Fin n)) : Aut (relativePower V n) where
  hom := permute V n σ
  inv := permute V n σ⁻¹
  hom_inv_id := by rw [permute_comp, mul_inv_cancel, permute_one]
  inv_hom_id := by rw [permute_comp, inv_mul_cancel, permute_one]

@[simp]
theorem permuteIso_hom {S : Scheme.{u}} (V : Over S) (n : ℕ)
    (σ : Equiv.Perm (Fin n)) :
    (permuteIso V n σ).hom = permute V n σ := rfl

/-- The permutation action on a relative product, valued in categorical
automorphisms.  The inverse in the value compensates for the opposite
multiplication on `Aut`. -/
noncomputable def permutationAutHom {S : Scheme.{u}} (V : Over S) (n : ℕ) :
    Equiv.Perm (Fin n) →* Aut (relativePower V n) where
  toFun σ := permuteIso V n σ⁻¹
  map_one' := by
    apply Iso.ext
    change permute V n (1 : Equiv.Perm (Fin n))⁻¹ = 𝟙 _
    rw [inv_one, permute_one]
  map_mul' σ τ := by
    apply Iso.ext
    change permute V n (σ * τ)⁻¹ =
      permute V n τ⁻¹ ≫ permute V n σ⁻¹
    rw [permute_comp, ← mul_inv_rev]

@[simp]
theorem permutationAutHom_apply_hom {S : Scheme.{u}} (V : Over S) (n : ℕ)
    (σ : Equiv.Perm (Fin n)) :
    ((permutationAutHom V n) σ).hom = permute V n σ⁻¹ := rfl

/-- Push the relative permutation action along `Over.forget` to the actual
underlying scheme used by a relative-product quotient. -/
noncomputable def permutationAutHomOverLeft {S : Scheme.{u}} (V : Over S) (n : ℕ) :
    Equiv.Perm (Fin n) →* Aut ((relativePower V n).left) :=
  (Functor.mapAut _ (Over.forget S)).comp (permutationAutHom V n)

/-- The permutation action on an affine relative power satisfies the
orbit-in-affine hypothesis via the whole affine scheme. -/
theorem permutation_orbitsInAffineOpen_of_isAffine {S : Scheme.{u}} (V : Over S) (n : ℕ)
    [IsAffine S] [IsAffine V.left] :
    StableGroupAction.OrbitsInAffineOpen (permutationAutHomOverLeft V n) := by
  letI : IsAffine (relativePower V n).left := relativePower_isAffine V n
  exact StableGroupAction.orbitsInAffineOpen_of_isAffine _

/-- Conditional stable-cover corollary for the relative permutation action.  The
orbit-in-affine hypothesis is kept explicit: this bridge does not assert it
for an arbitrary curve or relative product. -/
theorem exists_stable_affineOpen_permutation {S : Scheme.{u}} (V : Over S) (n : ℕ)
    (h : StableGroupAction.OrbitsInAffineOpen (permutationAutHomOverLeft V n))
    (x : (relativePower V n).left) :
    ∃ U : ((relativePower V n).left).Opens,
      IsAffineOpen U ∧ x ∈ U ∧
        StableGroupAction.IsStableOpen (permutationAutHomOverLeft V n) U :=
  StableGroupAction.exists_stable_affineOpen_of_orbits
    (permutationAutHomOverLeft V n) h x

/-
`End` uses the opposite order of categorical composition (`f * g = g ≫ f`).
The inverse below is consequently forced: it turns factor permutation into a
monoid action and lets `SingleObj.functor` build the action diagram.
-/
noncomputable def permutationEnd {S : Scheme.{u}} (V : Over S) (n : ℕ) :
    Equiv.Perm (Fin n) →* End (relativePower V n) where
  toFun σ := permute V n σ⁻¹
  map_one' := by
    apply Pi.hom_ext
    intro i
    change permute V n (1 : Equiv.Perm (Fin n)) ≫
      Pi.π (fun _ : Fin n => V) i = _
    rw [permute_comp_projection]
    simp
  map_mul' := by
    intro σ τ
    apply Pi.hom_ext
    intro i
    change permute V n (σ * τ)⁻¹ ≫ Pi.π (fun _ : Fin n => V) i = _
    rw [End.mul_def, permute_comp_projection, Category.assoc,
      permute_comp_projection, permute_comp_projection]
    simp [Equiv.Perm.mul_apply]

/-- The one-object diagram describing the action of `S_n` on the relative
power of `V`. -/
noncomputable def permutationDiagram {S : Scheme.{u}} (V : Over S) (n : ℕ) :
    SingleObj (Equiv.Perm (Fin n)) ⥤ Over S :=
  SingleObj.functor (permutationEnd V n)

@[simp]
theorem permutationDiagram_obj {S : Scheme.{u}} (V : Over S) (n : ℕ)
    (j : SingleObj (Equiv.Perm (Fin n))) :
    (permutationDiagram V n).obj j = relativePower V n := rfl

/-! ## The universal-property interface -/

/-- A morphism out of the relative power is symmetric when it is invariant
under every factor permutation. -/
def IsSymmetric {S : Scheme.{u}} {T : Over S} (V : Over S) (n : ℕ)
    (h : relativePower V n ⟶ T) : Prop :=
  ∀ σ : Equiv.Perm (Fin n), permute V n σ ≫ h = h

/-- Postcomposition preserves symmetry of a morphism out of a relative power.
This is the composition rule used when a symmetric quotient projection is
followed by a target morphism. -/
theorem IsSymmetric.comp {S : Scheme.{u}} {V T U : Over S} (n : ℕ)
    {h : relativePower V n ⟶ T} {k : T ⟶ U}
    (hsym : IsSymmetric V n h) :
    IsSymmetric V n (h ≫ k) := by
  intro σ
  calc
    permute V n σ ≫ (h ≫ k) =
        (permute V n σ ≫ h) ≫ k := (Category.assoc _ _ _).symm
    _ = h ≫ k := by rw [hsym]

/-!
The source proposition also asserts finiteness, surjectivity, separability, and
the affine invariant-ring description.  Those geometric properties belong to
the construction layer and are deliberately not represented by an unproved
global class here.  `SymmetricPowerData` names exactly the relative quotient
universal property, including the fact that its projection is symmetric.
-/

/-- The quotient interface for the `n`-th relative symmetric power of an
`S`-scheme.  This is data, not a global existence assertion. -/
structure SymmetricPowerData {S : Scheme.{u}} (V : Over S) (n : ℕ) where
  /-- The (unnamed) relative quotient `V^(n)` over `S`. -/
  carrier : Over S
  /-- The relative symmetrisation projection `V^n ⟶ V^(n)`. -/
  projection : relativePower V n ⟶ carrier
  /-- The projection is invariant under permutations. -/
  projection_symmetric : IsSymmetric V n projection
  /-- Every symmetric morphism over `S` factors uniquely through the
  projection. -/
  desc : ∀ {T : Over S} (h : relativePower V n ⟶ T),
    IsSymmetric V n h → ∃! u : carrier ⟶ T, projection ≫ u = h

namespace SymmetricPowerData

variable {S : Scheme.{u}} {V : Over S} {n : ℕ}

/-- The factorisation supplied by the universal property. -/
noncomputable def factor (D : SymmetricPowerData V n)
    {T : Over S} (h : relativePower V n ⟶ T) (hsym : IsSymmetric V n h) :
    D.carrier ⟶ T :=
  (D.desc h hsym).choose

@[reassoc (attr := simp)]
theorem projection_comp_factor (D : SymmetricPowerData V n)
    {T : Over S} (h : relativePower V n ⟶ T) (hsym : IsSymmetric V n h) :
    D.projection ≫ D.factor h hsym = h :=
  (D.desc h hsym).choose_spec.1

theorem factor_unique (D : SymmetricPowerData V n)
    {T : Over S} (h : relativePower V n ⟶ T) (hsym : IsSymmetric V n h)
    (u : D.carrier ⟶ T) (hu : D.projection ≫ u = h) :
    u = D.factor h hsym :=
  (D.desc h hsym).choose_spec.2 u hu

/-! The universal property can also be used as a direct characterization of
    a candidate factor.  This form is convenient when proving compatibility
    equations for maps between supplied quotient presentations. -/

theorem factor_eq_iff_projection_comp
    (D : SymmetricPowerData V n)
    {T : Over S} (h : relativePower V n ⟶ T) (hsym : IsSymmetric V n h)
    (u : D.carrier ⟶ T) :
    D.factor h hsym = u ↔ D.projection ≫ u = h := by
  constructor
  · intro hu
    rw [← hu]
    exact D.projection_comp_factor h hsym
  · intro hu
    exact (D.factor_unique h hsym u hu).symm

/-! Factoring is stable under postcomposition, as required for the quotient
    map functoriality below. -/

theorem factor_comp (D : SymmetricPowerData V n)
    {T U : Over S} (h : relativePower V n ⟶ T) (k : T ⟶ U)
    (hsym : IsSymmetric V n h) :
    D.factor (h ≫ k) (hsym.comp n) = D.factor h hsym ≫ k := by
  apply (D.factor_eq_iff_projection_comp (h ≫ k) (hsym.comp n)
    (D.factor h hsym ≫ k)).2
  rw [← Category.assoc, D.projection_comp_factor]

end SymmetricPowerData

/-! ## Colimit form of the interface -/

section Colimit

variable {S : Scheme.{u}} (V : Over S) (n : ℕ)

/-- Read the cocone condition of a permutation-action cocone as symmetry of
its unique leg. -/
theorem cocone_leg_is_symmetric (c : Cocone (permutationDiagram V n)) :
    IsSymmetric (T := c.pt) V n (c.ι.app (SingleObj.star _)) := by
  intro σ
  have h := c.w (SingleObj.toEnd (Equiv.Perm (Fin n)) σ⁻¹)
  have hmap :
      (permutationDiagram V n).map
          (SingleObj.toEnd (Equiv.Perm (Fin n)) σ⁻¹) = permute V n σ := by
    rfl
  rw [hmap] at h
  change permute V n σ ≫ c.ι.app (SingleObj.star _) =
    c.ι.app (SingleObj.star _) at h
  exact h

/-- A symmetric morphism over `S` gives a cocone over the permutation
action. -/
noncomputable def symmetricCocone {T : Over S}
    (h : relativePower V n ⟶ T) (hsym : IsSymmetric V n h) :
    Cocone (permutationDiagram V n) where
  pt := T
  ι :=
    { app := fun _ => h
      naturality := by
        intro X Y f
        change permute V n (f : Equiv.Perm (Fin n))⁻¹ ≫ h = h ≫ 𝟙 T
        rw [Category.comp_id]
        exact hsym _ }

section OfColimit

variable [HasColimit (permutationDiagram V n)]

/-- A colimit of the relative permutation action supplies the symmetric-power
interface.  This is conditional on the colimit and introduces no global
existence claim. -/
noncomputable def dataOfColimit : SymmetricPowerData V n where
  carrier := colimit (permutationDiagram V n)
  projection := colimit.ι (permutationDiagram V n) (SingleObj.star _)
  projection_symmetric := by
    intro σ
    have h := colimit.w (permutationDiagram V n)
      (SingleObj.toEnd (Equiv.Perm (Fin n)) σ⁻¹)
    have hmap :
        (permutationDiagram V n).map
            (SingleObj.toEnd (Equiv.Perm (Fin n)) σ⁻¹) = permute V n σ := by
      rfl
    rw [hmap] at h
    change permute V n σ ≫
        colimit.ι (permutationDiagram V n) (SingleObj.star _) =
      colimit.ι (permutationDiagram V n) (SingleObj.star _) at h
    exact h
  desc := by
    intro T h hsym
    refine ⟨colimit.desc (permutationDiagram V n) (symmetricCocone V n h hsym), ?_, ?_⟩
    · exact colimit.ι_desc (symmetricCocone V n h hsym) (SingleObj.star _)
    · intro u hu
      apply colimit.hom_ext
      intro j
      obtain rfl : j = SingleObj.star _ := Subsingleton.elim _ _
      exact hu.trans (colimit.ι_desc
        (symmetricCocone V n h hsym) (SingleObj.star _)).symm

theorem exists_data_of_hasColimit : Nonempty (SymmetricPowerData V n) :=
  ⟨dataOfColimit V n⟩

end OfColimit

/-! The converse is important for honesty: the interface, including symmetry
of the projection, is not weaker than the quotient colimit. -/

/-- Regard the relative symmetric-power projection as a cocone over the
permutation action. -/
noncomputable def SymmetricPowerData.cocone (D : SymmetricPowerData V n) :
    Cocone (permutationDiagram V n) where
  pt := D.carrier
  ι :=
    { app := fun _ => D.projection
      naturality := by
        intro X Y f
        change permute V n (f : Equiv.Perm (Fin n))⁻¹ ≫ D.projection =
          D.projection ≫ 𝟙 D.carrier
        rw [Category.comp_id]
        exact D.projection_symmetric _ }

/-- The relative symmetric-power universal property is precisely the colimit
universal property of the permutation action in `Over S`. -/
noncomputable def SymmetricPowerData.isColimit (D : SymmetricPowerData V n) :
    IsColimit (D.cocone V n) where
  desc c := D.factor (c.ι.app (SingleObj.star _)) (cocone_leg_is_symmetric V n c)
  fac c j := by
    obtain rfl : j = SingleObj.star _ := Subsingleton.elim _ _
    exact D.projection_comp_factor
      (c.ι.app (SingleObj.star _)) (cocone_leg_is_symmetric V n c)
  uniq c u hu :=
    D.factor_unique (c.ι.app (SingleObj.star _))
      (cocone_leg_is_symmetric V n c) u (hu (SingleObj.star _))

/-- Existence of relative symmetric-power universal-property data is
equivalent to existence of the corresponding quotient colimit in `Over S`. -/
theorem hasColimit_permutationDiagram_iff :
    HasColimit (permutationDiagram V n) ↔ Nonempty (SymmetricPowerData V n) := by
  constructor
  · intro h
    letI := h
    exact exists_data_of_hasColimit V n
  · rintro ⟨D⟩
    exact ⟨⟨⟨D.cocone V n, D.isColimit V n⟩⟩⟩

end Colimit

/-! ## The two degenerate relative powers -/

section Degenerate

variable {S : Scheme.{u}} (V : Over S)

namespace SymmetricPowerData

/-- The zeroth relative symmetric power is the terminal object of `Over S`,
represented by its empty product.  Thus over `Spec(k)` its carrier models
`Spec(k)`, rather than the terminal scheme `Spec(ℤ)` of the ambient category. -/
noncomputable def zero : SymmetricPowerData V 0 where
  carrier := relativePower V 0
  projection := 𝟙 _
  projection_symmetric := by
    intro σ
    rw [Category.comp_id]
    apply Pi.hom_ext
    intro i
    exact Fin.elim0 i
  desc := by
    intro T h hsym
    refine ⟨h, Category.id_comp h, ?_⟩
    intro u hu
    simpa using hu

/-- The first relative symmetric power is canonically the original
`S`-scheme. -/
noncomputable def one : SymmetricPowerData V 1 where
  carrier := V
  projection := Pi.π (fun _ : Fin 1 => V) 0
  projection_symmetric := by
    intro σ
    have hσ : σ 0 = 0 := Subsingleton.elim _ _
    change permute V 1 σ ≫ Pi.π (fun _ : Fin 1 => V) 0 = _
    rw [permute_comp_projection, hσ]
  desc := by
    intro T h hsym
    have hsec : Pi.lift (fun _ : Fin 1 => 𝟙 V) ≫
        Pi.π (fun _ : Fin 1 => V) 0 = 𝟙 V := by
      rw [Pi.lift_π]
    have hret : Pi.π (fun _ : Fin 1 => V) 0 ≫
        Pi.lift (fun _ : Fin 1 => 𝟙 V) = 𝟙 (relativePower V 1) := by
      apply Pi.hom_ext
      intro i
      have hi : i = 0 := Subsingleton.elim _ _
      subst hi
      rw [Category.assoc, Pi.lift_π, Category.comp_id, Category.id_comp]
    refine ⟨Pi.lift (fun _ : Fin 1 => 𝟙 V) ≫ h, ?_, ?_⟩
    · change Pi.π (fun _ : Fin 1 => V) 0 ≫
        (Pi.lift (fun _ : Fin 1 => 𝟙 V) ≫ h) = h
      rw [← Category.assoc, hret, Category.id_comp]
    · intro u hu
      calc
        u = 𝟙 V ≫ u := by simp
        _ = (Pi.lift (fun _ : Fin 1 => 𝟙 V) ≫
            Pi.π (fun _ : Fin 1 => V) 0) ≫ u := by rw [hsec]
        _ = Pi.lift (fun _ : Fin 1 => 𝟙 V) ≫
            (Pi.π (fun _ : Fin 1 => V) 0 ≫ u) := by rw [Category.assoc]
        _ = Pi.lift (fun _ : Fin 1 => 𝟙 V) ≫ h := by rw [hu]

end SymmetricPowerData

end Degenerate

/-! ## Functoriality of the quotient interface -/

section Functoriality

variable {S : Scheme.{u}} {V W X : Over S} {n : ℕ}

/-- The map on relative powers induced by a morphism over the base. -/
noncomputable def relativePowerMap (f : V ⟶ W) (n : ℕ) :
    relativePower V n ⟶ relativePower W n :=
  CategoryTheory.Limits.Pi.map (fun _ : Fin n => f)

@[simp]
theorem relativePowerMap_comp_projection (f : V ⟶ W) (n : ℕ) (i : Fin n) :
    relativePowerMap f n ≫ Pi.π (fun _ : Fin n => W) i =
      Pi.π (fun _ : Fin n => V) i ≫ f := by
  simp [relativePowerMap]

theorem relativePowerMap_id (V : Over S) (n : ℕ) :
    relativePowerMap (𝟙 V) n = 𝟙 (relativePower V n) := by
  apply Pi.hom_ext
  intro i
  simp [relativePowerMap]

theorem relativePowerMap_comp (f : V ⟶ W) (g : W ⟶ X) (n : ℕ) :
    relativePowerMap (f ≫ g) n =
      relativePowerMap f n ≫ relativePowerMap g n := by
  apply Pi.hom_ext
  intro i
  simp [relativePowerMap, Category.assoc]

/-- Relative power maps commute with the permutation action. -/
theorem relativePowerMap_perm_naturality (f : V ⟶ W) (n : ℕ)
    (σ : Equiv.Perm (Fin n)) :
    relativePowerMap f n ≫ permute W n σ =
      permute V n σ ≫ relativePowerMap f n := by
  apply Pi.hom_ext
  intro i
  simp [relativePowerMap, Category.assoc]

/-- Precomposing a symmetric morphism with a relative power map remains
symmetric. -/
theorem isSymmetric_comp_relativePowerMap (f : V ⟶ W) (h : relativePower W n ⟶ X)
    (hsym : IsSymmetric W n h) :
    IsSymmetric V n (relativePowerMap f n ≫ h) := by
  intro σ
  rw [← Category.assoc, ← relativePowerMap_perm_naturality,
    Category.assoc, hsym]

namespace SymmetricPowerData

/-- The morphism of relative symmetric powers induced by a map over `S`.
Both quotient universal properties are explicit inputs; no quotient existence
instance is inferred here. -/
noncomputable def map (DV : SymmetricPowerData V n)
    (DW : SymmetricPowerData W n) (f : V ⟶ W) :
    DV.carrier ⟶ DW.carrier :=
  DV.factor (relativePowerMap f n ≫ DW.projection)
    (isSymmetric_comp_relativePowerMap f DW.projection
      DW.projection_symmetric)

@[reassoc (attr := simp)]
theorem projection_comp_map (DV : SymmetricPowerData V n)
    (DW : SymmetricPowerData W n) (f : V ⟶ W) :
    DV.projection ≫ DV.map DW f =
      relativePowerMap f n ≫ DW.projection :=
  DV.projection_comp_factor _ _

theorem map_id (DV : SymmetricPowerData V n) :
    DV.map DV (𝟙 V) = 𝟙 DV.carrier := by
  change DV.factor (relativePowerMap (𝟙 V) n ≫ DV.projection)
      (isSymmetric_comp_relativePowerMap (𝟙 V) DV.projection
        DV.projection_symmetric) = 𝟙 DV.carrier
  symm
  apply DV.factor_unique
    (relativePowerMap (𝟙 V) n ≫ DV.projection)
    (isSymmetric_comp_relativePowerMap (𝟙 V) DV.projection
      DV.projection_symmetric)
    (𝟙 DV.carrier)
  rw [Category.comp_id, relativePowerMap_id]
  simp

theorem map_comp (DV : SymmetricPowerData V n)
    (DW : SymmetricPowerData W n) (DX : SymmetricPowerData X n)
    (f : V ⟶ W) (g : W ⟶ X) :
    DV.map DX (f ≫ g) = DV.map DW f ≫ DW.map DX g := by
  change DV.factor (relativePowerMap (f ≫ g) n ≫ DX.projection)
      (isSymmetric_comp_relativePowerMap (f ≫ g) DX.projection
        DX.projection_symmetric) =
    DV.map DW f ≫ DW.map DX g
  symm
  apply DV.factor_unique
    (relativePowerMap (f ≫ g) n ≫ DX.projection)
    (isSymmetric_comp_relativePowerMap (f ≫ g) DX.projection
      DX.projection_symmetric)
    (DV.map DW f ≫ DW.map DX g)
  rw [← Category.assoc, DV.projection_comp_map, Category.assoc,
    DW.projection_comp_map, ← Category.assoc, relativePowerMap_comp]

/-- Two supplied quotient data for the same relative power are canonically
isomorphic by their universal properties. -/
noncomputable def canonicalIso {S : Scheme.{u}} {V : Over S} {n : ℕ}
    (D E : SymmetricPowerData V n) : D.carrier ≅ E.carrier where
  hom := D.factor E.projection E.projection_symmetric
  inv := E.factor D.projection D.projection_symmetric
  hom_inv_id := by
    have h₁ :
        D.projection ≫
            (D.factor E.projection E.projection_symmetric ≫
              E.factor D.projection D.projection_symmetric) =
          D.projection := by
      rw [← Category.assoc, D.projection_comp_factor,
        E.projection_comp_factor]
    have h₂ : D.projection ≫ (𝟙 D.carrier) = D.projection :=
      Category.comp_id _
    exact
      (D.factor_unique D.projection D.projection_symmetric _ h₁).trans
        (D.factor_unique D.projection D.projection_symmetric _ h₂).symm
  inv_hom_id := by
    have h₁ :
        E.projection ≫
            (E.factor D.projection D.projection_symmetric ≫
              D.factor E.projection E.projection_symmetric) =
          E.projection := by
      rw [← Category.assoc, E.projection_comp_factor,
        D.projection_comp_factor]
    have h₂ : E.projection ≫ (𝟙 E.carrier) = E.projection :=
      Category.comp_id _
    exact
      (E.factor_unique E.projection E.projection_symmetric _ h₁).trans
        (E.factor_unique E.projection E.projection_symmetric _ h₂).symm

@[simp]
theorem projection_comp_canonicalIso_hom
    {S : Scheme.{u}} {V : Over S} {n : ℕ}
    (D E : SymmetricPowerData V n) :
    D.projection ≫ (canonicalIso D E).hom = E.projection := by
  exact D.projection_comp_factor E.projection E.projection_symmetric

@[simp]
theorem projection_comp_canonicalIso_inv
    {S : Scheme.{u}} {V : Over S} {n : ℕ}
    (D E : SymmetricPowerData V n) :
    E.projection ≫ (canonicalIso D E).inv = D.projection := by
  exact E.projection_comp_factor D.projection D.projection_symmetric

theorem canonicalIso_hom_unique
    {S : Scheme.{u}} {V : Over S} {n : ℕ}
    (D E : SymmetricPowerData V n) (u : D.carrier ⟶ E.carrier)
    (hu : D.projection ≫ u = E.projection) :
    u = (canonicalIso D E).hom := by
  calc
    u = D.factor E.projection E.projection_symmetric :=
      D.factor_unique E.projection E.projection_symmetric u hu
    _ = (canonicalIso D E).hom := rfl

@[simp]
theorem canonicalIso_refl
    {S : Scheme.{u}} {V : Over S} {n : ℕ}
    (D : SymmetricPowerData V n) :
    canonicalIso D D = Iso.refl D.carrier := by
  apply Iso.ext
  exact (canonicalIso_hom_unique D D (𝟙 D.carrier) (by simp)).symm

theorem canonicalIso_trans
    {S : Scheme.{u}} {V : Over S} {n : ℕ}
    (D E F : SymmetricPowerData V n) :
    canonicalIso D E ≪≫ canonicalIso E F = canonicalIso D F := by
  apply Iso.ext
  apply canonicalIso_hom_unique D F
  change D.projection ≫
      ((canonicalIso D E).hom ≫ (canonicalIso E F).hom) = F.projection
  rw [← Category.assoc, projection_comp_canonicalIso_hom,
    projection_comp_canonicalIso_hom]

end SymmetricPowerData

end Functoriality

end MilneLib
