---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.minorDet
docstring: 'The **minor determinant** `P^I_J = det(X^I_J)`: the determinant of the
  `d × d`

  submatrix of `universalMatrix` on the columns indexed by `J`, reindexed to `Fin
  d` via

  the order iso.  Defines the principal open `U^I_J = Spec R^I[1/P^I_J]`.'
file: AlgebraicJacobian/Picard/GrassmannianChart.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Grassmannian.minorDet
type: lean
updated: '2026-07-30T15:27:58'
---
noncomputable def minorDet (k : Type u) [Field k] (d r : ℕ) (I J : Finset (Fin r))
    (hI : I.card = d) (hJ : J.card = d) : ChartRing k d r I :=
  ((universalMatrix k d r I hI).submatrix id
    (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r))).det