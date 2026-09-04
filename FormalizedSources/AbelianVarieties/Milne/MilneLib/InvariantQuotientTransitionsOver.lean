/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.AffineQuotientOver
import MilneLib.InvariantQuotientTransitions

/-!
# Equivariant affine quotient transitions over a base

Equivariant `k`-algebra maps descend to morphisms between affine invariant
quotients over `Spec k`.  A pair of such maps into a common affine ring gives
the two legs of a conditional affine overlap, together with their quotient
squares.  No affineness or open-immersion claim for geometric intersections is
made here.
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

/-! ## Fixed subalgebras over the base -/

/-- An equivariant ring map which respects `k` continues to respect `k` after
restriction to fixed subalgebras. -/
theorem equivariantFixedRingHom_comp_algebraMap (φ : B →+* A)
    (hφ : ∀ (g : G) (b : B), g • φ b = φ (g • b))
    (hbase : φ.comp (algebraMap k B) = algebraMap k A) :
    (equivariantFixedRingHom (k := k) (G := G) φ hφ).comp
        (algebraMap k (FixedPoints.subalgebra k B G)) =
      algebraMap k (FixedPoints.subalgebra k A G) := by
  apply RingHom.ext
  intro r
  apply Subtype.ext
  change φ (algebraMap k B r) = algebraMap k A r
  exact DFunLike.congr_fun hbase r

/-- Restrict an equivariant `k`-algebra map to the fixed subalgebras. -/
def equivariantFixedAlgHom (φ : B →ₐ[k] A)
    (hφ : ∀ (g : G) (b : B), g • φ b = φ (g • b)) :
    FixedPoints.subalgebra k B G →ₐ[k] FixedPoints.subalgebra k A G where
  __ := equivariantFixedRingHom (k := k) (G := G) φ.toRingHom hφ
  commutes' r := by
    apply Subtype.ext
    exact φ.commutes r

@[simp]
theorem equivariantFixedAlgHom_coe (φ : B →ₐ[k] A)
    (hφ : ∀ (g : G) (b : B), g • φ b = φ (g • b))
    (b : FixedPoints.subalgebra k B G) :
    ((equivariantFixedAlgHom (G := G) φ hφ b :
      FixedPoints.subalgebra k A G) : A) = φ (b : B) := by
  rfl

/-- An equivariant `k`-algebra equivalence restricts to an equivalence of fixed
subalgebras over `k`. -/
noncomputable def equivariantFixedAlgEquiv (e : B ≃ₐ[k] A)
    (hₑ : ∀ (g : G) (b : B), g • e b = e (g • b)) :
    FixedPoints.subalgebra k B G ≃ₐ[k] FixedPoints.subalgebra k A G :=
  AlgEquiv.ofRingEquiv
    (f := equivariantFixedRingEquiv (k := k) (G := G) e.toRingEquiv hₑ) (by
      intro r
      apply Subtype.ext
      exact e.commutes r)

/-- The quotient-chart isomorphism induced by an equivariant `k`-algebra
equivalence, viewed in the slice over `Spec k`. -/
noncomputable def affineInvariantQuotientIsoOver (e : B ≃ₐ[k] A)
    (hₑ : ∀ (g : G) (b : B), g • e b = e (g • b)) :
    affineInvariantQuotientOver (k := k) (A := A) (G := G) ≅
      affineInvariantQuotientOver (k := k) (A := B) (G := G) :=
  Over.isoMk
    (Scheme.Spec.mapIso
      (equivariantFixedAlgEquiv (k := k) (G := G) e hₑ).toRingEquiv.toCommRingCatIso.op) (by
      change Spec.map (CommRingCat.ofHom
          (equivariantFixedAlgEquiv (k := k) (G := G) e hₑ).toRingEquiv.toRingHom) ≫
          Spec.map (CommRingCat.ofHom
            (algebraMap k (FixedPoints.subalgebra k B G))) =
        Spec.map (CommRingCat.ofHom
          (algebraMap k (FixedPoints.subalgebra k A G)))
      rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
      apply congrArg Spec.map
      apply CommRingCat.hom_ext
      apply RingHom.ext
      intro r
      apply Subtype.ext
      change e (algebraMap k B r) = algebraMap k A r
      exact e.commutes r)

@[simp]
theorem affineInvariantQuotientIsoOver_hom_left (e : B ≃ₐ[k] A)
    (hₑ : ∀ (g : G) (b : B), g • e b = e (g • b)) :
    (affineInvariantQuotientIsoOver (G := G) e hₑ).hom.left =
      (affineInvariantQuotientIso (k := k) (G := G) e.toRingEquiv hₑ).hom :=
  rfl

