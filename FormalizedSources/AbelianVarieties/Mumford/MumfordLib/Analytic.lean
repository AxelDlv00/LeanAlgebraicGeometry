/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import Mathlib.Topology.Instances.AddCircle.Real

/-!
# MumfordLib.Analytic

Elementary analytic-torus consequences used in the first chapter of Mumford.
-/

namespace Mumford

noncomputable section

/-- A real product torus, represented as a product of unit additive circles.

This is the elementary real Lie-group model used in the proof of Mumford's
divisibility and torsion proposition (`mumford-frag-torsion`).
-/
abbrev ProductTorus (d : Type*) := UnitAddTorus d

/-- Every product torus admits division by a nonzero integer. -/
theorem productTorus_division {d : Type*} (x : ProductTorus d) {n : ℤ} (hn : n ≠ 0) :
    n • DivisibleBy.div x n = x :=
  DivisibleBy.div_cancel x hn

/-- Membership in the `n`-torsion of a product torus is coordinatewise. -/
theorem mem_productTorus_torsion_iff {d : Type*} {n : ℕ} (x : ProductTorus d) :
    x ∈ {x : ProductTorus d | n • x = 0} ↔ ∀ i, n • x i = 0 := by
  constructor
  · intro hx i
    have hi := congrFun hx i
    simpa only [Pi.smul_apply, Pi.zero_apply] using hi
  · intro hx
    change n • x = 0
    funext i
    exact hx i

/-- The `n`-torsion of a finite product torus is finite. -/
theorem productTorus_torsion_finite {d : Type*} [Finite d] {n : ℕ} (hn : 0 < n) :
    {x : ProductTorus d | n • x = 0}.Finite := by
  have hpi : (Set.univ.pi (fun _ : d => {u : UnitAddCircle | n • u = 0})).Finite :=
    Set.Finite.pi (fun i => AddCircle.finite_torsion (1 : ℝ) hn)
  apply hpi.subset
  intro x hx
  simp only [Set.mem_setOf_eq] at hx ⊢
  intro i _
  change n • x i = 0
  have hi := congrFun hx i
  simpa only [Pi.smul_apply, Pi.zero_apply] using hi

private theorem real_isSMulRegular_int (n : ℤ) (hn : n ≠ 0) : IsSMulRegular ℝ n := by
  exact .of_right_eq_zero_of_smul (fun (x : ℝ) (h : n • x = 0) => by
    rw [zsmul_eq_mul] at h
    have hc : (n : ℝ) ≠ 0 := by exact_mod_cast hn
    rcases mul_eq_zero.mp h with h0 | hx
    · exact (hc h0).elim
    · exact hx)

/-- The nonzero-integer torsion of a finite product torus is finite. -/
theorem productTorus_zsmul_torsion_finite {d : Type*} [Finite d] {n : ℤ} (hn : n ≠ 0) :
    {x : ProductTorus d | n • x = 0}.Finite := by
  have hpi :
      (Set.univ.pi (fun _ : d => {u : UnitAddCircle | n • u = 0})).Finite :=
    Set.Finite.pi (fun _ => AddCircle.finite_torsion_of_isSMulRegular_int
      (1 : ℝ) n (real_isSMulRegular_int n hn))
  apply hpi.subset
  intro x hx
  simp only [Set.mem_setOf_eq] at hx ⊢
  intro i _
  change n • x i = 0
  have hi := congrFun hx i
  simpa only [Pi.smul_apply, Pi.zero_apply] using hi

end

end Mumford
