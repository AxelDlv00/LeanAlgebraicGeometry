---
author: sync
content_type: definition
created: '2026-07-31T08:04:21'
decl: AlgebraicGeometry.FiberCoordinateData.coordinateUnit
docstring: The function-field unit represented by the first coordinate and inverted
  by the second.
file: AlgebraicJacobian/RiemannRoch/Ledger/FiberCoordinateDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FiberCoordinateData.coordinateUnit
type: lean
updated: '2026-07-31T08:04:21'
---
noncomputable def coordinateUnit : Y.functionFieldˣ where
  val := (Y.presheaf.germ D.V₀ (genericPoint Y) (D.genericPoint_mem_inf).1).hom D.x
  inv := (Y.presheaf.germ D.V₁ (genericPoint Y) (D.genericPoint_mem_inf).2).hom D.y
  val_inv := germ_x_mul_germ_y D
  inv_val := by rw [mul_comm]; exact germ_x_mul_germ_y D

omit [Y.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (Y ↘ Spec (CommRingCat.of K))]
  [LocallyOfFiniteType (Y ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (Y ↘ Spec (CommRingCat.of K))] in