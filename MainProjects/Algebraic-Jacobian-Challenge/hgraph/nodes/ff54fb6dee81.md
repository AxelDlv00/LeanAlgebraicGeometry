---
author: sync
content_type: theorem
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.P1.SpecMap_awayToOverlapRight_chartι
docstring: 'The restriction of the chart `D₊(X₁)` to the overlap, as a factorization
  of the chart

  inclusion of `D₊(X₀X₁)`.'
file: AlgebraicJacobian/RiemannRoch/Ledger/P1Points.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.SpecMap_awayToOverlapRight_chartι
type: lean
updated: '2026-07-28T18:12:20'
---
theorem SpecMap_awayToOverlapRight_chartι :
    Spec.map (CommRingCat.ofHom (awayToOverlapRight k)) ≫ chartι k 1 =
      Proj.awayι 𝒜 ((X 0 : MvPolynomial (Fin 2) k) * X 1) (X_mul_X_mem k) two_pos := by
  rw [awayToOverlapRight_eq]
  exact Proj.SpecMap_awayMap_awayι 𝒜 (X_mem k 1) one_pos (X_mem k 0) (mul_comm (X 0) (X 1))