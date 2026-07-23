---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.prodOpens_fin_one
docstring: The Čech product over a 1-element multi-index is the single open.
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.prodOpens_fin_one
type: lean
updated: '2026-07-24T03:02:13'
---
theorem prodOpens_fin_one (j : Fin 1 → ι) :
    (∏ᶜ ((FormalCoproduct.mk _ 𝒰).obj ∘ j) : TopologicalSpace.Opens C.left.toTopCat)
      = 𝒰 (j 0) := by
  rw [prodOpens_eq_iInf]
  refine le_antisymm (iInf_le _ 0) (le_iInf fun a => ?_)
  fin_cases a
  exact le_rfl