@[simp]
theorem affineInvariantQuotientIsoOver_inv_left (e : B ≃ₐ[k] A)
    (hₑ : ∀ (g : G) (b : B), g • e b = e (g • b)) :
    (affineInvariantQuotientIsoOver (G := G) e hₑ).inv.left =
      (affineInvariantQuotientIso (k := k) (G := G) e.toRingEquiv hₑ).inv :=
  rfl

/-- Reversing an equivariant algebra equivalence reverses its slice quotient
isomorphism. -/
theorem affineInvariantQuotientIsoOver_symm (e : B ≃ₐ[k] A)
    (hₑ : ∀ (g : G) (b : B), g • e b = e (g • b)) :
    (affineInvariantQuotientIsoOver (G := G) e hₑ).symm =
      affineInvariantQuotientIsoOver (G := G) e.symm
        (ringEquiv_symm_equivariant e.toRingEquiv hₑ) := by
  apply Iso.ext
  apply Over.OverMorphism.ext
  change (affineInvariantQuotientIsoOver (G := G) e hₑ).inv.left =
    (affineInvariantQuotientIsoOver (G := G) e.symm
      (ringEquiv_symm_equivariant e.toRingEquiv hₑ)).hom.left
  rw [affineInvariantQuotientIsoOver_inv_left,
    affineInvariantQuotientIsoOver_hom_left,
    affineInvariantQuotientIso_inv_eq_hom_symm,
    affineInvariantQuotientIso_hom, affineInvariantQuotientIso_hom]
  rfl

/-- Slice quotient isomorphisms compose in the contravariant order dictated by
`Spec`. -/
theorem affineInvariantQuotientIsoOver_hom_trans (e : B ≃ₐ[k] A)
    (f : C ≃ₐ[k] B)
    (hₑ : ∀ (g : G) (b : B), g • e b = e (g • b))
    (hf : ∀ (g : G) (c : C), g • f c = f (g • c)) :
    (affineInvariantQuotientIsoOver (G := G) e hₑ).hom ≫
        (affineInvariantQuotientIsoOver (G := G) f hf).hom =
      (affineInvariantQuotientIsoOver (G := G) (f.trans e) (by
        intro g c
        change g • e (f c) = e (f (g • c))
        rw [hₑ, hf])).hom := by
  apply Over.OverMorphism.ext
  change (affineInvariantQuotientIsoOver (G := G) e hₑ).hom.left ≫
      (affineInvariantQuotientIsoOver (G := G) f hf).hom.left =
    (affineInvariantQuotientIsoOver (G := G) (f.trans e) (by
      intro g c
      change g • e (f c) = e (f (g • c))
      rw [hₑ, hf])).hom.left
  rw [affineInvariantQuotientIsoOver_hom_left,
    affineInvariantQuotientIsoOver_hom_left,
    affineInvariantQuotientIsoOver_hom_left]
  exact affineInvariantQuotientIso_hom_trans e.toRingEquiv f.toRingEquiv hₑ hf

@[simp]
theorem affineInvariantQuotientIsoOver_hom_refl :
    (affineInvariantQuotientIsoOver (G := G)
      (AlgEquiv.refl : A ≃ₐ[k] A) (fun _ _ => rfl)).hom = 𝟙 _ := by
  apply Over.OverMorphism.ext
  change (affineInvariantQuotientIsoOver (G := G)
      (AlgEquiv.refl : A ≃ₐ[k] A) (fun _ _ => rfl)).hom.left =
    Over.Hom.left (𝟙 (affineInvariantQuotientOver (k := k) (A := A) (G := G)))
  rw [affineInvariantQuotientIsoOver_hom_left, Over.id_left]
  exact affineInvariantQuotientIso_hom_refl (k := k) (A := A) (G := G)

/-! ## Quotient transitions in the slice -/

/-- The morphism over `Spec k` induced on affine invariant quotients by an
equivariant `k`-algebra map. -/
noncomputable def equivariantFixedAffineMapOver (φ : B →ₐ[k] A)
    (hφ : ∀ (g : G) (b : B), g • φ b = φ (g • b)) :
    affineInvariantQuotientOver (k := k) (A := A) (G := G) ⟶
      affineInvariantQuotientOver (k := k) (A := B) (G := G) :=
  invariantAffineMapOver
    (equivariantFixedRingHom (k := k) (G := G) φ.toRingHom hφ)
    (equivariantFixedRingHom_comp_algebraMap φ.toRingHom hφ
      φ.comp_algebraMap)

