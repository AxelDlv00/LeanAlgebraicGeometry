---
author: sync
content_type: definition
created: '2026-07-24T22:11:50'
decl: AlgebraicGeometry.Scheme.cotangent_iso_maximalIdeal_residue_tensor_kaehler_of_formallySmooth_residue
docstring: '**Stage 6.B substrate (iter-199), maximal-ideal-domain repackaging.**
  The

  same Stacks-02JK closed-point cotangent iso as

  `cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue` above, but

  restated with `(IsLocalRing.maximalIdeal Sₘ).Cotangent` (the canonical

  `Sₘ/m = κ`-module side of `IsLocalRing.CotangentSpace Sₘ`) as the domain

  rather than `(RingHom.ker (algebraMap Sₘ κ)).Cotangent`. The two coincide

  through `IsLocalRing.ResidueField.algebraMap_eq + IsLocalRing.ker_residue`,

  but the maximal-ideal form is the one Mathlib pre-equips with the κ-module

  instance via `IsLocalRing.instModuleResidueFieldCotangentSpace`, so this

  repackaging is what downstream κ-finrank computations want to consume.


  Axiom-clean: `rw`-transports the iso above along the ideal equality.'
file: AlgebraicJacobian/Albanese/CodimOneExtension.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.cotangent_iso_maximalIdeal_residue_tensor_kaehler_of_formallySmooth_residue
type: lean
updated: '2026-07-24T22:11:50'
---
noncomputable def cotangent_iso_maximalIdeal_residue_tensor_kaehler_of_formallySmooth_residue
    {R Sₘ : Type*} [CommRing R] [CommRing Sₘ] [IsLocalRing Sₘ] [Algebra R Sₘ]
    [Algebra.FormallySmooth R Sₘ]
    [Algebra.FormallySmooth R (IsLocalRing.ResidueField Sₘ)]
    [Subsingleton (Ω[IsLocalRing.ResidueField Sₘ⁄R])] :
    (IsLocalRing.maximalIdeal Sₘ).Cotangent ≃ₗ[Sₘ]
      TensorProduct Sₘ (IsLocalRing.ResidueField Sₘ) Ω[Sₘ⁄R] := by
  have hker : RingHom.ker (algebraMap Sₘ (IsLocalRing.ResidueField Sₘ)) =
      IsLocalRing.maximalIdeal Sₘ := by
    rw [IsLocalRing.ResidueField.algebraMap_eq, IsLocalRing.ker_residue]
  rw [← hker]
  exact cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue