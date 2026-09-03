/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotient

/-!
# Affine invariant quotients over a base

The affine invariant-ring construction in `InvariantQuotient` is an absolute
construction on spectra.  This file packages the same maps in the slice over
`Spec k`.  The quotient and its universal property remain conditional data:
the slice API does not assert a global (or non-affine) quotient exists.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open AlgebraicGeometry

namespace MilneLib

section Base

variable {k A : Type u} [CommRing k] [CommRing A] [Algebra k A]

/-! The structure map of an affine `k`-scheme and its bundled slice object. -/

/-- The canonical structure morphism `Spec A -> Spec k` induced by the
`k`-algebra structure on `A`. -/
noncomputable def affineSpecToBase :
    Spec (CommRingCat.of A) ⟶ Spec (CommRingCat.of k) :=
  Spec.map (CommRingCat.ofHom (algebraMap k A))

/-- The affine spectrum `Spec A`, viewed as an object over `Spec k`. -/
noncomputable def affineSpecOver : Over (Spec (CommRingCat.of k)) :=
  Over.mk (affineSpecToBase (k := k) (A := A))

@[simp]
theorem affineSpecOver_hom :
    (affineSpecOver (k := k) (A := A)).hom =
      affineSpecToBase (k := k) (A := A) :=
  rfl

end Base

section Quotient

variable {k A G : Type u} [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A]

/-- The structure map of the affine invariant quotient to `Spec k`. -/
noncomputable def affineInvariantQuotientBaseMap :
    Spec (CommRingCat.of (FixedPoints.subalgebra k A G)) ⟶
      Spec (CommRingCat.of k) :=
  affineSpecToBase (k := k) (A := FixedPoints.subalgebra k A G)

/-- The affine invariant quotient, viewed as an object over `Spec k`. -/
noncomputable def affineInvariantQuotientOver :
    Over (Spec (CommRingCat.of k)) :=
  Over.mk (affineInvariantQuotientBaseMap (k := k) (A := A) (G := G))

/-- The source affine scheme of the invariant quotient, viewed over `Spec k`.
This named alias keeps the source and quotient objects visible at call sites. -/
noncomputable def affineInvariantSourceOver :
    Over (Spec (CommRingCat.of k)) :=
  affineSpecOver (k := k) (A := A)

@[simp]
theorem affineInvariantQuotientOver_hom :
    (affineInvariantQuotientOver (k := k) (A := A) (G := G)).hom =
      affineInvariantQuotientBaseMap (k := k) (A := A) (G := G) :=
  rfl

@[simp]
theorem affineInvariantSourceOver_hom :
    (affineInvariantSourceOver (k := k) (A := A)).hom =
      affineSpecToBase (k := k) (A := A) :=
  rfl

/-- The affine invariant quotient map is a morphism over `Spec k`. -/
noncomputable def affineInvariantQuotientMapOver :
    affineInvariantSourceOver (k := k) (A := A) ⟶
      affineInvariantQuotientOver (k := k) (A := A) (G := G) :=
  Over.homMk
    (affineInvariantQuotientMap (k := k) (A := A) (G := G)) (by
      change affineInvariantQuotientMap (k := k) (A := A) (G := G) ≫
          affineSpecToBase (k := k)
            (A := FixedPoints.subalgebra k A G) =
        affineSpecToBase (k := k) (A := A)
      unfold affineInvariantQuotientMap affineSpecToBase
      rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
      apply congrArg Spec.map
      apply CommRingCat.hom_ext
      apply RingHom.ext
      intro x
      rfl)

@[simp]
theorem affineInvariantQuotientMapOver_left :
    (affineInvariantQuotientMapOver (k := k) (A := A) (G := G)).left =
      affineInvariantQuotientMap (k := k) (A := A) (G := G) :=
  rfl

theorem affineInvariantQuotientMapOver_isOver :
    (affineInvariantQuotientMapOver (k := k) (A := A) (G := G)).left ≫
        (affineInvariantQuotientOver (k := k) (A := A) (G := G)).hom =
      (affineInvariantSourceOver (k := k) (A := A)).hom :=
  Over.w _

end Quotient

section AffineMaps

