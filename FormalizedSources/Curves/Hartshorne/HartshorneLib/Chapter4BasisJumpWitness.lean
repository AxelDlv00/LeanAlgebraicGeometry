/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4BasePointFreeLocalJump
import HartshorneLib.Chapter4DivisorSectionCoordinates

/-!
# A fixed section basis detects every local jump

The local base-point-free witness is initially an arbitrary global section.
Finite-dimensional linear algebra upgrades it to a member of any fixed basis:
the projection to the one-point jump quotient cannot vanish on every basis
vector.  The geometric order witness is then inherited from the local-jump
producer.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]

/-! ### The finite-basis linear algebra used by the geometric witness -/

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
/-- A nonzero linear map is nonzero on at least one vector of a finite basis. -/
theorem exists_basis_apply_ne_zero
    {ι V W : Type*}
    [AddCommGroup V] [Module k V] [AddCommGroup W] [Module k W]
    (b : Module.Basis ι k V) (f : V →ₗ[k] W)
    (hf : ∃ v, f v ≠ 0) :
    ∃ i, f (b i) ≠ 0 := by
  classical
  by_cases hbasis : ∃ i, f (b i) ≠ 0
  · exact hbasis
  have hzero_on_basis : ∀ i, f (b i) = 0 := by
    intro i
    by_contra hi
    exact hbasis ⟨i, hi⟩
  have hzero : f = 0 := by
    apply b.ext
    intro i
    simpa using hzero_on_basis i
  exfalso
  obtain ⟨v, hv⟩ := hf
  apply hv
  rw [hzero]
  exact LinearMap.zero_apply v

/-! ### Specialization to divisor sections -/

variable {D : CurveDivisor k X}

/-- Identify the degree-zero cohomology module with the concrete subtype of
global divisor sections.  The object equality is exposed explicitly because
the sheaf object is not definitionally reduced through `divisorSheaf`. -/
noncomputable def divisorSectionSpaceEquiv :
    CurveDivisorSectionSpace D ≃ₗ[k] divisorSections D (⊤ : X.left.Opens) := by
  let e := CategoryTheory.Sheaf.HModule.linearEquiv₀
    (isTerminalTop : IsTerminal (⊤ : X.left.Opens)) (divisorSheaf D)
  rw [divisorSheaf_obj] at e
  exact e

/-- The local jump projection viewed as a map on the degree-zero section space. -/
noncomputable def sectionSpaceJumpMap
    {x : X.left} (hx : x ≠ genericPoint X.left) :
  CurveDivisorSectionSpace D →ₗ[k] jumpModule hx D :=
  (jumpProj hx D (⊤ : X.left.Opens) trivial).comp
    (divisorSectionSpaceEquiv (D := D)).toLinearMap

@[simp] theorem sectionSpaceJumpMap_apply
    {x : X.left} (hx : x ≠ genericPoint X.left)
    (v : CurveDivisorSectionSpace D) :
    sectionSpaceJumpMap (D := D) hx v =
      jumpProj hx D ⊤ trivial
        (divisorSectionSpaceEquiv (D := D) v) := by
  simp [sectionSpaceJumpMap]

/-- A base-point-free system has a nonzero jump coordinate in every fixed
finite basis at each closed point. -/
theorem exists_basisSection_jumpProj_ne_zero_of_basePointFree
    {n : ℕ} (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D)
    (x : X.left) (hx : x ≠ genericPoint X.left) :
    ∃ i, jumpProj hx D ⊤ trivial
      (divisorSectionSpaceEquiv (D := D) (basis i)) ≠ 0 := by
  have hf : ∃ v, sectionSpaceJumpMap (D := D) hx v ≠ 0 := by
    obtain ⟨s, hs⟩ := exists_jumpProj_ne_zero_of_basePointFree hD x hx
    let e := divisorSectionSpaceEquiv (D := D)
    let v : CurveDivisorSectionSpace D := e.symm s
    refine ⟨v, ?_⟩
    rw [sectionSpaceJumpMap_apply]
    simpa [v, e] using hs
  obtain ⟨i, hi⟩ := exists_basis_apply_ne_zero basis
    (sectionSpaceJumpMap (D := D) hx) hf
  refine ⟨i, ?_⟩
  simpa only [sectionSpaceJumpMap_apply] using hi

/-- The selected basis coordinate realizes the divisor order at the chosen
point, so it can serve as a denominator for the local-ratio chart. -/
theorem exists_basisSection_orderAt_eq_of_basePointFree
    {n : ℕ} (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D)
    (x : X.left) (hx : x ≠ genericPoint X.left) :
    ∃ i, orderAt X.hom hx
        ((divisorSectionSpaceEquiv (D := D) (basis i)) : X.left.functionField) =
      divisorBound D hx := by
  obtain ⟨i, hi⟩ := exists_basisSection_jumpProj_ne_zero_of_basePointFree
    basis hD x hx
  refine ⟨i, ?_⟩
  exact orderAt_eq_divisorBound_of_jumpProj_ne_zero hx D
    (U := ⊤) (by simp)
    (divisorSectionSpaceEquiv (D := D) (basis i)) hi

end
end Hartshorne
