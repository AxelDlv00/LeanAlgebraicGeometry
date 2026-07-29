---
author: sync
content_type: lemma
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Scheme.mulSpan_le
docstring: Eliminating a multiplication span into any submodule containing the products.
file: AlgebraicJacobian/RiemannRoch/AnnihilatorKernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.mulSpan_le
type: lean
updated: '2026-07-29T15:31:49'
---
lemma Scheme.mulSpan_le {U T W : Submodule K X.functionField}
    (h : ∀ a ∈ U, ∀ f ∈ T, a * f ∈ W) : Scheme.mulSpan K U T ≤ W := by
  refine Submodule.span_le.mpr ?_
  rintro w ⟨a, ha, f, hf, rfl⟩
  exact h a ha f hf