/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import Mathlib.RingTheory.Nakayama

/-!
# Nakayama's lemma

Source-faithful wrappers for the principal clauses of Stacks Project Tag
00DV.  The proofs delegate directly to Mathlib's Nakayama API.
-/

namespace StacksPart01

variable {R M N : Type*} [CommRing R]

/-! ### Finite submodules and Jacobson radicals -/

/-- **Stacks, Tag 00DV (1).**  A finite submodule contained in its
`I`-multiple has a scalar in `1 + I` which annihilates it. -/
@[stacks 00DV "(1)"]
theorem exists_sub_one_mem_and_smul_eq_zero_of_fg_of_le_smul
    [AddCommGroup M] [Module R M] (I : Ideal R) (N : Submodule R M)
    (hN : N.FG) (hIN : N ≤ I • N) :
    ∃ f : R, f - 1 ∈ I ∧ ∀ n ∈ N, f • n = (0 : M) := by
  exact Submodule.exists_sub_one_mem_and_smul_eq_zero_of_fg_of_le_smul I N hN hIN

/-- **Stacks, Tag 00DV (2).**  A finite submodule contained in its
`I`-multiple is zero when `I` lies in the Jacobson radical. -/
@[stacks 00DV "(2)"]
theorem eq_bot_of_le_smul_of_le_jacobson_bot
    [AddCommGroup M] [Module R M] (I : Ideal R) (N : Submodule R M)
    (hN : N.FG) (hIN : N ≤ I • N)
    (hI : I ≤ Ideal.jacobson (⊥ : Ideal R)) : N = ⊥ := by
  exact Submodule.eq_bot_of_le_smul_of_le_jacobson_bot I N hN hIN hI

