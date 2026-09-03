/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import Mathlib.Algebra.Module.LocalizedModule.Exact
import Mathlib.Algebra.Module.LocalizedModule.Submodule
import Mathlib.RingTheory.Localization.Finiteness
import Mathlib.RingTheory.Localization.BaseChange

/-!
# Localization of modules

The Stacks Project's localization chapter uses the localization of modules as
an exact functor.  This module exposes the corresponding Mathlib API under the
project namespace, together with the canonical-map identities used in the
universal-property arguments.
-/

namespace StacksPart01

open Function IsLocalizedModule
open scoped TensorProduct

variable {R : Type*} [CommSemiring R]

/-!
The canonical tensor description of a localized module is the formulation used
in Stacks, Tag 00DK.  Mathlib provides the inverse orientation (from the
localized module to the tensor product); the wrapper below presents the map in
the direction used by the source.
-/
noncomputable def tensorLocalizationEquiv
    (S : Submonoid R) (M : Type*) [AddCommMonoid M] [Module R M] :
    Localization S ⊗[R] M ≃ₗ[Localization S] LocalizedModule S M :=
  (LocalizedModule.equivTensorProduct S M).symm

/- The map sends a fraction tensor to the corresponding localized numerator. -/
@[simp]
theorem tensorLocalizationEquiv_tmul
    (S : Submonoid R) (M : Type*) [AddCommMonoid M] [Module R M]
    (r : R) (s : S) (m : M) :
    tensorLocalizationEquiv S M (Localization.mk r s ⊗ₜ[R] m) =
      r • LocalizedModule.mk m s := by
  exact LocalizedModule.equivTensorProduct_symm_apply_tmul S m r s

@[simp]
theorem tensorLocalizationEquiv_one_tmul
    (S : Submonoid R) (M : Type*) [AddCommMonoid M] [Module R M]
    (m : M) :
    tensorLocalizationEquiv S M (1 ⊗ₜ[R] m) = LocalizedModule.mk m 1 := by
  exact LocalizedModule.equivTensorProduct_symm_apply_tmul_one S m

/-!
The canonical localization map sends an element to the fraction with
denominator `1`, and the localized map agrees with it on such elements.
-/
@[simp]
theorem localizedModule_map_mk (S : Submonoid R) {M N : Type*}
    [AddCommMonoid M] [AddCommMonoid N] [Module R M] [Module R N]
    (g : M →ₗ[R] N) (m : M) :
    IsLocalizedModule.map S (LocalizedModule.mkLinearMap S M)
        (LocalizedModule.mkLinearMap S N) g
        (LocalizedModule.mkLinearMap S M m) =
      LocalizedModule.mkLinearMap S N (g m) := by
  exact IsLocalizedModule.map_apply S (LocalizedModule.mkLinearMap S M)
    (LocalizedModule.mkLinearMap S N) g m

/-!
Localization preserves composition of module maps.
-/
theorem localizedModule_map_comp (S : Submonoid R)
    {M N P : Type*} [AddCommMonoid M] [AddCommMonoid N] [AddCommMonoid P]
    [Module R M] [Module R N] [Module R P]
    (g : M →ₗ[R] N) (h : N →ₗ[R] P) :
    IsLocalizedModule.map S (LocalizedModule.mkLinearMap S M)
        (LocalizedModule.mkLinearMap S P) (h.comp g) =
      (IsLocalizedModule.map S (LocalizedModule.mkLinearMap S N)
        (LocalizedModule.mkLinearMap S P) h).comp
        (IsLocalizedModule.map S (LocalizedModule.mkLinearMap S M)
    (LocalizedModule.mkLinearMap S N) g) := by
  exact IsLocalizedModule.map_comp' S
    (LocalizedModule.mkLinearMap S M)
    (LocalizedModule.mkLinearMap S N)
    (LocalizedModule.mkLinearMap S P) g h

/-!
The localized module has the expected universal property: maps out of it are
uniquely determined by their restriction along the canonical map whenever the
elements of `S` act invertibly on the target.
-/
theorem localizedModule_universal (S : Submonoid R)
    {M N : Type*} [AddCommMonoid M] [AddCommMonoid N]
    [Module R M] [Module R N] (g : M →ₗ[R] N)
    (h : ∀ s : S, IsUnit ((algebraMap R (Module.End R N)) s)) :
    ∃! l : LocalizedModule S M →ₗ[R] N,
      l.comp (LocalizedModule.mkLinearMap S M) = g := by
  exact IsLocalizedModule.is_universal S
    (LocalizedModule.mkLinearMap S M) g h

