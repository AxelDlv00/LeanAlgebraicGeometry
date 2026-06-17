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

end AlgebraicGeometry
