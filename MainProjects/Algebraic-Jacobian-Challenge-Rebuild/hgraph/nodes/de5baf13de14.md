---
author: sync
content_type: theorem
created: '2026-08-03T18:38:51'
decl: AlgebraicGeometry.P1FiniteMap.FiniteMapGenerators.range_subset_targetOpen_sup
docstring: The two distinguished target charts cover the image.
file: AlgebraicJacobian/Projective/FiniteMapToP1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1FiniteMap.FiniteMapGenerators.range_subset_targetOpen_sup
type: lean
updated: '2026-08-07T05:01:59'
---
theorem range_subset_targetOpen_sup :
    Set.range G.toProjectiveSpace ⊆
      (G.targetOpen0 ⊔ G.targetOpen1 : _) := by
  rintro _ ⟨x, rfl⟩
  have hx : x ∈
      (pi ⁻¹ᵁ P1.chartOpen k 0) ⊔ (pi ⁻¹ᵁ P1.chartOpen k 1) := by
    rw [show (pi ⁻¹ᵁ P1.chartOpen k 0) ⊔ (pi ⁻¹ᵁ P1.chartOpen k 1) = ⊤ by
      change pi ⁻¹ᵁ (P1.chartOpen k 0 ⊔ P1.chartOpen k 1) = ⊤
      rw [P1.chartOpen_sup]
      rfl]
    trivial
  rw [TopologicalSpace.Opens.mem_sup] at hx
  change G.toProjectiveSpace x ∈ G.targetOpen0 ⊔ G.targetOpen1
  rw [TopologicalSpace.Opens.mem_sup]
  rcases hx with hx | hx
  · left
    change x ∈ G.toProjectiveSpace ⁻¹ᵁ G.targetOpen0
    rwa [G.preimage_targetOpen0]
  · right
    change x ∈ G.toProjectiveSpace ⁻¹ᵁ G.targetOpen1
    rwa [G.preimage_targetOpen1]