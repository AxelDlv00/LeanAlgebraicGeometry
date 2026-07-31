---
author: sync
content_type: lemma
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Scheme.annKernel_le
file: AlgebraicJacobian/RiemannRoch/AnnihilatorKernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.annKernel_le
type: lean
updated: '2026-07-31T20:15:28'
---
lemma Scheme.annKernel_le (U V : Submodule K X.functionField)
    (Λ : Module.Dual K X.functionField) : Scheme.annKernel K U V Λ ≤ U :=
  fun _ hh => hh.1