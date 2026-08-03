---
author: sync
content_type: theorem
created: '2026-08-03T18:38:51'
decl: AlgebraicGeometry.abelSigmaChartAffAdmissible_eq_sigmaExtension_admissibleAbelTrans
docstring: 'The ambient admissible Abel map is exactly the canonical sigma extension
  of the concrete

  map in the slice over `Spec k`.  This is the comparison needed to consume the separate

  etale-local-surjectivity theorem without adding a representability or surjectivity
  binder.'
file: AlgebraicJacobian/Picard/Pic0AdmissibleAbelKernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.abelSigmaChartAffAdmissible_eq_sigmaExtension_admissibleAbelTrans
type: lean
updated: '2026-08-03T18:38:51'
---
theorem abelSigmaChartAffAdmissible_eq_sigmaExtension_admissibleAbelTrans :
    abelSigmaChartAffAdmissible C =
      (CategoryTheory.Functor.RepresentableBy.yoneda
          (divRepAffAdmissibleScheme C)).toSigmaExtension ≫
        Over.sigmaExtensionNat (admissibleAbelTrans C) := by
  rfl

variable (C) in
/-- Evaluation of the represented admissible Abel map classifies the corresponding widened
divisor family and applies the concrete chart transformation. -/
@[simp]