---
author: sync
content_type: theorem
created: '2026-07-30T12:49:24'
decl: AlgebraicGeometry.exists_uniform_admissibleCoverageChart_eq_univ
docstring: '**The producer-facing endpoint:** one legal chart locus is all of the
  test space for every

  `pic⁰` class, uniformly in the test.


  This closes the numeric and splitting part of pointwise coverage.  It does not produce
  the

  neighbourhood morphism into the chart; that separate spreading-out obligation remains
  in

  `Pic0ChartCoverageSlice`.'
file: AlgebraicJacobian/Picard/Pic0ChartCoverageThreshold.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_uniform_admissibleCoverageChart_eq_univ
type: lean
updated: '2026-08-01T09:44:15'
---
theorem exists_uniform_admissibleCoverageChart_eq_univ
    {π : C.left ⟶ P1 k} [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k)) (g : ℕ)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ)) :
    ∃ (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor),
      Scheme.CurveDivisor.deg k Z
          = (m : ℤ) * classDeg k (thetaCechClass C)
            - (admissibleCoverageParameter (C := C) hπ g : ℤ) ∧
        ∀ {T : Over (Spec (.of k))} (lam : pic0Subgroup C T),
          chartLocus C m Z lam.1 = Set.univ := by
  obtain ⟨m, Z, hZ, hmem⟩ := exists_uniform_admissibleCoverageChart hπ g hχ
  refine ⟨m, Z, hZ, ?_⟩
  intro T lam
  apply Set.eq_univ_of_forall
  intro t
  exact hmem lam.1 t
    (mem_pic0Subgroup_iff.mp lam.2 (Over.testPointField t) (Over.testPoint t))

/-! ## Coverage with the threshold discharged

`mem_chartLocus_of_vanishing_bound` (`Picard/Pic0ChartCoverageNoDrop.lean:154`) takes `hb`
(the threshold) and `hdeg` (the calibration).  The threshold is now available at the
splitting field, so the composite below carries only the calibration — which is what
`Pic0ChartCoverageIndexSlack`'s `index_of_threshold` is about. -/