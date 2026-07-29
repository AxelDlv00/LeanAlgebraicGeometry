---
author: sync
content_type: instance
created: '2026-07-29T22:29:09'
decl: AlgebraicJacobian.TwoTerm.finitePresentation_quotRange
docstring: '**The cokernel of a two-term complex is finitely presented**, when the

  degree-0 term is finite: `Aⁿ` is finitely presented and `range k` is finitely

  generated.'
file: AlgebraicJacobian/Picard/TwoTermKernelSemicontinuity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.TwoTerm.finitePresentation_quotRange
type: lean
updated: '2026-07-29T22:29:09'
---
instance finitePresentation_quotRange (n : ℕ) (k : K →ₗ[A] (Fin n → A))
    [Module.Finite A K] :
    Module.FinitePresentation A ((Fin n → A) ⧸ LinearMap.range k) := by
  apply Module.finitePresentation_of_surjective (Submodule.mkQ (LinearMap.range k))
    (Submodule.mkQ_surjective _)
  rw [Submodule.ker_mkQ]
  exact Submodule.FG.of_finite