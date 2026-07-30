---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.moduleFinite_quotient_pow_of_isPrincipal
docstring: '**Finiteness dévissage.** If `B ⧸ I` is a finite `K`-module for a nonzero
  principal

  ideal `I`, then so is `B ⧸ Iⁿ` for every `n`: induct along the filtration

  `Iⁿ ⧸ Iⁿ⁺¹ ≅ B ⧸ I` (the landed `quotEquivMapPow`), using that module finiteness
  is closed

  under extensions (`Module.Finite.of_submodule_quotient`).'
file: AlgebraicJacobian/Algebra/LocalizedColength.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.moduleFinite_quotient_pow_of_isPrincipal
type: lean
updated: '2026-07-30T15:45:59'
---
theorem moduleFinite_quotient_pow_of_isPrincipal {I : Ideal B} (h : I.IsPrincipal)
    (h' : I ≠ ⊥) [Module.Finite K (B ⧸ I)] (n : ℕ) : Module.Finite K (B ⧸ I ^ n) := by
  induction n with
  | zero =>
    have hle : I ≤ I ^ 0 := by rw [pow_zero, Ideal.one_eq_top]; exact le_top
    exact Module.Finite.of_surjective (Ideal.Quotient.factorₐ K hle).toLinearMap
      (Ideal.Quotient.factor_surjective hle)
  | succ n ih =>
    set g : (B ⧸ I ^ (n + 1)) →ₗ[K] (B ⧸ I ^ n) :=
      (Ideal.Quotient.factorₐ K (Ideal.pow_le_pow_right n.le_succ)).toLinearMap with hg_def
    have hg : Function.Surjective g :=
      Ideal.Quotient.factor_surjective (Ideal.pow_le_pow_right n.le_succ)
    have hker : LinearMap.ker g =
        Submodule.restrictScalars K (Ideal.map (Ideal.Quotient.mk (I ^ (n + 1))) (I ^ n)) := by
      apply SetLike.ext
      intro x
      rw [LinearMap.mem_ker, Submodule.restrictScalars_mem, hg_def, AlgHom.toLinearMap_apply,
        Ideal.Quotient.factorₐ_apply, ← RingHom.mem_ker, Ideal.Quotient.factor_ker]
    haveI : Module.Finite K (LinearMap.ker g) := by
      rw [hker]
      exact Module.Finite.equiv (quotEquivMapPow h h' n)
    haveI := ih
    haveI : Module.Finite K ((B ⧸ I ^ (n + 1)) ⧸ LinearMap.ker g) :=
      Module.Finite.equiv (g.quotKerEquivOfSurjective hg).symm
    exact Module.Finite.of_submodule_quotient (LinearMap.ker g)

end Devissage

/-! ### Multiplicities and the adic valuation -/

section Count

variable {B : Type*} [CommRing B] [IsDedekindDomain B]