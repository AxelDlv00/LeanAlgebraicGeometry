---
author: sync
content_type: lemma
created: '2026-07-20T17:01:58'
decl: AlgebraicGeometry.FlatRangeBridge.subsingleton_imageInQuotient_tmul_residueField_of_flat_quotient
docstring: Residue-field form of the preceding bridge; only the pure tensor with `1`
  is needed.
file: AlgebraicJacobian/Picard/DivSchemeRedesignRangeFlatBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FlatRangeBridge.subsingleton_imageInQuotient_tmul_residueField_of_flat_quotient
type: lean
updated: '2026-07-20T17:01:58'
---
lemma subsingleton_imageInQuotient_tmul_residueField_of_flat_quotient
    {L P : Submodule R M} (hLP : L ≤ P) [Module.Flat R (M ⧸ P)]
    (p : PrimeSpectrum R)
    (hzero : ∀ n : imageInQuotient L P,
      ((n : M ⧸ L) ⊗ₜ[R] (1 : p.asIdeal.ResidueField)) = 0) :
    Subsingleton (imageInQuotient L P ⊗[R] p.asIdeal.ResidueField) := by
  apply subsingleton_imageInQuotient_tensor_of_flat_quotient hLP
  intro n a
  rw [show ((n : M ⧸ L) ⊗ₜ[R] a)
      = TensorProduct.comm R p.asIdeal.ResidueField (M ⧸ L)
        (a ⊗ₜ[R] (n : M ⧸ L)) from
        (TensorProduct.comm_tmul R p.asIdeal.ResidueField (M ⧸ L) a (n : M ⧸ L)).symm]
  have haz : (a ⊗ₜ[R] (n : M ⧸ L) :
      p.asIdeal.ResidueField ⊗[R] (M ⧸ L)) = 0 := by
    rw [show (a ⊗ₜ[R] (n : M ⧸ L))
        = a • ((1 : p.asIdeal.ResidueField) ⊗ₜ[R] (n : M ⧸ L)) by
          rw [TensorProduct.smul_tmul', smul_eq_mul, mul_one]]
    have h1' : (1 : p.asIdeal.ResidueField) ⊗ₜ[R] (n : M ⧸ L) = 0 := by
      have hc := congrArg (TensorProduct.comm R (M ⧸ L) p.asIdeal.ResidueField) (hzero n)
      rwa [TensorProduct.comm_tmul, map_zero] at hc
    rw [h1', smul_zero]
  rw [haz, map_zero]