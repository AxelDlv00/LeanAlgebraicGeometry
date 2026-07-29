---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.PicEtAff.relPicAlgMap_tensor_eq_of_compat
docstring: '**The pair condition**: descent-class representatives of two plus classes
  over the

  localizations `S₁, S₂` of `A` that agree over an overlap localization `Tv` have
  equal

  pullbacks to the `A`-tensor product of the covering carriers.  This is the step
  of the

  Layer-2 gluing licensed by the (C1) étale separatedness.'
file: AlgebraicJacobian/Picard/PicEtAffZariskiGlue.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicEtAff.relPicAlgMap_tensor_eq_of_compat
type: lean
updated: '2026-07-29T15:31:47'
---
theorem relPicAlgMap_tensor_eq_of_compat (g₁ g₂ : A)
    [IsLocalization.Away g₁ S₁] [IsLocalization.Away g₂ S₂]
    [IsLocalization.Away (g₁ * g₂) Tv]
    (ξ₁ : descentClasses C E₁) (ξ₂ : descentClasses C E₂)
    (h : PicEtAff.mapAlg C (φ₁.restrictScalars k) (PicEtAff.mk C E₁ ξ₁)
      = PicEtAff.mapAlg C (φ₂.restrictScalars k) (PicEtAff.mk C E₂ ξ₂)) :
    relPicAlgMap C ((Algebra.TensorProduct.includeLeft :
        E₁.Carrier →ₐ[k] E₁.Carrier ⊗[A] E₂.Carrier))
      (ξ₁ : relPic C (overSpec k E₁.Carrier))
      = relPicAlgMap C ((Algebra.TensorProduct.includeRight :
          E₂.Carrier →ₐ[A] E₁.Carrier ⊗[A] E₂.Carrier).restrictScalars k)
        (ξ₂ : relPic C (overSpec k E₂.Carrier)) := by
  classical
  -- unfold the overlap compatibility to a common refinement over `Tv`
  obtain ⟨H, m₁, m₂, hm₁, hm₂, hval⟩ := exists_relPicAlgMap_eq_of_mapAlg_eq C
    (φ₁.restrictScalars k) (φ₂.restrictScalars k) E₁ E₂ ξ₁ ξ₂ h
  -- `a ⊗ 1 = 1 ⊗ a` for scalars from the base
  have htensor : ∀ a : A,
      (algebraMap A E₁.Carrier a) ⊗ₜ[A] (1 : E₂.Carrier)
        = (1 : E₁.Carrier) ⊗ₜ[A] (algebraMap A E₂.Carrier a) := fun a => by
    rw [Algebra.algebraMap_eq_smul_one, Algebra.algebraMap_eq_smul_one,
      TensorProduct.smul_tmul]
  -- `g₁ * g₂` becomes a unit in `(E₁.Carrier ⊗[A] E₂.Carrier)`
  have hu : IsUnit (algebraMap A (E₁.Carrier ⊗[A] E₂.Carrier) (g₁ * g₂)) := by
    rw [map_mul]
    refine IsUnit.mul ?_ ?_
    · have h₁ : IsUnit (algebraMap A E₁.Carrier g₁) := by
        rw [IsScalarTower.algebraMap_apply A S₁ E₁.Carrier g₁]
        exact (IsLocalization.Away.algebraMap_isUnit (S := S₁) g₁).map
          (algebraMap S₁ E₁.Carrier)
      have h₂ := h₁.map (Algebra.TensorProduct.includeLeft
        (R := A) (S := A) (B := E₂.Carrier))
      rwa [show (Algebra.TensorProduct.includeLeft (R := A) (S := A)
          (B := E₂.Carrier)) (algebraMap A E₁.Carrier g₁)
          = algebraMap A (E₁.Carrier ⊗[A] E₂.Carrier) g₁ from
        ((Algebra.TensorProduct.includeLeft (R := A) (S := A)
          (B := E₂.Carrier)).commutes g₁)] at h₂
    · have h₁ : IsUnit (algebraMap A E₂.Carrier g₂) := by
        rw [IsScalarTower.algebraMap_apply A S₂ E₂.Carrier g₂]
        exact (IsLocalization.Away.algebraMap_isUnit (S := S₂) g₂).map
          (algebraMap S₂ E₂.Carrier)
      have h₂ := h₁.map (Algebra.TensorProduct.includeRight
        (R := A) (A := E₁.Carrier))
      rwa [show (Algebra.TensorProduct.includeRight (R := A) (A := E₁.Carrier))
          (algebraMap A E₂.Carrier g₂)
          = algebraMap A (E₁.Carrier ⊗[A] E₂.Carrier) g₂ from
        ((Algebra.TensorProduct.includeRight (R := A)
          (A := E₁.Carrier)).commutes g₂)] at h₂
  -- the induced `A`-algebra map from the overlap localization into `(E₁.Carrier ⊗[A] E₂.Carrier)`
  set ρ : Tv →ₐ[A] (E₁.Carrier ⊗[A] E₂.Carrier) :=
    IsLocalization.liftAlgHom (M := Submonoid.powers (g₁ * g₂))
    (f := Algebra.ofId A (E₁.Carrier ⊗[A] E₂.Carrier)) (fun y => by
      obtain ⟨n, hn⟩ := y.2
      simpa [Algebra.ofId_apply, ← hn, map_pow] using hu.pow n) with hρdef
  letI : Algebra Tv (E₁.Carrier ⊗[A] E₂.Carrier) := ρ.toRingHom.toAlgebra
  haveI : IsScalarTower A Tv (E₁.Carrier ⊗[A] E₂.Carrier) :=
    .of_algebraMap_eq fun a => (ρ.commutes a).symm
  haveI : IsScalarTower k Tv (E₁.Carrier ⊗[A] E₂.Carrier) := .of_algebraMap_eq fun c => by
    rw [IsScalarTower.algebraMap_apply k A (E₁.Carrier ⊗[A] E₂.Carrier) c,
      IsScalarTower.algebraMap_apply k A Tv c]
    exact (ρ.commutes (algebraMap k A c)).symm
  -- the base change of the common refinement to `(E₁.Carrier ⊗[A] E₂.Carrier)`
  set W := H.baseChange (E₁.Carrier ⊗[A] E₂.Carrier) with hWdef
  set θ : H.Carrier →ₐ[Tv] W.Carrier :=
    H.baseChangeInclude (E₁.Carrier ⊗[A] E₂.Carrier) with hθdef
  -- the (C1) corollary: restriction along `(E₁.Carrier ⊗[A] E₂.Carrier) → W.Carrier` is injective
  apply relPicAlgMap_injective_of_etaleCover C W
  rw [← relPicAlgMap_comp, ← relPicAlgMap_comp]
  -- the two `S`-semilinear routes into `W.Carrier`
  -- left: through the tensor product
  haveI hsub₁ : Subsingleton (S₁ →ₐ[A] (E₁.Carrier ⊗[A] E₂.Carrier)) :=
    IsLocalization.algHom_subsingleton (Submonoid.powers g₁)
  haveI hsub₂ : Subsingleton (S₂ →ₐ[A] (E₁.Carrier ⊗[A] E₂.Carrier)) :=
    IsLocalization.algHom_subsingleton (Submonoid.powers g₂)
  haveI : SMulCommClass A S₁ E₁.Carrier :=
    ⟨fun a s b => by simp only [Algebra.smul_def]; ring⟩
  haveI : IsScalarTower A S₁ (E₁.Carrier ⊗[A] E₂.Carrier) :=
    .of_algebraMap_eq fun a => by
      simp only [Algebra.TensorProduct.algebraMap_apply]
      rw [← IsScalarTower.algebraMap_apply A S₁ E₁.Carrier a]
  letI : Algebra S₂ (E₁.Carrier ⊗[A] E₂.Carrier) :=
    ((Algebra.TensorProduct.includeRight :
      E₂.Carrier →ₐ[A] (E₁.Carrier ⊗[A] E₂.Carrier)).toRingHom.comp
        (algebraMap S₂ E₂.Carrier)).toAlgebra
  haveI : IsScalarTower k S₂ (E₁.Carrier ⊗[A] E₂.Carrier) := .of_algebraMap_eq fun c => by
    change algebraMap k (E₁.Carrier ⊗[A] E₂.Carrier) c = Algebra.TensorProduct.includeRight
      (algebraMap S₂ E₂.Carrier (algebraMap k S₂ c))
    rw [← IsScalarTower.algebraMap_apply k S₂ E₂.Carrier c,
      IsScalarTower.algebraMap_apply k A E₂.Carrier c,
      show (Algebra.TensorProduct.includeRight :
          E₂.Carrier →ₐ[A] (E₁.Carrier ⊗[A] E₂.Carrier))
          (algebraMap A E₂.Carrier (algebraMap k A c))
        = algebraMap A (E₁.Carrier ⊗[A] E₂.Carrier) (algebraMap k A c) from
        Algebra.TensorProduct.includeRight.commutes (algebraMap k A c),
      ← IsScalarTower.algebraMap_apply k A (E₁.Carrier ⊗[A] E₂.Carrier) c]
  haveI : IsScalarTower A S₂ (E₁.Carrier ⊗[A] E₂.Carrier) := .of_algebraMap_eq fun a => by
    change algebraMap A (E₁.Carrier ⊗[A] E₂.Carrier) a = Algebra.TensorProduct.includeRight
      (algebraMap S₂ E₂.Carrier (algebraMap A S₂ a))
    rw [← IsScalarTower.algebraMap_apply A S₂ E₂.Carrier a,
      show (Algebra.TensorProduct.includeRight :
          E₂.Carrier →ₐ[A] (E₁.Carrier ⊗[A] E₂.Carrier)) (algebraMap A E₂.Carrier a)
        = algebraMap A (E₁.Carrier ⊗[A] E₂.Carrier) a from
        Algebra.TensorProduct.includeRight.commutes a]
  -- towers into `W.Carrier` (the canonical instance chains through `(E₁.Carrier ⊗[A] E₂.Carrier)`)
  haveI : IsScalarTower k S₁ (E₁.Carrier ⊗[A] E₂.Carrier) := .of_algebraMap_eq fun c => by
    simp only [Algebra.TensorProduct.algebraMap_apply]
    rw [← IsScalarTower.algebraMap_apply k S₁ E₁.Carrier c]
  haveI : IsScalarTower k S₁ W.Carrier := .of_algebraMap_eq fun c => by
    rw [IsScalarTower.algebraMap_apply k (E₁.Carrier ⊗[A] E₂.Carrier) W.Carrier c,
      IsScalarTower.algebraMap_apply k S₁ (E₁.Carrier ⊗[A] E₂.Carrier) c,
      ← IsScalarTower.algebraMap_apply S₁ (E₁.Carrier ⊗[A] E₂.Carrier) W.Carrier
        (algebraMap k S₁ c)]
  haveI : IsScalarTower k S₂ W.Carrier := .of_algebraMap_eq fun c => by
    rw [IsScalarTower.algebraMap_apply k (E₁.Carrier ⊗[A] E₂.Carrier) W.Carrier c,
      IsScalarTower.algebraMap_apply k S₂ (E₁.Carrier ⊗[A] E₂.Carrier) c,
      ← IsScalarTower.algebraMap_apply S₂ (E₁.Carrier ⊗[A] E₂.Carrier) W.Carrier
        (algebraMap k S₂ c)]
  -- the two `S₁`-algebra maps out of `E₁.Carrier`
  have hkey₁ : ρ.comp φ₁ = IsScalarTower.toAlgHom A S₁ (E₁.Carrier ⊗[A] E₂.Carrier) :=
    Subsingleton.elim _ _
  have hkey₂ : ρ.comp φ₂ = IsScalarTower.toAlgHom A S₂ (E₁.Carrier ⊗[A] E₂.Carrier) :=
    Subsingleton.elim _ _
  set j₁L : E₁.Carrier →ₐ[S₁] W.Carrier :=
    ((Algebra.ofId (E₁.Carrier ⊗[A] E₂.Carrier) W.Carrier).restrictScalars S₁).comp
      (Algebra.TensorProduct.includeLeft (S := S₁)) with hj₁L
  set j₂L : E₁.Carrier →ₐ[S₁] W.Carrier :=
    { toRingHom := ((θ.restrictScalars k).comp m₁).toRingHom
      commutes' := fun s => by
        change θ (m₁ (algebraMap S₁ E₁.Carrier s)) = _
        rw [hm₁ s]
        change θ (algebraMap Tv H.Carrier (φ₁ s)) = _
        rw [θ.commutes (φ₁ s),
          IsScalarTower.algebraMap_apply Tv (E₁.Carrier ⊗[A] E₂.Carrier) W.Carrier (φ₁ s),
          show algebraMap Tv (E₁.Carrier ⊗[A] E₂.Carrier) (φ₁ s) = (ρ.comp φ₁) s from rfl, hkey₁,
          show (IsScalarTower.toAlgHom A S₁ (E₁.Carrier ⊗[A] E₂.Carrier)) s
            = algebraMap S₁ (E₁.Carrier ⊗[A] E₂.Carrier) s from rfl,
          ← IsScalarTower.algebraMap_apply S₁ (E₁.Carrier ⊗[A] E₂.Carrier) W.Carrier s] } with hj₂L
  have hcongr₁ := relPicAlgMap_congr C j₁L j₂L ξ₁.2
  -- the two `S₂`-algebra maps out of `E₂.Carrier`
  set inclR : E₂.Carrier →ₐ[S₂] (E₁.Carrier ⊗[A] E₂.Carrier) :=
    { toRingHom := (Algebra.TensorProduct.includeRight :
        E₂.Carrier →ₐ[A] (E₁.Carrier ⊗[A] E₂.Carrier)).toRingHom
      commutes' := fun s => rfl } with hinclR
  set j₁R : E₂.Carrier →ₐ[S₂] W.Carrier :=
    ((Algebra.ofId (E₁.Carrier ⊗[A] E₂.Carrier) W.Carrier).restrictScalars S₂).comp inclR with hj₁R
  set j₂R : E₂.Carrier →ₐ[S₂] W.Carrier :=
    { toRingHom := ((θ.restrictScalars k).comp m₂).toRingHom
      commutes' := fun s => by
        change θ (m₂ (algebraMap S₂ E₂.Carrier s)) = _
        rw [hm₂ s]
        change θ (algebraMap Tv H.Carrier (φ₂ s)) = _
        rw [θ.commutes (φ₂ s),
          IsScalarTower.algebraMap_apply Tv (E₁.Carrier ⊗[A] E₂.Carrier) W.Carrier (φ₂ s),
          show algebraMap Tv (E₁.Carrier ⊗[A] E₂.Carrier) (φ₂ s) = (ρ.comp φ₂) s from rfl, hkey₂,
          show (IsScalarTower.toAlgHom A S₂ (E₁.Carrier ⊗[A] E₂.Carrier)) s
            = algebraMap S₂ (E₁.Carrier ⊗[A] E₂.Carrier) s from rfl,
          ← IsScalarTower.algebraMap_apply S₂ (E₁.Carrier ⊗[A] E₂.Carrier) W.Carrier s] } with hj₂R
  have hcongr₂ := relPicAlgMap_congr C j₁R j₂R ξ₂.2
  -- assemble the chain
  have hL : (j₁L.restrictScalars k : E₁.Carrier →ₐ[k] W.Carrier)
      = ((Algebra.ofId (E₁.Carrier ⊗[A] E₂.Carrier) W.Carrier).restrictScalars k).comp
          (Algebra.TensorProduct.includeLeft :
            E₁.Carrier →ₐ[k] E₁.Carrier ⊗[A] E₂.Carrier) :=
    AlgHom.ext fun _ => rfl
  have hR : (j₁R.restrictScalars k : E₂.Carrier →ₐ[k] W.Carrier)
      = ((Algebra.ofId (E₁.Carrier ⊗[A] E₂.Carrier) W.Carrier).restrictScalars k).comp
          ((Algebra.TensorProduct.includeRight :
            E₂.Carrier →ₐ[A] (E₁.Carrier ⊗[A] E₂.Carrier)).restrictScalars k) :=
    AlgHom.ext fun _ => rfl
  have hML : (j₂L.restrictScalars k : E₁.Carrier →ₐ[k] W.Carrier)
      = (θ.restrictScalars k).comp m₁ := AlgHom.ext fun _ => rfl
  have hMR : (j₂R.restrictScalars k : E₂.Carrier →ₐ[k] W.Carrier)
      = (θ.restrictScalars k).comp m₂ := AlgHom.ext fun _ => rfl
  rw [hL] at hcongr₁
  rw [hR] at hcongr₂
  rw [hML] at hcongr₁
  rw [hMR] at hcongr₂
  calc relPicAlgMap C
        (((Algebra.ofId (E₁.Carrier ⊗[A] E₂.Carrier) W.Carrier).restrictScalars k).comp
        (Algebra.TensorProduct.includeLeft :
          E₁.Carrier →ₐ[k] E₁.Carrier ⊗[A] E₂.Carrier))
        (ξ₁ : relPic C (overSpec k E₁.Carrier))
      = relPicAlgMap C ((θ.restrictScalars k).comp m₁)
          (ξ₁ : relPic C (overSpec k E₁.Carrier)) := hcongr₁
    _ = relPicAlgMap C (θ.restrictScalars k)
          (relPicAlgMap C m₁ (ξ₁ : relPic C (overSpec k E₁.Carrier))) :=
        relPicAlgMap_comp C _ _ _
    _ = relPicAlgMap C (θ.restrictScalars k)
          (relPicAlgMap C m₂ (ξ₂ : relPic C (overSpec k E₂.Carrier))) := by rw [hval]
    _ = relPicAlgMap C ((θ.restrictScalars k).comp m₂)
          (ξ₂ : relPic C (overSpec k E₂.Carrier)) := (relPicAlgMap_comp C _ _ _).symm
    _ = relPicAlgMap C
          (((Algebra.ofId (E₁.Carrier ⊗[A] E₂.Carrier) W.Carrier).restrictScalars k).comp
          ((Algebra.TensorProduct.includeRight :
            E₂.Carrier →ₐ[A] (E₁.Carrier ⊗[A] E₂.Carrier)).restrictScalars k))
          (ξ₂ : relPic C (overSpec k E₂.Carrier)) := hcongr₂.symm

end PairCondition

/-! ## Assembly of the glued class -/

section GlueHelpers

omit [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]