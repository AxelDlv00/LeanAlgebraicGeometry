/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib.RingTheory.TensorProduct.Maps

/-!
# Scalar extension of tensor-product pushouts

This file gives the canonical equivalence expressing that scalar extension commutes with
a pushout of commutative algebras.  The explicit homomorphisms and pure-tensor formulas
make the equivalence usable without relying on definitional choices of `Algebra` instances.
-/

set_option autoImplicit false

open scoped TensorProduct

universe u

namespace AlgebraicJacobian

noncomputable section

/-- The canonical map on scalar extensions induced by an algebra map in a scalar tower. -/
def scalarExtensionMap {M K A B : Type u}
    [CommRing M] [CommRing K] [CommRing A] [CommRing B]
    [Algebra M K] [Algebra M A] [Algebra M B] [Algebra A B]
    [IsScalarTower M A B] :
    (K ⊗[M] A) →ₐ[K] (K ⊗[M] B) :=
  Algebra.TensorProduct.map (AlgHom.id K K) (IsScalarTower.toAlgHom M A B)

/-- The forward map distributing scalar extension over a tensor-product pushout. -/
def tensorProductPushoutBaseChangeHom {M K A B₁ B₂ : Type u}
    [CommRing M] [CommRing K] [CommRing A] [CommRing B₁] [CommRing B₂]
    [Algebra M K] [Algebra M A]
    [Algebra A B₁] [Algebra A B₂]
    [Algebra M B₁] [Algebra M B₂]
    [IsScalarTower M A B₁] [IsScalarTower M A B₂] :
    let f₁ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₁)
    let f₂ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₂)
    letI : Algebra (K ⊗[M] A) (K ⊗[M] B₁) := f₁.toRingHom.toAlgebra
    letI : Algebra (K ⊗[M] A) (K ⊗[M] B₂) := f₂.toRingHom.toAlgebra
    (K ⊗[M] (B₁ ⊗[A] B₂)) →ₐ[K]
      ((K ⊗[M] B₁) ⊗[K ⊗[M] A] (K ⊗[M] B₂)) := by
  dsimp only
  let f₁ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₁)
  let f₂ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₂)
  letI : Algebra (K ⊗[M] A) (K ⊗[M] B₁) := f₁.toRingHom.toAlgebra
  letI : Algebra (K ⊗[M] A) (K ⊗[M] B₂) := f₂.toRingHom.toAlgebra
  let R := (K ⊗[M] B₁) ⊗[K ⊗[M] A] (K ⊗[M] B₂)
  let leftIncl : (K ⊗[M] B₁) →ₐ[K] R :=
    Algebra.TensorProduct.includeLeft
  let rightIncl : (K ⊗[M] B₂) →ₐ[K] R :=
    Algebra.TensorProduct.includeRight.restrictScalars K
  let b₁InclM : B₁ →ₐ[M] R :=
    (leftIncl.restrictScalars M).comp Algebra.TensorProduct.includeRight
  let b₂InclM : B₂ →ₐ[M] R :=
    (rightIncl.restrictScalars M).comp Algebra.TensorProduct.includeRight
  letI : Algebra A R :=
    (b₁InclM.toRingHom.comp (algebraMap A B₁)).toAlgebra
  letI : Algebra B₁ R := b₁InclM.toRingHom.toAlgebra
  letI : Algebra B₂ R := b₂InclM.toRingHom.toAlgebra
  haveI : IsScalarTower A B₁ R :=
    IsScalarTower.of_algebraMap_eq (fun _ => rfl)
  have hB₂ : b₂InclM.toRingHom.comp (algebraMap A B₂) =
      algebraMap A R := by
    ext a
    change 1 ⊗ₜ[K ⊗[M] A] (1 ⊗ₜ[M] (algebraMap A B₂) a) =
      (1 ⊗ₜ[M] (algebraMap A B₁) a) ⊗ₜ[K ⊗[M] A] 1
    have hf₁ : f₁ (1 ⊗ₜ[M] a) = 1 ⊗ₜ[M] (algebraMap A B₁) a := by
      simp [f₁, scalarExtensionMap]
    have hf₂ : f₂ (1 ⊗ₜ[M] a) = 1 ⊗ₜ[M] (algebraMap A B₂) a := by
      simp [f₂, scalarExtensionMap]
    rw [← hf₁, ← hf₂]
    exact (Algebra.TensorProduct.tmul_one_eq_one_tmul
      (R := K ⊗[M] A) (A := K ⊗[M] B₁) (B := K ⊗[M] B₂)
      (1 ⊗ₜ[M] a)).symm
  haveI : IsScalarTower A B₂ R :=
    IsScalarTower.of_algebraMap_eq
      (fun a => (DFunLike.congr_fun hB₂ a).symm)
  haveI : IsScalarTower M B₁ R :=
    IsScalarTower.of_algebraMap_eq
      (fun m => (b₁InclM.commutes m).symm)
  haveI : IsScalarTower M A R :=
    IsScalarTower.of_algebraMap_eq (fun m => by
      calc
        (algebraMap M R) m =
            (algebraMap B₁ R) ((algebraMap M B₁) m) :=
          IsScalarTower.algebraMap_apply M B₁ R m
        _ = (algebraMap B₁ R) ((algebraMap A B₁) ((algebraMap M A) m)) := by
          rw [← IsScalarTower.algebraMap_apply M A B₁ m]
        _ = (algebraMap A R) ((algebraMap M A) m) :=
          (IsScalarTower.algebraMap_apply A B₁ R _).symm)
  let inner : (B₁ ⊗[A] B₂) →ₐ[A] R :=
    Algebra.TensorProduct.lift
      (IsScalarTower.toAlgHom A B₁ R)
      (IsScalarTower.toAlgHom A B₂ R)
      (fun _ _ => Commute.all _ _)
  exact AlgHom.liftEquiv M K (B₁ ⊗[A] B₂) R (inner.restrictScalars M)

