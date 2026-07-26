/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Curve.P1

/-!
# Automorphisms of the projective line: the `GL₂`-twist

Work in progress.
-/

set_option autoImplicit false

universe u

open CategoryTheory

namespace MvPolynomial

section LinearSubstitution

variable {σ : Type*} [Fintype σ] {R : Type*} [CommRing R]

/-- The linear form `∑ⱼ Mᵢⱼ Xⱼ`, the image of `Xᵢ` under the substitution attached to a
square matrix `M`. -/
noncomputable def matrixLinearForm (M : Matrix σ σ R) (i : σ) : MvPolynomial σ R :=
  ∑ j, M i j • X j

/-- The linear forms attached to a matrix are homogeneous of degree one. -/
theorem matrixLinearForm_mem (M : Matrix σ σ R) (i : σ) :
    matrixLinearForm M i ∈ homogeneousSubmodule σ R 1 :=
  Submodule.sum_mem _ fun j _ =>
    Submodule.smul_mem _ _ (X_mem_homogeneousSubmodule_one R j)

/-- The `R`-algebra endomorphism of `R[Xᵢ]` given by the linear substitution
`Xᵢ ↦ ∑ⱼ Mᵢⱼ Xⱼ`. -/
noncomputable def substAlgHom (M : Matrix σ σ R) :
    MvPolynomial σ R →ₐ[R] MvPolynomial σ R :=
  aeval (matrixLinearForm M)

@[simp]
theorem substAlgHom_X (M : Matrix σ σ R) (i : σ) :
    substAlgHom M (X i) = matrixLinearForm M i :=
  aeval_X _ _

/-- A linear substitution preserves the degree of a homogeneous polynomial. -/
theorem substAlgHom_mem (M : Matrix σ σ R) {d : ℕ} {p : MvPolynomial σ R}
    (hp : p ∈ homogeneousSubmodule σ R d) :
    substAlgHom M p ∈ homogeneousSubmodule σ R d := by
  rw [mem_homogeneousSubmodule] at hp ⊢
  have h := hp.aeval (matrixLinearForm M)
    (fun i => (mem_homogeneousSubmodule _ _).mp (matrixLinearForm_mem M i))
  rwa [one_mul] at h

/-- The linear substitution attached to a matrix, as a *graded* ring endomorphism of
`R[Xᵢ]` for the standard degree grading. -/
noncomputable def substGradedHom (M : Matrix σ σ R) :
    homogeneousSubmodule σ R →+*ᵍ homogeneousSubmodule σ R where
  __ := (substAlgHom M).toRingHom
  map_mem := substAlgHom_mem M

@[simp]
theorem substGradedHom_apply (M : Matrix σ σ R) (p : MvPolynomial σ R) :
    substGradedHom M p = substAlgHom M p :=
  rfl

/-- The substitution attached to a product of matrices is the composite of the substitutions,
in the *reverse* order: `subst (M * N) = subst N ∘ subst M`. -/
theorem substAlgHom_mul (M N : Matrix σ σ R) :
    substAlgHom (M * N) = (substAlgHom N).comp (substAlgHom M) := by
  refine algHom_ext fun i => ?_
  rw [substAlgHom_X, AlgHom.comp_apply, substAlgHom_X, matrixLinearForm, matrixLinearForm,
    map_sum]
  simp_rw [map_smul, substAlgHom_X, matrixLinearForm, Matrix.mul_apply, Finset.sum_smul,
    Finset.smul_sum, smul_smul]
  exact Finset.sum_comm

/-- The substitution attached to a product of matrices, as graded ring homs. -/
theorem substGradedHom_mul (M N : Matrix σ σ R) :
    substGradedHom (M * N) = (substGradedHom N).comp (substGradedHom M) :=
  GradedRingHom.ext fun p => DFunLike.congr_fun (substAlgHom_mul M N) p

section DecEq

variable [DecidableEq σ]

/-- The identity matrix induces the identity substitution. -/
@[simp]
theorem substAlgHom_one : substAlgHom (1 : Matrix σ σ R) = AlgHom.id R (MvPolynomial σ R) := by
  refine algHom_ext fun i => ?_
  rw [substAlgHom_X, AlgHom.id_apply, matrixLinearForm]
  simp [Matrix.one_apply, ite_smul]

/-- The identity matrix induces the identity graded ring hom. -/
@[simp]
theorem substGradedHom_one :
    substGradedHom (1 : Matrix σ σ R) = GradedRingHom.id (homogeneousSubmodule σ R) :=
  GradedRingHom.ext fun p => DFunLike.congr_fun (substAlgHom_one (σ := σ) (R := R)) p

end DecEq

end LinearSubstitution

end MvPolynomial

namespace AlgebraicGeometry

open HomogeneousIdeal MvPolynomial Graded

section IrrelevantLe

variable {A B σ τ : Type*} [CommRing A] [SetLike σ A] [AddSubgroupClass σ A]
  [CommRing B] [SetLike τ B] [AddSubgroupClass τ B]
  {𝒜 : ℕ → σ} {ℬ : ℕ → τ} [GradedRing 𝒜] [GradedRing ℬ]

/-- A graded ring hom admitting a graded set-theoretic section satisfies the hypothesis
`ℬ₊ ≤ 𝒜₊.map f` needed to form `Proj.map f`. Indeed a positive-degree element `x` of `ℬ`
is `f (g x)`, and `g x` is again of positive degree, hence irrelevant. -/
theorem irrelevant_le_map_of_rightInverse (f : 𝒜 →+*ᵍ ℬ) (g : ℬ →+*ᵍ 𝒜)
    (h : ∀ x, f (g x) = x) : ℬ₊ ≤ 𝒜₊.map f := by
  rw [HomogeneousIdeal.irrelevant_le]
  intro i hi x hx
  have hgx : g x ∈ 𝒜₊ := HomogeneousIdeal.mem_irrelevant_of_mem 𝒜 hi (map_mem g hx)
  have hmem : f (g x) ∈ (𝒜₊.map f).toIdeal :=
    Ideal.mem_map_of_mem (f : A →+* B) hgx
  rw [h x] at hmem
  exact hmem

