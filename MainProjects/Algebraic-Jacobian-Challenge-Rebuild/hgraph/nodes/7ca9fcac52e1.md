---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.map_pulledGluedSubmodule_symm
docstring: 'The pulled glued module is carried onto the kernel of `id ⊗ δ` by the
  inverse

  transport.'
file: AlgebraicJacobian/Picard/DivisorFamilyPullbackGlued.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.map_pulledGluedSubmodule_symm
type: lean
updated: '2026-08-01T09:44:14'
---
lemma map_pulledGluedSubmodule_symm :
    (A.pulledGluedSubmodule R').map
        ((A.chartProdBaseChange R').symm :
          A.pulledChartProd R' →ₗ[R'] R' ⊗[R] A.chartProd) =
      LinearMap.ker (AlgebraTensorModule.lTensor R' R' (A.deltaLeft - A.deltaRight)) :=
  LinearEquiv.map_ker_of_comp_eq (A.chartProdBaseChange R').symm
    (A.ovlProdBaseChange R').symm
    (A.pulledDeltaLeft R' - A.pulledDeltaRight R')
    (AlgebraTensorModule.lTensor R' R' (A.deltaLeft - A.deltaRight))
    (A.delta_baseChange_comm' R')