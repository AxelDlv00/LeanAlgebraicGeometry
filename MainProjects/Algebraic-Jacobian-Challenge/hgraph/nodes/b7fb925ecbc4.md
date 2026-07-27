---
author: sync
content_type: theorem
created: '2026-07-27T19:08:27'
decl: AlgebraicGeometry.Adelic.bijective_aeval_p1YSection
docstring: '**`k[T] → Γ(ℙ¹_k, V₁)`, `T ↦ y`, is bijective** (mirror of `bijective_aeval_p1XSection`).'
file: AlgebraicJacobian/Picard/RigidPushforwardP1ChartSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.bijective_aeval_p1YSection
type: lean
updated: '2026-07-27T19:08:27'
---
theorem bijective_aeval_p1YSection :
    Function.Bijective (Polynomial.aeval (p1YSection k) :
      Polynomial k →ₐ[k] Γ(ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)), p1Chart k ⟨1⟩)) := by
  rw [← p1CoordSection_one_zero]
  refine ⟨Function.LeftInverse.injective
    (g := ⇑(p1ChartRetraction k p1Index_one_ne_zero).hom)
    (p1ChartRetraction_aeval k p1Index_one_ne_zero), ?_⟩
  exact surjective_aeval_p1CoordSection k
    (by rw [p1CoordSection_one_zero]; exact span_pow_p1YSection_scaffold k)