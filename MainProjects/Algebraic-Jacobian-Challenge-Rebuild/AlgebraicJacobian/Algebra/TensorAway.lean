/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Algebra.PiLocalization

/-!
# The tensor product of two `Away` localizations as an `Away` localization of the tensor square

Let `A → B` be a map of commutative rings and `r s : B`.  Fix models `Si`, `Sj` for the
localizations `B[1/r]`, `B[1/s]` (as `B`-algebras, via `IsScalarTower A B Si`,
`IsScalarTower A B Sj`).  This file exhibits their `A`-tensor product `Si ⊗[A] Sj` as a
localization of the tensor square `B ⊗[A] B` away from the element
`(r ⊗ₜ 1) * (1 ⊗ₜ s) = r ⊗ₜ s`.

This is the two-base analogue of `IsLocalization.Away.tensor'`
(`AlgebraicJacobian.Algebra.PiLocalization`): there the two factors are `Away`
localizations over the *same* base `A`, giving `Away (f * g)` over `A`; here the two
factors are `Away` localizations over `B`, tensored over the smaller ring `A`, giving an
`Away` localization over `B ⊗[A] B`.

## Main declarations

* `IsLocalization.Away.tensorAwayAlgebra` — the canonical `B ⊗[A] B`-algebra structure on
  `Si ⊗[A] Sj`, coming from `Algebra.TensorProduct.map` applied to the two structure maps
  `B →ₐ[A] Si`, `B →ₐ[A] Sj`.  It is a `def` (not a global instance) so as not to clash with
  `Algebra.id` in the degenerate case `Si = Sj = B`; consumers introduce it with `letI`.
* `IsLocalization.Away.isLocalization_away_tensor` — the localization statement
  `IsLocalization.Away ((r ⊗ₜ 1) * (1 ⊗ₜ s)) (Si ⊗[A] Sj)`.
* `IsLocalization.Away.tensorAwayEquiv` — the canonical `B ⊗[A] B`-algebra equivalence to any
  other model of this localization, with `tensorAwayEquiv_tmul` computing it on pure tensors.

## Implementation notes

The localization is factored through the intermediate ring `Si ⊗[A] B`: first the left
factor `B → Si` is localized at `r`, then the right factor `B → Sj` at `s`, combined with
`IsLocalization.Away.mul'`.  Each individual localization is provided by mathlib's
`IsLocalization.tensorProduct_tensorProduct` (left factor) and
`IsLocalization.tensorProduct_tensorProduct_right` (right factor), both of which take the
tensor-`map` algebra structure as an explicit hypothesis, thereby avoiding any
`Algebra.TensorProduct.rightAlgebra` instance diamonds.
-/

universe u

set_option autoImplicit false

open TensorProduct

namespace IsLocalization.Away

variable (A B : Type u) [CommRing A] [CommRing B] [Algebra A B]
variable (r s : B)
variable (Si Sj : Type u) [CommRing Si] [CommRing Sj]
variable [Algebra B Si] [Algebra B Sj] [Algebra A Si] [Algebra A Sj]
variable [IsScalarTower A B Si] [IsScalarTower A B Sj]

/-! ## The canonical algebra maps and structure -/

/-- The `A`-algebra map `B ⊗[A] B →ₐ[A] Si ⊗[A] B` localizing only the left factor. -/
noncomputable def leftMap : B ⊗[A] B →ₐ[A] Si ⊗[A] B :=
  Algebra.TensorProduct.map (IsScalarTower.toAlgHom A B Si) (AlgHom.id A B)

/-- The `A`-algebra map `Si ⊗[A] B →ₐ[A] Si ⊗[A] Sj` localizing the right factor. -/
noncomputable def rightMap : Si ⊗[A] B →ₐ[A] Si ⊗[A] Sj :=
  Algebra.TensorProduct.map (AlgHom.id A Si) (IsScalarTower.toAlgHom A B Sj)

/-- The `A`-algebra map `B ⊗[A] B →ₐ[A] Si ⊗[A] Sj` localizing both factors. -/
noncomputable def tensorMap : B ⊗[A] B →ₐ[A] Si ⊗[A] Sj :=
  Algebra.TensorProduct.map (IsScalarTower.toAlgHom A B Si) (IsScalarTower.toAlgHom A B Sj)

/-- The two-step factorisation of `tensorMap` through the intermediate `Si ⊗[A] B`. -/
lemma rightMap_comp_leftMap :
    (rightMap A B Si Sj).comp (leftMap A B Si) = tensorMap A B Si Sj := by
  rw [rightMap, leftMap, tensorMap, ← Algebra.TensorProduct.map_comp]; rfl

/-- The canonical `B ⊗[A] B`-algebra structure on `Si ⊗[A] Sj`, given by `tensorMap`.

