---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.prodOpens_fin_two
docstring: The Čech product over a 2-element multi-index is the binary intersection.
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.prodOpens_fin_two
type: lean
updated: '2026-07-24T03:02:13'
---
theorem prodOpens_fin_two (j : Fin 2 → ι) :
    (∏ᶜ ((FormalCoproduct.mk _ 𝒰).obj ∘ j) : TopologicalSpace.Opens C.left.toTopCat)
      = 𝒰 (j 0) ⊓ 𝒰 (j 1) := by
  rw [prodOpens_eq_iInf]
  refine le_antisymm (le_inf (iInf_le _ 0) (iInf_le _ 1)) (le_iInf fun a => ?_)
  fin_cases a
  · exact inf_le_left
  · exact inf_le_right