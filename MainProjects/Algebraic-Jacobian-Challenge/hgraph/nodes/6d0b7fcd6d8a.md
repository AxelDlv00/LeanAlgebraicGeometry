---
author: sync
content_type: theorem
created: '2026-07-27T15:50:35'
decl: AlgebraicGeometry.exists_fiberChartTensorEquiv
docstring: "**The chart fibre comparison isomorphism** (Stacks 02KG at `i = 0`, chart\n\
  form; Mumford AV II §5).  Let `f : X ⟶ Y` be a family over an affine base,\n`M`\
  \ a quasi-coherent module on `X`, `t : Y` a point and `W ⊆ X` an affine\nopen whose\
  \ fibre chart `W_t = f.fiberι t ⁻¹ᵁ W` is again affine.  Then the\nsections of the\
  \ fibre restriction `M_t` over `W_t` are the scalar extension\nof `Γ(M, W)` along\
  \ `Γ(Y, ⊤) → κ(t)`:\n\n`Γ(Spec κ(t), ⊤) ⊗_{Γ(Y, ⊤)} Γ(M, W) ≅ Γ(M_t, W_t)`,\n\n\
  as additive groups, the isomorphism sending `b ⊗ x` to\n`b · (canonical base-map\
  \ image of x)`.\n\nThe proof composes two existing pieces:\n\n* the **affine section\
  \ formula**\n  `pullback_app_isoTensor_baseMap_sectionLinearEquiv` (`Picard/QuotScheme.lean`,\n\
  \  Stacks 01HQ) applied to the fibre embedding, giving\n  `Γ(X_t, W_t) ⊗_{Γ(X, W)}\
  \ Γ(M, W) ≅ Γ(M_t, W_t)`;\n* the **associativity bridge** `SectionBaseChange.bijective_addHom_of_isPushout`\n\
  \  (`Picard/SectionBaseChange.lean`) along the fibre-chart section-ring pushout\n\
  \  of Brick 3 (`isPushout_appLE_fiberChart`), which rewrites the tensor factor\n\
  \  `Γ(X_t, W_t) = Γ(X, W) ⊗_{Γ(Y, ⊤)} Γ(Spec κ(t), ⊤)` and cancels.\n\nOnly additivity\
  \ is asserted: the source is a `Γ(Spec κ(t), ⊤)`-module and the\ntarget a `Γ(X_t,\
  \ W_t)`-module, and the comparison is semilinear over the\nstructural map between\
  \ them — which is exactly the content of the displayed\nformula for `Θ (b ⊗ₜ x)`.\n\
  \nThe assembly mirrors `isIso_pushforwardBaseChangeMap_app_of_isPullback`\n(`Picard/RigidPushforwardTransfer.lean`),\
  \ which performs the same two-step\nidentification for the pushforward base-change\
  \ mate."
