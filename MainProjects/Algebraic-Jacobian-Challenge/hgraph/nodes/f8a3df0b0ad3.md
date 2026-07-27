---
author: sync
content_type: definition
created: '2026-07-27T19:08:27'
decl: AlgebraicGeometry.Adelic.p1ChartSectionsAlgEquivX
docstring: '**The first chart ring of `ℙ¹_k` is a polynomial ring.**  `Γ(ℙ¹_k, V₀)
  ≃ₐ[k] k[T]`, sending

  the chart coordinate `x = X₁/X₀ = p1XSection k` to the variable `T`.'
file: AlgebraicJacobian/Picard/RigidPushforwardP1ChartSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.p1ChartSectionsAlgEquivX
type: lean
updated: '2026-07-27T19:08:27'
---
noncomputable def p1ChartSectionsAlgEquivX :
    Γ(ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)), p1Chart k ⟨0⟩) ≃ₐ[k] Polynomial k :=
  (AlgEquiv.ofBijective (Polynomial.aeval (p1XSection k)) (bijective_aeval_p1XSection k)).symm