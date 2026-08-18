---
author: sync
content_type: theorem
created: '2026-08-03T11:10:51'
decl: AlgebraicGeometry.exists_fiberCechLinearEquiv
docstring: '**The fibre-chart comparison as an isomorphism of two-term complexes.**

  For a quasicoherent module on a family over an affine base, residue-field base

  change of the two-chart Cech complex is linearly equivalent to the Cech complex

  of the induced fibre cover.


  The degree-zero equivalence combines tensor/base-change on the two charts; the

  degree-one equivalence is the corresponding comparison on their intersection.

  Restriction naturality makes the resulting square commute.  This is the

  reusable geometric input for surjectivity, kernel, and quotient-by-range

  comparisons.'
file: AlgebraicJacobian/Picard/RigidPushforwardFiberChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_fiberCechLinearEquiv
type: lean
updated: '2026-08-18T20:52:07'
---
theorem exists_fiberCechLinearEquiv
    (𝒰 : X.AffineCoverMVSquare) (f : X ⟶ Y) [IsAffine Y]
    (M : X.Modules) [M.IsQuasicoherent] (t : Y) [IsAffineHom (f.fiberι t)] :
    letI : Algebra Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤) :=
      ((Y.fromSpecResidueField t).appLE ⊤ ⊤ le_top).hom.toAlgebra
    letI := f.baseSectionsModule M 𝒰.U₁
    letI := f.baseSectionsModule M 𝒰.U₂
    letI := f.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
    letI := (f.fiberToSpecResidueField t).baseSectionsModule (f.fiberModule t M)
      ((𝒰.preimage (f.fiberι t)).U₁)
    letI := (f.fiberToSpecResidueField t).baseSectionsModule (f.fiberModule t M)
      ((𝒰.preimage (f.fiberι t)).U₂)
    letI := (f.fiberToSpecResidueField t).baseSectionsModule (f.fiberModule t M)
      ((𝒰.preimage (f.fiberι t)).U₁ ⊓ (𝒰.preimage (f.fiberι t)).U₂)
    ∃ (e0 : TensorProduct Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
          (Γ(M, 𝒰.U₁) × Γ(M, 𝒰.U₂)) ≃ₗ[Γ(Spec (Y.residueField t), ⊤)]
          (Γ(f.fiberModule t M, (𝒰.preimage (f.fiberι t)).U₁) ×
            Γ(f.fiberModule t M, (𝒰.preimage (f.fiberι t)).U₂)))
      (e1 : TensorProduct Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
          Γ(M, 𝒰.U₁ ⊓ 𝒰.U₂) ≃ₗ[Γ(Spec (Y.residueField t), ⊤)]
          Γ(f.fiberModule t M,
            (𝒰.preimage (f.fiberι t)).U₁ ⊓ (𝒰.preimage (f.fiberι t)).U₂)),
      ((𝒰.preimage (f.fiberι t)).moduleSectionDiffBase
          (f.fiberToSpecResidueField t) (f.fiberModule t M)) ∘ₗ e0.toLinearMap =
        e1.toLinearMap ∘ₗ ((𝒰.moduleSectionDiffBase f M).baseChange
          Γ(Spec (Y.residueField t), ⊤)) := by
  letI aAB : Algebra Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤) :=
    ((Y.fromSpecResidueField t).appLE ⊤ ⊤ le_top).hom.toAlgebra
  letI mA1 := f.baseSectionsModule M 𝒰.U₁
  letI mA2 := f.baseSectionsModule M 𝒰.U₂
  letI mA0 := f.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
  letI nB1 := (f.fiberToSpecResidueField t).baseSectionsModule (f.fiberModule t M)
    ((𝒰.preimage (f.fiberι t)).U₁)
  letI nB2 := (f.fiberToSpecResidueField t).baseSectionsModule (f.fiberModule t M)
    ((𝒰.preimage (f.fiberι t)).U₂)
  letI nB0 := (f.fiberToSpecResidueField t).baseSectionsModule (f.fiberModule t M)
    ((𝒰.preimage (f.fiberι t)).U₁ ⊓ (𝒰.preimage (f.fiberι t)).U₂)
  obtain ⟨⟨Θ₁, hΘ₁⟩⟩ := exists_fiberChartTensorEquiv f t M 𝒰.isAffineOpen_U₁
    (𝒰.isAffineOpen_U₁.preimage (f.fiberι t))
  obtain ⟨⟨Θ₂, hΘ₂⟩⟩ := exists_fiberChartTensorEquiv f t M 𝒰.isAffineOpen_U₂
    (𝒰.isAffineOpen_U₂.preimage (f.fiberι t))
  obtain ⟨⟨Θ₀, hΘ₀⟩⟩ := exists_fiberChartTensorEquiv f t M 𝒰.isAffineOpen_inf
    (𝒰.isAffineOpen_inf.preimage (f.fiberι t))
  haveI : (f.fiberModule t M).IsQuasicoherent := Scheme.Hom.fiberModule_isQuasicoherent f t M
  have hsm1 : ∀ (c : Γ(Spec (Y.residueField t), ⊤))
      (z : TensorProduct Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤) Γ(M, 𝒰.U₁)),
      Θ₁ (c • z) =
        ((f.fiberToSpecResidueField t).appLE ⊤ (f.fiberι t ⁻¹ᵁ 𝒰.U₁) le_top).hom c • Θ₁ z := by
    intro c z
    induction z using TensorProduct.induction_on with
    | zero => simp
    | add z₁ z₂ h₁ h₂ => rw [smul_add, map_add, map_add, h₁, h₂, smul_add]
    | tmul b x =>
      rw [TensorProduct.smul_tmul', hΘ₁, hΘ₁, smul_eq_mul, map_mul, mul_smul]
      rfl
  have hsm2 : ∀ (c : Γ(Spec (Y.residueField t), ⊤))
      (z : TensorProduct Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤) Γ(M, 𝒰.U₂)),
      Θ₂ (c • z) =
        ((f.fiberToSpecResidueField t).appLE ⊤ (f.fiberι t ⁻¹ᵁ 𝒰.U₂) le_top).hom c • Θ₂ z := by
    intro c z
    induction z using TensorProduct.induction_on with
    | zero => simp
    | add z₁ z₂ h₁ h₂ => rw [smul_add, map_add, map_add, h₁, h₂, smul_add]
    | tmul b x =>
      rw [TensorProduct.smul_tmul', hΘ₂, hΘ₂, smul_eq_mul, map_mul, mul_smul]
      rfl
  have hsm0 : ∀ (c : Γ(Spec (Y.residueField t), ⊤))
      (z : TensorProduct Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
        Γ(M, 𝒰.U₁ ⊓ 𝒰.U₂)),
      Θ₀ (c • z) =
        ((f.fiberToSpecResidueField t).appLE ⊤
          (f.fiberι t ⁻¹ᵁ (𝒰.U₁ ⊓ 𝒰.U₂)) le_top).hom c • Θ₀ z := by
    intro c z
    induction z using TensorProduct.induction_on with
    | zero => simp
    | add z₁ z₂ h₁ h₂ => rw [smul_add, map_add, map_add, h₁, h₂, smul_add]
    | tmul b x =>
      rw [TensorProduct.smul_tmul', hΘ₀, hΘ₀, smul_eq_mul, map_mul, mul_smul]
      rfl
  have hsquare : ∀ w : TensorProduct Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
      (Γ(M, 𝒰.U₁) × Γ(M, 𝒰.U₂)),
      Θ₀ ((𝒰.moduleSectionDiffBase f M).baseChange Γ(Spec (Y.residueField t), ⊤) w) =
        (𝒰.preimage (f.fiberι t)).moduleSectionDiff (f.fiberModule t M)
          (Θ₁ (TensorProduct.prodRight Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
              Γ(Spec (Y.residueField t), ⊤) Γ(M, 𝒰.U₁) Γ(M, 𝒰.U₂) w).1,
           Θ₂ (TensorProduct.prodRight Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
              Γ(Spec (Y.residueField t), ⊤) Γ(M, 𝒰.U₁) Γ(M, 𝒰.U₂) w).2) := by
    intro w
    induction w using TensorProduct.induction_on with
    | zero =>
      simp only [map_zero, Prod.fst_zero, Prod.snd_zero]
      exact (map_zero _).symm
    | add w₁ w₂ ih₁ ih₂ =>
      simp only [map_add, Prod.fst_add, Prod.snd_add]
      rw [ih₁, ih₂]
      exact (map_add _ _ _).symm
    | tmul b p =>
      obtain ⟨x₁, x₂⟩ := p
      rw [LinearMap.baseChange_tmul, hΘ₀ b _]
      simp only [TensorProduct.prodRight_tmul, hΘ₁, hΘ₂,
        Scheme.AffineCoverMVSquare.moduleSectionDiffBase_apply,
        Scheme.AffineCoverMVSquare.moduleSectionDiff_apply]
      have e₁ := fiberChart_smul_baseMap_res f t M
        (inf_le_left : 𝒰.U₁ ⊓ 𝒰.U₂ ≤ 𝒰.U₁) (le_refl (f.fiberι t ⁻¹ᵁ (𝒰.U₁ ⊓ 𝒰.U₂)))
        ((f.fiberι t).preimage_mono (inf_le_left : 𝒰.U₁ ⊓ 𝒰.U₂ ≤ 𝒰.U₁)) b x₁
      have e₂ := fiberChart_smul_baseMap_res f t M
        (inf_le_right : 𝒰.U₁ ⊓ 𝒰.U₂ ≤ 𝒰.U₂) (le_refl (f.fiberι t ⁻¹ᵁ (𝒰.U₁ ⊓ 𝒰.U₂)))
        ((f.fiberι t).preimage_mono (inf_le_right : 𝒰.U₁ ⊓ 𝒰.U₂ ≤ 𝒰.U₂)) b x₂
      rw [map_sub, smul_sub]
      exact congrArg₂ (· - ·) e₁.symm e₂.symm
  set PR := TensorProduct.prodRight Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
      Γ(Spec (Y.residueField t), ⊤) Γ(M, 𝒰.U₁) Γ(M, 𝒰.U₂) with hPR
  set Φ : TensorProduct Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
        (Γ(M, 𝒰.U₁) × Γ(M, 𝒰.U₂)) ≃+
      (Γ(f.fiberModule t M, (𝒰.preimage (f.fiberι t)).U₁) ×
        Γ(f.fiberModule t M, (𝒰.preimage (f.fiberι t)).U₂)) :=
    PR.toAddEquiv.trans (Θ₁.prodCongr Θ₂) with hΦdef
  have hΦsmul : ∀ (c : Γ(Spec (Y.residueField t), ⊤)) w, Φ (c • w) = c • Φ w := by
    intro c w
    rw [hΦdef]
    change (Θ₁ (PR (c • w)).1, Θ₂ (PR (c • w)).2) = _
    rw [map_smul]
    exact Prod.ext (hsm1 c (PR w).1) (hsm2 c (PR w).2)
  let e0 : TensorProduct Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
        (Γ(M, 𝒰.U₁) × Γ(M, 𝒰.U₂)) ≃ₗ[Γ(Spec (Y.residueField t), ⊤)]
      (Γ(f.fiberModule t M, (𝒰.preimage (f.fiberι t)).U₁) ×
        Γ(f.fiberModule t M, (𝒰.preimage (f.fiberι t)).U₂)) :=
    { Φ with map_smul' := hΦsmul }
  let e1 : TensorProduct Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
        Γ(M, 𝒰.U₁ ⊓ 𝒰.U₂) ≃ₗ[Γ(Spec (Y.residueField t), ⊤)]
      Γ(f.fiberModule t M,
        (𝒰.preimage (f.fiberι t)).U₁ ⊓ (𝒰.preimage (f.fiberι t)).U₂) :=
    { Θ₀ with map_smul' := hsm0 }
  refine ⟨e0, e1, ?_⟩
  ext w
  exact (hsquare w).symm