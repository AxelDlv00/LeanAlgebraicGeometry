---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.minorDet
docstring: 'The **minor determinant** `P^I_J = det(X^I_J)` (`def:gr_minor_det`): the
  determinant

  of the `d × d` submatrix of `universalMatrix d r I` whose columns are those indexed
  by

  `J`, reindexed to `Fin d` via the order iso `Fin d ≃o ↥J`. Project-local: defines
  the

  principal open `U^I_J = Spec R^I[1/P^I_J]`.'
file: AlgebraicJacobian/Picard/GrassmannianCells.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.minorDet
type: lean
updated: '2026-07-24T03:02:10'
---
noncomputable def minorDet (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) : MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ :=
  ((universalMatrix d r I hI).submatrix id
    (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r))).det