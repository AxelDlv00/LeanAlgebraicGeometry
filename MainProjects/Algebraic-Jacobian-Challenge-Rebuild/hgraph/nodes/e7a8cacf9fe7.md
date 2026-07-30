---
author: sync
content_type: theorem
created: '2026-07-19T10:31:16'
decl: AlgebraicGeometry.windowA_exists
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivFibre.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.windowA_exists
type: lean
updated: '2026-07-30T15:46:03'
---
private theorem windowA_exists : ∃ a : ℕ, windowBound π hπ ≤ (a : ℤ) * windowδ π := by
  refine ⟨(windowBound π hπ).toNat, ?_⟩
  have hδ : 1 ≤ windowδ π := one_le_windowδ π
  have h1 : (((windowBound π hπ).toNat : ℤ)) ≤ ((windowBound π hπ).toNat : ℤ) * windowδ π :=
    le_mul_of_one_le_right (Int.natCast_nonneg _) hδ
  have h2 : windowBound π hπ ≤ ((windowBound π hπ).toNat : ℤ) :=
    Int.self_le_toNat _
  linarith