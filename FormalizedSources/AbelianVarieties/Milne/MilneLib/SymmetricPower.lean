/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.AlgebraicGeometry.Limits
import Mathlib.CategoryTheory.Limits.Shapes.SingleObj

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

end MilneLib