Provided as a `def` (introduce it with `letI`), *not* a global instance: as a global
instance it would compete with `Algebra.id (B ⊗[A] B)` in the degenerate case
`Si = Sj = B`. -/
@[reducible] noncomputable def tensorAwayAlgebra : Algebra (B ⊗[A] B) (Si ⊗[A] Sj) :=
  (tensorMap A B Si Sj).toRingHom.toAlgebra

/-! ## The localization statement -/

/-- **The tensor product of two `Away` localizations over `B` is an `Away` localization of
the tensor square `B ⊗[A] B`.**  Namely, `Si ⊗[A] Sj` (with the canonical
`tensorAwayAlgebra` structure) is the localization of `B ⊗[A] B` away from
`(r ⊗ₜ 1) * (1 ⊗ₜ s)`, which equals `r ⊗ₜ s`. -/
theorem isLocalization_away_tensor
    [IsLocalization.Away r Si] [IsLocalization.Away s Sj] :
    letI := tensorAwayAlgebra A B Si Sj
    IsLocalization.Away ((r ⊗ₜ[A] 1) * (1 ⊗ₜ[A] s) : B ⊗[A] B) (Si ⊗[A] Sj) := by
  letI algL : Algebra (B ⊗[A] B) (Si ⊗[A] B) := (leftMap A B Si).toRingHom.toAlgebra
  letI algR : Algebra (Si ⊗[A] B) (Si ⊗[A] Sj) := (rightMap A B Si Sj).toRingHom.toAlgebra
  letI := tensorAwayAlgebra A B Si Sj
  -- the tower `B ⊗[A] B → Si ⊗[A] B → Si ⊗[A] Sj`
  haveI stRST : IsScalarTower (B ⊗[A] B) (Si ⊗[A] B) (Si ⊗[A] Sj) :=
    IsScalarTower.of_algebraMap_eq' <| by
      change (tensorMap A B Si Sj).toRingHom
        = (rightMap A B Si Sj).toRingHom.comp (leftMap A B Si).toRingHom
      rw [← rightMap_comp_leftMap A B Si Sj]; rfl
  -- left factor: `Si ⊗[A] B` is `Away (r ⊗ₜ 1)` over `B ⊗[A] B`
  haveI stL : IsScalarTower B (B ⊗[A] B) (Si ⊗[A] B) :=
    IsScalarTower.of_algebraMap_eq (fun _ => by
      simp [RingHom.algebraMap_toAlgebra, leftMap, Algebra.TensorProduct.map_tmul,
        IsScalarTower.coe_toAlgHom'])
  have H1 : (algebraMap (B ⊗[A] B) (Si ⊗[A] B)).comp Algebra.TensorProduct.includeRight.toRingHom
      = Algebra.TensorProduct.includeRight.toRingHom := by
    have key : (leftMap A B Si).comp Algebra.TensorProduct.includeRight
        = Algebra.TensorProduct.includeRight := by
      rw [leftMap, Algebra.TensorProduct.map_comp_includeRight, AlgHom.comp_id]
    ext b
    simpa [RingHom.algebraMap_toAlgebra] using congrArg (fun f => f b) key
  haveI hL : IsLocalization.Away (r ⊗ₜ[A] (1 : B) : B ⊗[A] B) (Si ⊗[A] B) := by
    have he : Algebra.algebraMapSubmonoid (B ⊗[A] B) (Submonoid.powers r)
        = Submonoid.powers (r ⊗ₜ[A] (1 : B)) := by
      rw [Algebra.algebraMapSubmonoid_powers]; rfl
    rw [IsLocalization.Away, ← he]
    exact IsLocalization.tensorProduct_tensorProduct (R := A) (S := B) (Submonoid.powers r) Si H1
  -- right factor: `Si ⊗[A] Sj` is `Away (1 ⊗ₜ s)` over `Si ⊗[A] B`
  haveI stR : IsScalarTower Si (Si ⊗[A] B) (Si ⊗[A] Sj) :=
    IsScalarTower.of_algebraMap_eq (fun _ => by
      simp [RingHom.algebraMap_toAlgebra, rightMap, Algebra.TensorProduct.map_tmul,
        IsScalarTower.coe_toAlgHom'])
  have H2 : (algebraMap (Si ⊗[A] B) (Si ⊗[A] Sj)).comp
      Algebra.TensorProduct.includeRight.toRingHom
        = Algebra.TensorProduct.includeRight.toRingHom.comp (algebraMap B Sj) := by
    have key : (rightMap A B Si Sj).comp Algebra.TensorProduct.includeRight
        = Algebra.TensorProduct.includeRight.comp (IsScalarTower.toAlgHom A B Sj) := by
      rw [rightMap, Algebra.TensorProduct.map_comp_includeRight]
    ext b
    simpa [RingHom.algebraMap_toAlgebra] using congrArg (fun f => f b) key
  haveI hR : IsLocalization.Away
      (algebraMap (B ⊗[A] B) (Si ⊗[A] B) ((1 : B) ⊗ₜ[A] s)) (Si ⊗[A] Sj) := by
    have hmap : algebraMap (B ⊗[A] B) (Si ⊗[A] B) ((1 : B) ⊗ₜ[A] s) = ((1 : Si) ⊗ₜ[A] s) := by
      simp [RingHom.algebraMap_toAlgebra, leftMap, Algebra.TensorProduct.map_tmul]
    rw [hmap]
    have he : (Submonoid.powers s).map
        (Algebra.TensorProduct.includeRight (R := A) (A := Si) (B := B))
          = Submonoid.powers ((1 : Si) ⊗ₜ[A] s) := by
      rw [Submonoid.map_powers]; rfl
    rw [IsLocalization.Away, ← he]
    exact IsLocalization.tensorProduct_tensorProduct_right A Si (Submonoid.powers s) Sj H2
  exact IsLocalization.Away.mul' (S := Si ⊗[A] B) (Si ⊗[A] Sj) (r ⊗ₜ[A] (1 : B)) ((1 : B) ⊗ₜ[A] s)

/-- The localization element in `simp`-normal form: `(r ⊗ₜ 1) * (1 ⊗ₜ s) = r ⊗ₜ s`. -/
@[simp] lemma tmul_one_mul_one_tmul (r s : B) :
    ((r ⊗ₜ[A] 1) * (1 ⊗ₜ[A] s) : B ⊗[A] B) = r ⊗ₜ[A] s := by
  rw [Algebra.TensorProduct.tmul_mul_tmul, mul_one, one_mul]

/-! ## Comparison with an arbitrary model -/

variable (Tij : Type u) [CommRing Tij] [Algebra (B ⊗[A] B) Tij]

/-- The canonical `B ⊗[A] B`-algebra equivalence from `Si ⊗[A] Sj` (with the
`tensorAwayAlgebra` structure) to any other model `Tij` of the localization of `B ⊗[A] B`
away from `(r ⊗ₜ 1) * (1 ⊗ₜ s)`. -/
noncomputable def tensorAwayEquiv
    [IsLocalization.Away r Si] [IsLocalization.Away s Sj]
    [IsLocalization.Away ((r ⊗ₜ[A] 1) * (1 ⊗ₜ[A] s) : B ⊗[A] B) Tij] :
    letI := tensorAwayAlgebra A B Si Sj
    Si ⊗[A] Sj ≃ₐ[B ⊗[A] B] Tij :=
  letI := tensorAwayAlgebra A B Si Sj
  haveI := isLocalization_away_tensor A B r s Si Sj
  IsLocalization.algEquiv (Submonoid.powers ((r ⊗ₜ[A] 1) * (1 ⊗ₜ[A] s))) (Si ⊗[A] Sj) Tij

/-- `tensorAwayEquiv` sends `tensorMap w` (equivalently, the image of `w : B ⊗[A] B` under
the canonical structure map) to `algebraMap w`; in particular it is a `B ⊗[A] B`-algebra
map. -/
lemma tensorAwayEquiv_tensorMap
    [IsLocalization.Away r Si] [IsLocalization.Away s Sj]
    [IsLocalization.Away ((r ⊗ₜ[A] 1) * (1 ⊗ₜ[A] s) : B ⊗[A] B) Tij] (w : B ⊗[A] B) :
    letI := tensorAwayAlgebra A B Si Sj
    tensorAwayEquiv A B r s Si Sj Tij (tensorMap A B Si Sj w) = algebraMap (B ⊗[A] B) Tij w :=
  letI := tensorAwayAlgebra A B Si Sj
  (tensorAwayEquiv A B r s Si Sj Tij).commutes w

/-- `tensorAwayEquiv` on a pure tensor of structure-map images: it sends
`algebraMap B Si b₁ ⊗ₜ algebraMap B Sj b₂` to `algebraMap (B ⊗[A] B) Tij (b₁ ⊗ₜ b₂)`. -/
lemma tensorAwayEquiv_tmul
    [IsLocalization.Away r Si] [IsLocalization.Away s Sj]
    [IsLocalization.Away ((r ⊗ₜ[A] 1) * (1 ⊗ₜ[A] s) : B ⊗[A] B) Tij] (b₁ b₂ : B) :
    letI := tensorAwayAlgebra A B Si Sj
    tensorAwayEquiv A B r s Si Sj Tij (algebraMap B Si b₁ ⊗ₜ[A] algebraMap B Sj b₂)
      = algebraMap (B ⊗[A] B) Tij (b₁ ⊗ₜ[A] b₂) := by
  letI := tensorAwayAlgebra A B Si Sj
  rw [← tensorAwayEquiv_tensorMap A B r s Si Sj Tij]
  rfl

end IsLocalization.Away
