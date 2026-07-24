---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.basicOpen_mul_le_right
file: AlgebraicJacobian/Picard/DescentClassRepBuild.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.basicOpen_mul_le_right
type: lean
updated: '2026-07-24T17:02:47'
---
private lemma basicOpen_mul_le_right
    (f g : Γ(SA, ⊤)) :
    (SA).basicOpen (f * g) ≤ (SA).basicOpen g :=
  ((SA).basicOpen_mul f g).trans_le inf_le_right

set_option maxHeartbeats 1600000 in
-- the concrete section-ring instance stacks exceed the default budget