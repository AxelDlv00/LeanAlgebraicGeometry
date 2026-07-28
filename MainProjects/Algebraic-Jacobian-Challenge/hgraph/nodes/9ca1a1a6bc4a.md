---
author: sync
content_type: theorem
created: '2026-07-28T15:48:27'
decl: CategoryTheory.SymPowData.symAVMap_unique
docstring: '`Sym^n φ` is the *unique* morphism restoring the `n`-fold sum along `proj`.'
file: AlgebraicJacobian/Albanese/SymPowInterface.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.SymPowData.symAVMap_unique
type: lean
updated: '2026-07-28T15:48:27'
---
theorem symAVMap_unique {A : K} [MonObj A] [IsCommMonObj A]
    (D : SymPowData C n) (φ : C ⟶ A) (u : D.carrier ⟶ A)
    (hu : D.proj ≫ u = MonObj.powSum n φ) : u = D.symAVMap φ :=
  (D.desc (MonObj.powSum n φ) (fun σ => MonObj.powSum_perm n φ σ)).choose_spec.2 u hu

end SymAVMap

end SymPowData

/-! ## §2. Milne's `Q ↦ Q + (n − 1) P₀`, and why it collapses the sum

The backward direction of the Albanese connector restricts the symmetric-power
equation along `Q ↦ (Q, P₀, …, P₀)`. The whole force of that step is the following
computation in the hom-monoid: summing `φ` over such a tuple gives
`φ(Q) + φ(P₀) + ⋯ + φ(P₀)`, and a *pointed* `φ` kills every term but the first. -/

namespace MonObj

variable {C : K}