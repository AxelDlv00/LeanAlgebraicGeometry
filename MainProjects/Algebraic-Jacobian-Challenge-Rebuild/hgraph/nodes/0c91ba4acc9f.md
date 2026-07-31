---
author: sync
content_type: lemma
created: '2026-07-24T17:02:46'
decl: TwoLatticePair.modelHom_hom₀_apply
file: AlgebraicJacobian/Cohomology/RigidEngineLatticeModelHom.lean
generated: lean
lean_status: lean_ok
title: TwoLatticePair.modelHom_hom₀_apply
type: lean
updated: '2026-07-31T20:15:18'
---
lemma modelHom_hom₀_apply (m : ι → ℤ) (a : ι → M₀) (b : ι → M₁)
    (hab : ∀ i, P.laurentToEnd (T (m i)) (P.ι₀ (a i)) = P.ι₁ (b i)) (p : ι → R[X]) :
    (P.modelHom m a b hab).hom₀ p = ∑ i : ι, Polynomial.aeval P.t₀ (p i) (a i) :=
  modelHomChart_apply ι P.t₀ a p