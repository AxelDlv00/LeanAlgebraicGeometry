---
author: sync
content_type: theorem
created: '2026-07-27T15:50:35'
decl: AlgebraicGeometry.Adelic.degK_eq_degree_of_residueDeg_eq_one
docstring: '**The weighted degree agrees with the geometric degree when every residue

  degree is one.**  `deg_k D = Σ_P D(P)·[κ(P):k]` collapses to

  `Σ_P D(P) = Scheme.WeilDivisor.degree D` as soon as `[κ(P):k] = 1` at every prime

  divisor in the support — which is the case over an algebraically closed base

  field, every closed point of a smooth curve then having residue field `k` itself.


  This is the **only** thing separating the adelic `degK_principal_eq_zero` from the

  geometric leaf `Scheme.WeilDivisor.principal_degree_zero`; see §4.  The hypothesis

  is stated pointwise on the support rather than globally so that a caller can

  discharge it where it is actually needed.'
file: AlgebraicJacobian/RiemannRoch/Adelic/SectionBounds.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.degK_eq_degree_of_residueDeg_eq_one
type: lean
updated: '2026-07-27T15:50:35'
---
theorem degK_eq_degree_of_residueDeg_eq_one {D : X.WeilDivisor}
    (h1 : ∀ P ∈ (show X.PrimeDivisor →₀ ℤ from D).support, residueDeg k P = 1) :
    degK k D = Scheme.WeilDivisor.degree D := by
  rw [degK_eq_sum, Scheme.WeilDivisor.degree, Finsupp.sum, Finsupp.sum]
  refine Finset.sum_congr rfl fun P hP => ?_
  rw [h1 P hP]
  simp

end DegK

/-! ## §2. The section-drop bounds (unconditional)

For a one-point twist `D' = D + P` the local step space
`Γ(⊤,𝒪(D'))/Γ(⊤,𝒪(D))` has dimension `ℓ(D') − ℓ(D)` (rank–nullity,
`finrank_localStepDom`) and dimension at most `[κ(P):k]` (node N14,
`localStep_finrank_le` applied at `U = ⊤`).  Both facts are already in the
project; combining them gives the classical section-drop sandwich
`ℓ(D) ≤ ℓ(D + P) ≤ ℓ(D) + [κ(P):k]` with **no** ledger exactness hypothesis and
**no** strong-approximation input — those are needed only for the `h¹` half of the
ledger, not for the `ℓ` half. -/

section Drops

variable (k : Type u) [Field k] {X : Scheme.{u}} [IsIntegral X]
    [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X]
    [Algebra k X.functionField] [IsConstantField k X]