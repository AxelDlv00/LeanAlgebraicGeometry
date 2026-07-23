---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechEnginePrependFam
docstring: 'The prepend-`i_fix` contracting map `C_p ⟶ C_{p+1}` of the engine complex:
  on the coproduct

  injection `ι_σ` (`σ : Fin (p+1) → I₁(V)`) it returns `ι_{Fin.cons i_fix σ}`.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechEnginePrependFam
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def cechEnginePrependFam (V : TopologicalSpace.Opens ↥X)
    (i_fix : {i : ι // V ≤ U i}) (p : ℕ) :
    cechEngineXFam U V p ⟶ cechEngineXFam U V (p + 1) :=
  Limits.Sigma.desc fun σ =>
    Limits.Sigma.ι (fun _ : Fin (p + 2) → {i : ι // V ≤ U i} => coverSectionModule V)
      (Fin.cons i_fix σ)