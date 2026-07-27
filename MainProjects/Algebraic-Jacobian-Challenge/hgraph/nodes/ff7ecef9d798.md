---
author: sync
content_type: theorem
created: '2026-07-27T20:11:15'
decl: AlgebraicGeometry.Adelic.exists_gammaBaseChange_of_kerPure
docstring: '**`H⁰` commutes with an affine base change**, in the `Γ`-level form the
  B3 gate consumes.


  For a cartesian square with affine bases `Y`, `Y''` and affine `g''`, a bundled
  2-affine cover `𝒰`

  of `X` and a quasi-coherent `M`, the Čech `H⁰`-purity hypothesis `hker` gives the
  canonical

  additive comparison


  `Γ(Y'', ⊤) ⊗_{Γ(Y, ⊤)} Γ(f_* M, ⊤) ≅ Γ(f''_* (g''^* M), ⊤)`, `b ⊗ x ↦ b · baseMap
  x`.


  **`f` is not assumed affine**, which is the whole point: in the application it is
  the proper

  family `q : C_A ⟶ Spec A`.  The two-term Čech complex of `𝒰` replaces the affineness
  of `f`.


  **Vacuity audit.**  The conclusion is `∃ s, (values of s on simple tensors) ∧ Bijective
  s`, and

  `s` is required to be additive while simple tensors generate the source as an abelian
  group; so

  the prescribed values determine `s` uniquely and the existential really asserts
  bijectivity of

  the canonical map, not the existence of a convenient one.'
