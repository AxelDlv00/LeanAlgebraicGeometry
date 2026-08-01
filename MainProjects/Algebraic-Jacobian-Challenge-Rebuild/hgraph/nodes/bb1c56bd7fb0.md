---
author: sync
content_type: theorem
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.ThetaGeneratorSeed.le_vanishingSubmodule
docstring: '**The vanishing law (the DDR-5 containment half)**: every element of `K`
  vanishes

  along the constructed local-equation system — `K ⊆ H⁰(𝒪(Θᵃ − d))` in the DD-4 spelling

  `Scheme.LocalEquations.vanishingSubmodule`.'
file: AlgebraicJacobian/Picard/DivSchemeFamily.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaGeneratorSeed.le_vanishingSubmodule
type: lean
updated: '2026-08-01T09:44:11'
---
theorem le_vanishingSubmodule [IsNoetherianRing R] (hD : D.IsGenerator) :
    K ≤ (D.localEquations hD).vanishingSubmodule R
      (relCover C R (fiberTwoCover π)).V₀ (relCover C R (fiberTwoCover π)).V₁
      (relThetaCocycle C R π a) := by
  intro ψ hψ
  rw [Scheme.LocalEquations.mem_vanishingSubmodule_iff]
  constructor
  · -- chart-0 component
    intro z hz
    have hz₀ : z ∈ relPinnedChart C R π false := hz.2
    -- work on the overlap of the piece of `z` with the pinned chart 0
    have hWle : D.piece z ⊓ relPinnedChart C R π false
        ≤ relPinnedChart C R π (D.side z) ⊓ relPinnedChart C R π false :=
      inf_le_inf (D.piece_le z) le_rfl
    have hzW : z ∈ D.piece z ⊓ relPinnedChart C R π false := ⟨D.mem_piece z, hz₀⟩
    -- the chart-0 component matches the side component through the side unit
    have hmatch := relThetaResSide_matching a false (D.side z) (le_inf
      (inf_le_right : D.piece z ⊓ relPinnedChart C R π false ≤ _)
      (inf_le_left.trans (D.piece_le z))) ψ
    -- germ of the side component lies in the stalk ideal
    have hside := D.germ_relThetaResSide_mem_span hD z hψ (D.mem_piece z)
    have hgermside : ((relCurve C R).presheaf.germ
        (D.piece z ⊓ relPinnedChart C R π false) z hzW).hom
          (relThetaResSide a (D.side z)
            ((le_inf (inf_le_right : D.piece z ⊓ relPinnedChart C R π false ≤ _)
              (inf_le_left.trans (D.piece_le z))).trans inf_le_right) ψ)
        ∈ (D.localEquations hD).stalkIdeal z := by
      rw [show relThetaResSide a (D.side z)
          ((le_inf (inf_le_right : D.piece z ⊓ relPinnedChart C R π false ≤ _)
            (inf_le_left.trans (D.piece_le z))).trans inf_le_right) ψ
          = (relCurve C R).resHom (inf_le_left : D.piece z ⊓ relPinnedChart C R π false
              ≤ D.piece z)
            (relThetaResSide a (D.side z) (D.piece_le z) ψ) from
        (resHom_relThetaResSide a (D.side z) (D.piece_le z) inf_le_left ψ).symm]
      rw [show ((relCurve C R).presheaf.germ
          (D.piece z ⊓ relPinnedChart C R π false) z hzW).hom
            ((relCurve C R).resHom (inf_le_left : D.piece z ⊓ relPinnedChart C R π false
              ≤ D.piece z) (relThetaResSide a (D.side z) (D.piece_le z) ψ))
          = ((relCurve C R).presheaf.germ (D.piece z) z (D.mem_piece z)).hom
            (relThetaResSide a (D.side z) (D.piece_le z) ψ) from
        TopCat.Presheaf.germ_res_apply _ _ _ _ _]
      rw [stalkIdeal_localEquations]
      exact D.germ_relThetaResSide_mem_span hD z hψ (D.mem_piece z)
    -- transport across the side unit
    have hkey := congrArg ((relCurve C R).presheaf.germ
      (D.piece z ⊓ relPinnedChart C R π false) z hzW).hom hmatch
    rw [map_mul] at hkey
    have hgerm₀ : ((relCurve C R).presheaf.germ
        (D.piece z ⊓ relPinnedChart C R π false) z hzW).hom
          (relThetaResSide a false ((le_inf
            (inf_le_right : D.piece z ⊓ relPinnedChart C R π false ≤ _)
            (inf_le_left.trans (D.piece_le z))).trans inf_le_left) ψ)
        = ((relCurve C R).presheaf.germ
            (⊤ ⊓ (relCover C R (fiberTwoCover π)).V₀) z hz).hom ψ.val.1 := by
      rw [relThetaResSide_false]
      exact TopCat.Presheaf.germ_res_apply _ _ _ _ _
    rw [hgerm₀] at hkey
    rw [hkey]
    exact Ideal.mul_mem_left _ _ hgermside
  · -- chart-1 component
    intro z hz
    have hz₁ : z ∈ relPinnedChart C R π true := hz.2
    have hzW : z ∈ D.piece z ⊓ relPinnedChart C R π true := ⟨D.mem_piece z, hz₁⟩
    have hmatch := relThetaResSide_matching a true (D.side z) (le_inf
      (inf_le_right : D.piece z ⊓ relPinnedChart C R π true ≤ _)
      (inf_le_left.trans (D.piece_le z))) ψ
    have hgermside : ((relCurve C R).presheaf.germ
        (D.piece z ⊓ relPinnedChart C R π true) z hzW).hom
          (relThetaResSide a (D.side z)
            ((le_inf (inf_le_right : D.piece z ⊓ relPinnedChart C R π true ≤ _)
              (inf_le_left.trans (D.piece_le z))).trans inf_le_right) ψ)
        ∈ (D.localEquations hD).stalkIdeal z := by
      rw [show relThetaResSide a (D.side z)
          ((le_inf (inf_le_right : D.piece z ⊓ relPinnedChart C R π true ≤ _)
            (inf_le_left.trans (D.piece_le z))).trans inf_le_right) ψ
          = (relCurve C R).resHom (inf_le_left : D.piece z ⊓ relPinnedChart C R π true
              ≤ D.piece z)
            (relThetaResSide a (D.side z) (D.piece_le z) ψ) from
        (resHom_relThetaResSide a (D.side z) (D.piece_le z) inf_le_left ψ).symm]
      rw [show ((relCurve C R).presheaf.germ
          (D.piece z ⊓ relPinnedChart C R π true) z hzW).hom
            ((relCurve C R).resHom (inf_le_left : D.piece z ⊓ relPinnedChart C R π true
              ≤ D.piece z) (relThetaResSide a (D.side z) (D.piece_le z) ψ))
          = ((relCurve C R).presheaf.germ (D.piece z) z (D.mem_piece z)).hom
            (relThetaResSide a (D.side z) (D.piece_le z) ψ) from
        TopCat.Presheaf.germ_res_apply _ _ _ _ _]
      rw [stalkIdeal_localEquations]
      exact D.germ_relThetaResSide_mem_span hD z hψ (D.mem_piece z)
    have hkey := congrArg ((relCurve C R).presheaf.germ
      (D.piece z ⊓ relPinnedChart C R π true) z hzW).hom hmatch
    rw [map_mul] at hkey
    have hgerm₁ : ((relCurve C R).presheaf.germ
        (D.piece z ⊓ relPinnedChart C R π true) z hzW).hom
          (relThetaResSide a true ((le_inf
            (inf_le_right : D.piece z ⊓ relPinnedChart C R π true ≤ _)
            (inf_le_left.trans (D.piece_le z))).trans inf_le_left) ψ)
        = ((relCurve C R).presheaf.germ
            (⊤ ⊓ (relCover C R (fiberTwoCover π)).V₁) z hz).hom ψ.val.2 := by
      rw [relThetaResSide_true]
      exact TopCat.Presheaf.germ_res_apply _ _ _ _ _
    rw [hgerm₁] at hkey
    rw [hkey]
    exact Ideal.mul_mem_left _ _ hgermside