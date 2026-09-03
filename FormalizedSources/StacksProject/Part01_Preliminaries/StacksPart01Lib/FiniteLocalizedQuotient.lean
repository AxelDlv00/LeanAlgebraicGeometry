/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import StacksPart01Lib.FiniteModule
import StacksPart01Lib.Localization

/-!
# Vanishing of finite localized quotients

For a finite module, elementwise denominator witnesses can be replaced by one
denominator that annihilates the whole module.  Applied to a quotient, this
says that its localization vanishes precisely when one denominator sends the
ambient module into the submodule.  This is the finite-generation step in the
proof that the support of a finite module is closed (Stacks, Tag 00L2).
-/

namespace StacksPart01

variable {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]

/-- A finite module localizes to zero exactly when one denominator annihilates
the entire module. -/
theorem finite_localizedModule_subsingleton_iff
    (S : Submonoid R) [Module.Finite R M] :
    Subsingleton (LocalizedModule S M) ↔
      ∃ s : S, ∀ m : M, (s : R) • m = 0 := by
  constructor
  · intro hloc
    have hker :
        LinearMap.ker (LocalizedModule.mkLinearMap S M) = ⊤ :=
      LocalizedModule.subsingleton_iff_ker_eq_top.mp hloc
    have htors : ∀ m : M, ∃ r : R, r ∈ S ∧ r • m = 0 := by
      intro m
      rw [← localizedModule_mem_ker_iff S, hker]
      exact Submodule.mem_top
    classical
    obtain ⟨t, ht⟩ := (inferInstance : Module.Finite R M).fg_top
    choose r hrS hr using htors
    refine ⟨⟨∏ m ∈ t, r m, S.prod_mem fun m _ => hrS m⟩, ?_⟩
    have hker' : Submodule.span R (t : Set M) ≤
        LinearMap.ker (LinearMap.lsmul R M (∏ m' ∈ t, r m')) := by
      rw [Submodule.span_le]
      intro m hm
      simp only [SetLike.mem_coe, LinearMap.mem_ker, LinearMap.lsmul_apply]
      rw [← Finset.mul_prod_erase t r hm, mul_comm, mul_smul, hr m, smul_zero]
    intro m
    have hm : m ∈ Submodule.span R (t : Set M) := by
      rw [ht]
      exact Submodule.mem_top
    simpa using hker' hm
  · rintro ⟨s, hs⟩
    rw [LocalizedModule.subsingleton_iff_ker_eq_top]
    apply top_unique
    intro m _
    exact (localizedModule_mem_ker_iff S).mpr
      ⟨s, s.property, hs m⟩

/-- The localization of `M ⧸ N` vanishes exactly when one denominator sends
every element of `M` into `N`. -/
theorem finite_localizedQuotient_subsingleton_iff
    (S : Submonoid R) (N : Submodule R M) [Module.Finite R M] :
    Subsingleton (LocalizedModule S (M ⧸ N)) ↔
      ∃ s : S, ∀ m : M, (s : R) • m ∈ N := by
  letI : Module.Finite R (M ⧸ N) := finite_module_quotient N
  rw [finite_localizedModule_subsingleton_iff S]
  constructor
  · rintro ⟨s, hs⟩
    refine ⟨s, fun m => (Submodule.Quotient.mk_eq_zero N).mp ?_⟩
    simpa [Submodule.mkQ_apply] using hs (Submodule.Quotient.mk m)
  · rintro ⟨s, hs⟩
    refine ⟨s, ?_⟩
    intro q
    induction q using Submodule.Quotient.induction_on with
    | _ m =>
      change Submodule.Quotient.mk ((s : R) • m) = 0
      exact (Submodule.Quotient.mk_eq_zero N).mpr (hs m)

end StacksPart01
