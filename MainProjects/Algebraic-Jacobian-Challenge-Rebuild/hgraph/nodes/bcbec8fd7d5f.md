---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.chartOverlap
docstring: 'The principal-open chart overlap `U^I_J = Spec R^I[1/P^I_J]`: the `V`-object
  of the

  Grassmannian glue data.'
file: AlgebraicJacobian/Picard/GrassmannianGlue.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Grassmannian.chartOverlap
type: lean
updated: '2026-07-31T20:14:49'
---
noncomputable def chartOverlap (k : Type u) [Field k] (d r : ℕ) (I J : Finset (Fin r))
    (hI : I.card = d) (hJ : J.card = d) : Scheme :=
  Spec (CommRingCat.of (Localization.Away (minorDet k d r I J hI hJ)))