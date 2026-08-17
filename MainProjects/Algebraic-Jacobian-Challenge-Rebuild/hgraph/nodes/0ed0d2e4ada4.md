---
author: sync
content_type: theorem
created: '2026-08-17T13:21:29'
decl: AlgebraicGeometry.tensorProductFieldTowerEquiv_tmul
docstring: Evaluation of `tensorProductFieldTowerEquiv` on a pure tensor.
file: AlgebraicJacobian/Descent/OpenImmersionFieldTowerDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.tensorProductFieldTowerEquiv_tmul
type: lean
updated: '2026-08-17T13:21:29'
---
theorem tensorProductFieldTowerEquiv_tmul {F L K A : Type u}
    [Field F] [Field L] [Field K]
    [Algebra F L] [Algebra F K] [Algebra L K] [IsScalarTower F L K]
    [CommRing A] [Algebra F A]
    (x : L ⊗[F] A) (c : K) :
    tensorProductFieldTowerEquiv (F := F) (L := L) (K := K) (A := A)
        (x ⊗ₜ[L] c) =
      c • Algebra.TensorProduct.map
        (IsScalarTower.toAlgHom F L K) (AlgHom.id F A) x := by
  induction x using TensorProduct.induction_on with
  | zero => simp
  | tmul l a =>
      simp [tensorProductFieldTowerEquiv,
        Algebra.TensorProduct.cancelBaseChange_tmul, Algebra.smul_def, mul_comm]
  | add x y hx hy =>
      rw [TensorProduct.add_tmul, map_add, hx, hy, map_add, smul_add]