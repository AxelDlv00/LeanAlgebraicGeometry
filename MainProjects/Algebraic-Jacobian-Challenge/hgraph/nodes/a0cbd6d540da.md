---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechEngineD_
docstring: 'Action of the engine differential on a coproduct injection: `ι_σ ≫ cechEngineDFam
  = ∑_i (-1)^i •

  ι_{σ ∘ succAbove i}`.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechEngineD_
type: lean
updated: '2026-07-23T12:02:28'
---
lemma cechEngineD_ιFam (V : TopologicalSpace.Opens ↥X) (p : ℕ)
    (σ : Fin (p + 2) → {i : ι // V ≤ U i}) :
    Limits.Sigma.ι _ σ ≫ cechEngineDFam U V p
      = ∑ i : Fin (p + 2), (-1 : ℤ) ^ (i : ℕ) •
          Limits.Sigma.ι (fun _ : Fin (p + 1) → {i : ι // V ≤ U i} =>
            coverSectionModule V) (σ ∘ i.succAbove) := by
  simp only [cechEngineDFam, Limits.Sigma.ι_desc]