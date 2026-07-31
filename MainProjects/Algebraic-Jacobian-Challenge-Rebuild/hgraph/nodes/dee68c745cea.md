---
author: sync
content_type: theorem
created: '2026-07-19T10:31:16'
decl: Module.Flat.quotient_range_of_forall_rTensor_residueField_injective
docstring: '**Fibrewise injective ⟹ flat cokernel**: for `ψ : P → N` with `P` finite,
  `N` finite

  flat and `ψ ⊗ κ(p)` injective at every prime, the cokernel `N ⧸ range ψ` is flat
  (locally

  it is even free, by `Module.free_of_lTensor_residueField_injective`).'
file: AlgebraicJacobian/Picard/SlicingFlatKernel.lean
generated: lean
lean_status: lean_ok
title: Module.Flat.quotient_range_of_forall_rTensor_residueField_injective
type: lean
updated: '2026-07-31T20:15:28'
---
theorem Module.Flat.quotient_range_of_forall_rTensor_residueField_injective
    [Module.Finite R P] [Module.Finite R N] [Module.Flat R N] (ψ : P →ₗ[R] N)
    (hfib : ∀ p : PrimeSpectrum R,
      Function.Injective (ψ.rTensor p.asIdeal.ResidueField)) :
    Module.Flat R (N ⧸ LinearMap.range ψ) := by
  apply Module.flat_of_localized_maximal
  intro J hJ
  haveI : Module.Finite (Localization.AtPrime J) (LocalizedModule J.primeCompl P) :=
    Module.Finite.of_isLocalizedModule J.primeCompl (LocalizedModule.mkLinearMap J.primeCompl P)
  haveI : Module.Finite (Localization.AtPrime J) (LocalizedModule J.primeCompl N) :=
    Module.Finite.of_isLocalizedModule J.primeCompl (LocalizedModule.mkLinearMap J.primeCompl N)
  haveI : Module.Free (Localization.AtPrime J) (LocalizedModule J.primeCompl N) :=
    Module.free_of_flat_of_isLocalRing
  haveI : Module.Free (Localization.AtPrime J)
      (LocalizedModule J.primeCompl (N ⧸ LinearMap.range ψ)) :=
    Module.free_of_lTensor_residueField_injective
      (LocalizedModule.map J.primeCompl ψ)
      (LocalizedModule.map J.primeCompl (LinearMap.range ψ).mkQ)
      (LocalizedModule.map_surjective _ _ (Submodule.mkQ_surjective _))
      (LocalizedModule.map_exact _ _ _ ψ.exact_map_mkQ_range)
      (injective_lTensor_residueField_localizedMap J ψ (hfib ⟨J, hJ.isPrime⟩))
  exact Module.Flat.trans R (Localization.AtPrime J) _

end FibrewiseInjective

/-! ## The kernel-flattening keystones -/

section KernelFlattening

variable {R : Type u} [CommRing R] [IsNoetherianRing R]
variable {M : Type v} {N : Type w} [AddCommGroup M] [Module R M] [AddCommGroup N] [Module R N]
variable [Module.Finite R M] [Module.Finite R N] [Module.Flat R N]
variable (f : M →ₗ[R] N) (L : Submodule R M)

omit [IsNoetherianRing R] [Module.Finite R M] [Module.Finite R N] [Module.Flat R N] in