/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomologyContractible
import Mathlib.Geometry.Manifold.Instances.Sphere
import Mathlib.Analysis.Convex.Contractible

/-!
# Singular cohomology of a punctured sphere

Stereographic projection identifies a punctured unit sphere with the orthogonal
complement of the removed point. This vector space is contractible. In particular,
every positive-degree integral singular cocycle on a punctured circle is a
coboundary. This supplies the open-set computation for the circle calculation
in Mumford, Chapter I, Section 1, p. 3.
-/

set_option autoImplicit false

noncomputable section

namespace Mumford.Analytic

/-- A unit sphere with one point removed is contractible by stereographic projection. -/
theorem puncturedUnitSphere_contractible {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℝ E] (v : Metric.sphere (0 : E) 1) :
    ContractibleSpace ({v}ᶜ : Set (Metric.sphere (0 : E) 1)) := by
  exact ((stereographic (norm_eq_of_mem_sphere v)).toHomeomorphSourceTarget.trans
    (Homeomorph.Set.univ _)).contractibleSpace

/-- Removing any point from the circle leaves a contractible space. -/
theorem puncturedCircle_contractible (v : Circle) :
    ContractibleSpace ({v}ᶜ : Set Circle) :=
  puncturedUnitSphere_contractible v

/-- Positive-degree integral singular cohomology of a punctured circle vanishes. -/
theorem integralSingularCohomology_puncturedCircle_eq_zero (v : Circle) {n : ℕ}
    (c : IntegralSingularCohomology (TopCat.of ({v}ᶜ : Set Circle)) (n + 1)) : c = 0 := by
  letI := puncturedCircle_contractible v
  exact integralSingularCohomology_eq_zero_of_contractible c

/-- Every positive-degree cocycle on a punctured circle has a primitive. -/
theorem singularCocycle_puncturedCircle_exists_primitive (v : Circle) {n : ℕ}
    (φ : singularCocycles (TopCat.of ({v}ᶜ : Set Circle)) (n + 1)) :
    ∃ ψ : IntegralSingularCochain (TopCat.of ({v}ᶜ : Set Circle)) n,
      singularCoboundaryToCocycles (TopCat.of ({v}ᶜ : Set Circle)) n ψ = φ := by
  letI := puncturedCircle_contractible v
  exact singularCocycle_exists_primitive_of_contractible φ

end Mumford.Analytic