file: AlgebraicJacobian/Picard/RigidPushforwardGammaBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.exists_gammaBaseChange_of_kerPure
type: lean
updated: '2026-07-27T20:42:16'
---
theorem exists_gammaBaseChange_of_kerPure {X Y X' Y' : Scheme.{u}}
    {f : X ⟶ Y} {g : Y' ⟶ Y} {f' : X' ⟶ Y'} {g' : X' ⟶ X}
    (h : IsPullback g' f' f g) [IsAffine Y] [IsAffine Y'] [IsAffineHom g']
    (𝒰 : X.AffineCoverMVSquare) (M : X.Modules) [M.IsQuasicoherent]
    (hker : ∀ (B : Type u) [CommRing B] [Algebra Γ(Y, ⊤) B],
      letI := f.baseSectionsModule M 𝒰.U₁
      letI := f.baseSectionsModule M 𝒰.U₂
      letI := f.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
      Function.Bijective
        (AlgebraicJacobian.TwoTerm.kerBaseChange (𝒰.moduleSectionDiffBase f M) B))
    (e' : f' ⁻¹ᵁ (⊤ : Y'.Opens) ≤ g' ⁻¹ᵁ (f ⁻¹ᵁ (⊤ : Y.Opens))) :
    letI : Algebra Γ(Y, ⊤) Γ(Y', ⊤) := (g.appLE ⊤ ⊤ le_top).hom.toAlgebra
    ∃ s : TensorProduct Γ(Y, ⊤) Γ(Y', ⊤)
        Γ((Scheme.Modules.pushforward f).obj M, (⊤ : Y.Opens)) →+
      Γ((Scheme.Modules.pushforward f').obj ((Scheme.Modules.pullback g').obj M),
        (⊤ : Y'.Opens)),
      (∀ (b : Γ(Y', ⊤)) (x : Γ((Scheme.Modules.pushforward f).obj M, (⊤ : Y.Opens))),
        s (b ⊗ₜ[Γ(Y, ⊤)] x) =
          b • (show Γ((Scheme.Modules.pushforward f').obj
              ((Scheme.Modules.pullback g').obj M), (⊤ : Y'.Opens)) from
            pullback_app_isoTensor_baseMap g' M e' x)) ∧
      Function.Bijective s := by
  letI aAB : Algebra Γ(Y, ⊤) Γ(Y', ⊤) := (g.appLE ⊤ ⊤ le_top).hom.toAlgebra
  letI mT := f.baseSectionsModule M (⊤ : X.Opens)
  letI m1 := f.baseSectionsModule M 𝒰.U₁
  letI m2 := f.baseSectionsModule M 𝒰.U₂
  letI m0 := f.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
  letI nT := f'.baseSectionsModule ((Scheme.Modules.pullback g').obj M) (⊤ : X'.Opens)
  letI n1 := f'.baseSectionsModule ((Scheme.Modules.pullback g').obj M) (𝒰.preimage g').U₁
  letI n2 := f'.baseSectionsModule ((Scheme.Modules.pullback g').obj M) (𝒰.preimage g').U₂
  letI n0 := f'.baseSectionsModule ((Scheme.Modules.pullback g').obj M)
    ((𝒰.preimage g').U₁ ⊓ (𝒰.preimage g').U₂)
  obtain ⟨⟨Ξ, hΞ⟩⟩ := exists_kerChartTensorEquiv h 𝒰 M hker
  let E := 𝒰.globalSectionsEquivKerModuleSectionDiffBase f M
  let E' := (𝒰.preimage g').globalSectionsEquivKerModuleSectionDiffBase f'
    ((Scheme.Modules.pullback g').obj M)
  let T := Scheme.Modules.pushforwardTopEquivBaseSections f M
  let T' := Scheme.Modules.pushforwardTopEquivBaseSections f'
    ((Scheme.Modules.pullback g').obj M)
  let s : TensorProduct Γ(Y, ⊤) Γ(Y', ⊤)
      Γ((Scheme.Modules.pushforward f).obj M, (⊤ : Y.Opens)) ≃+
      Γ((Scheme.Modules.pushforward f').obj ((Scheme.Modules.pullback g').obj M),
        (⊤ : Y'.Opens)) :=
    (TensorProduct.congr (LinearEquiv.refl Γ(Y, ⊤) Γ(Y', ⊤)) (T.trans E)).toAddEquiv.trans
      (Ξ.trans (E'.symm.trans T'.symm).toAddEquiv)
  refine ⟨s.toAddMonoidHom, ?_, s.bijective⟩
  intro b x
  -- the canonical base map commutes with restriction to either chart
  have hres : ∀ (W₀ : X.Opens) (hW₀ : W₀ ≤ f ⁻¹ᵁ (⊤ : Y.Opens))
      (hW'' : g' ⁻¹ᵁ W₀ ≤ f' ⁻¹ᵁ (⊤ : Y'.Opens)),
      (((Scheme.Modules.pullback g').obj M).presheaf.map (homOfLE hW'').op).hom
          (pullback_app_isoTensor_baseMap g' M e' x)
        = pullback_app_isoTensor_baseMap g' M (le_refl (g' ⁻¹ᵁ W₀))
          ((M.presheaf.map (homOfLE hW₀).op).hom x) :=
    fun W₀ hW₀ hW'' => pullback_app_isoTensor_baseMap_res' g' M e'
      (le_refl (g' ⁻¹ᵁ W₀)) hW₀ hW'' x
  have key : E' (T' (b • (show Γ((Scheme.Modules.pushforward f').obj
        ((Scheme.Modules.pullback g').obj M), (⊤ : Y'.Opens)) from
      pullback_app_isoTensor_baseMap g' M e' x))) = Ξ (b ⊗ₜ[Γ(Y, ⊤)] (E (T x))) := by
    rw [_root_.map_smul T' b, _root_.map_smul E' b]
    refine Subtype.ext ?_
    rw [hΞ b (E (T x))]
    exact Prod.ext
      (congrArg (fun z => (f'.appLE (⊤ : Y'.Opens) (g' ⁻¹ᵁ 𝒰.U₁) le_top).hom b • z)
        (hres 𝒰.U₁ le_top le_top))
      (congrArg (fun z => (f'.appLE (⊤ : Y'.Opens) (g' ⁻¹ᵁ 𝒰.U₂) le_top).hom b • z)
        (hres 𝒰.U₂ le_top le_top))
  have hsval : s.toAddMonoidHom (b ⊗ₜ[Γ(Y, ⊤)] x) =
      T'.symm (E'.symm (Ξ (b ⊗ₜ[Γ(Y, ⊤)] (E (T x))))) := rfl
  rw [hsval, ← key, E'.symm_apply_apply, T'.symm_apply_apply]

/-! ## §2. The gate's remaining statement, for an AJC curve -/

section AJC

variable {k : Type u} [Field k]

set_option maxHeartbeats 1600000 in
-- Elaborating the engine application unfolds two nested pullback squares and the full
-- `letI` dictionary of the preimage cover.