/-!
The universal property can be packaged as the explicit Hom-set equivalence used
in Stacks, Tag 07K0.  The forward map restricts a linear map along the
localization map, while the inverse is the canonical localized lift.
-/
noncomputable def localizedModule_homEquiv (S : Submonoid R)
    {M N : Type*} [AddCommMonoid M] [AddCommMonoid N]
    [Module R M] [Module R N]
    (h : ∀ s : S, IsUnit ((algebraMap R (Module.End R N)) s)) :
    (LocalizedModule S M →ₗ[R] N) ≃ (M →ₗ[R] N) where
  toFun l := l.comp (LocalizedModule.mkLinearMap S M)
  invFun g := IsLocalizedModule.lift S (LocalizedModule.mkLinearMap S M) g h
  left_inv l := by
    apply IsLocalizedModule.ext S (LocalizedModule.mkLinearMap S M) h
    exact IsLocalizedModule.lift_comp S (LocalizedModule.mkLinearMap S M)
      (l.comp (LocalizedModule.mkLinearMap S M)) h
  right_inv g := IsLocalizedModule.lift_comp S (LocalizedModule.mkLinearMap S M) g h

/-!
The canonical map into an iterated localization is itself a localization map
at the join of the two denominator submonoids.  This is the module form of
Stacks, Tag 02C7; the join has carrier the pointwise products in a commutative
semiring.
-/
theorem localizedModule_nested_smul_isUnit
    {M : Type*} [AddCommMonoid M] [Module R M]
    (S T : Submonoid R) (t : T) :
    IsUnit (algebraMap R
      (Module.End R (LocalizedModule S (LocalizedModule T M))) (t : R)) := by
  let fS : LocalizedModule T M →ₗ[R] LocalizedModule S (LocalizedModule T M) :=
    LocalizedModule.mkLinearMap S (LocalizedModule T M)
  let a₁ : Module.End R (LocalizedModule T M) :=
    algebraMap R (Module.End R (LocalizedModule T M)) (t : R)
  let a₂ : Module.End R (LocalizedModule S (LocalizedModule T M)) :=
    algebraMap R (Module.End R (LocalizedModule S (LocalizedModule T M))) (t : R)
  let d : Module.End R (LocalizedModule T M) := LocalizedModule.divBy t
  let D : Module.End R (LocalizedModule S (LocalizedModule T M)) :=
    IsLocalizedModule.map S fS fS d
  have hinner_left : d.comp a₁ = LinearMap.id := by
    ext x
    change LocalizedModule.divBy t (a₁ x) = x
    exact LocalizedModule.divBy_mul_by t x
  have hinner_right : a₁.comp d = LinearMap.id := by
    ext x
    change a₁ (LocalizedModule.divBy t x) = x
    exact LocalizedModule.mul_by_divBy t x
  have hscalar : a₂.comp fS = fS.comp a₁ := by
    ext x
    simp [LinearMap.comp_apply, a₁, a₂, Module.algebraMap_end_apply]
  have hmap : D.comp fS = fS.comp d := by
    exact IsLocalizedModule.map_comp S fS fS d
  have hDleft : D.comp a₂ = LinearMap.id := by
    apply IsLocalizedModule.linearMap_ext S fS fS
    calc
      (D.comp a₂).comp fS = D.comp (a₂.comp fS) := by rw [LinearMap.comp_assoc]
      _ = D.comp (fS.comp a₁) := by rw [hscalar]
      _ = (D.comp fS).comp a₁ := by rw [LinearMap.comp_assoc]
      _ = (fS.comp d).comp a₁ := by rw [hmap]
      _ = fS.comp (d.comp a₁) := by rw [LinearMap.comp_assoc]
      _ = fS.comp LinearMap.id := by rw [hinner_left]
      _ = LinearMap.id.comp fS := by ext; simp
  have hDright : a₂.comp D = LinearMap.id := by
    apply IsLocalizedModule.linearMap_ext S fS fS
    calc
      (a₂.comp D).comp fS = a₂.comp (D.comp fS) := by rw [LinearMap.comp_assoc]
      _ = a₂.comp (fS.comp d) := by rw [hmap]
      _ = (a₂.comp fS).comp d := by rw [LinearMap.comp_assoc]
      _ = (fS.comp a₁).comp d := by rw [hscalar]
      _ = fS.comp (a₁.comp d) := by rw [LinearMap.comp_assoc]
      _ = fS.comp LinearMap.id := by rw [hinner_right]
      _ = LinearMap.id.comp fS := by ext; simp
  rw [Module.End.isUnit_iff]
  constructor
  · intro x y hxy
    calc
      x = (D.comp a₂) x := by rw [hDleft]; rfl
      _ = D (a₂ x) := rfl
      _ = D (a₂ y) := congrArg D hxy
      _ = (D.comp a₂) y := rfl
      _ = y := by rw [hDleft]; rfl
  · intro y
    refine ⟨D y, ?_⟩
    change a₂ (D y) = y
    have hh := congrArg (fun q => q y) hDright
    simpa [LinearMap.comp_apply] using hh

