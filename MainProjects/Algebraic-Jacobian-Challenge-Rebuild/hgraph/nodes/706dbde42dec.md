---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: Module.DescentDatum.descentEquiv_tmul
file: AlgebraicJacobian/Descent/ModuleDescent.lean
generated: lean
lean_status: lean_ok
stale: true
title: Module.DescentDatum.descentEquiv_tmul
type: lean
updated: '2026-07-29T15:26:25'
---
@[simp] theorem descentEquiv_tmul [Module.Flat A B] (b : B) (m : D.descended) :
    D.descentEquiv (b ⊗ₜ m) = b • (m : M) := rfl

section Amitsur

variable [Module.FaithfullyFlat A B]