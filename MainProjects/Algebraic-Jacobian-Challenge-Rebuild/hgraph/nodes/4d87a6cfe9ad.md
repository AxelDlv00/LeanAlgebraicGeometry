---
author: sync
content_type: lemma
created: '2026-08-02T04:08:39'
decl: AlgebraicGeometry.germ_auxWindowRes_mem
docstring: 'The germ of an auxiliary piece restriction of a widened window element
  belongs to the

  cover-independent window germ set.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffWindowGen.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.germ_auxWindowRes_mem
type: lean
updated: '2026-08-02T07:12:52'
---
private lemma germ_auxWindowRes_mem (g : ℕ) (F : CertifiedDivisorFamilyAff C R g)
    (B : DivisorAdaptation C R π F.eqns) (j : B.index)
    {z : relCurve C R} (hz : z ∈ B.pieces j)
    {x : R ⊗[k] ↑(Scheme.divisorSections k
      (windowM_choice π hπ g • fiberWeilDivisor π) ⊤)}
    (hx : x ∈ (F.eps hπ g).1) :
    ((relCurve C R).presheaf.germ (B.pieces j) z hz).hom
      (B.toFinCoverData.windowRes (windowM_choice π hπ g) j
        (relThetaWindowEquiv C R π (windowM_choice π hπ g)
          (relThetaPairH1_windowM C π hπ g) x))
      ∈ eqnsWindowGermSetRel R hπ g F.eqns z := by
  unfold eqnsWindowGermSetRel
  cases j with
  | inl ℓ =>
    refine Set.mem_union_left _
      ⟨relThetaWindowEquiv C R π (windowM_choice π hπ g)
          (relThetaPairH1_windowM C π hπ g) x,
        Submodule.mem_map_of_mem hx,
        le_inf le_top (B.toFinCoverData.pieces_inl_le ℓ) hz, ?_⟩
    exact germ_resHom
      (le_inf le_top (B.toFinCoverData.pieces_inl_le ℓ)) z hz _
  | inr ℓ =>
    refine Set.mem_union_right _
      ⟨relThetaWindowEquiv C R π (windowM_choice π hπ g)
          (relThetaPairH1_windowM C π hπ g) x,
        Submodule.mem_map_of_mem hx,
        le_inf le_top (B.toFinCoverData.pieces_inr_le ℓ) hz, ?_⟩
    exact germ_resHom
      (le_inf le_top (B.toFinCoverData.pieces_inr_le ℓ)) z hz _

set_option maxRecDepth 8000 in
set_option maxHeartbeats 1600000 in
-- The localization, widened certificate and auxiliary restriction towers meet here.
set_option synthInstance.maxHeartbeats 800000 in