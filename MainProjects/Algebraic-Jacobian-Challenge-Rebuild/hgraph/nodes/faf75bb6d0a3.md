---
author: sync
content_type: definition
created: '2026-07-17T21:31:16'
decl: AlgebraicGeometry.windowTransportDatum
docstring: '**The transported theta datum**: the whole-chart theta datum of the base
  field,

  base-changed to `K`.'
file: AlgebraicJacobian/RiemannRoch/WindowFieldTransport.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.windowTransportDatum
type: lean
updated: '2026-07-31T20:15:29'
---
noncomputable def windowTransportDatum : BasicOpenCocycleDatum C K π :=
  (thetaChartDatum C k π a).baseChange K