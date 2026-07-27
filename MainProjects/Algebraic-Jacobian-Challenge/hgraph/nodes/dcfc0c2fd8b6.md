---
author: sync
content_type: theorem
created: '2026-07-28T04:32:28'
decl: AlgebraicGeometry.Adelic.sectionSub_top_eq_inf
docstring: '**`L(D)` is the intersection of the two chart section spaces**, as `k`-submodules.

  The `k`-linear form of `Substrate.linearSystem_eq_inf`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/ChiUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.sectionSub_top_eq_inf
type: lean
updated: '2026-07-28T04:32:28'
---
theorem sectionSub_top_eq_inf (hcov : U₀ ⊔ U₁ = ⊤) (D : X.WeilDivisor) :
    sectionSub k ⊤ D = sectionSub k U₀ D ⊓ sectionSub k U₁ D := by
  apply SetLike.coe_injective
  change (sectionOfDivisor ⊤ D : Set X.functionField) = _
  rw [show sectionOfDivisor (X := X) ⊤ D = linearSystem D from rfl,
    linearSystem_eq_inf hcov D]
  rfl