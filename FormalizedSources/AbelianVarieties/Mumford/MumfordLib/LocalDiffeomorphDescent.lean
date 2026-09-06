/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import Mathlib.Geometry.Manifold.LocalDiffeomorph

/-!
# Smooth descent along local diffeomorphisms

Smoothness can be checked after composition with a surjective local diffeomorphism.
This applies to maps from the quotient manifold of a vector space by a lattice.
-/

set_option autoImplicit false

noncomputable section

namespace Mumford.Analytic

variable {𝕜 : Type*} [NontriviallyNormedField 𝕜]
  {E : Type*} [NormedAddCommGroup E] [NormedSpace 𝕜 E]
  {F : Type*} [NormedAddCommGroup F] [NormedSpace 𝕜 F]
  {G : Type*} [NormedAddCommGroup G] [NormedSpace 𝕜 G]
  {H₁ : Type*} [TopologicalSpace H₁]
  {H₂ : Type*} [TopologicalSpace H₂]
  {H₃ : Type*} [TopologicalSpace H₃]
  {I : ModelWithCorners 𝕜 E H₁} {J : ModelWithCorners 𝕜 F H₂}
  {K : ModelWithCorners 𝕜 G H₃}
  {M : Type*} [TopologicalSpace M] [ChartedSpace H₁ M]
  {N : Type*} [TopologicalSpace N] [ChartedSpace H₂ N]
  {P : Type*} [TopologicalSpace P] [ChartedSpace H₃ P]
  {m n : WithTop ℕ∞} {p : M → N} {f : N → P} {x : M}

/-- Smoothness at a point descends along a local diffeomorphism at a preimage. -/
theorem contMDiffAt_of_comp_localDiffeomorph (hnm : n ≤ m)
    (hp : IsLocalDiffeomorphAt I J m p x) (hf : ContMDiffAt I K n (f ∘ p) x) :
    ContMDiffAt J K n f (p x) := by
  have hcomp := hf.comp_of_eq (hp.localInverse_contMDiffAt.of_le hnm)
    (hp.localInverse_left_inv hp.localInverse_mem_target)
  apply hcomp.congr_of_eventuallyEq
  filter_upwards [hp.localInverse_eventuallyEq_right] with y hy
  exact congrArg f hy.symm

/-- Smoothness descends along a surjective local diffeomorphism. -/
theorem contMDiff_of_comp_surjective_localDiffeomorph (hnm : n ≤ m)
    (hp : IsLocalDiffeomorph I J m p) (hsurj : Function.Surjective p)
    (hf : ContMDiff I K n (f ∘ p)) : ContMDiff J K n f := by
  intro y
  obtain ⟨x, rfl⟩ := hsurj y
  exact contMDiffAt_of_comp_localDiffeomorph hnm (hp x) (hf x)

/-- A surjective local diffeomorphism detects smoothness by precomposition. -/
theorem contMDiff_iff_comp_surjective_localDiffeomorph (hnm : n ≤ m)
    (hp : IsLocalDiffeomorph I J m p) (hsurj : Function.Surjective p) :
    ContMDiff J K n f ↔ ContMDiff I K n (f ∘ p) :=
  ⟨fun hf => hf.comp (hp.contMDiff.of_le hnm),
    contMDiff_of_comp_surjective_localDiffeomorph hnm hp hsurj⟩

end Mumford.Analytic