/-- The inverse map collecting a tensor product of scalar extensions into one scalar
extension of the pushout. -/
def tensorProductPushoutBaseChangeInvHom {M K A B₁ B₂ : Type u}
    [CommRing M] [CommRing K] [CommRing A] [CommRing B₁] [CommRing B₂]
    [Algebra M K] [Algebra M A]
    [Algebra A B₁] [Algebra A B₂]
    [Algebra M B₁] [Algebra M B₂]
    [IsScalarTower M A B₁] [IsScalarTower M A B₂] :
    let f₁ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₁)
    let f₂ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₂)
    letI : Algebra (K ⊗[M] A) (K ⊗[M] B₁) := f₁.toRingHom.toAlgebra
    letI : Algebra (K ⊗[M] A) (K ⊗[M] B₂) := f₂.toRingHom.toAlgebra
    ((K ⊗[M] B₁) ⊗[K ⊗[M] A] (K ⊗[M] B₂)) →ₐ[K]
      (K ⊗[M] (B₁ ⊗[A] B₂)) := by
  dsimp only
  let f₁ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₁)
  let f₂ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₂)
  letI : Algebra (K ⊗[M] A) (K ⊗[M] B₁) := f₁.toRingHom.toAlgebra
  letI : Algebra (K ⊗[M] A) (K ⊗[M] B₂) := f₂.toRingHom.toAlgebra
  let P := K ⊗[M] A
  let X₁ := K ⊗[M] B₁
  let X₂ := K ⊗[M] B₂
  let Q := B₁ ⊗[A] B₂
  let L := K ⊗[M] Q
  let q₁ : B₁ →ₐ[A] Q := Algebra.TensorProduct.includeLeft
  let q₂ : B₂ →ₐ[A] Q := Algebra.TensorProduct.includeRight
  let q₁M : B₁ →ₐ[M] Q := q₁.restrictScalars M
  let q₂M : B₂ →ₐ[M] Q := q₂.restrictScalars M
  let b₁L : B₁ →ₐ[M] L := Algebra.TensorProduct.includeRight.comp q₁M
  let b₂L : B₂ →ₐ[M] L := Algebra.TensorProduct.includeRight.comp q₂M
  let aL : A →ₐ[M] L := b₁L.comp (IsScalarTower.toAlgHom M A B₁)
  let pL : P →ₐ[K] L := AlgHom.liftEquiv M K A L aL
  let x₁L : X₁ →ₐ[K] L := AlgHom.liftEquiv M K B₁ L b₁L
  let x₂L : X₂ →ₐ[K] L := AlgHom.liftEquiv M K B₂ L b₂L
  letI : Algebra P L := pL.toRingHom.toAlgebra
  letI : Algebra X₁ L := x₁L.toRingHom.toAlgebra
  letI : Algebra X₂ L := x₂L.toRingHom.toAlgebra
  have hp₁ : x₁L.comp f₁ = pL := by
    apply DFunLike.ext _ _
    intro z
    induction z using TensorProduct.induction_on with
    | zero => simp
    | tmul k a =>
        change x₁L (f₁ (k ⊗ₜ[M] a)) = pL (k ⊗ₜ[M] a)
        rw [show f₁ (k ⊗ₜ[M] a) = k ⊗ₜ[M] (algebraMap A B₁) a by
          simp [f₁, scalarExtensionMap]]
        rw [AlgHom.liftEquiv_tmul, AlgHom.liftEquiv_tmul]
        rfl
    | add x y hx hy =>
        change x₁L (f₁ x) = pL x at hx
        change x₁L (f₁ y) = pL y at hy
        change x₁L (f₁ (x + y)) = pL (x + y)
        rw [map_add, map_add, map_add, hx, hy]
  have hp₂ : x₂L.comp f₂ = pL := by
    apply DFunLike.ext _ _
    intro z
    induction z using TensorProduct.induction_on with
    | zero => simp
    | tmul k a =>
        change x₂L (f₂ (k ⊗ₜ[M] a)) = pL (k ⊗ₜ[M] a)
        rw [show f₂ (k ⊗ₜ[M] a) = k ⊗ₜ[M] (algebraMap A B₂) a by
          simp [f₂, scalarExtensionMap]]
        rw [AlgHom.liftEquiv_tmul, AlgHom.liftEquiv_tmul]
        apply congrArg (k • ·)
        change 1 ⊗ₜ[M] (1 ⊗ₜ[A] (algebraMap A B₂) a) =
          1 ⊗ₜ[M] ((algebraMap A B₁) a ⊗ₜ[A] 1)
        apply congrArg (fun q : Q => (1 : K) ⊗ₜ[M] q)
        exact (Algebra.TensorProduct.tmul_one_eq_one_tmul
          (R := A) (A := B₁) (B := B₂) a).symm
    | add x y hx hy =>
        change x₂L (f₂ x) = pL x at hx
        change x₂L (f₂ y) = pL y at hy
        change x₂L (f₂ (x + y)) = pL (x + y)
        rw [map_add, map_add, map_add, hx, hy]
  haveI : IsScalarTower P X₁ L :=
    IsScalarTower.of_algebraMap_eq
      (fun z => (DFunLike.congr_fun hp₁ z).symm)
  haveI : IsScalarTower P X₂ L :=
    IsScalarTower.of_algebraMap_eq
      (fun z => (DFunLike.congr_fun hp₂ z).symm)
  haveI : IsScalarTower K P L :=
    IsScalarTower.of_algebraMap_eq
      (fun k => (pL.commutes k).symm)
  exact (Algebra.TensorProduct.lift
    (IsScalarTower.toAlgHom P X₁ L)
    (IsScalarTower.toAlgHom P X₂ L)
    (fun _ _ => Commute.all _ _)).restrictScalars K

