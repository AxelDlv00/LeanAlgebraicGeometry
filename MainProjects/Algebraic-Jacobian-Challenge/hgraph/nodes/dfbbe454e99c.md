---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.inv_mul_inv_mul_cancel'
docstring: Port of `GrassmannianCells.inv_mul_inv_mul_cancel` (private there).
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.inv_mul_inv_mul_cancel'
type: lean
updated: '2026-07-16T21:14:27'
---
private lemma inv_mul_inv_mul_cancel' {d e : ℕ} {R : Type*} [CommRing R]
    (A B : Matrix (Fin d) (Fin d) R) (M : Matrix (Fin d) (Fin e) R) (hA : IsUnit A.det) :
    (B⁻¹ * A) * (A⁻¹ * M) = B⁻¹ * M := by
  rw [Matrix.mul_assoc B⁻¹ A (A⁻¹ * M), ← Matrix.mul_assoc A A⁻¹ M,
    Matrix.mul_nonsing_inv A hA, Matrix.one_mul]