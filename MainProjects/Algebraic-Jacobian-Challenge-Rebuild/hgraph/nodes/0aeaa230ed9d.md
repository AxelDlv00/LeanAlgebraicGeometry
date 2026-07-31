---
author: sync
content_type: lemma
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.graphPoint_mem_productChart
docstring: The graph point lies in the product chart `𝔚(U, ⊤)`.
file: AlgebraicJacobian/RiemannRoch/GraphChart.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.graphPoint_mem_productChart
type: lean
updated: '2026-07-31T20:14:40'
---
lemma graphPoint_mem_productChart :
    Over.graphPoint C t
      ∈ Over.productChart C (overSpec k K) (graphBaseChart C t) ⊤ := by
  rw [Over.mem_productChart]
  refine ⟨?_, trivial⟩
  rw [Over.fst_graphPoint]
  exact basePoint_mem_graphBaseChart C t