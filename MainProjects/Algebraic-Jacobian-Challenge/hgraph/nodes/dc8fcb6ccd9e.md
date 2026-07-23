---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.prodOpens_eq_iInf
docstring: '**The abstract Čech product is the concrete infimum of opens.** In the
  poset `Opens X` the

  categorical product `∏ᶜ (𝒰∘j)` of the family `a ↦ 𝒰 (j a)` equals its infimum `⨅ₐ
  𝒰 (j a)`.

  This is the bridge identifying the Čech section groups `Γ(∏ᶜ 𝒰∘j, F)` with the concrete

  `Γ(⨅ₐ 𝒰(j a), F)` (and, for the 2-cover, with `Γ(U₁ ⊓ U₂)`).'
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.prodOpens_eq_iInf
type: lean
updated: '2026-07-24T03:02:13'
---
theorem prodOpens_eq_iInf {m : ℕ} (j : Fin m → ι) :
    (∏ᶜ ((FormalCoproduct.mk _ 𝒰).obj ∘ j) : TopologicalSpace.Opens C.left.toTopCat)
      = ⨅ a, 𝒰 (j a) :=
  le_antisymm (le_iInf fun a => (Limits.Pi.π ((FormalCoproduct.mk _ 𝒰).obj ∘ j) a).le)
    (Limits.Pi.lift (fun a => homOfLE (iInf_le (fun a => 𝒰 (j a)) a))).le