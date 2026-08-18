---
author: sync
content_type: theorem
created: '2026-08-04T10:53:20'
decl: AlgebraicGeometry.Scheme.LocalEquations.cartierIdealData_ideal
file: AlgebraicJacobian/Picard/DivisorIntrinsicIdealSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.LocalEquations.cartierIdealData_ideal
type: lean
updated: '2026-08-18T20:51:02'
---
theorem cartierIdealData_ideal [IsProper C.hom]
    (d : (relCurve C R).LocalEquations) (U : (relCurve C R).affineOpens) :
    d.cartierIdealData.ideal U = d.sectionIdeal U.1 :=
  rfl