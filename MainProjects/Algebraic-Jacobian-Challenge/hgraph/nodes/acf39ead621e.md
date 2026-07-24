---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.overRestrictPresentation
docstring: '**Slice presentation ⟹ geometric-restriction presentation** (gap1, P1).


  Given a sheaf of modules `M` on `X`, an open `U ⊆ X`, and a `SheafOfModules.Presentation`
  of the

  abstract Grothendieck-slice restriction `M.over U`, there is a `SheafOfModules.Presentation`
  of the

  *geometric* restriction `(pullback U.ι).obj M = U.ι^* M` on the open subscheme `U.toScheme`.
  The

  transport is `Presentation.map` along the slice-to-geometric equivalence functor
  (using the unit-iso

  `overRestrictUnitIso`) followed by `Presentation.ofIsIso` across the bridge

  `overRestrictPullbackIso` (gap1, C).


  This closes the slice-touching step of the gap1 per-element transport

  `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` (P1): with `U = q.X i` and

  `P = q.presentation i` it produces a global presentation of `U.ι^* M`; the remaining
  geometric step

  restricts further to a basic affine `D(r) ≅ Spec R_r` and concludes via

  `isIso_fromTildeΓ_of_presentation`. Project-local.'
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.overRestrictPresentation
type: lean
updated: '2026-07-25T06:32:31'
---
noncomputable def overRestrictPresentation (U : X.Opens) (M : X.Modules)
    (P : (M.over U).Presentation) : ((Scheme.Modules.pullback U.ι).obj M).Presentation :=
  SheafOfModules.Presentation.ofIsIso.{u} (overRestrictPullbackIso U M).hom
    (SheafOfModules.Presentation.map.{u} P (overRestrictEquiv U).functor (overRestrictUnitIso U))

set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 2000000 in
-- Reconstructing a global presentation expands the cover colimit and sheafification instances.
set_option synthInstance.maxHeartbeats 800000 in
set_option backward.isDefEq.respectTransparency false in