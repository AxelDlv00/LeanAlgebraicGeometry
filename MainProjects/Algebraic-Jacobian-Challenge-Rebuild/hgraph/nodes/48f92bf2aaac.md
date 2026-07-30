---
author: sync
content_type: lemma
created: '2026-07-18T22:31:15'
decl: AlgebraicGeometry.span_resSnd_windowBaseChange_le
docstring: Chart-1 mirror of `span_resFst_windowBaseChange_le`.
file: AlgebraicJacobian/Picard/DivSchemeMonoBridgeRelWindow.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.span_resSnd_windowBaseChange_le
type: lean
updated: '2026-07-30T15:27:59'
---
lemma span_resSnd_windowBaseChange_le (D : FinCoverData C R π) (ℓ : Fin D.m₁)
    (N : Submodule R (R ⊗[k] ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤))) :
    Ideal.span ((fun x : relThetaSections C R' π a =>
        (relCurve C R').resHom (le_inf le_top ((D.baseChange R').pieces_inr_le ℓ))
          x.val.2) ''
        ↑(Submodule.map (relThetaWindowEquiv C R' π a hH1).toLinearMap
            (windowBaseChange R' N)))
      ≤ Ideal.span (D.piecesMap R' (Sum.inr ℓ) ''
          ((fun x => (relCurve C R).resHom (le_inf le_top (D.pieces_inr_le ℓ))
            ((relThetaWindowEquiv C R π a hH1 x).val.2)) '' ↑N)) := by
  have main : ∀ w ∈ N.baseChange R',
      (relCurve C R').resHom (le_inf le_top ((D.baseChange R').pieces_inr_le ℓ))
        ((relThetaWindowEquiv C R' π a hH1
          (TensorProduct.AlgebraTensorModule.cancelBaseChange k R R' R' _ w)).val.2)
      ∈ Ideal.span (D.piecesMap R' (Sum.inr ℓ) ''
          ((fun x => (relCurve C R).resHom (le_inf le_top (D.pieces_inr_le ℓ))
            ((relThetaWindowEquiv C R π a hH1 x).val.2)) '' ↑N)) := by
    intro w hw
    rw [Submodule.baseChange_eq_span] at hw
    induction hw using Submodule.span_induction with
    | mem w hmem =>
      obtain ⟨m, hm, rfl⟩ := hmem
      have key : (relCurve C R').resHom
          (le_inf le_top ((D.baseChange R').pieces_inr_le ℓ))
          ((relThetaWindowEquiv C R' π a hH1
            (TensorProduct.AlgebraTensorModule.cancelBaseChange k R R' R' _
              ((TensorProduct.mk R R' _ 1) m))).val.2)
          = D.piecesMap R' (Sum.inr ℓ)
              ((relCurve C R).resHom (le_inf le_top (D.pieces_inr_le ℓ))
                ((relThetaWindowEquiv C R π a hH1 m).val.2)) :=
        (Scheme.resHom_resHom (le_inf le_top le_rfl)
            ((D.baseChange R').pieces_inr_le ℓ) _).symm.trans
          (((congrArg ((relCurve C R').resHom ((D.baseChange R').pieces_inr_le ℓ))
            (resHom_relThetaWindowEquiv_cancelBaseChange_snd C R R' π a hH1 m)).trans
              (resHom_relSectionsMap_pieces₁ D ℓ _)).trans
            (congrArg (D.piecesMap R' (Sum.inr ℓ))
              (Scheme.resHom_resHom (le_inf le_top le_rfl) (D.pieces_inr_le ℓ) _)))
      have hmem2 : D.piecesMap R' (Sum.inr ℓ)
          ((relCurve C R).resHom (le_inf le_top (D.pieces_inr_le ℓ))
            ((relThetaWindowEquiv C R π a hH1 m).val.2))
          ∈ Ideal.span (D.piecesMap R' (Sum.inr ℓ) ''
            ((fun x => (relCurve C R).resHom (le_inf le_top (D.pieces_inr_le ℓ))
              ((relThetaWindowEquiv C R π a hH1 x).val.2)) '' ↑N)) :=
        Ideal.subset_span ⟨_, ⟨m, hm, rfl⟩, rfl⟩
      exact key.symm ▸ hmem2
    | zero =>
      simp only [map_zero, Submodule.coe_zero, Prod.snd_zero]
      exact (Ideal.span _).zero_mem
    | add w₁ w₂ hw₁ hw₂ h₁ h₂ =>
      simp only [map_add, Submodule.coe_add, Prod.snd_add]
      exact (Ideal.span _).add_mem h₁ h₂
    | smul c w hw h =>
      simp only [map_smul, Submodule.coe_smul, Prod.smul_snd]
      rw [resHom_smul_rel' C R' _ c _]
      exact Submodule.smul_of_tower_mem _ c h
  rw [Ideal.span_le]
  rintro _ ⟨x', hx', rfl⟩
  obtain ⟨y, hy, rfl⟩ := hx'
  rw [windowBaseChange] at hy
  obtain ⟨w, hw, rfl⟩ := hy
  exact main w hw