/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import Mathlib.GroupTheory.Commutator.Basic

/-!
# Abstract theta extensions

This module records the elementary group-theoretic interface for a theta
group.  The scalar group is written multiplicatively, while the quotient is
written additively.  Geometric representability and local splitting are left
to later modules; the fields below expose the exact sequence and centrality
facts needed by its algebraic consequences.
-/

set_option autoImplicit false

open scoped commutatorElement

universe u v w

namespace Mumford

/-- The elementary group-theoretic data underlying a theta-group extension. -/
structure ThetaExtension (G : Type u) (S : Type v) (K : Type w)
    [Group G] [CommGroup S] [AddCommGroup K] where
  /-- Inclusion of scalar automorphisms. -/
  includeScalar : S →* G
  /-- Projection to the additive quotient, represented as a multiplicative group. -/
  quotientHom : G →* Multiplicative K
  /-- The scalar inclusion has trivial kernel. -/
  includeScalar_ker : includeScalar.ker = ⊥
  /-- The quotient map is onto. -/
  quotientHom_range : quotientHom.range = ⊤
  /-- Exactness: the scalar image is the kernel of the quotient map. -/
  exact : includeScalar.range = quotientHom.ker
  /-- Scalars commute with every element of the extension. -/
  central : ∀ s g, Commute (includeScalar s) g

namespace ThetaExtension

variable {G : Type u} {S : Type v} {K : Type w}
  [Group G] [CommGroup S] [AddCommGroup K] (E : ThetaExtension G S K)

/-- The quotient map, written additively. -/
def quotient (g : G) : K :=
  Multiplicative.toAdd (E.quotientHom g)

@[simp]
theorem quotient_one : E.quotient 1 = 0 := by
  change Multiplicative.toAdd (E.quotientHom 1) = 0
  rw [map_one]
  rfl

@[simp]
theorem quotient_mul (x y : G) :
    E.quotient (x * y) = E.quotient x + E.quotient y := by
  change Multiplicative.toAdd (E.quotientHom (x * y)) =
    Multiplicative.toAdd (E.quotientHom x) + Multiplicative.toAdd (E.quotientHom y)
  rw [map_mul]
  rfl

@[simp]
theorem quotient_inv (x : G) :
    E.quotient x⁻¹ = -E.quotient x := by
  change Multiplicative.toAdd (E.quotientHom x⁻¹) =
    -Multiplicative.toAdd (E.quotientHom x)
  rw [map_inv]
  rfl

/-- The scalar inclusion is injective, as witnessed by its kernel field. -/
theorem includeScalar_injective : Function.Injective E.includeScalar :=
  (MonoidHom.ker_eq_bot_iff E.includeScalar).mp E.includeScalar_ker

/-- The quotient homomorphism is surjective, as witnessed by its range field. -/
theorem quotientHom_surjective : Function.Surjective E.quotientHom :=
  MonoidHom.range_eq_top.mp E.quotientHom_range

/-- A scalar commutes with every element of the extension. -/
theorem includeScalar_commute (s : S) (g : G) :
    Commute (E.includeScalar s) g :=
  E.central s g

/-- Every scalar lies in the kernel of the quotient map. -/
theorem includeScalar_mem_ker (s : S) :
    E.includeScalar s ∈ E.quotientHom.ker := by
  rw [← E.exact]
  exact ⟨s, rfl⟩

@[simp]
theorem quotient_includeScalar (s : S) :
    E.quotient (E.includeScalar s) = 0 := by
  change Multiplicative.toAdd (E.quotientHom (E.includeScalar s)) = 0
  have h := E.includeScalar_mem_ker s
  rw [MonoidHom.mem_ker] at h
  rw [h]
  rfl

/-- Kernel elements are exactly the scalar elements. -/
theorem mem_quotientHom_ker_iff (g : G) :
    g ∈ E.quotientHom.ker ↔ ∃ s, E.includeScalar s = g := by
  rw [← E.exact]
  rfl

/-- Every extension commutator projects to the identity in the quotient. -/
theorem commutator_mem_ker (x y : G) :
    ⁅x, y⁆ ∈ E.quotientHom.ker := by
  rw [MonoidHom.mem_ker, map_commutatorElement]
  exact commutatorElement_eq_one_iff_commute.mpr (Commute.all _ _)

/-- Every commutator belongs to the scalar image. -/
theorem commutator_mem_includeScalar_range (x y : G) :
    ⁅x, y⁆ ∈ E.includeScalar.range := by
  rw [E.exact]
  exact E.commutator_mem_ker x y

/-- A commutator admits a scalar lift. -/
theorem exists_scalar_eq_commutator (x y : G) :
    ∃ s, E.includeScalar s = ⁅x, y⁆ :=
  (E.mem_quotientHom_ker_iff ⁅x, y⁆).mp (E.commutator_mem_ker x y)

/-! The central exact sequence makes the commutator a scalar-valued
bihomomorphism.  This is the algebraic core of the theta commutator pairing;
the quotient-level pairing is obtained after choosing lifts in a later layer. -/

