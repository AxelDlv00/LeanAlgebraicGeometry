---
author: sync
content_type: theorem
created: '2026-07-17T08:41:24'
decl: IsBaseChange.tensorProduct_mk_one
docstring: '**Base change in stages**: if `A''` is the base change of `A` along `R
  → R''`

  (through the algebra map `A → A''`), then for every `A`-module `M` the canonical
  map

  `m ↦ 1 ⊗ₜ m` exhibits `A'' ⊗[A] M` as the base change of `M` along `R → R''`.'
file: AlgebraicJacobian/Cohomology/GluedBaseChangeAlgebra.lean
generated: lean
lean_status: lean_ok
title: IsBaseChange.tensorProduct_mk_one
type: lean
updated: '2026-07-29T15:31:34'
---
theorem IsBaseChange.tensorProduct_mk_one
    (hA : IsBaseChange R' ((IsScalarTower.toAlgHom R A A').toLinearMap)) :
    IsBaseChange R' (((TensorProduct.mk A A' M) 1).restrictScalars R) := by
  apply IsBaseChange.of_lift_unique
  intro Q _ _ _ _ φ
  -- the lift on the first factor: `a' ↦ φ (a • m)` extended through `hA`
  let L : M → A' →ₗ[R'] Q := fun m => hA.lift
    { toFun := fun a => φ (a • m)
      map_add' := fun a b => by rw [add_smul, map_add]
      map_smul' := fun r a => by rw [RingHom.id_apply, smul_assoc, map_smul] }
  have hL : ∀ (m : M) (a : A), L m (algebraMap A A' a) = φ (a • m) := fun m a =>
    hA.lift_eq _ a
  -- additivity in `m`
  have hLadd : ∀ m m' : M, L (m + m') = L m + L m' := by
    intro m m'
    refine hA.algHom_ext _ _ fun a => ?_
    rw [LinearMap.add_apply]
    change L (m + m') (algebraMap A A' a) =
      L m (algebraMap A A' a) + L m' (algebraMap A A' a)
    rw [hL, hL, hL, smul_add, map_add]
  have hLzero : L 0 = 0 := by
    refine hA.algHom_ext _ _ fun a => ?_
    change L 0 (algebraMap A A' a) = (0 : A' →ₗ[R'] Q) (algebraMap A A' a)
    rw [hL, smul_zero, map_zero, LinearMap.zero_apply]
  -- `A`-balancedness in `m`
  have hLbal : ∀ (a₀ : A) (m : M),
      (L m).comp (LinearMap.mulLeft R' (algebraMap A A' a₀)) = L (a₀ • m) := by
    intro a₀ m
    refine hA.algHom_ext _ _ fun a => ?_
    rw [LinearMap.comp_apply, LinearMap.mulLeft_apply]
    change L m (algebraMap A A' a₀ * algebraMap A A' a) = L (a₀ • m) (algebraMap A A' a)
    rw [← map_mul, hL, hL, mul_comm a₀ a, mul_smul]
  -- the balanced biadditive map and its lift to the tensor product
  let F : A' →+ M →+ Q :=
    { toFun := fun a' =>
        { toFun := fun m => L m a'
          map_zero' := by rw [hLzero, LinearMap.zero_apply]
          map_add' := fun m m' => by rw [hLadd, LinearMap.add_apply] }
      map_zero' := by
        ext m
        exact map_zero (L m)
      map_add' := fun a' a'' => by
        ext m
        exact map_add (L m) a' a'' }
  have hFbal : ∀ (a₀ : A) (a' : A') (m : M), F (a₀ • a') m = F a' (a₀ • m) := by
    intro a₀ a' m
    change L m (a₀ • a') = L (a₀ • m) a'
    rw [Algebra.smul_def, ← hLbal a₀ m, LinearMap.comp_apply, LinearMap.mulLeft_apply]
  let ℓ₀ : A' ⊗[A] M →+ Q := TensorProduct.liftAddHom F hFbal
  have hℓ₀ : ∀ (a' : A') (m : M), ℓ₀ (a' ⊗ₜ m) = L m a' := fun a' m => rfl
  -- upgrade to `R'`-linearity
  let ℓ : A' ⊗[A] M →ₗ[R'] Q :=
    { toFun := ℓ₀
      map_add' := ℓ₀.map_add
      map_smul' := by
        intro r' x
        rw [RingHom.id_apply]
        induction x with
        | zero => rw [smul_zero, map_zero, smul_zero]
        | tmul a' m =>
          rw [TensorProduct.smul_tmul', hℓ₀, hℓ₀, map_smul]
        | add a b ha hb => rw [smul_add, map_add, ha, hb, map_add, smul_add] }
  refine ⟨ℓ, ?_, ?_⟩
  · -- the triangle
    refine LinearMap.ext fun m => ?_
    change ℓ₀ ((1 : A') ⊗ₜ m) = φ m
    have h1 : (1 : A') = algebraMap A A' 1 := (map_one _).symm
    rw [hℓ₀, h1, hL, one_smul]
  · -- uniqueness
    rintro ℓ' hℓ'
    have htri : ∀ m : M, ℓ' ((1 : A') ⊗ₜ m) = φ m := fun m =>
      DFunLike.congr_fun hℓ' m
    refine LinearMap.ext fun x => ?_
    induction x with
    | zero => rw [map_zero, map_zero]
    | add a b ha hb => rw [map_add, map_add, ha, hb]
    | tmul a' m =>
      have hmk : ∀ m : M, ℓ ((1 : A') ⊗ₜ m) = φ m := fun m => by
        change ℓ₀ ((1 : A') ⊗ₜ m) = φ m
        have h1 : (1 : A') = algebraMap A A' 1 := (map_one _).symm
        rw [hℓ₀, h1, hL, one_smul]
      induction a' using hA.inductionOn with
      | zero => rw [TensorProduct.zero_tmul, map_zero, map_zero]
      | tmul a =>
        have ha' : (IsScalarTower.toAlgHom R A A').toLinearMap a ⊗ₜ[A] m =
            (1 : A') ⊗ₜ[A] (a • m) := by
          change (algebraMap A A' a) ⊗ₜ[A] m = (1 : A') ⊗ₜ[A] (a • m)
          rw [Algebra.algebraMap_eq_smul_one, TensorProduct.smul_tmul]
        rw [ha', htri, hmk]
      | smul r' a'' ih =>
        rw [← TensorProduct.smul_tmul', map_smul, map_smul, ih]
      | add a'' a''' ih ih' =>
        rw [TensorProduct.add_tmul, map_add, map_add, ih, ih']

end Stage

/-! ## Localization at powers, restricted along an algebra map -/

section Powers

variable {A A' : Type u} [CommRing A] [CommRing A'] [Algebra A A']
variable {P Q : Type u} [AddCommGroup P] [Module A' P] [AddCommGroup Q] [Module A' Q]
variable [Module A P] [Module A Q] [IsScalarTower A A' P] [IsScalarTower A A' Q]