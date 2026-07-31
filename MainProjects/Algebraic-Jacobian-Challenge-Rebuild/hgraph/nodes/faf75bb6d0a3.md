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
stale: true
title: AlgebraicGeometry.windowTransportDatum
type: lean
updated: '2026-07-31T20:14:52'
---
noncomputable def windowTransportDatum : BasicOpenCocycleDatum C K π :=
  (thetaChartDatum C k π a).baseChange K