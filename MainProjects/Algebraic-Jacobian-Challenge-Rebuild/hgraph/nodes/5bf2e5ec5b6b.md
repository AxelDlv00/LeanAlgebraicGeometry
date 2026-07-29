---
author: sync
content_type: lemma
created: '2026-07-17T23:01:28'
decl: AlgebraicGeometry.divFam.toZarVehicle_val
file: AlgebraicJacobian/Picard/DivisorFamilyZarVehicle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divFam.toZarVehicle_val
type: lean
updated: '2026-07-29T15:31:45'
---
lemma divFam.toZarVehicle_val {T : Over (Spec (.of k))} (s : divFam C π n T)
    (U : T.left.affineOpens) :
    (divFam.toZarVehicle s).1 U = (s.1 U).toZar :=
  rfl