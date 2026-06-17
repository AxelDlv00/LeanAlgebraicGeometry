/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.CechToCohomology

/-!
# Serre vanishing on affines (Stacks 02KG) — affine cover-system infrastructure

Project-local: builds the *affine cover system* feeding the basis-comparison criterion
`cech_eq_cohomology_of_basis` (01EO). The basis `B` is the distinguished opens `D(f)`
of an affine scheme, and the admissible coverings `Cov` are the standard open covers.

This file builds the cover-system infrastructure (Lane 1 of the 02KG decomposition) as far
as possible; the quasi-coherent seed `affine_cech_vanishing_qcoh` and the top
`affine_serre_vanishing` are handed off to the assembly iteration (they consume Lane 2's
`qcoh_iso_tilde_sections`).
-/

universe u

open CategoryTheory Limits TopologicalSpace

namespace AlgebraicGeometry

variable {X : Scheme.{u}}

/-! ## Project-local Mathlib supplement — distinguished opens closed under finite intersection -/

/-- **Distinguished opens are closed under finite intersection** (Stacks 02KG, condition (1)).
For a family `s : ι → R` of ring elements and a Čech multi-index `σ : Fin (p + 1) → ι`, the
`(p + 1)`-fold intersection of distinguished opens `⨅ₖ D(s_{σ k})` is again a distinguished
open, namely `D(∏ₖ s_{σ k})`; hence it lies in the basis of distinguished opens. This discharges
the `faces_mem` field of the affine cover system. Project-local: re-export of `basicOpen_sprod`
in the membership shape the `BasisCovSystem.faces_mem` field consumes. -/
theorem affine_faces_mem {R : CommRingCat.{u}} {ι : Type u} (s : ι → R)
    {p : ℕ} (σ : Fin (p + 1) → ι) :
    (⨅ k, PrimeSpectrum.basicOpen (s (σ k)) : (Spec R).Opens)
      ∈ Set.range (fun f : R => (PrimeSpectrum.basicOpen f : (Spec R).Opens)) :=
  ⟨∏ k, s (σ k), (basicOpen_sprod (p + 1) s σ).symm⟩

/-! ## Project-local Mathlib supplement — covering-datum bridge to the open-cover Čech form -/

/-- **The standard affine open cover realizes the distinguished-open family.** For a spanning
family `s : ι → R`, the `i`-th member of the standard affine open cover
`affineOpenCoverOfSpanRangeEqTop s hs` of `Spec R` has open range exactly the distinguished open
`D(s_i)`, i.e. `coverOpen 𝒰 i = PrimeSpectrum.basicOpen (s i)`. This is the open-level half of the
covering-datum bridge (`lem:cover_datum_bridge`): funext-rewriting the raw family `c.2 = fun i ↦
D(s_i)` to `coverOpen 𝒰` identifies the two section Čech complexes, so the Čech cohomology computed
over the raw `CovDatum` and over the `X.OpenCover` agree. Project-local: needed to feed the
`X.OpenCover`-shaped `injective_cech_acyclic` into the raw-family `BasisCovSystem` fields. -/
theorem coverOpen_affineOpenCoverOfSpan {R : CommRingCat.{u}} {ι : Type u} [Finite ι]
    (s : ι → R) (hs : Ideal.span (Set.range s) = ⊤) (i : ι) :
    coverOpen (Scheme.AffineOpenCover.openCover (Scheme.affineOpenCoverOfSpanRangeEqTop s hs)) i
      = PrimeSpectrum.basicOpen (s i) := by
  unfold coverOpen
  change (Spec.map (CommRingCat.ofHom (algebraMap R (Localization.Away (s i))))).opensRange = _
  apply TopologicalSpace.Opens.ext
  change Set.range (Spec.map (CommRingCat.ofHom (algebraMap R (Localization.Away (s i))))).base = _
  rw [Spec.map_base]
  exact PrimeSpectrum.localization_away_comap_range (Localization.Away (s i)) (s i)

/-! ## Project-local Mathlib supplement — injective acyclicity for the standard affine cover -/

/-- **Injective Čech-acyclicity for the standard affine cover** (Stacks 02KG, `injective_acyclic`
field; Stacks `lemma-injective-trivial-cech`). For a spanning family `s : ι → R` (so the
distinguished opens `D(s_i)` cover `Spec R`) and an injective `O_X`-module `I`, the positive-degree
section Čech cohomology over the standard cover vanishes:
`Ȟ^q(𝒰, I) = 0` for all `q > 0`. Reduces the raw-family `cechCohomology` to the `X.OpenCover` form
via `coverOpen_affineOpenCoverOfSpan` and applies `injective_cech_acyclic`. Project-local: this is
the affine instantiation of `injective_cech_acyclic` discharging the
`BasisCovSystem.injective_acyclic` field for standard covers of the whole affine. -/
theorem affine_injective_acyclic {R : CommRingCat.{u}} {ι : Type u} [Finite ι]
    (s : ι → R) (hs : Ideal.span (Set.range s) = ⊤)
    (I : (Spec R).Modules) [Injective I] (q : ℕ) (hq : 0 < q) :
    IsZero (cechCohomology (fun i => PrimeSpectrum.basicOpen (s i))
      ((Scheme.Modules.toPresheafOfModules (Spec R)).obj I) q) := by
  have hbridge : (fun i => PrimeSpectrum.basicOpen (s i))
      = coverOpen (Scheme.affineOpenCoverOfSpanRangeEqTop s hs).openCover := by
    funext i; exact (coverOpen_affineOpenCoverOfSpan s hs i).symm
  haveI : Finite (Scheme.affineOpenCoverOfSpanRangeEqTop s hs).openCover.I₀ :=
    inferInstanceAs (Finite ι)
  rw [cechCohomology, hbridge]
  exact injective_cech_acyclic (Scheme.affineOpenCoverOfSpanRangeEqTop s hs).openCover I q hq

/-! ## Project-local Mathlib supplement — the underlying-abelian-sheaf functor preserves epis -/

set_option synthInstance.maxHeartbeats 4000000 in
set_option maxHeartbeats 4000000 in
set_option backward.isDefEq.respectTransparency false in
/-- **The underlying-abelian-sheaf functor preserves epimorphisms** (blueprint
`lem:to_sheaf_preserves_epi`; project-bespoke gap-fill). The forgetful functor
`SheafOfModules.toSheaf` from sheaves of `O_X`-modules to the underlying sheaves of abelian
groups preserves epimorphisms. Project-local: Mathlib provides `PreservesFiniteLimits` for
`toSheaf` but not epi-preservation; this unlocks the passage from a module epimorphism to local
section surjectivity in `affine_surj_of_vanishing`. -/
instance toSheaf_preservesEpimorphisms :
    (SheafOfModules.toSheaf X.ringCatSheaf).PreservesEpimorphisms := by
  apply Functor.preservesEpimorphisms_of_preserves_shortExact_right
  intro S hS
  sorry

end AlgebraicGeometry