end IrrelevantLe

section MapCongr

variable {A B σ τ : Type u} [CommRing A] [SetLike σ A] [AddSubgroupClass σ A]
  [CommRing B] [SetLike τ B] [AddSubgroupClass τ B]
  {𝒜 : ℕ → σ} {ℬ : ℕ → τ} [GradedRing 𝒜] [GradedRing ℬ]

/-- `Proj.map` only depends on the graded ring hom, not on the proof of its hypothesis. -/
theorem Proj.map_congr {f g : 𝒜 →+*ᵍ ℬ} (h : f = g) (hf : ℬ₊ ≤ 𝒜₊.map f)
    (hg : ℬ₊ ≤ 𝒜₊.map g) : Proj.map f hf = Proj.map g hg := by
  subst h; rfl

end MapCongr

namespace P1

variable (k : Type u) [Field k]

local notation "𝒜" => homogeneousSubmodule (Fin 2) k

/-- Notation-free shorthand for the coefficient matrix of `M ∈ GL₂(k)`. -/
local notation "mat" M => ((M : Matrix.GeneralLinearGroup (Fin 2) k) :
  Matrix (Fin 2) (Fin 2) k)

/-- The substitution attached to an invertible matrix satisfies the hypothesis of `Proj.map`:
its inverse substitution is a two-sided inverse. -/
theorem irrelevant_le_map_substGradedHom (M : Matrix.GeneralLinearGroup (Fin 2) k) :
    𝒜₊ ≤ 𝒜₊.map (substGradedHom (mat M)) := by
  refine irrelevant_le_map_of_rightInverse _ (substGradedHom (mat M⁻¹)) fun x => ?_
  have h : substGradedHom ((mat M⁻¹) * (mat M)) =
      (substGradedHom (mat M)).comp (substGradedHom (mat M⁻¹)) := substGradedHom_mul _ _
  rw [← Units.val_mul, inv_mul_cancel, Units.val_one, substGradedHom_one] at h
  exact DFunLike.congr_fun h.symm x

/-- **The `GL₂(k)`-twist of the projective line.** The linear substitution
`Xᵢ ↦ ∑ⱼ Mᵢⱼ Xⱼ` attached to `M ∈ GL₂(k)` induces, via functoriality of `Proj`, an
automorphism of `P¹_k`. -/
noncomputable def autOfMatrix (M : Matrix.GeneralLinearGroup (Fin 2) k) : P1 k ⟶ P1 k :=
  Proj.map (substGradedHom (mat M)) (irrelevant_le_map_substGradedHom k M)

@[simp]
theorem autOfMatrix_one : autOfMatrix k 1 = 𝟙 (P1 k) := by
  refine Eq.trans (Proj.map_congr (g := GradedRingHom.id 𝒜) ?_ _ (by simp)) Proj.map_id
  rw [Units.val_one, substGradedHom_one]

/-- Functoriality. `Proj.map` is contravariant, so `M ↦ autOfMatrix M` is an
**anti**-homomorphism for composition of morphisms: `γ_{MN} = γ_N ≫ γ_M`.
(Equivalently, it *is* a homomorphism into `Aut (P1 k)`, whose multiplication is
`(f * g).hom = g.hom ≫ f.hom`; see `P1.autMonoidHom`.) -/
theorem autOfMatrix_mul (M N : Matrix.GeneralLinearGroup (Fin 2) k) :
    autOfMatrix k (M * N) = autOfMatrix k N ≫ autOfMatrix k M := by
  have h := Proj.map_comp (substGradedHom (mat M)) (substGradedHom (mat N))
    (irrelevant_le_map_substGradedHom k M) (irrelevant_le_map_substGradedHom k N)
  refine Eq.trans (Proj.map_congr ?_ _ _) h
  rw [Units.val_mul, substGradedHom_mul]

/-- The `GL₂(k)`-twist as an isomorphism of schemes, with inverse the twist by `M⁻¹`. -/
@[simps]
noncomputable def autIsoOfMatrix (M : Matrix.GeneralLinearGroup (Fin 2) k) : P1 k ≅ P1 k where
  hom := autOfMatrix k M
  inv := autOfMatrix k M⁻¹
  hom_inv_id := by rw [← autOfMatrix_mul, inv_mul_cancel, autOfMatrix_one]
  inv_hom_id := by rw [← autOfMatrix_mul, mul_inv_cancel, autOfMatrix_one]

instance isIso_autOfMatrix (M : Matrix.GeneralLinearGroup (Fin 2) k) :
    IsIso (autOfMatrix k M) :=
  (autIsoOfMatrix k M).isIso_hom

/-- The action of `GL₂(k)` on `P¹_k` by scheme automorphisms, as a group homomorphism
`GL₂(k) →* Aut (P¹_k)`. -/
@[simps]
noncomputable def autMonoidHom : Matrix.GeneralLinearGroup (Fin 2) k →* Aut (P1 k) where
  toFun := autIsoOfMatrix k
  map_one' := Iso.ext (autOfMatrix_one k)
  map_mul' M N := Iso.ext (autOfMatrix_mul k M N)

end P1

end AlgebraicGeometry
