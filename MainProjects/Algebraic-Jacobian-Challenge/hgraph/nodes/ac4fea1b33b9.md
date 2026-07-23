---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.overRestrictPresentationInv
docstring: '**(Piece A, L2) Geometric presentation back-transported to a slice presentation.**

  Dual to `overRestrictPresentation`: a presentation of the geometric pullback `(V.ι^*)
  M` yields a

  presentation of the abstract Grothendieck slice `M.over V`. Transport the given
  presentation across

  `(overRestrictPullbackIso V M).inv` (`Presentation.ofIsIso`), `Presentation.map`
  along the inverse

  slice-equivalence functor (using `overRestrictUnitIsoInv V`), then collapse the
  round trip across the

  equivalence unit iso. Project-local.'
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.overRestrictPresentationInv
type: lean
updated: '2026-07-24T03:02:11'
---
noncomputable def overRestrictPresentationInv (V : X.Opens) (M : X.Modules)
    (P : ((Scheme.Modules.pullback V.ι).obj M).Presentation) : (M.over V).Presentation :=
  SheafOfModules.Presentation.ofIsIso.{u}
    ((overRestrictEquiv V).unitIso.symm.app (M.over V)).hom
    (SheafOfModules.Presentation.map.{u}
      (SheafOfModules.Presentation.ofIsIso.{u} (overRestrictPullbackIso V M).inv P)
      (overRestrictEquiv V).inverse (overRestrictUnitIsoInv V).symm)