---
author: sync
content_type: definition
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.P1.overlapAlgEquiv
docstring: 'The overlap identification: the section ring `(k[X₀,X₁]_(X₀X₁))₀` of the
  chart overlap is

  the ring of Laurent polynomials over `k`, with `T = X₁/X₀`.'
file: AlgebraicJacobian/RiemannRoch/Ledger/P1Charts.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.overlapAlgEquiv
type: lean
updated: '2026-07-28T18:12:20'
---
noncomputable def overlapAlgEquiv :
    Away 𝒜 (X 0 * X 1) ≃ₐ[k] LaurentPolynomial k :=
  { overlapRingEquiv k with
    commutes' := fun r => by
      change overlapRingEquiv k (algebraMap k _ r) = _
      rw [← awayToOverlapLeft_algebraMap, overlapRingEquiv_awayToOverlapLeft,
        AlgEquiv.commutes, ← Polynomial.C_eq_algebraMap, Polynomial.toLaurent_C,
        LaurentPolynomial.C_eq_algebraMap] }