---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.universalMinor
docstring: 'The **localised `J`-minor** `X^I_J` over `R^I_J` (`def:gr_universal_minor`):
  the

  `J`-minor of `universalMatrix d r I` with entries pushed forward along the structure
  map

  `R^I → R^I_J = Localization.Away (minorDet d r I J)`. Project-local.'
file: AlgebraicJacobian/Picard/GrassmannianCells.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.universalMinor
type: lean
updated: '2026-07-16T21:14:27'
---
noncomputable def universalMinor (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) :
    Matrix (Fin d) (Fin d) (Localization.Away (minorDet d r I J hI hJ)) :=
  ((universalMatrix d r I hI).submatrix id
    (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r))).map (algebraMap _ _)