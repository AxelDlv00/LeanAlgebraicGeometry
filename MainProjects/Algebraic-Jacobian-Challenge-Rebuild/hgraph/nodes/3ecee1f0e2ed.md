---
author: sync
content_type: definition
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.divFunctorAff_representableBy
docstring: 'The widened divisor functor is represented by its chosen scheme, with
  no genus or chart-basis

  hypothesis.'
file: AlgebraicJacobian/Picard/DivRepChartClassUnivAffRepresentable.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divFunctorAff_representableBy
type: lean
updated: '2026-08-03T13:09:52'
---
noncomputable def divFunctorAff_representableBy :
    (divFunctorAff C g).RepresentableBy (divRepAffScheme C hpi g hO hchi) :=
  (divFunctorAffRepresenter C hpi g hO hchi).2

omit hchi in