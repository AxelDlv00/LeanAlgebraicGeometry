---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.Modules.chartLocus
docstring: 'The **chart locus**: the union of all `e`-presentation charts — the

  open locus on which the rank-`e` stratum is a closed subscheme

  [Nitsure §4: the ambient open `V` of the local construction].'
file: AlgebraicJacobian/Picard/FlatteningStratificationUniversal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.chartLocus
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def chartLocus : S.Opens :=
  ⨆ V : {V : S.affineOpens // IsPresentationChart F e V}, V.1.1