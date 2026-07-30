---
author: sync
content_type: lemma
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Scheme.annKernel_le
file: AlgebraicJacobian/RiemannRoch/AnnihilatorKernel.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.annKernel_le
type: lean
updated: '2026-07-30T15:27:56'
---
lemma Scheme.annKernel_le (U V : Submodule K X.functionField)
    (Λ : Module.Dual K X.functionField) : Scheme.annKernel K U V Λ ≤ U :=
  fun _ hh => hh.1