---
author: sync
content_type: theorem
created: '2026-07-31T00:30:37'
decl: AlgebraicGeometry.seamPair_abelSigmaChartZero_of_subsingleton
docstring: '**THE INHABITANT OF THE SEAM PAIR.**


  Both antecedents of `pic0RepresentableByOfCharts`, at one chart, at once — the thing
  four

  roadmap rows record as unmeasured.  Antecedent 1 is `MorphismProperty.of_isIso`;
  antecedent 2

  is the instance an iso carries.


  Read against the endpoint literature: `Pic0ChartRestrictedFibreSat` shows the pair''s
  clauses

  fail at `V = ⊤` for the *unrestricted divisor scheme* chart and degenerate at `V
  = ⊥`, and

  concludes "any working `V` is a proper intermediate open".  That conclusion is about
  *that*

  chart.  Here the chart source is `Spec k`, and no restriction is used at all — the
  honest

  statement of the interval result is that a working `V` is proper *for a chart whose
  source is

  the divisor scheme of a positive-degree parameter*.'
file: AlgebraicJacobian/Picard/Pic0ChartSeamPairDecided.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.seamPair_abelSigmaChartZero_of_subsingleton
type: lean
updated: '2026-07-31T00:30:37'
---
theorem seamPair_abelSigmaChartZero_of_subsingleton
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - ((0 : ℕ) : ℤ))
    (hvan : ∀ S : Over (Spec (.of k)), Subsingleton (pic0Subgroup C S)) :
    IsOpenImmersion.presheaf (abelSigmaChartZero (C := C) (pi := pi) m Z hdeg) ∧
      Presheaf.IsLocallySurjective Scheme.zariskiTopology
        (abelSigmaChartZero (C := C) (pi := pi) m Z hdeg) := by
  haveI := isIso_abelSigmaChartZero_of_subsingleton C pi m Z hdeg hvan
  exact ⟨MorphismProperty.of_isIso (P := IsOpenImmersion.presheaf) _, inferInstance⟩

variable (C pi) in