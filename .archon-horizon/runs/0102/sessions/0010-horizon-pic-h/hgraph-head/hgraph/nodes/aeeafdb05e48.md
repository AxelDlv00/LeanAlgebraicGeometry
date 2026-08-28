---
author: sync
content_type: definition
created: '2026-07-27T01:04:30'
decl: AlgebraicGeometry.gluedOfCharts
docstring: '**The glued object of a chart family**, as a scheme over the base field.  This
  is the

  object represented by `pic0RepresentableByOfCharts`.'
file: AlgebraicJacobian/Picard/JacobianDataCharts.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.gluedOfCharts
type: lean
updated: '2026-08-01T09:44:15'
---
noncomputable abbrev gluedOfCharts : Over (Spec (.of k)) := Over.mk (gluedHom C f hf)