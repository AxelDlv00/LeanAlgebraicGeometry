---
author: sync
content_type: theorem
created: '2026-07-24T12:32:23'
decl: AlgebraicGeometry.DivisorAdaptation.finrank_ker_delta_baseChange_eq_of_pulled_degree
docstring: 'If the pulled local-equation divisor has degree `n`, then the fibre kernel
  of the

  original Cech difference map has dimension `n`.  This is the exact `hdim` shape
  used by

  `DivisorAdaptation.isCertified_of_kernel_spanning`.'
file: AlgebraicJacobian/Picard/DivSchemeCertFibreRank.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.finrank_ker_delta_baseChange_eq_of_pulled_degree
type: lean
updated: '2026-07-29T15:31:39'
---
theorem finrank_ker_delta_baseChange_eq_of_pulled_degree {n : Nat}
    (hproj : forall j : A.index, Module.Projective R (A.colength j))
    (hdeg : Scheme.CurveDivisor.deg K
      (Scheme.presentationDivisor K
        ((A.pulledEquations K hproj).presentation)) = (n : Int)) :
    Module.finrank K
      (LinearMap.ker ((A.deltaLeft - A.deltaRight).baseChange K)) = n := by
  let eMap := Submodule.equivMapOfInjective
    (A.chartProdBaseChange K).toLinearMap
    (A.chartProdBaseChange K).injective
    (LinearMap.ker (AlgebraTensorModule.lTensor K K (A.deltaLeft - A.deltaRight)))
  let e :
      LinearMap.ker ((A.deltaLeft - A.deltaRight).baseChange K) ≃ₗ[K]
        A.pulledGluedSubmodule K :=
    (LinearEquiv.ofEq _ _ (A.ker_delta_baseChange_eq_ker_lTensor (K := K))).trans
      (eMap.trans (LinearEquiv.ofEq _ _ (A.map_ker_lTensor_delta K)))
  have hfr := ((A.pullback K hproj).isCertified_of_deg hdeg).finrank_glued
  change Module.finrank K (A.pulledGluedSubmodule K) = n at hfr
  rw [LinearEquiv.finrank_eq e]
  exact hfr