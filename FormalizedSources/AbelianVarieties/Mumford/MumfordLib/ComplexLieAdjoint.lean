/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import Mathlib.Geometry.Manifold.Complex
import Mathlib.Geometry.Manifold.Algebra.LieGroup
import Mathlib.Geometry.Manifold.ContMDiffMFDeriv
import Mathlib.Algebra.Group.End

/-!
# The adjoint map of a compact complex Lie group

For a complex Lie group, conjugation by `x` fixes the identity and hence has
a derivative on the tangent space there.  Mumford observes that these
derivatives form a holomorphic map from the group to its endomorphism space.
Compactness and connectedness force that map to be constant, so every
conjugation derivative is the identity.

This is the first analytic producer in Mumford's proof that a compact
connected complex Lie group is commutative.  The remaining step needs a Lie
exponential and its functoriality under conjugation, which are not yet
available in Mathlib.
-/

set_option autoImplicit false

noncomputable section

open scoped Manifold ContDiff

namespace Mumford
namespace Analytic

variable {E H G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℂ E]
  [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
  [TopologicalSpace G] [ChartedSpace H G] [Group G]
  [LieGroup I ω G]

/-- Conjugation by an element of a complex Lie group. -/
def complexLieConjugation (x : G) : G → G := fun y ↦ x * y * x⁻¹

/-!
The abstract group API already packages conjugation as the homomorphism
`MulAut.conj : G →* MulAut G`.  The bridge below keeps the analytic map used
in this file synchronized with that canonical API, so later differential or
integration results can consume the homomorphism laws directly.
-/

omit [TopologicalSpace G] in
@[simp]
theorem complexLieConjugation_eq_mulAut_conj (x : G) :
    complexLieConjugation x = MulAut.conj x := by
  funext y
  simp [complexLieConjugation, MulAut.conj_apply]

omit [TopologicalSpace G] in
theorem complexLieConjugation_mul (x y : G) :
    complexLieConjugation (x * y) =
      complexLieConjugation x ∘ complexLieConjugation y := by
  have h := congrArg (fun e : MulAut G => (e : G → G))
    ((MulAut.conj).map_mul x y)
  convert h using 1 <;> rfl

omit [TopologicalSpace G] in
@[simp]
theorem complexLieConjugation_one (x : G) : complexLieConjugation x 1 = 1 := by
  simp [complexLieConjugation]

omit [TopologicalSpace G] in
@[simp]
theorem complexLieConjugation_one_eq_id :
    complexLieConjugation (G := G) 1 = id := by
  funext y
  simp [complexLieConjugation]

/-- The derivative at the identity of conjugation by `x`, expressed in the
fixed model vector space using the tangent-bundle coordinates at the identity. -/
def complexLieAdjoint (x : G) : E →L[ℂ] E :=
  inTangentCoordinates I I (fun _ : G ↦ (1 : G)) (fun _ : G ↦ (1 : G))
    (fun y ↦ mfderiv I I (complexLieConjugation y) 1) x x

/-- The conjugation derivatives vary holomorphically with the conjugating
element. -/
theorem complexLieAdjoint_mdifferentiable :
    MDifferentiable I 𝓘(ℂ, E →L[ℂ] E)
      (complexLieAdjoint (G := G) I) := by
  have hf : ContMDiff (I.prod I) I ω (fun p : G × G ↦ p.1 * p.2 * p.1⁻¹) :=
    (contMDiff_fst.mul contMDiff_snd).mul contMDiff_fst.inv
  intro x
  have h := ContMDiffAt.mfderiv (x₀ := x) (m := 1) (n := ω)
    (I := I) (I' := I) (J := I)
    (fun x : G ↦ fun y : G ↦ x * y * x⁻¹)
    (fun _ : G ↦ (1 : G)) hf.contMDiffAt contMDiffAt_const (by simp)
  have hout : (fun y : G ↦ y * 1 * y⁻¹) = (fun _ : G ↦ (1 : G)) := by
    funext y
    simp
  rw [hout] at h
  have hc : ContMDiffAt I 𝓘(ℂ, E →L[ℂ] E) 1
      (complexLieAdjoint (G := G) I) x := by
    convert h using 1
    · with_reducible_and_instances rfl
    · funext y
      rfl
  exact hc.mdifferentiableAt one_ne_zero

/-- Conjugation by the identity has identity derivative. -/
@[simp]
theorem complexLieAdjoint_one :
    complexLieAdjoint (G := G) I 1 = ContinuousLinearMap.id ℂ E := by
  rw [complexLieAdjoint, inTangentCoordinates,
    complexLieConjugation_one_eq_id, mfderiv_id]
  rw [ContinuousLinearMap.inCoordinates_eq
    (FiberBundle.mem_baseSet_trivializationAt' (1 : G))
    (FiberBundle.mem_baseSet_trivializationAt' (1 : G))]
  ext v
  simp

/-- The adjoint map of a compact connected complex Lie group is trivial.

This is the compact-holomorphic constancy step in Mumford's proof of
commutativity. -/
theorem complexLieAdjoint_eq_id
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] (x : G) :
    complexLieAdjoint I x = ContinuousLinearMap.id ℂ E := by
  rw [← complexLieAdjoint_one (G := G) I]
  exact MDifferentiable.apply_eq_of_compactSpace
    (complexLieAdjoint_mdifferentiable (G := G) I) x 1

end Analytic
end Mumford
