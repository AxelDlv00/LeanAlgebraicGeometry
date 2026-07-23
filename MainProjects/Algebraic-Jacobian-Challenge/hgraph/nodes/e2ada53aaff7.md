---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.finrank_alternating_of_exact4
docstring: '**Alternating dimension identity of a 4-term exact sequence.** For a four-term

  exact sequence of finite-dimensional `k`-vector spaces

  `0 → A --i--> B --p--> C --q--> E → 0`

  (`i` injective, exact at `B` and `C`, `q` surjective),

  `dim A − dim B + dim C − dim E = 0`.


  The proof is a double application of rank–nullity: `dim(ker p) = dim(range i) =

  dim A` and `dim(ker q) = dim C − dim E`, and exactness `range p = ker q` matches

  `dim B − dim A = dim C − dim E`.  This is the χ-ledger engine (design §3, node

  N15): applied to the ledger sequence it is exactly `χ(D+P) = χ(D) + deg P`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/ChiLedger.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.finrank_alternating_of_exact4
type: lean
updated: '2026-07-24T03:02:13'
---
theorem finrank_alternating_of_exact4
    (i : A →ₗ[k] B) (p : B →ₗ[k] C) (q : C →ₗ[k] E)
    (hi : Function.Injective i)
    (hB : LinearMap.range i = LinearMap.ker p)
    (hC : LinearMap.range p = LinearMap.ker q)
    (hq : Function.Surjective q) :
    (Module.finrank k A : ℤ) - Module.finrank k B + Module.finrank k C
      - Module.finrank k E = 0 := by
  have hkerp : Module.finrank k (LinearMap.ker p) = Module.finrank k A := by
    rw [← hB, LinearMap.finrank_range_of_inj hi]
  have hrnp := LinearMap.finrank_range_add_finrank_ker p
  have hrnq := LinearMap.finrank_range_add_finrank_ker q
  have hrangeq : Module.finrank k (LinearMap.range q) = Module.finrank k E := by
    rw [LinearMap.range_eq_top.mpr hq]; exact finrank_top k E
  have hkerqp : Module.finrank k (LinearMap.range p) = Module.finrank k (LinearMap.ker q) := by
    rw [hC]
  rw [hkerp] at hrnp
  rw [hrangeq] at hrnq
  omega

end ExactDim

/-! ## §N15/N16. The `k`-dimension χ-ledger and the Riemann inequality

We now assemble the numerical χ-ledger over a field of constants `k`.  With
`ℓ(D) := dim_k Γ(⊤, 𝒪(D))` and `h¹(D) := dim_k Ȟ¹(D)`, the Euler characteristic
`χ(D) := ℓ(D) − h¹(D)` telescopes along the twist ledger: `χ(D + P) = χ(D) +
dim_k(𝒜(D')/𝒜(D))`, and the local dimension `dim_k(𝒜(D')/𝒜(D)) = deg P`
(node N14).  The Riemann inequality `deg D + χ(0) ≤ ℓ(D)` is the elementary
consequence `χ(D) ≤ ℓ(D)` (i.e. `h¹(D) = i(D) ≥ 0`) combined with the telescoped
`χ(D) = χ(0) + deg D`. -/

section ChiLedgerDim

variable (k : Type u) [Field k] {X : Scheme.{u}} [IsIntegral X]
    [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X]
    [Algebra k X.functionField] [IsConstantField k X]