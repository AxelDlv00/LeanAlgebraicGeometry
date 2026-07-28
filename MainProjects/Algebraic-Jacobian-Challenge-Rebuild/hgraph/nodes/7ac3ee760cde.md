---
author: sync
content_type: theorem
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.DivFamZar.existsUnique_glue_of_awaySpan
docstring: '**The away-span glue, uniquely**: the glued class of `exists_glue_of_awaySpan`
  is the

  unique class over `S` restricting to the given family, by `eq_of_awaySpan_eq`.


  **Note what this `∃!` does and does not say.**  It pins the value against *one*
  cover `f` and

  *one* family `F`: it says the glue is determined by that data, not that it is independent
  of

  the data.  Independence across two different covers is a genuinely separate statement
  — for

  the DDR-9 forward map it is `divRepPullGlue_eq_of_chartFactors`

  (`Picard/DivRepAffPullIndep.lean`), and it needs the overlap agreement, not just
  separation.

  An earlier version of this docstring claimed the `∃!` made that argument unnecessary;
  it does

  not, and a fresh-context review caught the overclaim.'
file: AlgebraicJacobian/Picard/DivRepAwaySpanGlue.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivFamZar.existsUnique_glue_of_awaySpan
type: lean
updated: '2026-07-28T13:42:17'
---
theorem existsUnique_glue_of_awaySpan {m : ℕ} (f : Fin m → S)
    (hspan : Ideal.span (Set.range f) = ⊤)
    (F : ∀ p : Fin m, DivFamZar C (Localization.Away (f p)) π n)
    (hcompat : ∀ p q : Fin m,
      DivFamZar.mapAlgHom (awayMulLeft (k := k) f p q) (F p)
        = DivFamZar.mapAlgHom (awayMulRight (k := k) f p q) (F q)) :
    ∃! F₀ : DivFamZar C S π n, ∀ p : Fin m,
      DivFamZar.mapAlgHom (IsScalarTower.toAlgHom k S (Localization.Away (f p))) F₀ = F p := by
  obtain ⟨F₀, hF₀⟩ := exists_glue_of_awaySpan f hspan F hcompat
  exact ⟨F₀, hF₀, fun F₁ hF₁ =>
    eq_of_awaySpan_eq f hspan (fun p => (hF₁ p).trans (hF₀ p).symm)⟩