variable {k A B G : Type u} [CommRing k] [CommRing A] [CommRing B]
  [Algebra k A] [Algebra k B]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A]

/-- An affine map is a map over `Spec k` when its ring homomorphism respects
the displayed `k`-algebra structures.  The compatibility is an explicit
hypothesis because no canonical `k`-algebra structure on a bare ring map is
inferred here. -/
noncomputable def invariantAffineMapOver (phi : B →+* A)
    (hbase : phi.comp (algebraMap k B) = algebraMap k A) :
    affineSpecOver (k := k) (A := A) ⟶
      affineSpecOver (k := k) (A := B) :=
  Over.homMk (Spec.map (CommRingCat.ofHom phi)) (by
    change Spec.map (CommRingCat.ofHom phi) ≫
        affineSpecToBase (k := k) (A := B) =
      affineSpecToBase (k := k) (A := A)
    unfold affineSpecToBase
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp, hbase])

@[simp]
theorem invariantAffineMapOver_left (phi : B →+* A)
    (hbase : phi.comp (algebraMap k B) = algebraMap k A) :
    (invariantAffineMapOver (k := k) (A := A) (B := B) phi hbase).left =
      Spec.map (CommRingCat.ofHom phi) :=
  rfl

theorem invariantAffineMapOver_isOver (phi : B →+* A)
    (hbase : phi.comp (algebraMap k B) = algebraMap k A) :
    (invariantAffineMapOver (k := k) (A := A) (B := B) phi hbase).left ≫
        (affineSpecOver (k := k) (A := B)).hom =
      (affineSpecOver (k := k) (A := A)).hom :=
  Over.w _

/-! The lift through the fixed subalgebra also respects the base map. -/

theorem invariantRingHomLift_comp_algebraMap
    (phi : B →+* A)
    (hinv : ∀ (g : G) (b : B), g • phi b = phi b)
    (hbase : phi.comp (algebraMap k B) = algebraMap k A) :
    (invariantRingHomLift (k := k) (G := G) phi hinv).comp
        (algebraMap k B) =
      algebraMap k (FixedPoints.subalgebra k A G) := by
  apply RingHom.ext
  intro x
  apply Subtype.ext
  change (invariantRingHomLift (k := k) (G := G) phi hinv)
      (algebraMap k B x) = algebraMap k A x
  rw [invariantRingHomLift_coe]
  exact DFunLike.congr_fun hbase x

/-- The factor map supplied by the affine invariant-ring universal property,
packaged as a morphism over `Spec k`. -/
noncomputable def affineInvariantQuotientFactorOver
    (phi : B →+* A)
    (hinv : ∀ (g : G) (b : B), g • phi b = phi b)
    (hbase : phi.comp (algebraMap k B) = algebraMap k A) :
    affineInvariantQuotientOver (k := k) (A := A) (G := G) ⟶
      affineSpecOver (k := k) (A := B) :=
  Over.homMk
    (Spec.map (CommRingCat.ofHom
      (invariantRingHomLift (k := k) (G := G) phi hinv))) (by
    change Spec.map (CommRingCat.ofHom
        (invariantRingHomLift (k := k) (G := G) phi hinv)) ≫
        affineSpecToBase (k := k) (A := B) =
      affineSpecToBase (k := k)
        (A := FixedPoints.subalgebra k A G)
    unfold affineSpecToBase
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
    apply congrArg Spec.map
    apply CommRingCat.hom_ext
    exact invariantRingHomLift_comp_algebraMap phi hinv hbase)

@[simp]
theorem affineInvariantQuotientFactorOver_left
    (phi : B →+* A)
    (hinv : ∀ (g : G) (b : B), g • phi b = phi b)
    (hbase : phi.comp (algebraMap k B) = algebraMap k A) :
    (affineInvariantQuotientFactorOver (k := k) (A := A) (B := B)
      (G := G) phi hinv hbase).left =
      Spec.map (CommRingCat.ofHom
        (invariantRingHomLift (k := k) (G := G) phi hinv)) :=
  rfl

