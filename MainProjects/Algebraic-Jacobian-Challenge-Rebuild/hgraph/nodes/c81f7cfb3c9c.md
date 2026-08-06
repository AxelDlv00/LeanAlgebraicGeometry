---
author: sync
content_type: theorem
created: '2026-08-05T02:56:16'
decl: AlgebraicGeometry.not_isOpenImmersion_abelSigmaChartAff_of_not_injective_chartValueAff
docstring: 'Noninjectivity of the widened chart value at one test refutes open immersion
  of the actual

  widened Abel natural transformation.'
file: AlgebraicJacobian/Picard/Pic0HighDegreeRouteGuard.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.not_isOpenImmersion_abelSigmaChartAff_of_not_injective_chartValueAff
type: lean
updated: '2026-08-07T05:01:56'
---
theorem not_isOpenImmersion_abelSigmaChartAff_of_not_injective_chartValueAff
    {T : Over (Spec (.of k))}
    (hnot : ¬ Function.Injective (chartValueAff C n m Z T)) :
    ¬ IsOpenImmersion.presheaf (abelSigmaChartAff C n rep m Z hdeg) := by
  intro hopen
  apply hnot
  intro s₁ s₂ hval
  by_contra hne
  exact (not_injective_abelSigmaChartAff_of_divFamZarAff rep m Z hdeg s₁ s₂ hne hval)
    (injective_of_isOpenImmersion_presheaf hopen (op T.left))

end AbelAff

section Compare

variable [IsAffineHom π]
variable (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)