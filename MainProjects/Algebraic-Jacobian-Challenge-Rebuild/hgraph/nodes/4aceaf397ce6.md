---
author: sync
content_type: theorem
created: '2026-07-17T21:01:12'
decl: AlgebraicGeometry.pic0Pullback_coe
file: AlgebraicJacobian/Picard/Pic0Pullback.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.pic0Pullback_coe
type: lean
updated: '2026-07-29T15:26:19'
---
theorem pic0Pullback_coe (g : D ⟶ E) (T : Over (Spec (.of k)))
    (lam : pic0Subgroup E T) :
    (pic0Pullback g T lam : picEt D T) = picEtPullback g T (lam : picEt E T) :=
  rfl