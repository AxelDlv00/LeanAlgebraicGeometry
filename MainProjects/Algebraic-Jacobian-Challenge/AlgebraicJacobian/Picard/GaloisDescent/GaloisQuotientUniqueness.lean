/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.FiniteGaloisQuotientAffine

/-!
# Uniqueness of finite Galois quotients

The universal `T`-points clause in `IsGaloisQuotient` determines the quotient
scheme uniquely over the base.  This file packages that observation as a
canonical comparison morphism and isomorphism.  The transitivity theorem is the
cocycle engine for gluing affine Galois quotient charts: once two restrictions
are known to be quotients of the same acted scheme, their overlap isomorphism
and every triple-overlap identity follow from uniqueness.
-/

open CategoryTheory Limits AlgebraicGeometry

universe u

namespace AlgebraicJacobian.GaloisDescent

/-- The data asserted by `IsGaloisQuotient`, retained in `Type` so its universal
property can define comparison morphisms. -/
structure GaloisQuotientWitness
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    (rho : SemilinearGalAction K L X f)
    (Y : Scheme.{u}) (g : Y ⟶ Spec (CommRingCat.of K)) where
  e : pullback g (Spec.map (CommRingCat.ofHom (algebraMap K L))) ≅ X
  over : e.hom ≫ f = pullback.snd g (Spec.map (CommRingCat.ofHom (algebraMap K L)))
  equivariant : (pullbackSemilinearGalAction K L g).IsEquivariant rho e.hom
  universal : ∀ (T : Scheme.{u}) (t : T ⟶ Spec (CommRingCat.of K))
      (h : pullback t (Spec.map (CommRingCat.ofHom (algebraMap K L))) ⟶ X),
      h ≫ f = pullback.snd t (Spec.map (CommRingCat.ofHom (algebraMap K L))) →
      (pullbackSemilinearGalAction K L t).IsEquivariant rho h →
      ∃! v : {v : T ⟶ Y // v ≫ g = t},
        pullbackBaseChange K L g t v.1 v.2 ≫ e.hom = h

/-- Extract the full quotient witness from the proposition-valued predicate.
This is the sole use of choice in the comparison construction. -/
noncomputable def IsGaloisQuotient.witness
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    {rho : SemilinearGalAction K L X f}
    {Y : Scheme.{u}} {g : Y ⟶ Spec (CommRingCat.of K)}
    (h : IsGaloisQuotient rho g) : GaloisQuotientWitness rho Y g :=
  Classical.choice (show Nonempty (GaloisQuotientWitness rho Y g) from by
    obtain ⟨e, hover, hequiv, huniv⟩ := h
    exact ⟨⟨e, hover, hequiv, huniv⟩⟩)

/-- The unique morphism from one Galois quotient to another, obtained by
applying the second quotient's universal property to the first one's
base-change isomorphism. -/
noncomputable def quotientComparison
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    (rho : SemilinearGalAction K L X f)
    {Y₁ Y₂ : Scheme.{u}}
    {g₁ : Y₁ ⟶ Spec (CommRingCat.of K)}
    {g₂ : Y₂ ⟶ Spec (CommRingCat.of K)}
    (h₁ : IsGaloisQuotient rho g₁) (h₂ : IsGaloisQuotient rho g₂) :
    {v : Y₁ ⟶ Y₂ // v ≫ g₂ = g₁} :=
  ((h₂.witness).universal Y₁ g₁ (h₁.witness).e.hom
    (h₁.witness).over (h₁.witness).equivariant).choose

/-- The base change of `quotientComparison` carries the second quotient's
chosen descent isomorphism to the first one's. -/
theorem quotientComparison_spec
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    (rho : SemilinearGalAction K L X f)
    {Y₁ Y₂ : Scheme.{u}}
    {g₁ : Y₁ ⟶ Spec (CommRingCat.of K)}
    {g₂ : Y₂ ⟶ Spec (CommRingCat.of K)}
    (h₁ : IsGaloisQuotient rho g₁) (h₂ : IsGaloisQuotient rho g₂) :
    pullbackBaseChange K L g₂ g₁ (quotientComparison rho h₁ h₂).1
        (quotientComparison rho h₁ h₂).2 ≫ (h₂.witness).e.hom =
      (h₁.witness).e.hom :=
  ((h₂.witness).universal Y₁ g₁ (h₁.witness).e.hom
    (h₁.witness).over (h₁.witness).equivariant).choose_spec.1

/-- Comparing a quotient with itself gives the identity morphism. -/
theorem quotientComparison_self
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    (rho : SemilinearGalAction K L X f)
    {Y : Scheme.{u}} {g : Y ⟶ Spec (CommRingCat.of K)}
    (h : IsGaloisQuotient rho g) :
    (quotientComparison rho h h).1 = 𝟙 Y := by
  classical
  have hbc : pullbackBaseChange K L g g (𝟙 Y) (Category.id_comp g) = 𝟙 _ := by
    apply pullback.hom_ext <;> simp
  have hid : pullbackBaseChange K L g g (𝟙 Y) (Category.id_comp g) ≫
      (h.witness).e.hom = (h.witness).e.hom := by rw [hbc, Category.id_comp]
  have heq := ((h.witness).universal Y g (h.witness).e.hom (h.witness).over
    (h.witness).equivariant).unique
      (y₁ := quotientComparison rho h h) (y₂ := ⟨𝟙 Y, Category.id_comp g⟩)
      (quotientComparison_spec rho h h) hid
  exact congrArg Subtype.val heq

/-- Comparison morphisms compose transitively.  This is the triple-overlap
cocycle identity used by quotient gluing. -/
theorem quotientComparison_comp
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    (rho : SemilinearGalAction K L X f)
    {Y₁ Y₂ Y₃ : Scheme.{u}}
    {g₁ : Y₁ ⟶ Spec (CommRingCat.of K)}
    {g₂ : Y₂ ⟶ Spec (CommRingCat.of K)}
    {g₃ : Y₃ ⟶ Spec (CommRingCat.of K)}
    (h₁ : IsGaloisQuotient rho g₁) (h₂ : IsGaloisQuotient rho g₂)
    (h₃ : IsGaloisQuotient rho g₃) :
    (quotientComparison rho h₁ h₂).1 ≫ (quotientComparison rho h₂ h₃).1 =
      (quotientComparison rho h₁ h₃).1 := by
  classical
  let v₁₂ := quotientComparison rho h₁ h₂
  let v₂₃ := quotientComparison rho h₂ h₃
  have hbase : (v₁₂.1 ≫ v₂₃.1) ≫ g₃ = g₁ := by
    rw [Category.assoc, v₂₃.2, v₁₂.2]
  have hcomp : pullbackBaseChange K L g₃ g₁ (v₁₂.1 ≫ v₂₃.1) hbase ≫
      (h₃.witness).e.hom = (h₁.witness).e.hom := by
    rw [pullbackBaseChange_comp K L g₃ g₂ g₁ v₂₃.1 v₂₃.2 v₁₂.1 v₁₂.2,
      Category.assoc, quotientComparison_spec rho h₂ h₃,
      quotientComparison_spec rho h₁ h₂]
  have heq := ((h₃.witness).universal Y₁ g₁ (h₁.witness).e.hom (h₁.witness).over
    (h₁.witness).equivariant).unique
      (y₁ := ⟨v₁₂.1 ≫ v₂₃.1, hbase⟩) (y₂ := quotientComparison rho h₁ h₃)
      hcomp (quotientComparison_spec rho h₁ h₃)
  exact congrArg Subtype.val heq

/-- Any two schemes representing the same finite Galois quotient are
canonically isomorphic over `Spec K`. -/
noncomputable def quotientUniqueIso
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    (rho : SemilinearGalAction K L X f)
    {Y₁ Y₂ : Scheme.{u}}
    {g₁ : Y₁ ⟶ Spec (CommRingCat.of K)}
    {g₂ : Y₂ ⟶ Spec (CommRingCat.of K)}
    (h₁ : IsGaloisQuotient rho g₁) (h₂ : IsGaloisQuotient rho g₂) : Y₁ ≅ Y₂ where
  hom := (quotientComparison rho h₁ h₂).1
  inv := (quotientComparison rho h₂ h₁).1
  hom_inv_id := by rw [quotientComparison_comp, quotientComparison_self]
  inv_hom_id := by rw [quotientComparison_comp, quotientComparison_self]

@[reassoc]
theorem quotientUniqueIso_hom_base
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    (rho : SemilinearGalAction K L X f)
    {Y₁ Y₂ : Scheme.{u}}
    {g₁ : Y₁ ⟶ Spec (CommRingCat.of K)}
    {g₂ : Y₂ ⟶ Spec (CommRingCat.of K)}
    (h₁ : IsGaloisQuotient rho g₁) (h₂ : IsGaloisQuotient rho g₂) :
    (quotientUniqueIso rho h₁ h₂).hom ≫ g₂ = g₁ :=
  (quotientComparison rho h₁ h₂).2

@[reassoc]
theorem quotientUniqueIso_inv_base
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    (rho : SemilinearGalAction K L X f)
    {Y₁ Y₂ : Scheme.{u}}
    {g₁ : Y₁ ⟶ Spec (CommRingCat.of K)}
    {g₂ : Y₂ ⟶ Spec (CommRingCat.of K)}
    (h₁ : IsGaloisQuotient rho g₁) (h₂ : IsGaloisQuotient rho g₂) :
    (quotientUniqueIso rho h₁ h₂).inv ≫ g₁ = g₂ :=
  (quotientComparison rho h₂ h₁).2

/-- The hom maps of the canonical quotient isomorphisms satisfy the gluing
cocycle on triple overlaps. -/
theorem quotientUniqueIso_hom_trans
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    (rho : SemilinearGalAction K L X f)
    {Y₁ Y₂ Y₃ : Scheme.{u}}
    {g₁ : Y₁ ⟶ Spec (CommRingCat.of K)}
    {g₂ : Y₂ ⟶ Spec (CommRingCat.of K)}
    {g₃ : Y₃ ⟶ Spec (CommRingCat.of K)}
    (h₁ : IsGaloisQuotient rho g₁) (h₂ : IsGaloisQuotient rho g₂)
    (h₃ : IsGaloisQuotient rho g₃) :
    (quotientUniqueIso rho h₁ h₂).hom ≫ (quotientUniqueIso rho h₂ h₃).hom =
      (quotientUniqueIso rho h₁ h₃).hom :=
  quotientComparison_comp rho h₁ h₂ h₃

@[simp]
theorem quotientUniqueIso_self
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    (rho : SemilinearGalAction K L X f)
    {Y : Scheme.{u}} {g : Y ⟶ Spec (CommRingCat.of K)}
    (h : IsGaloisQuotient rho g) : quotientUniqueIso rho h h = Iso.refl Y := by
  ext
  exact quotientComparison_self rho h

end AlgebraicJacobian.GaloisDescent
