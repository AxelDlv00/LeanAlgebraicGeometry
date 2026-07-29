---
author: sync
content_type: lemma
created: '2026-07-24T17:02:47'
decl: AlgebraicGeometry.mem_V₁_of_notMem_V₀
docstring: 'A point off the first pinned chart lies in the second: the pinned charts
  cover.'
file: AlgebraicJacobian/Picard/DivisorFamilyFieldDictionaryCore.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.mem_V₁_of_notMem_V₀
type: lean
updated: '2026-07-29T15:26:38'
---
lemma mem_V₁_of_notMem_V₀ {x : relCurve C K}
    (hx : x ∉ (relCover C K (fiberTwoCover π)).V₀) :
    x ∈ (relCover C K (fiberTwoCover π)).V₁ := by
  have hx' : x ∈ (relCover C K (fiberTwoCover π)).V₀
      ⊔ (relCover C K (fiberTwoCover π)).V₁ := by rw [relCover_sup]; trivial
  rcases (TopologicalSpace.Opens.mem_sup).mp hx' with h0 | h1
  exacts [absurd h0 hx, h1]