/-- The forward base-change map on a pure tensor. -/
theorem tensorProductPushoutBaseChangeHom_tmul {M K A B₁ B₂ : Type u}
    [CommRing M] [CommRing K] [CommRing A] [CommRing B₁] [CommRing B₂]
    [Algebra M K] [Algebra M A]
    [Algebra A B₁] [Algebra A B₂]
    [Algebra M B₁] [Algebra M B₂]
    [IsScalarTower M A B₁] [IsScalarTower M A B₂]
    (k : K) (b₁ : B₁) (b₂ : B₂) :
    let f₁ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₁)
    let f₂ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₂)
    letI : Algebra (K ⊗[M] A) (K ⊗[M] B₁) := f₁.toRingHom.toAlgebra
    letI : Algebra (K ⊗[M] A) (K ⊗[M] B₂) := f₂.toRingHom.toAlgebra
    tensorProductPushoutBaseChangeHom
        (M := M) (K := K) (A := A) (B₁ := B₁) (B₂ := B₂)
        (k ⊗ₜ[M] (b₁ ⊗ₜ[A] b₂)) =
      (k ⊗ₜ[M] b₁) ⊗ₜ[K ⊗[M] A] (1 ⊗ₜ[M] b₂) := by
  dsimp only
  let f₁ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₁)
  let f₂ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₂)
  letI : Algebra (K ⊗[M] A) (K ⊗[M] B₁) := f₁.toRingHom.toAlgebra
  letI : Algebra (K ⊗[M] A) (K ⊗[M] B₂) := f₂.toRingHom.toAlgebra
  simp only [tensorProductPushoutBaseChangeHom, Lean.Elab.WF.paramLet,
    AlgHom.toRingHom_eq_coe, id_eq, AlgHom.liftEquiv_tmul,
    AlgHom.coe_restrictScalars', Algebra.TensorProduct.lift_tmul,
    IsScalarTower.coe_toAlgHom']
  change k • ((((1 : K) ⊗ₜ[M] b₁) ⊗ₜ[K ⊗[M] A]
        (1 : K ⊗[M] B₂)) *
      ((1 : K ⊗[M] B₁) ⊗ₜ[K ⊗[M] A] ((1 : K) ⊗ₜ[M] b₂))) = _
  simp only [Algebra.TensorProduct.tmul_mul_tmul, one_mul, mul_one]
  rw [TensorProduct.smul_tmul']
  congr 1
  rw [TensorProduct.smul_tmul']
  simp

/-- The inverse base-change map on pure tensors. -/
theorem tensorProductPushoutBaseChangeInvHom_tmul {M K A B₁ B₂ : Type u}
    [CommRing M] [CommRing K] [CommRing A] [CommRing B₁] [CommRing B₂]
    [Algebra M K] [Algebra M A]
    [Algebra A B₁] [Algebra A B₂]
    [Algebra M B₁] [Algebra M B₂]
    [IsScalarTower M A B₁] [IsScalarTower M A B₂]
    (k₁ k₂ : K) (b₁ : B₁) (b₂ : B₂) :
    let f₁ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₁)
    let f₂ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₂)
    letI : Algebra (K ⊗[M] A) (K ⊗[M] B₁) := f₁.toRingHom.toAlgebra
    letI : Algebra (K ⊗[M] A) (K ⊗[M] B₂) := f₂.toRingHom.toAlgebra
    tensorProductPushoutBaseChangeInvHom
        (M := M) (K := K) (A := A) (B₁ := B₁) (B₂ := B₂)
        ((k₁ ⊗ₜ[M] b₁) ⊗ₜ[K ⊗[M] A] (k₂ ⊗ₜ[M] b₂)) =
      (k₁ * k₂) ⊗ₜ[M] (b₁ ⊗ₜ[A] b₂) := by
  dsimp only
  let f₁ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₁)
  let f₂ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₂)
  letI : Algebra (K ⊗[M] A) (K ⊗[M] B₁) := f₁.toRingHom.toAlgebra
  letI : Algebra (K ⊗[M] A) (K ⊗[M] B₂) := f₂.toRingHom.toAlgebra
  simp only [tensorProductPushoutBaseChangeInvHom, Lean.Elab.WF.paramLet,
    AlgHom.toRingHom_eq_coe, id_eq, AlgHom.coe_restrictScalars']
  change (k₁ • ((1 : K) ⊗ₜ[M] (b₁ ⊗ₜ[A] 1))) *
      (k₂ • ((1 : K) ⊗ₜ[M] (1 ⊗ₜ[A] b₂))) = _
  rw [TensorProduct.smul_tmul', TensorProduct.smul_tmul']
  simp

/-- Scalar extension commutes with a tensor-product pushout of commutative algebras. -/
def tensorProductPushoutBaseChange {M K A B₁ B₂ : Type u}
    [CommRing M] [CommRing K] [CommRing A] [CommRing B₁] [CommRing B₂]
    [Algebra M K] [Algebra M A]
    [Algebra A B₁] [Algebra A B₂]
    [Algebra M B₁] [Algebra M B₂]
    [IsScalarTower M A B₁] [IsScalarTower M A B₂] :
    let f₁ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₁)
    let f₂ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₂)
    letI : Algebra (K ⊗[M] A) (K ⊗[M] B₁) := f₁.toRingHom.toAlgebra
    letI : Algebra (K ⊗[M] A) (K ⊗[M] B₂) := f₂.toRingHom.toAlgebra
    (K ⊗[M] (B₁ ⊗[A] B₂)) ≃ₐ[K]
      ((K ⊗[M] B₁) ⊗[K ⊗[M] A] (K ⊗[M] B₂)) := by
  dsimp only
  let f₁ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₁)
  let f₂ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₂)
  letI : Algebra (K ⊗[M] A) (K ⊗[M] B₁) := f₁.toRingHom.toAlgebra
  letI : Algebra (K ⊗[M] A) (K ⊗[M] B₂) := f₂.toRingHom.toAlgebra
  let forward := tensorProductPushoutBaseChangeHom
    (M := M) (K := K) (A := A) (B₁ := B₁) (B₂ := B₂)
  let inverse := tensorProductPushoutBaseChangeInvHom
    (M := M) (K := K) (A := A) (B₁ := B₁) (B₂ := B₂)
  apply AlgEquiv.ofAlgHom forward inverse
  · apply DFunLike.ext _ _
    intro z
    induction z using TensorProduct.induction_on with
    | zero => simp
    | tmul x₁ x₂ =>
        induction x₁ using TensorProduct.induction_on with
        | zero => simp
        | tmul k₁ b₁ =>
            induction x₂ using TensorProduct.induction_on with
            | zero => simp
            | tmul k₂ b₂ =>
                change forward (inverse
                    ((k₁ ⊗ₜ[M] b₁) ⊗ₜ[K ⊗[M] A] (k₂ ⊗ₜ[M] b₂))) = _
                rw [tensorProductPushoutBaseChangeInvHom_tmul,
                  tensorProductPushoutBaseChangeHom_tmul]
                change ((k₁ * k₂) ⊗ₜ[M] b₁) ⊗ₜ[K ⊗[M] A]
                    (1 ⊗ₜ[M] b₂) =
                  (k₁ ⊗ₜ[M] b₁) ⊗ₜ[K ⊗[M] A] (k₂ ⊗ₜ[M] b₂)
                have hk₂ : k₂ ⊗ₜ[M] b₂ = k₂ • ((1 : K) ⊗ₜ[M] b₂) := by
                  rw [TensorProduct.smul_tmul']
                  simp
                rw [hk₂, TensorProduct.tmul_smul, TensorProduct.smul_tmul']
                apply congrArg (fun x : K ⊗[M] B₁ =>
                  x ⊗ₜ[K ⊗[M] A] ((1 : K) ⊗ₜ[M] b₂))
                apply congrArg (fun c : K => c ⊗ₜ[M] b₁)
                simpa [smul_eq_mul] using (mul_comm k₁ k₂)
            | add x y hx hy =>
                change forward (inverse
                    ((k₁ ⊗ₜ[M] b₁) ⊗ₜ[K ⊗[M] A] x)) = _ at hx
                change forward (inverse
                    ((k₁ ⊗ₜ[M] b₁) ⊗ₜ[K ⊗[M] A] y)) = _ at hy
                change forward (inverse
                    ((k₁ ⊗ₜ[M] b₁) ⊗ₜ[K ⊗[M] A] (x + y))) = _
                rw [TensorProduct.tmul_add, map_add, map_add, map_add, hx, hy]
        | add x y hx hy =>
            change forward (inverse (x ⊗ₜ[K ⊗[M] A] x₂)) = _ at hx
            change forward (inverse (y ⊗ₜ[K ⊗[M] A] x₂)) = _ at hy
            change forward (inverse ((x + y) ⊗ₜ[K ⊗[M] A] x₂)) = _
            rw [TensorProduct.add_tmul, map_add, map_add, map_add, hx, hy]
    | add x y hx hy =>
        change forward (inverse x) = _ at hx
        change forward (inverse y) = _ at hy
        change forward (inverse (x + y)) = _
        rw [map_add, map_add, map_add, hx, hy]
  · apply DFunLike.ext _ _
    intro z
    induction z using TensorProduct.induction_on with
    | zero => simp
    | tmul k q =>
        induction q using TensorProduct.induction_on with
        | zero => simp
        | tmul b₁ b₂ =>
            change inverse (forward (k ⊗ₜ[M] (b₁ ⊗ₜ[A] b₂))) = _
            rw [tensorProductPushoutBaseChangeHom_tmul,
              tensorProductPushoutBaseChangeInvHom_tmul]
            simp
        | add x y hx hy =>
            change inverse (forward (k ⊗ₜ[M] x)) = _ at hx
            change inverse (forward (k ⊗ₜ[M] y)) = _ at hy
            change inverse (forward (k ⊗ₜ[M] (x + y))) = _
            rw [TensorProduct.tmul_add, map_add, map_add, map_add, hx, hy]
    | add x y hx hy =>
        change inverse (forward x) = _ at hx
        change inverse (forward y) = _ at hy
        change inverse (forward (x + y)) = _
        rw [map_add, map_add, map_add, hx, hy]

/-- The base-change equivalence on a pure tensor. -/
theorem tensorProductPushoutBaseChange_tmul {M K A B₁ B₂ : Type u}
    [CommRing M] [CommRing K] [CommRing A] [CommRing B₁] [CommRing B₂]
    [Algebra M K] [Algebra M A]
    [Algebra A B₁] [Algebra A B₂]
    [Algebra M B₁] [Algebra M B₂]
    [IsScalarTower M A B₁] [IsScalarTower M A B₂]
    (k : K) (b₁ : B₁) (b₂ : B₂) :
    let f₁ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₁)
    let f₂ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₂)
    letI : Algebra (K ⊗[M] A) (K ⊗[M] B₁) := f₁.toRingHom.toAlgebra
    letI : Algebra (K ⊗[M] A) (K ⊗[M] B₂) := f₂.toRingHom.toAlgebra
    tensorProductPushoutBaseChange
        (M := M) (K := K) (A := A) (B₁ := B₁) (B₂ := B₂)
        (k ⊗ₜ[M] (b₁ ⊗ₜ[A] b₂)) =
      (k ⊗ₜ[M] b₁) ⊗ₜ[K ⊗[M] A] (1 ⊗ₜ[M] b₂) := by
  dsimp only
  let f₁ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₁)
  let f₂ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₂)
  letI : Algebra (K ⊗[M] A) (K ⊗[M] B₁) := f₁.toRingHom.toAlgebra
  letI : Algebra (K ⊗[M] A) (K ⊗[M] B₂) := f₂.toRingHom.toAlgebra
  change tensorProductPushoutBaseChangeHom
      (M := M) (K := K) (A := A) (B₁ := B₁) (B₂ := B₂)
      (k ⊗ₜ[M] (b₁ ⊗ₜ[A] b₂)) = _
  exact tensorProductPushoutBaseChangeHom_tmul k b₁ b₂