theorem localizedModule_comp_isLocalizedModule
    {M : Type*} [AddCommMonoid M] [Module R M]
    (S T : Submonoid R) :
    IsLocalizedModule (S ⊔ T)
      ((LocalizedModule.mkLinearMap S (LocalizedModule T M)).comp
        (LocalizedModule.mkLinearMap T M)) := by
  let fS : LocalizedModule T M →ₗ[R] LocalizedModule S (LocalizedModule T M) :=
    LocalizedModule.mkLinearMap S (LocalizedModule T M)
  let fT : M →ₗ[R] LocalizedModule T M := LocalizedModule.mkLinearMap T M
  let f : M →ₗ[R] LocalizedModule S (LocalizedModule T M) := fS.comp fT
  constructor
  · intro c
    rcases (Submonoid.mem_sup.mp c.property) with ⟨s, hs, t, ht, hst⟩
    rw [← hst, map_mul]
    exact (IsLocalizedModule.map_units fS ⟨s, hs⟩).mul
      (localizedModule_nested_smul_isUnit S T ⟨t, ht⟩)
  · intro y
    obtain ⟨⟨x, s⟩, hs⟩ := IsLocalizedModule.surj S fS y
    obtain ⟨⟨m, t⟩, ht⟩ := IsLocalizedModule.surj T fT x
    let c : ↥(S ⊔ T) := ⟨(s : R) * (t : R),
      (Submonoid.mem_sup.mpr ⟨s, s.property, t, t.property, rfl⟩)⟩
    refine ⟨⟨m, c⟩, ?_⟩
    have hs' : (s : R) • y = fS x := by
      simpa only [Submonoid.smul_def] using hs
    have ht' : (t : R) • x = fT m := by
      simpa only [Submonoid.smul_def] using ht
    dsimp [c]
    change ((s : R) * (t : R)) • y = fS (fT m)
    rw [← smul_smul, smul_comm (s : R) (t : R), hs', ← fS.map_smul, ht']
  · intro x y hxy
    obtain ⟨s, hs⟩ := IsLocalizedModule.exists_of_eq (S := S) (f := fS) hxy
    have hxy' : fT ((s : R) • x) = fT ((s : R) • y) := by
      have hs' : (s : R) • fT x = (s : R) • fT y := by
        simpa only [Submonoid.smul_def] using hs
      simpa [fT, map_smul] using hs'
    obtain ⟨t, ht⟩ := IsLocalizedModule.exists_of_eq (S := T) (f := fT) hxy'
    refine ⟨⟨(t : R) * (s : R),
      (Submonoid.mem_sup.mpr ⟨s, s.property, t, t.property, by ring⟩)⟩, ?_⟩
    change ((t : R) * (s : R)) • x = ((t : R) * (s : R)) • y
    calc
      ((t : R) * (s : R)) • x = (t : R) • (s : R) • x := (smul_smul _ _ _).symm
      _ = (t : R) • (s : R) • y := by simpa only [Submonoid.smul_def] using ht
      _ = ((t : R) * (s : R)) • y := smul_smul _ _ _

