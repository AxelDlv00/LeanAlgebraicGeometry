---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.cotangentDualToDerivation
docstring: 'The inverse construction: an `R`-linear functional on the cotangent space

  `m/m²` extends to a `k`-derivation `R → ResidueField R` via the canonical

  splitting `R = k ⊕ m` at a `k`-rational point.'
file: AlgebraicJacobian/Picard/TangentSpaceDualNumbers.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cotangentDualToDerivation
type: lean
updated: '2026-07-24T03:02:12'
---
noncomputable def cotangentDualToDerivation
    (φ : CotangentSpace R →ₗ[R] ResidueField R) :
    Derivation k R (ResidueField R) where
  toFun r := φ ((maximalIdeal R).toCotangent (maximalIdealPart hres r))
  map_add' r s := by
    rw [maximalIdealPart_add, map_add, map_add]
  map_smul' c r := by
    have hpart : maximalIdealPart hres (c • r)
        = algebraMap k R c • maximalIdealPart hres r := by
      ext
      simp only [maximalIdealPart_coe, SetLike.val_smul, smul_eq_mul]
      have hsm : (c • r : R) = algebraMap k R c * r := Algebra.smul_def c r
      rw [hsm, sectOfBijective_mul, sectOfBijective_algebraMap]
      ring
    rw [hpart, map_smul, map_smul, RingHom.id_apply, algebraMap_smul]
  map_one_eq_zero' := by
    change φ ((maximalIdeal R).toCotangent (maximalIdealPart hres (1 : R))) = 0
    have h1 : maximalIdealPart hres (1 : R) = 0 := by
      ext
      rw [maximalIdealPart_coe, sectOfBijective_one, sub_self,
        ZeroMemClass.coe_zero]
    rw [h1, map_zero, map_zero]
  leibniz' r s := by
    change φ ((maximalIdeal R).toCotangent (maximalIdealPart hres (r * s)))
        = r • φ ((maximalIdeal R).toCotangent (maximalIdealPart hres s))
          + s • φ ((maximalIdeal R).toCotangent (maximalIdealPart hres r))
    have hsq : (maximalIdeal R).toCotangent
        ⟨(r - sectOfBijective hres r) * (s - sectOfBijective hres s),
         Ideal.mul_mem_right _ _ (sub_sectOfBijective_mem_maximalIdeal hres r)⟩
          = 0 := by
      rw [Ideal.toCotangent_eq_zero, pow_two]
      exact Ideal.mul_mem_mul
        (sub_sectOfBijective_mem_maximalIdeal hres r)
        (sub_sectOfBijective_mem_maximalIdeal hres s)
    rw [maximalIdealPart_mul]
    simp only [map_add, map_smul, hsq, add_zero]
    rw [← smul_residueField_eq_sectOfBijective_smul hres r,
      ← smul_residueField_eq_sectOfBijective_smul hres s]

@[simp]