include E

theorem commutator_commute (x y z : G) :
    Commute ⁅x, y⁆ z := by
  obtain ⟨s, hs⟩ := E.exists_scalar_eq_commutator x y
  rw [← hs]
  exact E.includeScalar_commute s z

noncomputable def commutatorScalar (x y : G) : S :=
  Classical.choose (E.exists_scalar_eq_commutator x y)

@[simp]
theorem includeScalar_commutatorScalar (x y : G) :
    E.includeScalar (E.commutatorScalar x y) = ⁅x, y⁆ :=
  Classical.choose_spec (E.exists_scalar_eq_commutator x y)

theorem commutatorScalar_unique (x y : G) {s : S}
    (hs : E.includeScalar s = ⁅x, y⁆) :
    s = E.commutatorScalar x y :=
  E.includeScalar_injective (hs.trans (E.includeScalar_commutatorScalar x y).symm)

@[simp]
theorem commutatorScalar_one_left (y : G) :
    E.commutatorScalar 1 y = 1 := by
  apply E.includeScalar_injective
  rw [E.includeScalar_commutatorScalar, commutatorElement_one_left, map_one]

@[simp]
theorem commutatorScalar_one_right (x : G) :
    E.commutatorScalar x 1 = 1 := by
  apply E.includeScalar_injective
  rw [E.includeScalar_commutatorScalar, commutatorElement_one_right, map_one]

@[simp]
theorem commutatorScalar_self (x : G) :
    E.commutatorScalar x x = 1 := by
  apply E.includeScalar_injective
  rw [E.includeScalar_commutatorScalar, commutatorElement_self, map_one]

theorem commutatorScalar_swap (x y : G) :
    E.commutatorScalar y x = (E.commutatorScalar x y)⁻¹ := by
  apply E.includeScalar_injective
  calc
    E.includeScalar (E.commutatorScalar y x) = ⁅y, x⁆ :=
      E.includeScalar_commutatorScalar y x
    _ = ⁅x, y⁆⁻¹ := by rw [commutatorElement_inv]
    _ = (E.includeScalar (E.commutatorScalar x y))⁻¹ :=
      congrArg Inv.inv (E.includeScalar_commutatorScalar x y).symm
    _ = E.includeScalar ((E.commutatorScalar x y)⁻¹) :=
      (map_inv E.includeScalar _).symm

@[simp]
theorem commutatorScalar_includeScalar_left (s : S) (y : G) :
    E.commutatorScalar (E.includeScalar s) y = 1 := by
  apply E.includeScalar_injective
  rw [E.includeScalar_commutatorScalar,
    (E.includeScalar_commute s y).commutator_eq, map_one]

@[simp]
theorem commutatorScalar_includeScalar_right (x : G) (s : S) :
    E.commutatorScalar x (E.includeScalar s) = 1 := by
  rw [E.commutatorScalar_swap, E.commutatorScalar_includeScalar_left, inv_one]

theorem commutatorScalar_mul_left (x y z : G) :
    E.commutatorScalar (x * y) z =
      E.commutatorScalar x z * E.commutatorScalar y z := by
  apply E.includeScalar_injective
  rw [map_mul, E.includeScalar_commutatorScalar, E.includeScalar_commutatorScalar,
    E.includeScalar_commutatorScalar, commutatorElement_mul_left_eq_conj_mul,
    (E.commutator_commute y z x).symm.mul_inv_cancel,
    (E.commutator_commute x z ⁅y, z⁆).eq]

theorem commutatorScalar_mul_right (x y z : G) :
    E.commutatorScalar x (y * z) =
      E.commutatorScalar x y * E.commutatorScalar x z := by
  apply E.includeScalar_injective
  rw [map_mul, E.includeScalar_commutatorScalar, E.includeScalar_commutatorScalar,
    E.includeScalar_commutatorScalar, commutatorElement_mul_right_eq_mul_conj]
  calc
    ⁅x, y⁆ * y * ⁅x, z⁆ * y⁻¹ =
        ⁅x, y⁆ * (y * ⁅x, z⁆ * y⁻¹) := by simp only [mul_assoc]
    _ = ⁅x, y⁆ * ⁅x, z⁆ := by
      rw [(E.commutator_commute x z y).symm.mul_inv_cancel]

noncomputable def commutatorHom (x : G) : G →* S where
  toFun := E.commutatorScalar x
  map_one' := E.commutatorScalar_one_right x
  map_mul' := E.commutatorScalar_mul_right x

@[simp]
theorem commutatorHom_apply (x y : G) :
    E.commutatorHom x y = E.commutatorScalar x y :=
  rfl

noncomputable def commutatorBihom : G →* G →* S where
  toFun := E.commutatorHom
  map_one' := by ext y; exact E.commutatorScalar_one_left y
  map_mul' x y := by ext z; exact E.commutatorScalar_mul_left x y z

@[simp]
theorem commutatorBihom_apply (x y : G) :
    E.commutatorBihom x y = E.commutatorScalar x y :=
  rfl

end ThetaExtension

end Mumford
