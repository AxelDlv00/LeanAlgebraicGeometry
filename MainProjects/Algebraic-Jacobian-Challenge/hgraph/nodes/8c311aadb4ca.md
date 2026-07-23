---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechEngineDFam
docstring: 'The engine differential `C_{p+1} ⟶ C_p`: the alternating sum over `i :
  Fin (p+2)` of the

  coproduct reindexing maps `ι_σ ↦ (-1)^i • ι_{σ ∘ Fin.succAbove i}` that drop the
  `i`-th index of

  the multi-index `σ : Fin (p+2) → I₁(V)`.  Chain (insertion) dual of

  `FreeCechEngine.combDifferential`.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechEngineDFam
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def cechEngineDFam (V : TopologicalSpace.Opens ↥X) (p : ℕ) :
    cechEngineXFam U V (p + 1) ⟶ cechEngineXFam U V p :=
  Limits.Sigma.desc fun σ => ∑ i : Fin (p + 2), (-1 : ℤ) ^ (i : ℕ) •
    Limits.Sigma.ι (fun _ : Fin (p + 1) → {i : ι // V ≤ U i} => coverSectionModule V)
      (σ ∘ i.succAbove)