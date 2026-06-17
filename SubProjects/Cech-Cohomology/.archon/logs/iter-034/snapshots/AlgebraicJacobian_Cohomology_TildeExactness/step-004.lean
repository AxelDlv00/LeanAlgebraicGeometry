/-
Copyright (c) 2026 Axel Delaval. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Axel Delaval
-/
import Mathlib.AlgebraicGeometry.Modules.Tilde
import Mathlib.RingTheory.LocalProperties.Exactness
import Mathlib.CategoryTheory.Preadditive.LeftExact

/-!
# Exactness of the tilde functor (Stacks 01HV) — Route-P step P3

Project-local supplement feeding `AlgebraicGeometry.qcoh_kernel_qcoh`.

For `X = Spec R`, the tilde functor `~ : ModuleCat R ⥤ (Spec R).Modules`,
`M ↦ M^~`, is exact.  The named target of this file is
`AlgebraicGeometry.tildePreservesFiniteLimits : PreservesFiniteLimits (tilde.functor R)`
(the *left*-exactness / kernel-preservation half).

## What is delivered (axiom-clean)

* `tilde_preservesFiniteColimits` — the *right*-exactness half: `~` is a left adjoint
  (`AlgebraicGeometry.tilde.adjunction`), hence preserves all colimits, in particular finite
  colimits.  This is one of the two halves of exactness.
* `tilde_toStalk_map_injective` — the *flatness core* in the only publicly-accessible form:
  for an injective `R`-module map `f : M ⟶ N`, the localised stalk map
  `M_𝔭 →ₗ[R] N_𝔭` (built from Mathlib's `IsLocalizedModule (tilde.toStalk · x)` instances) is
  injective.  This is the algebraic content that "localisation `R → R_𝔭` is flat" contributes
  to mono-preservation.

## Why `tildePreservesFiniteLimits` itself is NOT closed here

The mathematical route (blueprint `lem:tilde_preserves_kernels`) is stalkwise flatness.  Two
genuine obstructions remain, each a non-trivial build:

1. **Mono-preservation plumbing.**  The reduction
   `Functor.preservesFiniteLimits_of_preservesKernels` turns the goal into "tilde preserves
   every kernel `parallelPair f 0`".  For that one wants either the stalkwise detector
   `TopCat.Presheaf.mono_of_stalk_mono` / `app_injective_of_stalkFunctor_map_injective`, with the
   stalk map identified with the localised map of `f`.
   * The **`ModuleCat R`-valued** stalk path (where everything is `R`-linear by construction) is
     blocked: the localisation handles `StructureSheaf.toStalkₗ'`, `stalkIsoₗ`,
     `stalkToLocalizationₗ`, `structurePresheafInModuleCat` are all **module-private** in Mathlib
     (`Mathlib/AlgebraicGeometry/StructureSheaf.lean`) and are not name-accessible downstream.
   * The **`Ab`-valued** stalk path is open via `Scheme.Modules.toPresheaf` (faithful, reflects
     isos, preserves limits) and the public `IsLocalizedModule (tilde.toStalk M x).hom` instance,
     but requires packaging the `Ab` germ-induced stalk map as an `R`-linear map and a
     germ-naturality identification (`stalkFunctor_map_germ` + a `⊤`-section naturality matching
     `tilde.toOpen`); this is the remaining ~100–200 LOC of transport.
2. **The categorical glue is absent from Mathlib.**  Even granting mono-preservation, there is no
   Mathlib lemma "additive + preserves finite colimits (right exact) + preserves monomorphisms ⟹
   preserves finite limits (left exact)".  It must be built (image-factorisation / short-exact
   sequence argument in the abelian category `(Spec R).Modules`).

See `task_results/AlgebraicJacobian.Cohomology.TildeExactness.md` for the precise next steps.
-/

universe u

open CategoryTheory Limits AlgebraicGeometry

namespace AlgebraicGeometry

variable {R : CommRingCat.{u}}

/-! ## Project-local Mathlib supplement — exactness of the tilde functor -/