/- The canonical map identity records the orientation of the Tag 02C7 equivalence. -/
noncomputable def localizedModule_localizeTwiceEquiv
    {M : Type*} [AddCommMonoid M] [Module R M]
    (S T : Submonoid R) :
    LocalizedModule S (LocalizedModule T M) ≃ₗ[R] LocalizedModule (S ⊔ T) M := by
  let f : M →ₗ[R] LocalizedModule S (LocalizedModule T M) :=
    (LocalizedModule.mkLinearMap S (LocalizedModule T M)).comp
      (LocalizedModule.mkLinearMap T M)
  letI : IsLocalizedModule (S ⊔ T) f :=
    localizedModule_comp_isLocalizedModule S T
  exact IsLocalizedModule.linearEquiv (S ⊔ T) f
    (LocalizedModule.mkLinearMap (S ⊔ T) M)

@[simp]
theorem localizedModule_localizeTwiceEquiv_comp
    {M : Type*} [AddCommGroup M] [Module R M]
    (S T : Submonoid R) :
    (localizedModule_localizeTwiceEquiv S T).toLinearMap.comp
        ((LocalizedModule.mkLinearMap S (LocalizedModule T M)).comp
          (LocalizedModule.mkLinearMap T M)) =
      LocalizedModule.mkLinearMap (S ⊔ T) M := by
  let f : M →ₗ[R] LocalizedModule S (LocalizedModule T M) :=
    (LocalizedModule.mkLinearMap S (LocalizedModule T M)).comp
      (LocalizedModule.mkLinearMap T M)
  letI : IsLocalizedModule (S ⊔ T) f :=
    localizedModule_comp_isLocalizedModule S T
  apply LinearMap.ext
  intro x
  change (IsLocalizedModule.linearEquiv (S ⊔ T)
      ((LocalizedModule.mkLinearMap S (LocalizedModule T M)).comp
        (LocalizedModule.mkLinearMap T M))
      (LocalizedModule.mkLinearMap (S ⊔ T) M))
      (((LocalizedModule.mkLinearMap S (LocalizedModule T M)).comp
        (LocalizedModule.mkLinearMap T M)) x) =
      (LocalizedModule.mkLinearMap (S ⊔ T) M) x
  exact IsLocalizedModule.linearEquiv_apply _ _ _ x

/-!
The localized identity map is the identity, a useful normalization for
iterated localization constructions.
-/
@[simp]
theorem localizedModule_map_id (S : Submonoid R) (M : Type*)
    [AddCommMonoid M] [Module R M] :
    IsLocalizedModule.map S (LocalizedModule.mkLinearMap S M)
      (LocalizedModule.mkLinearMap S M) LinearMap.id = LinearMap.id := by
  exact IsLocalizedModule.map_id S (LocalizedModule.mkLinearMap S M)

/-!
Kernels and ranges of localized maps are the localizations of the original
kernels and ranges.  These identities are the submodule form of exactness.
-/
theorem localizedModule_ker_map (S : Submonoid R)
    {M N : Type*} [AddCommMonoid M] [AddCommMonoid N]
    [Module R M] [Module R N] (g : M →ₗ[R] N) :
    (IsLocalizedModule.map S (LocalizedModule.mkLinearMap S M)
      (LocalizedModule.mkLinearMap S N) g).ker =
      Submodule.localized₀ S (LocalizedModule.mkLinearMap S M) g.ker := by
  exact LinearMap.ker_localizedMap_eq_localized₀_ker S
    (LocalizedModule.mkLinearMap S M)
    (LocalizedModule.mkLinearMap S N) g

theorem localizedModule_range_map (S : Submonoid R)
    {M N : Type*} [AddCommMonoid M] [AddCommMonoid N]
    [Module R M] [Module R N] (g : M →ₗ[R] N) :
    (IsLocalizedModule.map S (LocalizedModule.mkLinearMap S M)
      (LocalizedModule.mkLinearMap S N) g).range =
      Submodule.localized₀ S (LocalizedModule.mkLinearMap S N) g.range := by
  exact LinearMap.range_localizedMap_eq_localized₀_range S
    (LocalizedModule.mkLinearMap S M)
    (LocalizedModule.mkLinearMap S N) g

