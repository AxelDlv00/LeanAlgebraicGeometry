---
author: sync
content_type: theorem
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.IsAffineOpen.exists_pow_mul_eq_zero_of_res_eq_zero
docstring: 'Annihilation on an affine open: a section of the structure sheaf on `U`
  restricting to

  zero on `U ⊓ D(g)` is killed by a power of `g`.'
file: AlgebraicJacobian/RiemannRoch/Ledger/AffineCech.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.IsAffineOpen.exists_pow_mul_eq_zero_of_res_eq_zero
type: lean
updated: '2026-07-28T18:12:20'
---
theorem exists_pow_mul_eq_zero_of_res_eq_zero (t : Γ(X, U))
    (ht : X.resHom (inf_le_left : U ⊓ X.basicOpen g ≤ U) t = 0) :
    ∃ M : ℕ, X.resHom hUW g ^ M * t = 0 := by
  have hb : X.basicOpen (X.resHom hUW g) = U ⊓ X.basicOpen g :=
    basicOpen_resHom hUW g
  haveI := hU.isLocalization_basicOpen (X.resHom hUW g)
  have h0 : algebraMap Γ(X, U) Γ(X, X.basicOpen (X.resHom hUW g)) t = 0 := by
    rw [Scheme.algebraMap_basicOpen_eq_resHom]
    have hcomp : X.resHom (X.basicOpen_le (X.resHom hUW g)) t =
        X.resHom hb.le (X.resHom inf_le_left t) := by
      rw [Scheme.resHom_resHom]
    rw [hcomp, ht, map_zero]
  obtain ⟨m, hm⟩ := (IsLocalization.map_eq_zero_iff
    (Submonoid.powers (X.resHom hUW g)) _ t).mp h0
  obtain ⟨M, hM⟩ := (Submonoid.mem_powers_iff (m : Γ(X, U))
    (X.resHom hUW g)).mp m.2
  refine ⟨M, ?_⟩
  calc X.resHom hUW g ^ M * t = ↑m * t := by rw [← hM]
    _ = 0 := hm

variable {hU hUW g}