---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicJacobian.GaloisDescent.SemilinearAction.finrank_invariants
docstring: '**Corollary (Galois descent of dimension).** `dim_K V^G = dim_L V`: the

  invariants `V^G` form a `K`-form of the semilinear representation `V`.'
file: AlgebraicJacobian/Picard/GaloisDescent/SemilinearModules.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.SemilinearAction.finrank_invariants
type: lean
updated: '2026-07-16T21:14:26'
---
theorem finrank_invariants [IsSemilinear K L V] :
    Module.finrank K (invariants K L V) = Module.finrank L V := by
  have h := (descentEquiv K L V).finrank_eq
  rwa [Module.finrank_baseChange] at h

end SemilinearAction

/-! ## The regular representation

The natural `Gal(L/K)`-action on `L` itself is semilinear, and its invariants are
`K` (Artin), so `descentEquiv` specialises to the base-change isomorphism
`L ⊗[K] L^{Gal} ≃ L`.  This confirms the framework on the universal example. -/

/-- The natural `Gal(L/K)`-action on `L` (apply the automorphism) is semilinear for
the `L`-module structure of `L` on itself. -/
instance : IsSemilinear K L L where
  smul_smul' σ a b := by simp [smul_eq_mul, AlgEquiv.smul_def]