theorem affineInvariantQuotientFactorOver_isOver
    (phi : B →+* A)
    (hinv : ∀ (g : G) (b : B), g • phi b = phi b)
    (hbase : phi.comp (algebraMap k B) = algebraMap k A) :
    (affineInvariantQuotientFactorOver (k := k) (A := A) (B := B)
      (G := G) phi hinv hbase).left ≫
        (affineSpecOver (k := k) (A := B)).hom =
      (affineInvariantQuotientOver (k := k) (A := A) (G := G)).hom :=
  Over.w _

/-- The underlying affine factorization, retained as a named bridge for
consumers that work in the ordinary category of affine schemes. -/
theorem affineInvariantQuotientMap_comp_factorOver
    (phi : B →+* A)
    (hinv : ∀ (g : G) (b : B), g • phi b = phi b)
    (hbase : phi.comp (algebraMap k B) = algebraMap k A) :
    affineInvariantQuotientMap (k := k) (A := A) (G := G) ≫
        (affineInvariantQuotientFactorOver (k := k) (A := A) (B := B)
          (G := G) phi hinv hbase).left =
      Spec.map (CommRingCat.ofHom phi) := by
  change affineInvariantQuotientMap (k := k) (A := A) (G := G) ≫
      Spec.map (CommRingCat.ofHom
        (invariantRingHomLift (k := k) (G := G) phi hinv)) =
    Spec.map (CommRingCat.ofHom phi)
  change Spec.map (CommRingCat.ofHom
      (algebraMap (FixedPoints.subalgebra k A G) A)) ≫
      Spec.map (CommRingCat.ofHom
        (invariantRingHomLift (k := k) (G := G) phi hinv)) =
    Spec.map (CommRingCat.ofHom phi)
  rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
  apply congrArg Spec.map
  apply CommRingCat.hom_ext
  apply RingHom.ext
  intro b
  exact invariantRingHomLift_coe (k := k) (G := G) phi hinv b

@[reassoc (attr := simp)]
theorem affineInvariantQuotientMapOver_comp_factorOver
    (phi : B →+* A)
    (hinv : ∀ (g : G) (b : B), g • phi b = phi b)
    (hbase : phi.comp (algebraMap k B) = algebraMap k A) :
    affineInvariantQuotientMapOver (k := k) (A := A) (G := G) ≫
        affineInvariantQuotientFactorOver (k := k) (A := A) (B := B)
          (G := G) phi hinv hbase =
      invariantAffineMapOver (k := k) (A := A) (B := B) phi hbase := by
  apply Over.OverMorphism.ext
  exact affineInvariantQuotientMap_comp_factorOver phi hinv hbase

/-- Universal factorization in the slice over `Spec k`.  The only hypotheses
are the explicit invariance and base-compatibility conditions on the affine
ring map; no quotient-existence instance is introduced. -/
theorem affineInvariantQuotientMapOver_existsUnique_factor
    (phi : B →+* A)
    (hinv : ∀ (g : G) (b : B), g • phi b = phi b)
    (hbase : phi.comp (algebraMap k B) = algebraMap k A) :
    ∃! u : affineInvariantQuotientOver (k := k) (A := A) (G := G) ⟶
        affineSpecOver (k := k) (A := B),
      affineInvariantQuotientMapOver (k := k) (A := A) (G := G) ≫ u =
        invariantAffineMapOver (k := k) (A := A) (B := B) phi hbase := by
  let u0 : affineInvariantQuotientOver (k := k) (A := A) (G := G) ⟶
      affineSpecOver (k := k) (A := B) :=
    affineInvariantQuotientFactorOver (k := k) (A := A) (B := B)
      (G := G) phi hinv hbase
  refine ⟨u0, ?_, ?_⟩
  · exact affineInvariantQuotientMapOver_comp_factorOver phi hinv hbase
  · intro u hu
    apply Over.OverMorphism.ext
    apply (affineInvariantQuotientMap_existsUnique_factor
      (k := k) (A := A) (G := G) phi hinv).unique
    · have h := congrArg Over.Hom.left hu
      change affineInvariantQuotientMap (k := k) (A := A) (G := G) ≫
          u.left = Spec.map (CommRingCat.ofHom phi) at h
      exact h
    · exact affineInvariantQuotientMap_comp_factorOver phi hinv hbase

end AffineMaps

end MilneLib
