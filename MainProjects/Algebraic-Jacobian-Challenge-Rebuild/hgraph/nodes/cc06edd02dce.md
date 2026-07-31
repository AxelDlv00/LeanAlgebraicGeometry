---
author: sync
content_type: theorem
created: '2026-07-31T03:02:19'
decl: AlgebraicGeometry.DivisorAdaptation.thetaIdealIncl_app
file: AlgebraicJacobian/Picard/DivisorThetaSheafSequence.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivisorAdaptation.thetaIdealIncl_app
type: lean
updated: '2026-07-31T20:14:50'
---
theorem thetaIdealIncl_app (W : (relCurve C R).Opens) :
    (thetaIdealIncl (A := A) (a := a)).hom.app (op W) =
      ModuleCat.ofHom (A.thetaIdealInclApp (a := a) W) := by
  rw [thetaIdealIncl_hom (A := A) (a := a)]
  rfl