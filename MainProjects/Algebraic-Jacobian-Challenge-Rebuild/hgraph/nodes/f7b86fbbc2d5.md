---
author: sync
content_type: theorem
created: '2026-07-17T10:19:49'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.termBaseChangeInf_tmul
docstring: The overlap term base change on a pure tensor.
file: AlgebraicJacobian/Cohomology/GluedSheafH0BaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.termBaseChangeInf_tmul
type: lean
updated: '2026-07-17T10:19:49'
---
theorem termBaseChangeInf_tmul (b' : B')
    (s : D.sheaf.obj.obj (op ((relCover C B (fiberTwoCover π)).V₀ ⊓
      (relCover C B (fiberTwoCover π)).V₁))) :
    D.termBaseChangeInf B' (b' ⊗ₜ[B] s) =
      b' • D.sectionsMap B'
        (le_preimage_chart B' ((fiberTwoCover π).V₀ ⊓ (fiberTwoCover π).V₁)) s := by
  letI : Scheme.QcohOn D.sheaf
      ((fst C (overSpec k B)).left ⁻¹ᵁ ((fiberTwoCover π).V₀ ⊓ (fiberTwoCover π).V₁)) :=
    gluedQcohOn B D.pieces D.unit D.isGluingCocycle (σ := Sum.inl) (h := D.hInf)
      D.basicOpen_hInf_le D.coverInf
  letI : Scheme.QcohOn (D.baseChange B').sheaf
      ((fst C (overSpec k B')).left ⁻¹ᵁ ((fiberTwoCover π).V₀ ⊓ (fiberTwoCover π).V₁)) :=
    gluedQcohOn B' (D.baseChange B').pieces (D.baseChange B').unit
      (D.baseChange B').isGluingCocycle (σ := Sum.inl) (h := (D.baseChange B').hInf)
      (D.baseChange B').basicOpen_hInf_le (D.baseChange B').coverInf
  exact D.termBaseChange_tmul B' ((fiberTwoCover π).V₀ ⊓ (fiberTwoCover π).V₁) Sum.inl D.hInf
    (fiberTwoCover π).isAffineOpen_inf.isCompact
    (fiberTwoCover π).isAffineOpen_inf.isQuasiSeparated
    (relCover C B (fiberTwoCover π)).isAffineOpen_inf
    (relCover C B' (fiberTwoCover π)).isAffineOpen_inf
    (fun _ _ _ => rfl) (fun _ _ _ => rfl) D.basicOpen_hInf_le D.span_range_hInf b' s

/-! ## The degree-zero term base change and the δ-naturality square -/