/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4ModuleFrameEvaluation
import HartshorneLib.Chapter4ProjectivePullbackSections
import HartshorneLib.Chapter4RestrictedModuleFiber

/-!
# Nonvanishing fibers of pulled projective coordinates

A morphism to projective space and an isomorphism from its pullback of `O(1)`
produce coordinate sections with nonzero fibers on a neighbourhood of each
source point.  No basis of the complete space of global sections is assumed.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne.ProjectiveTwist

noncomputable section

variable {k : Type u} [Field k] {J : Type} {X : Scheme.{u}} {M : X.Modules}

attribute [local instance] MvPolynomial.gradedAlgebra

/-- At every source point, one pulled homogeneous coordinate has nonzero
ordinary fiber on a source neighbourhood. -/
theorem exists_coordinateSectionOfIso_local_fiber_ne_zero
    (f : X ⟶ Proj (MvPolynomial.homogeneousSubmodule J k))
    (e : (Scheme.Modules.pullback f).obj (twistingSheafOne (k := k) (J := J)) ≅ M)
    (x : X) :
    ∃ (i : J) (V : X.Opens) (hx : x ∈ V),
      Scheme.Modules.fiberEvaluation ((Scheme.Modules.restrictFunctor V.ι).obj M)
        (⟨x, hx⟩ : V.toScheme)
        (M.presheaf.map
          (homOfLE (le_top : V.ι ''ᵁ (⊤ : V.toScheme.Opens) ≤ ⊤)).op
            (coordinateSectionOfIso f e i ⊤)) ≠ 0 := by
  obtain ⟨i, V, hx, eV, hframe⟩ := exists_coordinateFrameOfIso f e x
  exact ⟨i, V, hx, ModulePullbackFrames.fiberEvaluation_ne_zero_of_local_frame
    V M eV ⟨x, hx⟩ _ hframe⟩

/-- The pulled homogeneous coordinates have no common zero in the ordinary
fibers of the target module. -/
theorem exists_coordinateSectionOfIso_fiber_ne_zero
    (f : X ⟶ Proj (MvPolynomial.homogeneousSubmodule J k))
    (e : (Scheme.Modules.pullback f).obj (twistingSheafOne (k := k) (J := J)) ≅ M)
    (x : X) :
    ∃ i : J, Scheme.Modules.fiberEvaluation M x (coordinateSectionOfIso f e i ⊤) ≠ 0 := by
  obtain ⟨i, V, hx, hi⟩ := exists_coordinateSectionOfIso_local_fiber_ne_zero f e x
  exact ⟨i, Scheme.Modules.fiberEvaluation_ne_zero_of_restrict
    V.ι M (⟨x, hx⟩ : V.toScheme) (coordinateSectionOfIso f e i ⊤) hi⟩

end
end Hartshorne.ProjectiveTwist
