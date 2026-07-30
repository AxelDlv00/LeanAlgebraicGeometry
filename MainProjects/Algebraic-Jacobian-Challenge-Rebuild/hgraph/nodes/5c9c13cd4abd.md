---
author: sync
content_type: theorem
created: '2026-07-30T07:28:28'
decl: AlgebraicGeometry.finite_divisorWindow_quot_of_isCertified
docstring: '**The three window-quotient hypotheses from a chart-typed certificate
  on the SAME `d`** —

  finiteness.'
file: ScratchWR/probe_r7_nogo_noeth.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.finite_divisorWindow_quot_of_isCertified
type: lean
updated: '2026-07-31T03:02:52'
---
theorem finite_divisorWindow_quot_of_isCertified {d : (relCurve C R).LocalEquations}
    (A : DivisorAdaptation C R π d) (hc : A.IsCertified g) :
    Module.Finite R ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸ divisorWindow d ha1) :=
  haveI := hc.finite_thetaGlued a
  Module.Finite.equiv (windowQuotEquiv A ha1
    (hc.thetaGluedEval_surjective (C := C) (π := π) hπ hO hχ ha1 hMa)).symm

include hπ hO hχ hMa in