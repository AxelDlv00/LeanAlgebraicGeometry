---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.derivationToDualNumberHom_fst_of_mem
file: AlgebraicJacobian/Picard/TangentSpaceDualNumbers.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.derivationToDualNumberHom_fst_of_mem
type: lean
updated: '2026-07-24T03:02:12'
---
lemma derivationToDualNumberHom_fst_of_mem (D : Derivation k R (ResidueField R))
    {x : R} (hx : x ∈ maximalIdeal R) :
    fst (derivationToDualNumberHom hres D x) = 0 := by
  have h0 : residue R x = 0 := Ideal.Quotient.eq_zero_iff_mem.mpr hx
  rw [derivationToDualNumberHom_apply, fst_add, fst_inl, fst_inr, add_zero,
    h0, map_zero]