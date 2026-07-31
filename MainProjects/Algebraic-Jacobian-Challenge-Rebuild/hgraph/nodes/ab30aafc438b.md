---
author: sync
content_type: definition
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.graphTensorEval
docstring: 'The tensor-level point evaluation `Γ(C, U) ⊗[k] F → F`, `a ⊗ λ ↦ c a ·
  λ`

  (`AlgebraicJacobian.Diagonal.pointEv` with the transported coordinate).'
file: AlgebraicJacobian/RiemannRoch/GraphChart.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.graphTensorEval
type: lean
updated: '2026-07-31T20:14:49'
---
noncomputable def graphTensorEval :
    Γ(C.left, graphBaseChart C t) ⊗[k] Γ((overSpec k K).left, ⊤)
      →ₐ[k] Γ((overSpec k K).left, ⊤) :=
  Algebra.TensorProduct.lift (graphCoordEval C t) (AlgHom.id k _)
    (fun _ _ => Commute.all _ _)