/-- **Stacks, Tag 00DV (4).**  If `N'` is finite, `N'` is contained in
`N + I N'`, and `I` lies in the Jacobson radical, then `N' ≤ N`. -/
@[stacks 00DV "(4)"]
theorem le_of_le_smul_of_le_jacobson_bot
    [AddCommGroup M] [Module R M] {I : Ideal R} {N N' : Submodule R M}
    (hN' : N'.FG) (hI : I ≤ Ideal.jacobson (⊥ : Ideal R))
    (hNN' : N' ≤ N ⊔ I • N') : N' ≤ N := by
  exact Submodule.le_of_le_smul_of_le_jacobson_bot hN' hI hNN'

/-! ### Residue surjectivity -/

/-- **Stacks, Tag 00DV (6).**  Surjectivity after quotienting the target by
`I` lifts to surjectivity for a map into a finite module when `I` is contained
in the Jacobson radical. -/
@[stacks 00DV "(6)"]
theorem LinearMap.surjective_of_surjective_mod_smul
    [AddCommGroup M] [Module R M] [AddCommGroup N] [Module R N]
    [Module.Finite R N] (f : M →ₗ[R] N) (I : Ideal R)
    (hI : I ≤ Ideal.jacobson (⊥ : Ideal R))
    (hf : Function.Surjective
      (((I • (⊤ : Submodule R N)).mkQ) ∘ₗ f)) : Function.Surjective f := by
  exact LinearMap.surjective_of_surjective_comp_mkQ f I hI hf

/-! ### Nilpotent ideals -/

/-- If an ideal is nilpotent, a submodule contained in its own multiple is
zero.  This is the nilpotent form of **Stacks, Tag 00DV (9)**; the statement
is given without a finiteness hypothesis, so it applies in particular to
finite submodules. -/
@[stacks 00DV "(9)"]
theorem eq_bot_of_le_smul_of_isNilpotent
    [AddCommGroup M] [Module R M] (I : Ideal R) (N : Submodule R M)
    (hIN : N ≤ I • N) (hI : IsNilpotent I) : N = ⊥ := by
  obtain ⟨n, hn⟩ := hI
  have hpow : ∀ k : ℕ, N ≤ I ^ k • N := by
    intro k
    induction k with
    | zero => simp
    | succ k ih =>
        rw [pow_succ', Submodule.mul_smul]
        exact hIN.trans (Submodule.smul_mono le_rfl ih)
  apply le_bot_iff.mp
  simpa [hn] using hpow n

/-- Equality form of the nilpotent Nakayama conclusion (Stacks, Tag 00DV
(9)). -/
theorem eq_bot_of_eq_smul_of_isNilpotent
    [AddCommGroup M] [Module R M] (I : Ideal R) (N : Submodule R M)
    (hIN : N = I • N) (hI : IsNilpotent I) : N = ⊥ := by
  exact eq_bot_of_le_smul_of_isNilpotent I N hIN.le hI

/-- If `I` is nilpotent and `N' ≤ N + I N'`, then `N' ≤ N`.  This is the
nilpotent analogue of **Stacks, Tag 00DV (10)** and, in particular, gives the
finite-submodule corollary without any Jacobson assumption. -/
@[stacks 00DV "(10)"]
theorem le_of_le_smul_of_isNilpotent
    [AddCommGroup M] [Module R M] {I : Ideal R} {N N' : Submodule R M}
    (hNN' : N' ≤ N ⊔ I • N') (hI : IsNilpotent I) : N' ≤ N := by
  obtain ⟨n, hn⟩ := hI
  have hpow : ∀ k : ℕ, N' ≤ N ⊔ I ^ k • N' := by
    intro k
    induction k with
    | zero => simp
    | succ k ih =>
        rw [pow_succ', Submodule.mul_smul]
        calc
          N' ≤ N ⊔ I • N' := hNN'
          _ ≤ N ⊔ I • (N ⊔ I ^ k • N') :=
            sup_le_sup_left (Submodule.smul_mono le_rfl ih) N
          _ = N ⊔ (I • N ⊔ I • (I ^ k • N')) := by
            rw [Submodule.smul_sup]
          _ ≤ N ⊔ I • (I ^ k • N') := by
            exact sup_le le_sup_left
              (sup_le ((Submodule.smul_le_right : I • N ≤ N).trans le_sup_left)
                le_sup_right)
  simpa [hn, Submodule.bot_smul, sup_bot_eq] using hpow n

/-! ### Nilpotent residue criteria -/

/-- **Stacks, Tag 00DV (11).**  For a nilpotent ideal, surjectivity after
quotienting source and target lifts to surjectivity of the original map. -/
@[stacks 00DV "(11)"]
theorem LinearMap.surjective_of_surjective_mod_smul_of_isNilpotent
    [AddCommGroup M] [Module R M] [AddCommGroup N] [Module R N]
    (f : M →ₗ[R] N) (I : Ideal R) (hI : IsNilpotent I)
    (hf : Function.Surjective
      (((I • (⊤ : Submodule R N)).mkQ) ∘ₗ f)) : Function.Surjective f := by
  rw [← LinearMap.range_eq_top, ← top_le_iff]
  apply le_of_le_smul_of_isNilpotent (N := LinearMap.range f)
    (N' := (⊤ : Submodule R N)) (hI := hI)
  rw [top_le_iff, sup_comm, ← Submodule.map_mkQ_eq_top, ← LinearMap.range_comp]
  exact LinearMap.range_eq_top_of_surjective _ hf

/-- **Stacks, Tag 00DV (12).**  If a set of elements spans the quotient by a
nilpotent ideal, then it spans the whole module. -/
@[stacks 00DV "(12)"]
theorem span_eq_top_of_span_image_mkQ_eq_top_of_isNilpotent
    [AddCommGroup M] [Module R M] (I : Ideal R) (s : Set M)
    (hspan : Submodule.span R
      (((I • (⊤ : Submodule R M)).mkQ) '' s) = ⊤)
    (hI : IsNilpotent I) : Submodule.span R s = ⊤ := by
  have hmap : (Submodule.span R s).map ((I • (⊤ : Submodule R M)).mkQ) = ⊤ := by
    rw [Submodule.map_span, hspan]
  have hsup :
      (I • (⊤ : Submodule R M)) ⊔ Submodule.span R s = ⊤ :=
    (Submodule.map_mkQ_eq_top _ _).mp hmap
  have hle : (⊤ : Submodule R M) ≤ Submodule.span R s ⊔ I • (⊤ : Submodule R M) := by
    simpa [sup_comm] using hsup.symm.le
  exact top_unique (le_of_le_smul_of_isNilpotent (N := Submodule.span R s)
    (N' := (⊤ : Submodule R M)) hle hI)

/-! A finite-submodule spelling is useful at call sites that already carry
`FG` as the finiteness witness. -/

theorem finite_eq_bot_of_le_smul_of_isNilpotent
    [AddCommGroup M] [Module R M] (I : Ideal R) (N : Submodule R M)
    (_hN : N.FG) (hIN : N ≤ I • N) (hI : IsNilpotent I) : N = ⊥ := by
  exact eq_bot_of_le_smul_of_isNilpotent I N hIN hI

theorem finite_le_of_le_smul_of_isNilpotent
    [AddCommGroup M] [Module R M] {I : Ideal R} {N N' : Submodule R M}
    (_hN' : N'.FG) (hNN' : N' ≤ N ⊔ I • N') (hI : IsNilpotent I) : N' ≤ N := by
  exact le_of_le_smul_of_isNilpotent hNN' hI

end StacksPart01
