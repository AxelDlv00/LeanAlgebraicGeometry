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

end AlgebraicGeometry
