/-
Copyright (c) 2026 Archon Horizon. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Horizon (Archon Horizon)
-/
import Mathlib

/-!
# Galois descent for semilinear representations (Speiser's theorem)

This file supplies the **finite Galois descent** substrate for the FGA Picard-scheme
representability campaign (`instHasPicScheme`, cluster `G` of
`informal/pic-representability-campaign.md`): milestone `G2(b)` (Speiser's
semilinear descent) and its consumers `G1`/`G3`.

Let `L/K` be a finite Galois extension with group `G = Gal(L/K) = L ≃ₐ[K] L`, and
let `V` be an `L`-vector space equipped with a **semilinear** `G`-action, i.e. an
additive `G`-action with
`σ • (a • v) = σ a • (σ • v)` for `σ ∈ G`, `a ∈ L`, `v ∈ V` (`IsSemilinear`).
The `K`-subspace of invariants `V^G` (`SemilinearAction.invariants`) is a `K`-form
of `V`: the canonical `L`-linear map

`descentMap : L ⊗[K] V^G → V`,  `a ⊗ v ↦ a • v`

is an **isomorphism** (`descentEquiv`), so `dim_K V^G = dim_L V`. This is Speiser's
theorem — Galois descent for vector spaces — the algebraic heart of the finite
Galois quotient engine `G2`.

## Main definitions and results

* `IsSemilinear K L V` — the semilinearity hypothesis on a `G`-action.
* `SemilinearAction.invariants K L V : Submodule K V` — the fixed subspace `V^G`.
* `SemilinearAction.avg K L a v : V` — the averaging element `∑_σ σ a • (σ • v)`,
  which always lies in `V^G` (`avg_mem_invariants`).
* `SemilinearAction.descentMap K L V : L ⊗[K] V^G →ₗ[L] V` — the descent map.
* `SemilinearAction.descentMap_bijective` / `descentEquiv` — Speiser's theorem.

## Mathlib inputs

The linear-algebra heart is **Dedekind's independence of characters**
(`linearIndependent_algHom_toLinearMap`): the `K`-algebra homomorphisms `L →ₐ[K] L`
are `L`-linearly independent as `K`-linear maps.  Combined with the finite-field
count `AlgHom.card`, the "Galois matrix" `(σ (b i))_{σ, i}` of a `K`-basis `b` of
`L` is invertible over `L`, which powers both directions of the descent isomorphism.

Campaign reference: milestone `G2` of `informal/pic-representability-campaign.md`
(Kleiman §4 uses finite Galois descent to build `Pic_{C/k}` from `Pic_{C_{k'}/k'}`;
this brick is field-agnostic and reused for `Sym^d`/Albanese).
-/

universe u v

open scoped TensorProduct

namespace AlgebraicJacobian.GaloisDescent

variable (K L : Type u) [Field K] [Field L] [Algebra K L]
variable (V : Type v) [AddCommGroup V] [Module K V] [Module L V] [IsScalarTower K L V]
variable [DistribMulAction (L ≃ₐ[K] L) V]

/-- A **semilinear** `Gal(L/K)`-action on an `L`-module `V`: the additive `G`-action
is compatible with the `L`-scalar action twisted by `σ`, i.e.
`σ • (a • v) = σ a • (σ • v)`. -/
class IsSemilinear : Prop where
  /-- The semilinearity relation `σ • (a • v) = σ a • (σ • v)`. -/
  smul_smul' (σ : L ≃ₐ[K] L) (a : L) (v : V) : σ • (a • v) = σ a • σ • v

namespace SemilinearAction

variable {K L V}

omit [Module K V] [IsScalarTower K L V] in
lemma smul_smul_apply [IsSemilinear K L V]
    (σ : L ≃ₐ[K] L) (a : L) (v : V) : σ • (a • v) = σ a • σ • v :=
  IsSemilinear.smul_smul' σ a v

variable (K L V)

/-- The `K`-subspace `V^G` of `Gal(L/K)`-invariant vectors. It is a `K`-submodule
(not `L`) because the `G`-action is only `K`-semilinear. -/
def invariants [IsSemilinear K L V] : Submodule K V where
  carrier := {v | ∀ σ : L ≃ₐ[K] L, σ • v = v}
  add_mem' {x y} hx hy σ := by rw [smul_add, hx, hy]
  zero_mem' σ := smul_zero σ
  smul_mem' c v hv σ := by
    -- `c : K` acts through `L`; `σ` fixes `K`, so it fixes `c • v`.
    rw [← IsScalarTower.algebraMap_smul L c v, smul_smul_apply, AlgEquiv.commutes, hv]

@[simp] lemma mem_invariants [IsSemilinear K L V] {v : V} :
    v ∈ invariants K L V ↔ ∀ σ : L ≃ₐ[K] L, σ • v = v := Iff.rfl

variable {V}

/-- The **averaging** element `∑_σ σ a • (σ • v)`.  For every `a : L` and `v : V`
it lies in the invariants `V^G` (`avg_mem_invariants`); ranging `a` over `L` it
produces enough invariants to span `V` over `L` (`span_avg_eq_top`). -/
noncomputable def avg [FiniteDimensional K L] (a : L) (v : V) : V :=
  ∑ σ : L ≃ₐ[K] L, σ a • σ • v

variable {K L}

lemma avg_mem_invariants [FiniteDimensional K L] [IsSemilinear K L V] (a : L) (v : V) :
    avg K L a v ∈ invariants K L V := by
  intro τ
  have hτ : τ • avg K L a v = ∑ σ : L ≃ₐ[K] L, (τ * σ) a • (τ * σ) • v := by
    rw [avg, Finset.smul_sum]
    refine Finset.sum_congr rfl fun σ _ => ?_
    rw [smul_smul_apply, ← mul_smul, ← AlgEquiv.mul_apply]
  rw [hτ, avg]
  exact Equiv.sum_comp (Equiv.mulLeft τ) (fun σ => σ a • σ • v)

variable (K L V)

/-- The **descent map** `L ⊗[K] V^G →ₗ[L] V`, `a ⊗ v ↦ a • v`, the `L`-linear
extension of the `K`-linear inclusion `V^G ↪ V`.  Speiser's theorem
(`descentMap_bijective`) is that it is bijective. -/
noncomputable def descentMap [IsSemilinear K L V] :
    L ⊗[K] (invariants K L V) →ₗ[L] V :=
  TensorProduct.AlgebraTensorModule.lift
    (LinearMap.toSpanSingleton L _ (invariants K L V).subtype)

@[simp] lemma descentMap_tmul [IsSemilinear K L V] (a : L) (w : invariants K L V) :
    descentMap K L V (a ⊗ₜ[K] w) = a • (w : V) := by
  simp [descentMap, LinearMap.toSpanSingleton_apply, LinearMap.smul_apply]

end SemilinearAction

end AlgebraicJacobian.GaloisDescent
