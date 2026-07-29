---
author: sync
content_type: definition
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.graphCoordEval
docstring: '**The point pullback** `c := t^♯ : Γ(C, U) →ₐ[k] Γ(Spec K, ⊤)` on the
  chart at the

  image point.'
file: AlgebraicJacobian/RiemannRoch/GraphChart.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.graphCoordEval
type: lean
updated: '2026-07-29T15:26:31'
---
noncomputable def graphCoordEval :
    Γ(C.left, graphBaseChart C t) →ₐ[k] Γ((overSpec k K).left, ⊤) :=
  Over.appLEAlgHom t (graphBaseChart C t) ⊤ (top_le_preimage_graphBaseChart C t)