/-- The inverse base-change equivalence on pure tensors. -/
theorem tensorProductPushoutBaseChange_symm_tmul {M K A B₁ B₂ : Type u}
    [CommRing M] [CommRing K] [CommRing A] [CommRing B₁] [CommRing B₂]
    [Algebra M K] [Algebra M A]
    [Algebra A B₁] [Algebra A B₂]
    [Algebra M B₁] [Algebra M B₂]
    [IsScalarTower M A B₁] [IsScalarTower M A B₂]
    (k₁ k₂ : K) (b₁ : B₁) (b₂ : B₂) :
    let f₁ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₁)
    let f₂ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₂)
    letI : Algebra (K ⊗[M] A) (K ⊗[M] B₁) := f₁.toRingHom.toAlgebra
    letI : Algebra (K ⊗[M] A) (K ⊗[M] B₂) := f₂.toRingHom.toAlgebra
    (tensorProductPushoutBaseChange
        (M := M) (K := K) (A := A) (B₁ := B₁) (B₂ := B₂)).symm
        ((k₁ ⊗ₜ[M] b₁) ⊗ₜ[K ⊗[M] A] (k₂ ⊗ₜ[M] b₂)) =
      (k₁ * k₂) ⊗ₜ[M] (b₁ ⊗ₜ[A] b₂) := by
  dsimp only
  let f₁ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₁)
  let f₂ := scalarExtensionMap (M := M) (K := K) (A := A) (B := B₂)
  letI : Algebra (K ⊗[M] A) (K ⊗[M] B₁) := f₁.toRingHom.toAlgebra
  letI : Algebra (K ⊗[M] A) (K ⊗[M] B₂) := f₂.toRingHom.toAlgebra
  change tensorProductPushoutBaseChangeInvHom
      (M := M) (K := K) (A := A) (B₁ := B₁) (B₂ := B₂)
      ((k₁ ⊗ₜ[M] b₁) ⊗ₜ[K ⊗[M] A] (k₂ ⊗ₜ[M] b₂)) = _
  exact tensorProductPushoutBaseChangeInvHom_tmul k₁ k₂ b₁ b₂

end

end AlgebraicJacobian