/-!
Localization preserves exactness of a sequence of module maps.  This is the
formal counterpart of Stacks Tag 00CS.
-/
theorem localization_exact (S : Submonoid R)
    {M₀ M₁ M₂ : Type*}
    [AddCommMonoid M₀] [AddCommMonoid M₁] [AddCommMonoid M₂]
    [Module R M₀] [Module R M₁] [Module R M₂]
    (g : M₀ →ₗ[R] M₁) (h : M₁ →ₗ[R] M₂)
    (hex : Function.Exact g h) :
    Function.Exact
      (IsLocalizedModule.map S (LocalizedModule.mkLinearMap S M₀)
        (LocalizedModule.mkLinearMap S M₁) g)
      (IsLocalizedModule.map S (LocalizedModule.mkLinearMap S M₁)
        (LocalizedModule.mkLinearMap S M₂) h) := by
  exact LocalizedModule.map_exact S g h hex

/-- Localization preserves injectivity of a linear map. -/
theorem localizedModule_map_injective (S : Submonoid R)
    {M N : Type*} [AddCommMonoid M] [AddCommMonoid N]
    [Module R M] [Module R N] (g : M →ₗ[R] N) (hg : Function.Injective g) :
    Function.Injective
      (IsLocalizedModule.map S (LocalizedModule.mkLinearMap S M)
        (LocalizedModule.mkLinearMap S N) g) := by
  exact LocalizedModule.map_injective S g hg

/-- Localization preserves surjectivity of a linear map. -/
theorem localizedModule_map_surjective (S : Submonoid R)
    {M N : Type*} [AddCommMonoid M] [AddCommMonoid N]
    [Module R M] [Module R N] (g : M →ₗ[R] N) (hg : Function.Surjective g) :
    Function.Surjective
      (IsLocalizedModule.map S (LocalizedModule.mkLinearMap S M)
        (LocalizedModule.mkLinearMap S N) g) := by
  exact LocalizedModule.map_surjective S g hg

/-!
The kernel of the canonical map is precisely the submodule of elements killed
by some denominator.  This is the elementwise form of the localization
equivalence relation.
-/
theorem localizedModule_mem_ker_iff
    {A : Type*} [CommRing A] (S : Submonoid A)
    {M : Type*} [AddCommMonoid M] [Module A M] {m : M} :
    m ∈ (LocalizedModule.mkLinearMap S M).ker ↔
      ∃ r : A, r ∈ S ∧ r • m = 0 := by
  exact LocalizedModule.mem_ker_mkLinearMap_iff (S := S) (m := m)

/- The localization of a quotient module agrees with the quotient of the
localized module (Stacks, Tag 02C8 and the surrounding construction). -/
noncomputable def localizedModule_quotient_equiv
    {A : Type*} [CommRing A] (S : Submonoid A) {M : Type*}
    [AddCommGroup M] [Module A M] (N : Submodule A M) :
    (LocalizedModule S M ⧸ Submodule.localized S N) ≃ₗ[Localization S]
      LocalizedModule S (M ⧸ N) :=
  localizedQuotientEquiv S N

/- Finite generation is preserved by localization. -/
theorem localizedModule_finite (S : Submonoid R)
    {M : Type*} [AddCommMonoid M] [Module R M] [Module.Finite R M] :
    Module.Finite (Localization S) (LocalizedModule S M) := by
  infer_instance

theorem localizedModule_finite_of_isLocalized
    (S : Submonoid R) {Rₚ : Type*} [CommSemiring Rₚ] [Algebra R Rₚ]
    [IsLocalization S Rₚ] {M : Type*} [AddCommMonoid M] [Module R M]
    {Mₚ : Type*} [AddCommMonoid Mₚ] [Module R Mₚ] [Module Rₚ Mₚ]
    [IsScalarTower R Rₚ Mₚ] (f : M →ₗ[R] Mₚ)
    [IsLocalizedModule S f] [Module.Finite R M] :
    Module.Finite Rₚ Mₚ := by
  exact Module.Finite.of_isLocalizedModule S f

/-- The ring-level universal property of localization (Stacks, Tag 00CP). -/
theorem existsUnique_localization_lift
    {A B : Type*} [CommSemiring A] [CommSemiring B]
    (S : Submonoid A) (f : A →+* B)
    (hf : ∀ s : S, IsUnit (f s)) :
    ∃! g : Localization S →+* B,
      g.comp (algebraMap A (Localization S)) = f := by
  refine ⟨IsLocalization.lift hf, IsLocalization.lift_comp hf, ?_⟩
  intro g hg
  exact (IsLocalization.lift_unique (S := Localization S) hf
    (RingHom.congr_fun hg)).symm

end StacksPart01