@[simp]
theorem equivariantFixedAffineMapOver_left (φ : B →ₐ[k] A)
    (hφ : ∀ (g : G) (b : B), g • φ b = φ (g • b)) :
    (equivariantFixedAffineMapOver (G := G) φ hφ).left =
      Spec.map (CommRingCat.ofHom
        (equivariantFixedRingHom (k := k) (G := G) φ.toRingHom hφ)) := by
  rfl

/-- Equivariant quotient transitions commute with the quotient projections in
the slice over `Spec k`. -/
@[reassoc]
theorem affineInvariantQuotientMapOver_naturality (φ : B →ₐ[k] A)
    (hφ : ∀ (g : G) (b : B), g • φ b = φ (g • b)) :
    affineInvariantQuotientMapOver (k := k) (A := A) (G := G) ≫
        equivariantFixedAffineMapOver (G := G) φ hφ =
      invariantAffineMapOver (k := k) (A := A) (B := B)
          φ.toRingHom φ.comp_algebraMap ≫
        affineInvariantQuotientMapOver (k := k) (A := B) (G := G) := by
  apply Over.OverMorphism.ext
  exact affineInvariantQuotientMap_naturality φ.toRingHom hφ

/-! ## Pairwise affine overlap cones -/

/-- Two equivariant `k`-algebra restrictions into a common affine ring.  This
is the algebraic cone attached to an explicitly affine pairwise overlap.  It
does not assert that an intersection is affine or that its quotient legs are
open immersions. -/
structure EquivariantAffineOverlapOver where
  left : A →ₐ[k] C
  right : B →ₐ[k] C
  left_equivariant : ∀ (g : G) (a : A), g • left a = left (g • a)
  right_equivariant : ∀ (g : G) (b : B), g • right b = right (g • b)

namespace EquivariantAffineOverlapOver

variable
  (D : EquivariantAffineOverlapOver (k := k) (A := A) (B := B) (C := C) (G := G))

/-- The source overlap map to the left affine chart over `Spec k`. -/
noncomputable def leftSourceMap :
    affineSpecOver (k := k) (A := C) ⟶ affineSpecOver (k := k) (A := A) :=
  invariantAffineMapOver D.left.toRingHom D.left.comp_algebraMap

/-- The source overlap map to the right affine chart over `Spec k`. -/
noncomputable def rightSourceMap :
    affineSpecOver (k := k) (A := C) ⟶ affineSpecOver (k := k) (A := B) :=
  invariantAffineMapOver D.right.toRingHom D.right.comp_algebraMap

/-- The invariant quotient of the overlap maps to the left quotient chart over
`Spec k`. -/
noncomputable def leftQuotientMap :
    affineInvariantQuotientOver (k := k) (A := C) (G := G) ⟶
      affineInvariantQuotientOver (k := k) (A := A) (G := G) :=
  equivariantFixedAffineMapOver D.left D.left_equivariant

/-- The invariant quotient of the overlap maps to the right quotient chart over
`Spec k`. -/
noncomputable def rightQuotientMap :
    affineInvariantQuotientOver (k := k) (A := C) (G := G) ⟶
      affineInvariantQuotientOver (k := k) (A := B) (G := G) :=
  equivariantFixedAffineMapOver D.right D.right_equivariant

omit [SMulCommClass G k B] in
/-- The left overlap leg commutes with the affine quotient projections. -/
theorem quotientMap_comp_leftQuotientMap :
    affineInvariantQuotientMapOver (k := k) (A := C) (G := G) ≫
        D.leftQuotientMap =
      D.leftSourceMap ≫
        affineInvariantQuotientMapOver (k := k) (A := A) (G := G) :=
  affineInvariantQuotientMapOver_naturality D.left D.left_equivariant

omit [SMulCommClass G k A] in
/-- The right overlap leg commutes with the affine quotient projections. -/
theorem quotientMap_comp_rightQuotientMap :
    affineInvariantQuotientMapOver (k := k) (A := C) (G := G) ≫
        D.rightQuotientMap =
      D.rightSourceMap ≫
        affineInvariantQuotientMapOver (k := k) (A := B) (G := G) :=
  affineInvariantQuotientMapOver_naturality D.right D.right_equivariant

end EquivariantAffineOverlapOver

end InvariantLocalization
end MilneLib
