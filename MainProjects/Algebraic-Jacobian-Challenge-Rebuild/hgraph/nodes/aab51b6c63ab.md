---
author: sync
content_type: theorem
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.P1.chartι_structureMap
docstring: The chart inclusions are morphisms over `Spec k`.
file: AlgebraicJacobian/Curve/P1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.chartι_structureMap
type: lean
updated: '2026-08-01T09:44:10'
---
theorem chartι_structureMap (i : Fin 2) :
    chartι k i ≫ structureMap k =
      Spec.map (CommRingCat.ofHom (algebraMap k (Away 𝒜 (X i)))) := by
  change Proj.awayι 𝒜 (X i) (X_mem k i) one_pos ≫
      (Proj.toSpecZero 𝒜 ≫ Spec.map (CommRingCat.ofHom (algebraMap k (𝒜 0)))) = _
  rw [Proj.awayι_toSpecZero_assoc, ← Spec.map_comp, ← CommRingCat.ofHom_comp]

/-! ### The chart coordinate and the identification with the polynomial ring

Throughout, `i j : Fin 2` are the two distinct indices; the chart coordinate on `D₊(Xᵢ)`
is `t = Xⱼ/Xᵢ`. -/