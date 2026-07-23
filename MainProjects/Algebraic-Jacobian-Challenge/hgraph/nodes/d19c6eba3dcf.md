---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechEngineComplex_exactAt
docstring: '**Positive-degree exactness of the engine complex.** When `I₁(V)` is nonempty
  (witnessed by

  `i_fix`), `cechEngineComplex 𝒰 V` is exact at every positive degree `n + 1`, from
  the

  contracting-homotopy exactness `cechEngineD_exact` via `ModuleCat.shortComplex_exact`.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechEngineComplex_exactAt
type: lean
updated: '2026-07-24T03:02:09'
---
lemma cechEngineComplex_exactAt (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X)
    (i_fix : {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i}) (n : ℕ) :
    (cechEngineComplex 𝒰 V).ExactAt (n + 1) := by
  rw [HomologicalComplex.exactAt_iff' _ (n + 2) (n + 1) n (by simp [ChainComplex.prev])
    (by simp)]
  apply ModuleCat.shortComplex_exact
  have hf : (cechEngineComplex 𝒰 V).d (n + 2) (n + 1) = cechEngineD 𝒰 V (n + 1) :=
    ChainComplex.of_d _ _ (n + 1)
  have hg : (cechEngineComplex 𝒰 V).d (n + 1) n = cechEngineD 𝒰 V n := ChainComplex.of_d _ _ n
  change Function.Exact ⇑(ConcreteCategory.hom ((cechEngineComplex 𝒰 V).d (n + 2) (n + 1)))
    ⇑(ConcreteCategory.hom ((cechEngineComplex 𝒰 V).d (n + 1) n))
  rw [hf, hg]
  exact cechEngineD_exact 𝒰 V i_fix n

/-! ## Project-local Mathlib supplement — augmentation of the engine complex

The engine complex augments onto its degree-`0` coefficient `O_X(V)` via the codiagonal of the
constant summands.  Together with the positive-degree acyclicity `cechEngineComplex_exactAt` and the
degree-`0` contracting identity this exhibits `cechEngineComplex 𝒰 V` as a resolution of `O_X(V)`
in the nonempty case — the engine-side input to `cechFreeEval_quasiIso_of_nonempty`. -/