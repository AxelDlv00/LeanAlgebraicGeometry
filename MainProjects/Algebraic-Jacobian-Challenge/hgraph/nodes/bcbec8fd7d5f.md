---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.chartOverlap
docstring: 'The principal-open overlap `U^I_J = Spec R^I[1/P^I_J]` as a scheme: the
  affine

  spectrum of the away-localisation of the chart ring `R^I` at the minor determinant

  `P^I_J`. Project-local: the `V`-object of the Grassmannian glue data.'
file: AlgebraicJacobian/Picard/GrassmannianCells.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.chartOverlap
type: lean
updated: '2026-07-24T03:02:10'
---
noncomputable def chartOverlap (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) : Scheme :=
  Spec (CommRingCat.of (Localization.Away (minorDet d r I J hI hJ)))