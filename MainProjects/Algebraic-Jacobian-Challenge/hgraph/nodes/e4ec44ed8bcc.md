---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.tautologicalQuotientComponent
docstring: 'The per-chart component of the tautological quotient: the adjoint transpose,
  along the

  chart immersion `ι_I`, of the chart quotient `u^I` (`chartQuotientMap`) precomposed
  with

  the free-pullback comparison `pullbackFreeIso (ι_I)`. Project-local helper for

  `tautologicalQuotient`.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.tautologicalQuotientComponent
type: lean
updated: '2026-07-24T03:02:11'
---
noncomputable def tautologicalQuotientComponent (d r : ℕ) (I : (theGlueData d r).J) :
    SheafOfModules.free (R := (scheme d r).ringCatSheaf) (Fin r) ⟶
      (Scheme.Modules.pushforward ((theGlueData d r).ι I)).obj
        (SheafOfModules.free (R := ((theGlueData d r).U I).ringCatSheaf) (Fin d)) :=
  (Scheme.Modules.pullbackPushforwardAdjunction ((theGlueData d r).ι I)).homEquiv _ _
    ((Scheme.Modules.pullbackFreeIso ((theGlueData d r).ι I) (Fin r)).hom ≫
      chartQuotientMap d r I.1 I.2)

set_option maxHeartbeats 1600000 in
-- The `Q`-cancellation rewrites and the final matrix comparison run under the
-- `X.Modules` diamond on the heavy localisation objects; the raised limit covers the
-- `isDefEq` cost (the `bundleTransition_cocycle_transport` precedent).