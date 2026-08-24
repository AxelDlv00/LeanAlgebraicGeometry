---
author: sync
content_type: theorem
created: '2026-08-03T22:58:50'
decl: AlgebraicGeometry.abelSigmaChartAffAdmissible_app_left_eq_iff_forall_picClass_div_mem_picFromBase
docstring: 'The kernel of the actual ambient admissible Abel chart on points over
  a fixed test scheme is

  exactly relative linear equivalence, including the quotient by classes pulled back
  from the

  base.'
file: AlgebraicJacobian/Picard/Pic0AdmissibleAbelKernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.abelSigmaChartAffAdmissible_app_left_eq_iff_forall_picClass_div_mem_picFromBase
type: lean
updated: '2026-08-18T20:51:04'
---
theorem abelSigmaChartAffAdmissible_app_left_eq_iff_forall_picClass_div_mem_picFromBase
    {T : Over (Spec (.of k))}
    (q₁ q₂ : T ⟶ divRepAffAdmissibleScheme C) :
    (abelSigmaChartAffAdmissible C).app (op T.left) q₁.left =
        (abelSigmaChartAffAdmissible C).app (op T.left) q₂.left
      ↔ ∀ U : T.left.affineOpens,
          (((divFunctorAff_admissible_representableBy C).homEquiv q₁).1 U).picClass /
              (((divFunctorAff_admissible_representableBy C).homEquiv q₂).1 U).picClass
            ∈ picFromBase C (overSpec k Γ(T.left, U.1)) := by
  rw [abelSigmaChartAffAdmissible_app_left C q₁,
    abelSigmaChartAffAdmissible_app_left C q₂]
  change (⟨T.hom, (admissibleAbelTrans C).app (op T) q₁⟩ :
      (pic0SigmaSheaf C).1.obj (op T.left)) =
        ⟨T.hom, (admissibleAbelTrans C).app (op T) q₂⟩ ↔ _
  rw [Sigma.mk.inj_iff]
  simp only [heq_eq_eq, true_and]
  exact admissibleAbelTrans_app_eq_iff_forall_picClass_div_mem_picFromBase C q₁ q₂