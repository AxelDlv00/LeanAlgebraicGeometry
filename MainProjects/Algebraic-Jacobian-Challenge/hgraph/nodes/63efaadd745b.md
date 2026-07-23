---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.T_mem_nonneg_of_nonneg
docstring: Every nonnegative pure power `xⁿ` lies in the `k[x]` part.
file: AlgebraicJacobian/RiemannRoch/Adelic/P1BaseCase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.T_mem_nonneg_of_nonneg
type: lean
updated: '2026-07-16T21:14:28'
---
lemma T_mem_nonneg_of_nonneg {n : ℤ} (hn : 0 ≤ n) :
    (T n : LaurentPolynomial R) ∈ nonnegLaurentSubmodule R := by
  obtain ⟨m, rfl⟩ : ∃ m : ℕ, n = (m : ℤ) := ⟨n.toNat, (Int.toNat_of_nonneg hn).symm⟩
  exact Submodule.subset_span ⟨m, rfl⟩