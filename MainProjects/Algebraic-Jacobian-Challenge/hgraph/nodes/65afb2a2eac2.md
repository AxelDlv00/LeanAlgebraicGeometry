---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.prodOpens_le_of_forall_exists
docstring: 'If every open of the multi-index `j` occurs among the opens of the multi-index
  `x`,

  the Čech product of `x` is contained in the Čech product of `j`.  For concrete

  multi-indices the hypothesis is decidable, so this yields all the inclusion witnesses

  of the 8-index kernel analysis by `decide`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.prodOpens_le_of_forall_exists
type: lean
updated: '2026-07-24T03:02:13'
---
theorem prodOpens_le_of_forall_exists {m m' : ℕ} {j : Fin m → ι} {x : Fin m' → ι}
    (h : ∀ a, ∃ b, x b = j a) :
    (∏ᶜ ((FormalCoproduct.mk _ 𝒰).obj ∘ x) : TopologicalSpace.Opens C.left.toTopCat)
      ≤ ∏ᶜ ((FormalCoproduct.mk _ 𝒰).obj ∘ j) := by
  rw [prodOpens_eq_iInf, prodOpens_eq_iInf]
  refine le_iInf fun a => ?_
  obtain ⟨b, hb⟩ := h a
  exact (iInf_le _ b).trans (le_of_eq (congrArg 𝒰 hb))

end SmallProdOpens

/-! ## Node N5 — componentwise form of the low-degree Čech differentials -/

section CechComponentFormulas

open AlgebraicTopology CategoryTheory CategoryTheory.Limits

variable {k : Type u} [Field k] {C : Over (Spec (CommRingCat.of k))}
  {ι : Type u} (𝒰 : ι → TopologicalSpace.Opens C.left.toTopCat)
  (F : Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k))