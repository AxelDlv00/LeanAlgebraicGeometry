---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.gluedBaseChange
docstring: '**Base change of the glued colength module** (the (c2) keystone): under
  the

  flat-cokernel clauses (c3)/(c4), `R'' ⊗[R] W(d) ≃ₗ[R''] W''` — the `FlatCokernel`

  comparison followed by kernel transport along the `δ`-naturality square.'
file: AlgebraicJacobian/Picard/DivisorFamilyPullbackGlued.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.gluedBaseChange
type: lean
updated: '2026-07-31T20:15:24'
---
noncomputable def gluedBaseChange
    [Module.Flat R (A.chartProd ⧸ A.gluedSubmodule)]
    [Module.Flat R (A.ovlProd ⧸ LinearMap.range (A.deltaLeft - A.deltaRight))] :
    R' ⊗[R] A.Glued ≃ₗ[R'] ↥(A.pulledGluedSubmodule R') :=
  haveI : Module.Flat R
      (A.chartProd ⧸ LinearMap.ker (A.deltaLeft - A.deltaRight)) :=
    ‹Module.Flat R (A.chartProd ⧸ A.gluedSubmodule)›
  (LinearMap.tensorKerEquivOfFlatCoker (A.deltaLeft - A.deltaRight) R').trans
    (((A.chartProdBaseChange R').submoduleMap
        (LinearMap.ker (AlgebraTensorModule.lTensor R' R'
          (A.deltaLeft - A.deltaRight)))).trans
      (LinearEquiv.ofEq _ _ (A.map_ker_lTensor_delta R')))