---
author: sync
content_type: theorem
created: '2026-07-29T06:51:20'
decl: AlgebraicGeometry.divisorWindow_eq_of_le_of_isCertified_of_quotientData
docstring: '**The landed chart-typed statement is a corollary** — recorded as a lemma
  so that the

  generalisation above is machine-checked rather than asserted in prose.  The three

  window-quotient facts come from the certificate through `windowQuotEquiv`, exactly
  as in the

  landed proof; what the corollary shows is that nothing else in that proof used `A`.'
file: AlgebraicJacobian/Picard/DivRepChartClassUnivQuot.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divisorWindow_eq_of_le_of_isCertified_of_quotientData
type: lean
updated: '2026-07-29T15:26:32'
---
theorem divisorWindow_eq_of_le_of_isCertified_of_quotientData
    (A : DivisorAdaptation C R π d) (hc : A.IsCertified g)
    (hH1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1)
    (x : Grassmannian.grFunctorAff k
      (↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) g R)
    (hsurj : Function.Surjective (A.thetaGluedEval a))
    (hle : x.toSubmodule ≤ divisorWindow d hH1) :
    divisorWindow d hH1 = x.toSubmodule := by
  -- the two window-quotient facts, transported off the certificate by `windowQuotEquiv`.
  -- The `Module.Finite`/`Module.Projective` slots of `A.ThetaGlued a` are certificate
  -- CONSEQUENCES rather than instances, so they are introduced explicitly (`haveI`) before
  -- the transport: `Module.Projective.of_equiv` needs the source side in scope, and leaving
  -- it to synthesis fails.
  haveI := hc.finite_thetaGlued (A := A) a
  haveI := hc.projective_thetaGlued (A := A) a
  refine divisorWindow_eq_of_le_of_quotientData hH1 x
    (Module.Projective.of_equiv (windowQuotEquiv A hH1 hsurj).symm) (fun p => ?_) hle
  rw [congrFun (Module.rankAtStalk_eq_of_equiv (windowQuotEquiv A hH1 hsurj)) p]
  exact hc.rankAtStalk_thetaGlued a p