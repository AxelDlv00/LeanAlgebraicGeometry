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

end ThetaExtension

end Mumford
