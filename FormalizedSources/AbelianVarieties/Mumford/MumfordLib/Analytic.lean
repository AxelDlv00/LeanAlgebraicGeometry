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

/-!
The quotient description of the additive circle gives an explicit model for
its finite torsion.  We keep the equivalence at the subtype level so that the
annihilation equation remains available to coordinatewise constructions.
-/

/-- The `n`-torsion of the unit additive circle is `ZMod n`. -/
def unitAddCircle_torsion_equiv_zmod {n : ℕ} (hn : 0 < n) :
    {u : UnitAddCircle | n • u = 0} ≃ ZMod n := by
  letI : NeZero n := ⟨Nat.ne_of_gt hn⟩
  have hmem (j : ZMod n) : n • ZMod.toAddCircle j = 0 := by
    apply (AddCircle.nsmul_eq_zero_iff hn).2
    refine ⟨j.val, j.val_lt, ?_⟩
    rw [ZMod.toAddCircle_apply]
    norm_num
  let f : ZMod n → {u : UnitAddCircle | n • u = 0} :=
    fun j => ⟨ZMod.toAddCircle j, hmem j⟩
  have hf : Function.Bijective f := by
    constructor
    · intro a b hab
      exact ZMod.toAddCircle_injective n (Subtype.mk.inj hab)
    · intro u
      obtain ⟨m, hm, hu⟩ := (AddCircle.nsmul_eq_zero_iff hn).1 u.property
      refine ⟨(m : ZMod n), ?_⟩
      apply Subtype.ext
      change ZMod.toAddCircle (m : ZMod n) = u.val
      rw [ZMod.toAddCircle_apply]
      simpa [Nat.mod_eq_of_lt hm] using hu
  exact (Equiv.ofBijective f hf).symm

/-- The torsion of a product torus is the corresponding product of `ZMod`s. -/
def productTorus_torsion_equiv_pi_zmod {d : Type*} {n : ℕ} (hn : 0 < n) :
    {x : ProductTorus d | n • x = 0} ≃ (d → ZMod n) := by
  let e := unitAddCircle_torsion_equiv_zmod hn
  let f : (d → ZMod n) → {x : ProductTorus d | n • x = 0} := fun z =>
    ⟨fun i => (e.symm (z i)).val, by
      apply (mem_productTorus_torsion_iff (n := n) (fun i => (e.symm (z i)).val)).2
      intro i
      exact (e.symm (z i)).property⟩
  have hf : Function.Bijective f := by
    constructor
    · intro a b hab
      funext i
      have hi : (e.symm (a i)).val = (e.symm (b i)).val :=
        congrFun (Subtype.mk.inj hab) i
      have heq : e.symm (a i) = e.symm (b i) := Subtype.ext hi
      simpa using congrArg e heq
    · intro x
      have hx : ∀ i, n • x.val i = 0 :=
        (mem_productTorus_torsion_iff (n := n) x.val).1 x.property
      refine ⟨fun i => e ⟨x.val i, hx i⟩, ?_⟩
      apply Subtype.ext
      funext i
      change (e.symm (e ⟨x.val i, hx i⟩)).val = x.val i
      exact congrArg Subtype.val (e.symm_apply_apply ⟨x.val i, hx i⟩)
  exact (Equiv.ofBijective f hf).symm

/-- The finite `n`-torsion of a finite product torus has cardinality `n ^ |d|`. -/
theorem productTorus_torsion_card {d : Type*} [Fintype d] {n : ℕ} (hn : 0 < n) :
    Nat.card {x : ProductTorus d | n • x = 0} = n ^ Fintype.card d := by
  rw [Nat.card_congr (productTorus_torsion_equiv_pi_zmod hn)]
  rw [Nat.card_fun, Nat.card_zmod, Nat.card_eq_fintype_card]

end

end Mumford
