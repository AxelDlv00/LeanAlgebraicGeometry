/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomologyHomotopy
import MumfordLib.SingularCohomologyPoint
import Mathlib.Topology.Homotopy.Contractible

/-!
# Positive-degree singular cohomology of contractible spaces

Homotopy invariance transports the point computation to every contractible
space. Thus every positive-degree integral singular cocycle has a primitive.
The result concerns the homology of the actual integral singular cochain
complex and supplies an acyclicity prerequisite for the circle computation in
Mumford, Chapter I, Section 1, p. 3.
-/

set_option autoImplicit false

noncomputable section

namespace Mumford.Analytic

variable {X : TopCat} {n : ℕ}

/-- Positive-degree integral singular cohomology of a contractible space vanishes. -/
theorem integralSingularCohomology_eq_zero_of_contractible [ContractibleSpace X]
    (c : IntegralSingularCohomology X (n + 1)) : c = 0 := by
  obtain ⟨e⟩ := ContractibleSpace.hequiv_unit X
  let E := singularCohomologyHomotopyEquiv (X := X) (Y := TopCat.of Unit) e (n + 1)
  obtain ⟨d, rfl⟩ := E.surjective c
  rw [integralSingularCohomology_eq_zero_of_subsingleton d, map_zero]

/-- The positive-degree cohomology groups of a contractible space are trivial. -/
theorem integralSingularCohomology_subsingleton_of_contractible [ContractibleSpace X]
    (n : ℕ) : Subsingleton (IntegralSingularCohomology X (n + 1)) := by
  refine ⟨fun c d => ?_⟩
  rw [integralSingularCohomology_eq_zero_of_contractible c,
    integralSingularCohomology_eq_zero_of_contractible d]

/-- Every positive-degree cocycle on a contractible space has a primitive. -/
theorem singularCocycle_exists_primitive_of_contractible [ContractibleSpace X]
    (φ : singularCocycles X (n + 1)) :
    ∃ ψ : IntegralSingularCochain X n,
      singularCoboundaryToCocycles X n ψ = φ := by
  exact (singularPositiveCohomologyClass_eq_zero_iff X n φ).mp
    (integralSingularCohomology_eq_zero_of_contractible
      (singularPositiveCohomologyClass X n φ))

end Mumford.Analytic
