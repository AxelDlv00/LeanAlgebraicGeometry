---
author: sync
content_type: lemma
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.Scheme.divisorVal_coe
file: AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.divisorVal_coe
type: lean
updated: '2026-07-31T20:15:29'
---
lemma divisorVal_coe {D : X.CurveDivisor} {W : X.Opens} (s : divisorSections K D W) :
    divisorVal K (D := D) (W := W) s = (s : X.functionField) := rfl