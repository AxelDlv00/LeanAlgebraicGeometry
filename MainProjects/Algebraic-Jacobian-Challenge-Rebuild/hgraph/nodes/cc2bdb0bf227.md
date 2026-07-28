---
author: sync
content_type: lemma
created: '2026-07-28T17:25:25'
decl: AlgebraicGeometry.AffAdaptation.map_ker_lTensor_delta
file: AlgebraicJacobian/Picard/DivisorFamilyAffCert.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.map_ker_lTensor_delta
type: lean
updated: '2026-07-28T17:25:25'
---
lemma map_ker_lTensor_delta :
    (LinearMap.ker (AlgebraTensorModule.lTensor R' R' (A.deltaLeft - A.deltaRight))).map
        (A.chartProdBaseChange R' hproj :
          R' ⊗[R] A.chartProd →ₗ[R'] (A.pullback R' hproj).chartProd) =
      (A.pullback R' hproj).gluedSubmodule :=
  LinearEquiv.map_ker_of_comp_eq (A.chartProdBaseChange R' hproj)
    (A.ovlProdBaseChange R' hproj hinf)
    (AlgebraTensorModule.lTensor R' R' (A.deltaLeft - A.deltaRight))
    ((A.pullback R' hproj).deltaLeft - (A.pullback R' hproj).deltaRight)
    (A.delta_baseChange_comm R' hproj hinf)

include hinf in