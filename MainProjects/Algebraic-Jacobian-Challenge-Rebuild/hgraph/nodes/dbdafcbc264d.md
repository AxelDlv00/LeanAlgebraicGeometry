---
author: sync
content_type: theorem
created: '2026-07-17T21:17:13'
decl: Module.Flat.of_surjective_exact_of_forall_rTensor_residueField_injective
docstring: '**The slicing criterion, module form** (Kleiman `lm:ctn` (iii)⟹(i), flat-quotient

  conclusion): over a Noetherian ring `R`, if `φ` is an endomorphism of a flat module
  `M`

  that is injective on every residue-field fibre, then any quotient of `M` by the
  image of

  `φ` (presented as a surjection `π` exact against `φ`) is flat.'
file: AlgebraicJacobian/Picard/SlicingFlat.lean
generated: lean
lean_status: lean_ok
stale: true
title: Module.Flat.of_surjective_exact_of_forall_rTensor_residueField_injective
type: lean
updated: '2026-07-30T15:28:04'
---
theorem Module.Flat.of_surjective_exact_of_forall_rTensor_residueField_injective
    [IsNoetherianRing R] [Module.Flat R M] (φ : M →ₗ[R] M) (π : M →ₗ[R] Q)
    (hsurj : Function.Surjective π) (hexact : Function.Exact φ π)
    (hfib : ∀ p : PrimeSpectrum R,
      Function.Injective (φ.rTensor p.asIdeal.ResidueField)) :
    Module.Flat R Q :=
  Module.Flat.of_surjective_exact_of_forall_mem_smul_top φ π hsurj hexact
    (fun I _ _ hx => Module.Flat.mem_smul_top_of_apply_mem_smul_top φ hfib I hx)

end FlatOfExact

/-! ## The ring form: flatness and projectivity of the principal colength -/

section RingForm

variable {R : Type u} [CommRing R] {B : Type u} [CommRing B] [Algebra R B]