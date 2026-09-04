/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotient

/-!
# Equivariant transitions between affine invariant quotients

An equivariant ring map between two affine schemes restricts to a map between
their fixed-point subalgebras.  The resulting spectrum map is the transition
between the corresponding affine quotient charts.  This module records the
restriction, its functoriality, and the square with the two quotient maps; it
does not assert existence of a non-affine quotient.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry
open scoped Pointwise

namespace MilneLib
namespace InvariantLocalization

variable {k A B C G : Type u}
  [CommRing k] [CommRing A] [CommRing B] [CommRing C]
  [Algebra k A] [Algebra k B] [Algebra k C]
  [Group G] [MulSemiringAction G A] [MulSemiringAction G B]
  [MulSemiringAction G C]
  [SMulCommClass G k A] [SMulCommClass G k B] [SMulCommClass G k C]

/-! ## Restriction to fixed subalgebras -/

/-- Restrict an equivariant ring map to the fixed-point subalgebras. -/
def equivariantFixedRingHom (φ : B →+* A)
    (hφ : ∀ (g : G) (b : B), g • φ b = φ (g • b)) :
    FixedPoints.subalgebra k B G →+* FixedPoints.subalgebra k A G :=
  (φ.comp (FixedPoints.subalgebra k B G).val).codRestrict
    (FixedPoints.subalgebra k A G) (fun b => by
      intro g
      change g • φ (b : B) = φ (b : B)
      rw [hφ, b.property g])

@[simp]
theorem equivariantFixedRingHom_coe (φ : B →+* A)
    (hφ : ∀ (g : G) (b : B), g • φ b = φ (g • b))
    (b : FixedPoints.subalgebra k B G) :
    ((equivariantFixedRingHom (k := k) (G := G) φ hφ b :
      FixedPoints.subalgebra k A G) : A) = φ (b : B) := by
  rfl

/-! ## Functoriality -/

/-- Restriction to fixed subalgebras respects composition of equivariant maps. -/
theorem equivariantFixedRingHom_comp (φ : B →+* A) (ψ : C →+* B)
    (hφ : ∀ (g : G) (b : B), g • φ b = φ (g • b))
    (hψ : ∀ (g : G) (c : C), g • ψ c = ψ (g • c)) :
    (equivariantFixedRingHom (k := k) (G := G) φ hφ).comp
        (equivariantFixedRingHom (k := k) (G := G) ψ hψ) =
      equivariantFixedRingHom (k := k) (G := G) (φ.comp ψ) (by
        intro g c
        change g • φ (ψ c) = φ (ψ (g • c))
        rw [hφ, hψ]) := by
  ext c
  rfl

@[simp]
theorem equivariantFixedRingHom_id :
    equivariantFixedRingHom (k := k) (G := G) (RingHom.id A)
        (fun _ _ => rfl) = RingHom.id (FixedPoints.subalgebra k A G) := by
  ext a
  rfl

/-- The inverse of an equivariant ring equivalence is equivariant. -/
theorem ringEquiv_symm_equivariant (e : B ≃+* A)
    (hₑ : ∀ (g : G) (b : B), g • e b = e (g • b))
    (g : G) (a : A) :
    g • e.symm a = e.symm (g • a) := by
  apply e.injective
  rw [e.apply_symm_apply]
  exact (hₑ g (e.symm a)).symm.trans
    (congrArg (g • ·) (e.apply_symm_apply a))

/-- An equivariant ring equivalence restricts to an equivalence of fixed-point
subalgebras. -/
noncomputable def equivariantFixedRingEquiv (e : B ≃+* A)
    (hₑ : ∀ (g : G) (b : B), g • e b = e (g • b)) :
    FixedPoints.subalgebra k B G ≃+* FixedPoints.subalgebra k A G :=
  RingEquiv.ofRingHom
    (equivariantFixedRingHom (k := k) (G := G) e.toRingHom hₑ)
    (equivariantFixedRingHom (k := k) (G := G) e.symm.toRingHom
      (ringEquiv_symm_equivariant e hₑ))
    (by
      ext a
      simp [equivariantFixedRingHom])
    (by
      ext b
      simp [equivariantFixedRingHom])

