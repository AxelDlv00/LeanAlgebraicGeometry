---
author: sync
content_type: lemma
created: '2026-07-31T06:25:53'
decl: AlgebraicGeometry.fiberLattice_step
docstring: 'One application of multiplication by the inverse fiber coordinate advances
  the entire

  fiber lattice by one step, after adjoining its constant chart-one summand.'
file: AlgebraicJacobian/RiemannRoch/Ledger/FiberLattice.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.fiberLattice_step
type: lean
updated: '2026-07-31T06:25:53'
---
private lemma fiberLattice_step (D : Y.CurveDivisor) (n : ℕ) :
    Submodule.map (mulByUnit K (fiberCoordUnit π)⁻¹).toLinearMap (fiberLattice π D n)
        ⊔ divisorSections K D (fiberChart₁ π)
      = fiberLattice π D n.succ := by
  rw [fiberLattice, fiberLattice, Submodule.map_sup, chart0_mul_inv_map,
    divisorSections_add_nsmul_fiberWeilDivisor_chart₁,
    divisorSections_add_nsmul_fiberWeilDivisor_chart₁, sup_assoc,
    sup_eq_right.mpr (chart1_mul_inv_map_le π D)]