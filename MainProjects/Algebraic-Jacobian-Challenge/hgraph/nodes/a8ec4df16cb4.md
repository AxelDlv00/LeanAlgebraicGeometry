---
author: sync
content_type: theorem
created: '2026-08-03T23:03:51'
decl: AlgebraicGeometry.Scheme.DivFamily.d3Support_locallyQuasiFinite_of_curve
docstring: 'The finite-fibre producer is visible at the demand ledger and discharges

  the exact locally-quasi-finite binder carried by the divisor pushforward

  theorems.  The remaining D3'' demand is the whole-fibre `ExistsUnique` locus.'
file: AlgebraicJacobian/Projective/DemandLedger.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.DivFamily.d3Support_locallyQuasiFinite_of_curve
type: lean
updated: '2026-08-18T20:52:09'
---
theorem d3Support_locallyQuasiFinite_of_curve
    {S X : Scheme.{u}} {π : X ⟶ S} {T : Over S}
    [SmoothOfRelativeDimension 1 π] [GeometricallyIntegral π] [IsProper π]
    (x : DivFamily π T) :
    LocallyQuasiFinite
      (Modules.schematicSupportι x.F ≫ pullback.snd π T.hom) := by
  infer_instance