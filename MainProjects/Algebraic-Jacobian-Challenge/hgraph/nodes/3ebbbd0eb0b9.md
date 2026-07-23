---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.DivFamily.hasFiberDeg_pullbackAlong_degLocusHom
docstring: '**Every `T`-point of `Div` decomposes `T` into clopen constant-degree

  pieces** (the honest form of `Div = ∐_d Div^d`, per-family half): the

  restriction of the family to its degree-`d` locus has constant fibre degree

  `d`.  Together with `iSup_degLocus`/`degLocus_disjoint`/`isClopen_degLocus`

  this is the clopen decomposition the coproduct assembly (campaign G4)

  consumes.'
file: AlgebraicJacobian/Picard/DivDegree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.DivFamily.hasFiberDeg_pullbackAlong_degLocusHom
type: lean
updated: '2026-07-16T21:14:26'
---
theorem hasFiberDeg_pullbackAlong_degLocusHom {T : Over S} (x : DivFamily π T)
    (hlc : IsLocallyConstant x.fiberDeg) (d : ℕ) :
    (x.pullbackAlong (x.degLocusHom hlc d)).HasFiberDeg d := by
  intro t'
  rw [fiberDeg_pullbackAlong]
  exact t'.2