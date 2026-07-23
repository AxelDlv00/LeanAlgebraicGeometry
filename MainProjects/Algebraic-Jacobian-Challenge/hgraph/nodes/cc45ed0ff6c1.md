---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicJacobian.GaloisDescent.SemilinearAction.avg_mem_invariants
file: AlgebraicJacobian/Picard/GaloisDescent/SemilinearModules.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.SemilinearAction.avg_mem_invariants
type: lean
updated: '2026-07-24T03:02:10'
---
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