@[simp]
theorem equivariantFixedRingEquiv_apply_coe (e : B ≃+* A)
    (hₑ : ∀ (g : G) (b : B), g • e b = e (g • b))
    (b : FixedPoints.subalgebra k B G) :
    ((equivariantFixedRingEquiv (k := k) (G := G) e hₑ b :
      FixedPoints.subalgebra k A G) : A) = e (b : B) := by
  rfl

/-! ## Quotient-chart isomorphisms -/

/-- The scheme isomorphism induced on affine invariant quotients by an
equivariant ring equivalence. -/
noncomputable def affineInvariantQuotientIso (e : B ≃+* A)
    (hₑ : ∀ (g : G) (b : B), g • e b = e (g • b)) :
    Spec (CommRingCat.of (FixedPoints.subalgebra k A G)) ≅
      Spec (CommRingCat.of (FixedPoints.subalgebra k B G)) :=
  Scheme.Spec.mapIso
    (equivariantFixedRingEquiv (k := k) (G := G) e hₑ).toCommRingCatIso.op

@[simp]
theorem affineInvariantQuotientIso_hom (e : B ≃+* A)
    (hₑ : ∀ (g : G) (b : B), g • e b = e (g • b)) :
    (affineInvariantQuotientIso (k := k) (G := G) e hₑ).hom =
      Spec.map (CommRingCat.ofHom
        (equivariantFixedRingHom (k := k) (G := G) e.toRingHom hₑ)) := by
  rfl

@[simp]
theorem affineInvariantQuotientIso_inv (e : B ≃+* A)
    (hₑ : ∀ (g : G) (b : B), g • e b = e (g • b)) :
    (affineInvariantQuotientIso (k := k) (G := G) e hₑ).inv =
      Spec.map (CommRingCat.ofHom
        (equivariantFixedRingHom (k := k) (G := G) e.symm.toRingHom
          (ringEquiv_symm_equivariant e hₑ))) := by
  rfl

/-! ## The quotient transition square -/

/-- An equivariant affine map descends to a map between the affine invariant
quotients, and the two quotient projections form a commuting square. -/
theorem affineInvariantQuotientMap_naturality
    (φ : B →+* A)
    (hφ : ∀ (g : G) (b : B), g • φ b = φ (g • b)) :
    affineInvariantQuotientMap (k := k) (A := A) (G := G) ≫
        Spec.map (CommRingCat.ofHom
          (equivariantFixedRingHom (k := k) (G := G) φ hφ)) =
      Spec.map (CommRingCat.ofHom φ) ≫
        affineInvariantQuotientMap (k := k) (A := B) (G := G) := by
  change Spec.map (CommRingCat.ofHom
      (algebraMap (FixedPoints.subalgebra k A G) A)) ≫
      Spec.map (CommRingCat.ofHom
        (equivariantFixedRingHom (k := k) (G := G) φ hφ)) =
    Spec.map (CommRingCat.ofHom φ) ≫
      Spec.map (CommRingCat.ofHom
        (algebraMap (FixedPoints.subalgebra k B G) B))
  rw [← Spec.map_comp, ← CommRingCat.ofHom_comp, ← Spec.map_comp,
    ← CommRingCat.ofHom_comp]
  apply congrArg Spec.map
  apply CommRingCat.hom_ext
  ext b
  exact equivariantFixedRingHom_coe (k := k) (G := G) φ hφ b

/-- The quotient map commutes with the chart isomorphism induced by an
equivariant ring equivalence. -/
theorem affineInvariantQuotientMap_comp_iso
    (e : B ≃+* A)
    (hₑ : ∀ (g : G) (b : B), g • e b = e (g • b)) :
    affineInvariantQuotientMap (k := k) (A := A) (G := G) ≫
        (affineInvariantQuotientIso (k := k) (G := G) e hₑ).hom =
      Spec.map (CommRingCat.ofHom e.toRingHom) ≫
        affineInvariantQuotientMap (k := k) (A := B) (G := G) := by
  rw [affineInvariantQuotientIso_hom]
  exact affineInvariantQuotientMap_naturality e.toRingHom hₑ

end InvariantLocalization
end MilneLib
