---
author: sync
content_type: theorem
created: '2026-07-28T17:25:25'
decl: AlgebraicGeometry.AffAdaptation.flat_coker_incl_pullback
docstring: '(c3) transport: the cokernel of the pulled glued inclusion is flat.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffCert.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.flat_coker_incl_pullback
type: lean
updated: '2026-07-29T15:26:34'
---
theorem flat_coker_incl_pullback
    [Module.Flat R (A.chartProd ⧸ A.gluedSubmodule)]
    [Module.Flat R (A.ovlProd ⧸ LinearMap.range (A.deltaLeft - A.deltaRight))] :
    Module.Flat R' ((A.pullback R' hproj).chartProd ⧸
      (A.pullback R' hproj).gluedSubmodule) := by
  refine Module.Flat.of_linearEquiv
    (N := (A.pullback R' hproj).chartProd ⧸ (A.pullback R' hproj).gluedSubmodule)
    (M := R' ⊗[R] (A.chartProd ⧸ A.gluedSubmodule)) ?_
  refine (Submodule.Quotient.equiv ((A.pullback R' hproj).gluedSubmodule)
      (LinearMap.ker (AlgebraTensorModule.lTensor R' R' (A.deltaLeft - A.deltaRight)))
      (A.chartProdBaseChange R' hproj).symm
      (A.map_pulledGluedSubmodule_symm R' hproj hinf)).trans
    ((Submodule.quotEquivOfEq _ _ (A.range_baseChange_gluedSubtype R').symm).trans
      (((LinearMap.quotRangeBaseChangeEquiv R' (A.gluedSubmodule).subtype).symm).trans
        (TensorProduct.AlgebraTensorModule.congr (LinearEquiv.refl R' R')
          (Submodule.quotEquivOfEq _ _ (Submodule.range_subtype A.gluedSubmodule)))))

omit [Algebra k R'] [IsScalarTower k R R'] in