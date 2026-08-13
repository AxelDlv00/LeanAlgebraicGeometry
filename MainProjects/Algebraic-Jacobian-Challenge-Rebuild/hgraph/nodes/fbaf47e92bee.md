---
author: sync
content_type: theorem
created: '2026-08-05T04:36:57'
decl: AlgebraicGeometry.PicRankOneLocalPresentation.evaluation_evaluationLiftOfH0
docstring: 'Evaluation of the canonical unit-lift returns the original native global
  section.


  This is the right triangle identity of pullback-pushforward.  It is the counit compatibility

  needed before the section can be used to define a divisor; no zero-locus claim is
  made here.'
file: AlgebraicJacobian/Picard/Pic0RankOnePresentation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRankOneLocalPresentation.evaluation_evaluationLiftOfH0
type: lean
updated: '2026-08-13T22:44:52'
---
theorem evaluation_evaluationLiftOfH0 (P : PicRankOneLocalPresentation pi lam)
    (y : Sheaf.HModule P.datum.sheaf 0) :
    (Scheme.Modules.Hom.app P.evaluation
      ((relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier)) ⁻¹ᵁ
        (⊤ : (Spec (.of P.cover.Carrier)).Opens))).hom
      (P.evaluationLiftOfH0 y) = P.pushforwardSectionOfH0 y := by
  have h := congrArg
    (fun (f : (Scheme.Modules.pushforward
        (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj P.module ⟶
      (Scheme.Modules.pushforward
        (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj P.module) =>
      (Scheme.Modules.Hom.app f (⊤ : (Spec (.of P.cover.Carrier)).Opens)).hom
        (P.pushforwardSectionOfH0 y))
    ((Scheme.Modules.pullbackPushforwardAdjunction
      (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).right_triangle_components
        P.module)
  exact h

/-! ## Local-away generators for the canonical evaluation -/