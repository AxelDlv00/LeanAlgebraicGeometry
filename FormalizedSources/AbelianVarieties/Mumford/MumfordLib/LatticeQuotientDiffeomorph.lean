/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.ComplexExponentialAtlas
import MumfordLib.LocalDiffeomorphDescent

/-!
# Smooth identification of a lattice quotient

A lattice exponential that is a complex local diffeomorphism identifies the
explicit quotient manifold with its target. Both directions follow by descent
through local inverse branches, retaining the target's original charts.
-/

set_option autoImplicit false

open scoped Manifold ContDiff

noncomputable section

namespace Mumford.Uniformization.ComplexVectorLatticeExponentialData

variable {V F H G : Type*}
  [NormedAddCommGroup V] [NormedSpace ℂ V]
  [NormedAddCommGroup F] [NormedSpace ℂ F]
  [TopologicalSpace H] (I : ModelWithCorners ℂ F H)
  [TopologicalSpace G] [ChartedSpace H G] [CommGroup G]
  {g : ℕ} (d : ComplexVectorLatticeExponentialData V (Additive G) g)

/-- A locally diffeomorphic exponential induces a global diffeomorphism from
its period quotient with the explicit lattice branch atlas. -/
noncomputable def quotientDiffeomorph
    (hexp : IsLocalDiffeomorph (𝓘(ℂ, V)) I 1
      (fun v => Additive.toMul (d.exponential v))) :
    letI : ChartedSpace V (V ⧸ d.ambientPeriodLattice) :=
      analyticQuotientChartedSpace d
    Diffeomorph (𝓘(ℂ, V)) I (V ⧸ d.ambientPeriodLattice) G 1 := by
  letI : ChartedSpace V (V ⧸ d.ambientPeriodLattice) :=
    analyticQuotientChartedSpace d
  let e : (V ⧸ d.ambientPeriodLattice) ≃ G :=
    d.quotientAddEquiv.toEquiv.trans Additive.toMul
  let p : V → V ⧸ d.ambientPeriodLattice := QuotientAddGroup.mk
  have he (v : V) : e (p v) = Additive.toMul (d.exponential v) := by
    change Additive.toMul
      (d.quotientAddEquiv (QuotientAddGroup.mk' d.ambientPeriodLattice v)) = _
    rw [d.quotientAddEquiv_mk]
  have he_comp : (e : (V ⧸ d.ambientPeriodLattice) → G) ∘ p =
      (fun v => Additive.toMul (d.exponential v)) := funext he
  have he_symm_comp : (e.symm : G → V ⧸ d.ambientPeriodLattice) ∘
      (fun v => Additive.toMul (d.exponential v)) = p := by
    funext v
    exact e.symm_apply_eq.mpr (he v).symm
  have hp : IsLocalDiffeomorph (𝓘(ℂ, V)) (𝓘(ℂ, V)) ω p :=
    analyticQuotient_mk_isLocalDiffeomorph d
  refine { toEquiv := e, contMDiff_toFun := ?_, contMDiff_invFun := ?_ }
  · apply Analytic.contMDiff_of_comp_surjective_localDiffeomorph
      (show (1 : ℕ∞ω) ≤ ω from le_top) hp
      (QuotientAddGroup.mk'_surjective d.ambientPeriodLattice)
    rw [he_comp]
    exact hexp.contMDiff
  · apply Analytic.contMDiff_of_comp_surjective_localDiffeomorph le_rfl hexp
      (Additive.toMul.surjective.comp d.surjective)
    rw [he_symm_comp]
    exact hp.contMDiff.of_le le_top

/-- The quotient diffeomorphism has the underlying first-isomorphism map. -/
@[simp]
theorem quotientDiffeomorph_apply
    (hexp : IsLocalDiffeomorph (𝓘(ℂ, V)) I 1
      (fun v => Additive.toMul (d.exponential v)))
    (q : V ⧸ d.ambientPeriodLattice) :
    d.quotientDiffeomorph I hexp q = Additive.toMul (d.quotientAddEquiv q) := rfl

/-- A representative is sent to its exponential. -/
@[simp]
theorem quotientDiffeomorph_mk
    (hexp : IsLocalDiffeomorph (𝓘(ℂ, V)) I 1
      (fun v => Additive.toMul (d.exponential v))) (v : V) :
    d.quotientDiffeomorph I hexp (QuotientAddGroup.mk' d.ambientPeriodLattice v) =
      Additive.toMul (d.exponential v) := by
  rw [quotientDiffeomorph_apply, quotientAddEquiv_mk]

end Mumford.Uniformization.ComplexVectorLatticeExponentialData