/-- **Right-exactness of `~`.**  The tilde functor `~ : ModuleCat R ⥤ (Spec R).Modules`
preserves finite colimits: it is a left adjoint (`AlgebraicGeometry.tilde.adjunction`), so it
preserves all colimits.  Project-local because the packaged statement is what the
kernel/cokernel quasi-coherence argument (Stacks `lemma-kernel-cokernel-quasi-coherent`)
consumes alongside the (still open) finite-limit half. -/
theorem tilde_preservesFiniteColimits :
    Limits.PreservesFiniteColimits (tilde.functor R) := inferInstance

/-- **Flatness core of mono-preservation for `~`.**  For an injective `R`-module map
`f : M ⟶ N` and a point `x ↔ 𝔭` of `Spec R`, the induced localised map on stalks
`M_𝔭 →ₗ[R] N_𝔭` — assembled from Mathlib's `IsLocalizedModule (tilde.toStalk · x).hom`
instances via `IsLocalizedModule.map` — is injective.  This is exactly the contribution of
"localisation `R → R_𝔭` is flat" to the statement that `~` preserves monomorphisms (Stacks
01HV, exactness of `~`).  Stated with the publicly-accessible stalk-localisation map
`AlgebraicGeometry.tilde.toStalk`, the only such handle exported by Mathlib. -/
theorem tilde_toStalk_map_injective {M N : ModuleCat R} (f : M ⟶ N)
    (hf : Function.Injective f.hom) (x : PrimeSpectrum.Top R) :
    Function.Injective (IsLocalizedModule.map x.asIdeal.primeCompl
      (AlgebraicGeometry.tilde.toStalk M x).hom (AlgebraicGeometry.tilde.toStalk N x).hom f.hom) :=
  IsLocalizedModule.map_injective _ _ _ _ hf

/-- **Reduction of the named target.**  `tildePreservesFiniteLimits` follows once `~` is shown to
preserve every kernel `parallelPair f 0`; all the ambient typeclass hypotheses of
`Functor.preservesFiniteLimits_of_preservesKernels` are already discharged for
`tilde.functor R` (it is additive, `ModuleCat R` and `(Spec R).Modules` have the requisite
finite (co)products / zero objects).  Recorded project-locally so the remaining obligation is a
single, sharply-stated hypothesis for the continuation lane. -/
theorem tilde_preservesFiniteLimits_of_preservesKernels
    (H : ∀ {M N : ModuleCat R} (f : M ⟶ N),
      PreservesLimit (parallelPair f 0) (tilde.functor R)) :
    PreservesFiniteLimits (tilde.functor R) :=
  Functor.preservesFiniteLimits_of_preservesKernels _

/-! ### SCRATCH probes -/

section Scratch

example {M N : ModuleCat R} (f : M ⟶ N) (x : PrimeSpectrum.Top R) (m : M) :
    (TopCat.Presheaf.stalkFunctor _ x).map
        ((Scheme.Modules.toPresheaf (Spec (.of R))).map (tilde.map f))
        ((tilde.toStalk M x).hom m)
      = (tilde.toStalk N x).hom (f.hom m) := by
  change (TopCat.Presheaf.stalkFunctor _ x).map
        ((Scheme.Modules.toPresheaf (Spec (.of R))).map (tilde.map f))
        (TopCat.Presheaf.germ (AlgebraicGeometry.moduleStructurePresheaf R M).presheaf ⊤ x
          (by trivial) (StructureSheaf.toOpenₗ R M ⊤ m))
      = TopCat.Presheaf.germ (AlgebraicGeometry.moduleStructurePresheaf R N).presheaf ⊤ x
          (by trivial) (StructureSheaf.toOpenₗ R N ⊤ (f.hom m))
  erw [TopCat.Presheaf.stalkFunctor_map_germ_apply ⊤ x True.intro
    ((Scheme.Modules.toPresheaf (Spec (.of R))).map (tilde.map f)) (StructureSheaf.toOpenₗ R M ⊤ m)]
  sorry

end Scratch

end AlgebraicGeometry
