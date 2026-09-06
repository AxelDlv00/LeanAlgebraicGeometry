/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4BasePointFreeCriterion
import HartshorneLib.Chapter4DivisorStalkSurjectivity

/-!
# Base-point-freeness through the ordinary divisor-module fiber

The ordinary fiber evaluation of the divisor module can be followed by the
intrinsic additive map from that fiber to the one-point jump quotient.  This
composite agrees with the existing local jump projection on global divisor
sections.  Consequently numerical base-point-freeness is equivalent to
surjectivity of this composite at every non-generic point.  Since the
fiber-to-jump map is bijective, this is also equivalent to surjectivity of the
ordinary fiber evaluation itself.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

attribute [local instance] functionFieldOverModule Scheme.overModule
attribute [local instance] Scheme.Modules.stalkModule

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]

/-- Global ordinary-fiber evaluation followed by the intrinsic additive jump
map.  No uniformizer or residue-field coordinate is chosen. -/
noncomputable def divisorModuleFiberJumpEvaluation {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X) :
    Γ(divisorModule D, (⊤ : X.left.Opens)) →+ jumpModule hx D :=
  (stalkJumpFiberAddHom_of_divisorModule (X := X) hx D).comp
    (Scheme.Modules.fiberEvaluation (divisorModule D) x).toAddMonoidHom

/-- The ordinary-fiber-to-jump composite is the intrinsic jump projection on
global bounded rational sections. -/
@[simp]
lemma divisorModuleFiberJumpEvaluation_apply {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X)
    (s : Γ(divisorModule D, (⊤ : X.left.Opens))) :
    divisorModuleFiberJumpEvaluation (X := X) hx D s =
      jumpProj hx D ⊤ trivial
        (show divisorSections D (⊤ : X.left.Opens) from s) := by
  change stalkJumpFiberAddHom_of_divisorModule (X := X) hx D
      (Scheme.Modules.fiberEvaluation (divisorModule D) x s) =
    jumpProj hx D ⊤ trivial
      (show divisorSections D (⊤ : X.left.Opens) from s)
  rw [stalkJumpFiberAddHom_of_divisorModule_fiberEvaluation, stalkJump_germ]

/-- Surjectivity of the ordinary-fiber-to-jump composite is exactly
surjectivity of the intrinsic jump projection. -/
lemma divisorModuleFiberJumpEvaluation_surjective_iff {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X) :
    Function.Surjective (divisorModuleFiberJumpEvaluation (X := X) hx D) ↔
      Function.Surjective (jumpProj hx D ⊤ trivial) := by
  constructor
  · intro h q
    obtain ⟨s, hs⟩ := h q
    refine ⟨(show divisorSections D (⊤ : X.left.Opens) from s), ?_⟩
    rw [← divisorModuleFiberJumpEvaluation_apply hx D]
    exact hs
  · intro h q
    obtain ⟨s, hs⟩ := h q
    refine ⟨(show Γ(divisorModule D, (⊤ : X.left.Opens)) from s), ?_⟩
    rw [divisorModuleFiberJumpEvaluation_apply]
    exact hs

/-- Ordinary fiber evaluation is surjective exactly when its composite with
the intrinsic fiber-to-jump map is surjective. -/
lemma fiberEvaluation_surjective_iff_divisorModuleFiberJumpEvaluation_surjective
    {x : X.left} (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X) :
    Function.Surjective (Scheme.Modules.fiberEvaluation (divisorModule D) x) ↔
      Function.Surjective (divisorModuleFiberJumpEvaluation (X := X) hx D) := by
  constructor
  · intro heval q
    obtain ⟨z, hz⟩ :=
      stalkJumpFiberAddHom_of_divisorModule_surjective (X := X) hx D q
    obtain ⟨s, hs⟩ := heval z
    refine ⟨s, ?_⟩
    change stalkJumpFiberAddHom_of_divisorModule (X := X) hx D
      (Scheme.Modules.fiberEvaluation (divisorModule D) x s) = q
    rw [hs, hz]
  · intro hcomp z
    obtain ⟨s, hs⟩ := hcomp
      (stalkJumpFiberAddHom_of_divisorModule (X := X) hx D z)
    exact ⟨s, stalkJumpFiberAddHom_of_divisorModule_injective hx D hs⟩

/-- Numerical base-point-freeness is equivalent to surjectivity, at every
non-generic point, of global ordinary-fiber evaluation after passage to the
intrinsic jump quotient. -/
theorem basePointFreeLinearSystem_iff_divisorModuleFiberJumpEvaluation_surjective
    (D : CurveDivisor k X) :
    BasePointFreeLinearSystem D ↔
      ∀ (x : X.left) (hx : x ≠ genericPoint X.left),
        Function.Surjective (divisorModuleFiberJumpEvaluation (X := X) hx D) := by
  rw [basePointFreeLinearSystem_iff_jumpProj_surjective]
  exact forall_congr' fun x => forall_congr' fun hx =>
    (divisorModuleFiberJumpEvaluation_surjective_iff (X := X) hx D).symm

/-- Numerical base-point-freeness is equivalent to surjectivity of global
section evaluation in every ordinary divisor-module fiber. -/
theorem basePointFreeLinearSystem_iff_divisorModule_fiberEvaluation_surjective
    (D : CurveDivisor k X) :
    BasePointFreeLinearSystem D ↔
      ∀ x : X.left, x ≠ genericPoint X.left →
        Function.Surjective
          (Scheme.Modules.fiberEvaluation (divisorModule D) x) := by
  rw [basePointFreeLinearSystem_iff_divisorModuleFiberJumpEvaluation_surjective]
  exact forall_congr' fun x => forall_congr' fun hx =>
    (fiberEvaluation_surjective_iff_divisorModuleFiberJumpEvaluation_surjective
      (X := X) hx D).symm

end
end Hartshorne
