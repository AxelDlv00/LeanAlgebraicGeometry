---
author: sync
content_type: theorem
created: '2026-07-17T22:01:16'
decl: AlgebraicGeometry.carveIdeal_le_ker_of_map_pairTaut
docstring: '**The chart-framed classification keystone** (DDR-6): a chart map `w :
  R_{I,J} → S`

  pulling the tautological pair back to a pair of submodules that satisfies the carve

  `(♦)` over `S` kills the carve ideal `I_♦`.  Mechanism: the DDR-1 keystone

  `carveIdeal_le_ker_iff_carve_map` reduces the kill condition to the carve for the

  pulled-back tautological pair, which *is* the framed pair by `map_toSubmodule`.'
file: AlgebraicJacobian/Picard/DivSchemeClassify.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.carveIdeal_le_ker_of_map_pairTaut
type: lean
updated: '2026-07-30T15:46:02'
---
theorem carveIdeal_le_ker_of_map_pairTaut
    (i : (glueData k g r₁).J) (j : (glueData k g r₂).J)
    {S : Type u} [CommRing S] [Algebra k S]
    (w : PairChartRing k g r₁ g r₂ i j →ₐ[k] S)
    {K₁ : Submodule S (TensorProduct k S (Fin r₁ → k))}
    {K₂ : Submodule S (TensorProduct k S (Fin r₂ → k))}
    (hw₁ : (Module.Grassmannian.map w (pairTautFst k g r₁ r₂ i j)).toSubmodule = K₁)
    (hw₂ : (Module.Grassmannian.map w (pairTautSnd k g r₁ r₂ i j)).toSubmodule = K₂)
    (hcarve : ∀ m, carvePairArrow (μ m) K₁ K₂ = 0) :
    carveIdeal k g r₁ r₂ μ i j ≤ RingHom.ker w.toRingHom := by
  letI : Algebra (PairChartRing k g r₁ g r₂ i j) S := w.toAlgebra
  letI : IsScalarTower k (PairChartRing k g r₁ g r₂ i j) S :=
    IsScalarTower.of_algebraMap_eq' w.comp_algebraMap.symm
  have hgoal : carveIdeal k g r₁ r₂ μ i j
      ≤ RingHom.ker (algebraMap (PairChartRing k g r₁ g r₂ i j) S) := by
    rw [carveIdeal_le_ker_iff_carve_map]
    intro m
    rw [← Module.Grassmannian.map_toSubmodule w (pairTautFst k g r₁ r₂ i j),
      ← Module.Grassmannian.map_toSubmodule w (pairTautSnd k g r₁ r₂ i j), hw₁, hw₂]
    exact hcarve m
  exact hgoal