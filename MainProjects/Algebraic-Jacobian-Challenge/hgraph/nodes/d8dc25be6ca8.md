---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechEngineComplex_exactAtFam
docstring: '**Positive-degree exactness of the engine complex.** When `I₁(V)` is nonempty
  (witnessed by

  `i_fix`), `cechEngineComplexFam U V` is exact at every positive degree `n + 1`,
  from the

  contracting-homotopy exactness `cechEngineD_exactFam` via `ModuleCat.shortComplex_exact`.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechEngineComplex_exactAtFam
type: lean
updated: '2026-07-24T03:02:09'
---
lemma cechEngineComplex_exactAtFam (V : TopologicalSpace.Opens ↥X)
    (i_fix : {i : ι // V ≤ U i}) (n : ℕ) :
    (cechEngineComplexFam U V).ExactAt (n + 1) := by
  rw [HomologicalComplex.exactAt_iff' _ (n + 2) (n + 1) n (by simp [ChainComplex.prev])
    (by simp)]
  apply ModuleCat.shortComplex_exact
  have hf : (cechEngineComplexFam U V).d (n + 2) (n + 1) = cechEngineDFam U V (n + 1) :=
    ChainComplex.of_d _ _ (n + 1)
  have hg : (cechEngineComplexFam U V).d (n + 1) n = cechEngineDFam U V n := ChainComplex.of_d _ _ n
  change Function.Exact ⇑(ConcreteCategory.hom ((cechEngineComplexFam U V).d (n + 2) (n + 1)))
    ⇑(ConcreteCategory.hom ((cechEngineComplexFam U V).d (n + 1) n))
  rw [hf, hg]
  exact cechEngineD_exactFam U V i_fix n