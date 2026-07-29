---
author: sync
content_type: lemma
created: '2026-07-19T15:31:13'
decl: AlgebraicGeometry.divUniversalFst_toSubmodule_eq_span_aux
docstring: '(Implementation) The `Module.Grassmannian.map` `letI` seam, closed: inside
  the

  `toAlgebra` structure of the quotient presentation the universal first window is
  the

  span of the compared tautological kernel; the comparison is intrinsic (`algebraMap`
  of

  the ambient quotient instance is the quotient map), so the statement is `letI`-free.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivRes.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.divUniversalFst_toSubmodule_eq_span_aux
type: lean
updated: '2026-07-29T15:26:34'
---
private lemma divUniversalFst_toSubmodule_eq_span_aux :
    (divUniversalFst k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j).toSubmodule
      = Submodule.span
          (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
            (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
          (windowCompare (PairChartRing k g r₁ g r₂ i j)
              (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
                (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j) ''
            ((pairTautFst k g r₁ r₂ i j).toSubmodule :
              Set (TensorProduct k (PairChartRing k g r₁ g r₂ i j) (Fin r₁ → k)))) := by
  letI : Algebra (PairChartRing k g r₁ g r₂ i j)
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j) :=
    (divCarveChartMk k (windowS_choice π hπ g • fiberWeilDivisor π)
      (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j).toAlgebra
  letI : IsScalarTower k (PairChartRing k g r₁ g r₂ i j)
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j) :=
    IsScalarTower.of_algebraMap_eq' <| IsScalarTower.algebraMap_eq k _ _
  have h1 := Module.Grassmannian.map_toSubmodule
    (divCarveChartMk k (windowS_choice π hπ g • fiberWeilDivisor π)
      (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
    (pairTautFst k g r₁ r₂ i j)
  refine ((show (divUniversalFst k (windowS_choice π hπ g • fiberWeilDivisor π)
      (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j).toSubmodule = _
    from h1).trans ?_)
  rw [Grassmannian.ker_baseChangeMkQ_eq_span_windowCompare]

set_option linter.unusedSectionVars false in