file: AlgebraicJacobian/Picard/RigidPushforwardFiberChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_fiberChartTensorEquiv
type: lean
updated: '2026-07-27T15:50:35'
---
theorem exists_fiberChartTensorEquiv {X Y : Scheme.{u}} (f : X ⟶ Y) [IsAffine Y] (t : Y)
    (M : X.Modules) [M.IsQuasicoherent] {W : X.Opens} (hW : IsAffineOpen W)
    (hWt : IsAffineOpen (f.fiberι t ⁻¹ᵁ W)) :
    letI : Algebra Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤) :=
      ((Y.fromSpecResidueField t).appLE ⊤ ⊤ le_top).hom.toAlgebra
    letI := f.baseSectionsModule M W
    Nonempty { Θ : TensorProduct Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤) Γ(M, W) ≃+
        Γ(f.fiberModule t M, f.fiberι t ⁻¹ᵁ W) //
      ∀ (b : Γ(Spec (Y.residueField t), ⊤)) (x : Γ(M, W)),
        Θ (b ⊗ₜ[Γ(Y, ⊤)] x) =
          ((f.fiberToSpecResidueField t).appLE ⊤ (f.fiberι t ⁻¹ᵁ W) le_top).hom b •
            pullback_app_isoTensor_baseMap (f.fiberι t) M
              (le_refl (f.fiberι t ⁻¹ᵁ W)) x } := by
  letI aAB : Algebra Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤) :=
    ((Y.fromSpecResidueField t).appLE ⊤ ⊤ le_top).hom.toAlgebra
  letI mAM := f.baseSectionsModule M W
  -- the algebra dictionary of the fibre-chart section-ring square
  letI aAC : Algebra Γ(Y, ⊤) Γ(X, W) := (f.appLE ⊤ W le_top).hom.toAlgebra
  letI aCD : Algebra Γ(X, W) Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W) :=
    ((f.fiberι t).appLE W (f.fiberι t ⁻¹ᵁ W) le_rfl).hom.toAlgebra
  letI aBD : Algebra Γ(Spec (Y.residueField t), ⊤) Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W) :=
    ((f.fiberToSpecResidueField t).appLE ⊤ (f.fiberι t ⁻¹ᵁ W) le_top).hom.toAlgebra
  letI aAD : Algebra Γ(Y, ⊤) Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W) :=
    ((f.appLE ⊤ W le_top) ≫
      ((f.fiberι t).appLE W (f.fiberι t ⁻¹ᵁ W) le_rfl)).hom.toAlgebra
  have hsq := (isPushout_appLE_fiberChart f t hW).w
  haveI tACD : IsScalarTower Γ(Y, ⊤) Γ(X, W) Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W) :=
    IsScalarTower.of_algebraMap_eq (fun _ => rfl)
  haveI tABD : IsScalarTower Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
      Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W) :=
    IsScalarTower.of_algebraMap_eq (fun r => by
      have h0 := congrArg
        (fun (φ : Γ(Y, ⊤) ⟶ Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W)) => φ.hom r) hsq
      simp only [CommRingCat.hom_comp, RingHom.comp_apply] at h0
      exact h0)
  haveI pushAlg : Algebra.IsPushout Γ(Y, ⊤) Γ(X, W) Γ(Spec (Y.residueField t), ⊤)
      Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W) :=
    (CommRingCat.isPushout_iff_isPushout).mp (isPushout_appLE_fiberChart f t hW)
  haveI tACM : IsScalarTower Γ(Y, ⊤) Γ(X, W) Γ(M, W) :=
    IsScalarTower.of_algebraMap_smul (fun _ _ => rfl)
  -- the affine section formula for the fibre embedding
  obtain ⟨⟨eL, heL⟩⟩ :=
    pullback_app_isoTensor_baseMap_sectionLinearEquiv (f.fiberι t) M hWt hW
      (le_refl (f.fiberι t ⁻¹ᵁ W))
  -- the scalar-extension bridge along the fibre-chart pushout
  let s : TensorProduct Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤) Γ(M, W) →+
      TensorProduct Γ(X, W) Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W) Γ(M, W) :=
    TensorProduct.liftAddHom
      (AddMonoidHom.mk' (fun b => AddMonoidHom.mk'
        (fun m => algebraMap Γ(Spec (Y.residueField t), ⊤)
          Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W) b ⊗ₜ[Γ(X, W)] m)
        (fun m₁ m₂ => TensorProduct.tmul_add _ m₁ m₂))
        (fun b₁ b₂ => by
          ext m
          simp [TensorProduct.add_tmul]))
      (fun r b m => by
        change algebraMap Γ(Spec (Y.residueField t), ⊤)
            Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W) (r • b) ⊗ₜ[Γ(X, W)] m =
          algebraMap Γ(Spec (Y.residueField t), ⊤)
            Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W) b ⊗ₜ[Γ(X, W)] (r • m)
        rw [Algebra.smul_def, map_mul,
          ← IsScalarTower.algebraMap_apply Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
            Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W),
          IsScalarTower.algebraMap_apply Γ(Y, ⊤) Γ(X, W)
            Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W),
          ← Algebra.smul_def, TensorProduct.smul_tmul,
          IsScalarTower.algebraMap_smul Γ(X, W) r m])
  have hs : ∀ (b : Γ(Spec (Y.residueField t), ⊤)) (m : Γ(M, W)),
      s (b ⊗ₜ[Γ(Y, ⊤)] m) = algebraMap Γ(Spec (Y.residueField t), ⊤)
        Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W) b ⊗ₜ[Γ(X, W)] m :=
    fun b m => TensorProduct.liftAddHom_tmul _ _ b m
  have hs_bij : Function.Bijective s :=
    SectionBaseChange.bijective_addHom_of_isPushout s hs
  refine ⟨⟨AddEquiv.ofBijective (eL.toAddEquiv.toAddMonoidHom.comp s)
    ((EquivLike.bijective eL).comp hs_bij), ?_⟩⟩
  intro b x
  show eL (s (b ⊗ₜ[Γ(Y, ⊤)] x)) = _
  rw [hs b x]
  have hsm : (algebraMap Γ(Spec (Y.residueField t), ⊤)
      Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W) b ⊗ₜ[Γ(X, W)] x :
      TensorProduct Γ(X, W) Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W) Γ(M, W)) =
      algebraMap Γ(Spec (Y.residueField t), ⊤) Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W) b •
        ((1 : Γ(f.fiber t, f.fiberι t ⁻¹ᵁ W)) ⊗ₜ[Γ(X, W)] x) := by
    rw [TensorProduct.smul_tmul', smul_eq_mul, mul_one]
  rw [hsm, map_smul, heL]
  rfl

end FiberChartComparison

/-! ## §6 (Brick 5). Restriction naturality of the chart comparison -/

section FiberChartRes

set_option backward.isDefEq.respectTransparency false in