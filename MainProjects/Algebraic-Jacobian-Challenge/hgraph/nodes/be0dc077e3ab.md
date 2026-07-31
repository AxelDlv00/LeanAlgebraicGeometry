---
author: sync
content_type: lemma
created: '2026-07-31T08:04:21'
decl: AlgebraicGeometry.FiberCoordinateData.coordinateUnit_inv_pow_eq_germ_overlap
file: AlgebraicJacobian/RiemannRoch/Ledger/FiberCoordinateComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FiberCoordinateData.coordinateUnit_inv_pow_eq_germ_overlap
type: lean
updated: '2026-07-31T19:37:13'
---
lemma coordinateUnit_inv_pow_eq_germ_overlap (n : ℕ) :
    ((Q.coordinateUnit⁻¹ ^ n : Y.functionFieldˣ) : Y.functionField) =
      (Y.presheaf.germ (Q.V₀ ⊓ Q.V₁) (genericPoint Y) Q.genericPoint_mem_inf).hom
        (Q.overlapInversePower n) := by
  rw [Units.val_pow_eq_pow_val, overlapInversePower, map_pow, Q.coordinateUnit_inv_val]
  exact congrArg (fun z : Y.functionField => z ^ n)
    (Y.presheaf.germ_res_apply
      (homOfLE (inf_le_right : Q.V₀ ⊓ Q.V₁ ≤ Q.V₁))
      (genericPoint Y) Q.genericPoint_mem_inf Q.y).symm

omit [LocallyOfFiniteType (Y ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (Y ↘ Spec (CommRingCat.of K))] in