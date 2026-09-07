/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4OrdinaryFiberBasePointFree
import HartshorneLib.Chapter4ProjectivePullbackCoordinateFibers

/-!
# Base-point-freeness from a projective pullback isomorphism

An isomorphism between a divisor module and the pullback of `O(1)` along a
morphism to projective space gives the numerical base-point-free condition.  The proof
extracts the homogeneous coordinate sections and their nonvanishing fibers;
it assumes neither a complete basis of global sections nor base-point-freeness.
This supplies the base-point-free part of the converse in Hartshorne IV.3.1.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]

attribute [local instance] MvPolynomial.gradedAlgebra
attribute [local instance] functionFieldOverModule Scheme.overModule

/-- Pullback of the projective twisting sheaf makes a divisor's complete
linear system base-point-free.  The coordinate sections may be dependent. -/
theorem basePointFreeLinearSystem_of_projectivePullbackIso
    (D : CurveDivisor k X) {J : Type}
    (f : X.left ⟶ Proj (MvPolynomial.homogeneousSubmodule J k))
    (e : (Scheme.Modules.pullback f).obj (ProjectiveTwist.twistingSheafOne (k := k) (J := J)) ≅
      divisorModule D) :
    BasePointFreeLinearSystem D := by
  apply (basePointFreeLinearSystem_iff_exists_jumpProj_ne_zero D).mpr
  intro x hx
  obtain ⟨i, hi⟩ := ProjectiveTwist.exists_coordinateSectionOfIso_fiber_ne_zero f e x
  let s := ProjectiveTwist.coordinateSectionOfIso f e i ⊤
  refine ⟨(show divisorSections D (⊤ : X.left.Opens) from s), ?_⟩
  intro hz
  apply hi
  apply stalkJumpFiberAddHom_of_divisorModule_injective hx D
  rw [map_zero, stalkJumpFiberAddHom_of_divisorModule_fiberEvaluation, stalkJump_germ]
  exact hz

end
end Hartshorne
