---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.universalMinor
docstring: 'The **localised `J`-minor** `X^I_J` over `R^I_J`: the `J`-minor of `universalMatrix`

  with entries pushed along `R^I → R^I_J = Localization.Away P^I_J`.'
file: AlgebraicJacobian/Picard/GrassmannianChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.universalMinor
type: lean
updated: '2026-07-17T08:41:25'
---
noncomputable def universalMinor (k : Type u) [Field k] (d r : ℕ) (I J : Finset (Fin r))
    (hI : I.card = d) (hJ : J.card = d) :
    Matrix (Fin d) (Fin d) (Localization.Away (minorDet k d r I J hI hJ)) :=
  ((universalMatrix k d r I hI).submatrix id
    (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r))).map (algebraMap _ _)