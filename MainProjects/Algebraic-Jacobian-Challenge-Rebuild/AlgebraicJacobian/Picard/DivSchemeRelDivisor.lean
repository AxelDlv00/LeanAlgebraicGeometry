/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib.RingTheory.LocalRing.Module
import Mathlib.RingTheory.Support
import Mathlib.RingTheory.Ideal.Quotient.Operations

/-!
# DD-4 RelDivisor (Route 2) — the relative-local base-point-free Nakayama neighbourhood

The load-bearing algebraic engine of the divisor-first relative achiever
(`informal/spec-dd4-seam.md` §2.3, landing note I-0268): the **flat ⟹
module-fibre-zero = scheme-fibre-zero, so its support avoids `p`; shrink to the
support-free neighbourhood** step that turns a *fibre* achiever into a *relative*
generator.

Route 2 (I-0268) builds the relative effective Cartier divisor `d` over the chart ring
`R_Z` directly from the universal carve's flat rank-`g` quotient, and reads off the seed
fields `(side z, h z, sec z)`. The residual honest step is **relative local
base-point-freeness**: for each `z`, on a small enough `D(h z)`, the chosen `sec z ∈
K_univ` generates the Cartier ideal `I_d`. Fibrewise this is P-fib's achiever; the
relative lift is a *Nakayama-neighbourhood*:

* the colength `Q := I_d ⧸ (sec z)` is a **finite** `R_Z`-module (finiteness from
  `SupportTubeFinite`, I-0244);
* because `I_d` is the **flat** Cartier ideal (§2.2; the flatness of the colength is what
  makes the *module* fibre agree with the *scheme* fibre — supplied by
  `SlicingFlatKernel`, I-0240, and the flat-cokernel base-change engine
  `AlgebraicJacobian.Picard.FlatCokernel`), the fibre achiever `f_p` gives
  `Q ⊗ κ(p) = 0` genuinely — *not* mere fibrewise vanishing;
* hence the support of `Q` avoids `p`, and shrinking `D(h z)` to that support-free
  neighbourhood makes `sec z` generate `I_d` there.

**This file supplies the last bullet's engine** (`Module.exists_subsingleton_away_of_*`):
for a finite `R`-module `Q` whose residue-field fibre at `p` vanishes, some `f ∉ p`
localizes `Q` to zero — the honest "support avoids `p`; shrink the neighbourhood" move.

**I-0231 / `k[ε]` guard.** The hypothesis is the *module* fibre `Q ⊗ κ(p) = 0`, **not**
"vanishes in every fibre". For the bad section (`e = t+ε`, `K`-components `(t)`, over
`R = k[ε]`) the colength `Q = (ε)` has `Q ⊗_{k[ε]} k ≅ k ≠ 0` (§2.1), so the hypothesis
*correctly fails* and the engine cannot certify it — exactly the guard the `k[ε]`
counterexample enforces. The engine is applicable only once the flat Cartier structure
(§2.2) has genuinely produced `Q ⊗ κ(p) = 0`, which is where flatness (not fibrewise
vanishing) does the work.
-/

set_option autoImplicit false

universe u v

namespace Module

open scoped TensorProduct

variable {R : Type u} [CommRing R] {M : Type v} [AddCommGroup M] [Module R M]

/-- **Relative-local BPF Nakayama neighbourhood** (`spec-dd4-seam` §2.3, residue field on
the left): if the residue-field fibre `κ(p) ⊗ M` of a **finite** `R`-module `M` at a prime
`p` is trivial, then `M` localizes to zero on a basic-open neighbourhood of `p` — some
`f ∉ p` has `M[1/f] = 0`.

This is the honest "the module's support avoids `p`; shrink to the support-free
neighbourhood" step: `M ⊗ κ(p) = 0` places `p` outside the (closed, for a finite module)
support `Z(Ann M)`, so a basic open `D(f) ∋ p` misses the support entirely. -/
theorem exists_subsingleton_away_of_residueField_tmul [Module.Finite R M]
    (p : PrimeSpectrum R)
    (h : Subsingleton (p.asIdeal.ResidueField ⊗[R] M)) :
    ∃ f ∉ p.asIdeal, Subsingleton (LocalizedModule.Away f M) := by
  have hns : p ∉ Module.support R M := by
    rw [Module.mem_support_iff_nontrivial_residueField_tensorProduct,
      not_nontrivial_iff_subsingleton]
    exact h
  haveI : Subsingleton (LocalizedModule p.asIdeal.primeCompl M) :=
    Module.notMem_support_iff.mp hns
  exact LocalizedModule.exists_subsingleton_away p.asIdeal

/-- **Relative-local BPF Nakayama neighbourhood** (`spec-dd4-seam` §2.3, residue field on
the right): the orientation the seed's fibre comparison produces, where the fibre is
written `M ⊗ κ(p)` with the pure tensor `· ⊗ₜ (1 : κ(p))`. Transported from
`exists_subsingleton_away_of_residueField_tmul` across `TensorProduct.comm`. -/
theorem exists_subsingleton_away_of_tmul_residueField [Module.Finite R M]
    (p : PrimeSpectrum R)
    (h : Subsingleton (M ⊗[R] p.asIdeal.ResidueField)) :
    ∃ f ∉ p.asIdeal, Subsingleton (LocalizedModule.Away f M) :=
  exists_subsingleton_away_of_residueField_tmul p
    ((TensorProduct.comm R M p.asIdeal.ResidueField).symm.toEquiv.subsingleton)

end Module

/-! ## The ideal-membership form of the Nakayama neighbourhood (the `hdvd` algebraic core)

The landed engine `Module.exists_subsingleton_away_of_tmul_residueField` produces a basic
open `D(f)` of the base on which a finite module localizes to zero.  The divisor-first
`hdvd` (`spec-dd4-seam` §1.1/§2.3) consumes this as concrete `Ideal.span` membership: on
the colength `S ⧸ (e)` (the piece sections `S = Γ(D(h z))` modulo the local equation
`e = eqn z`), a submodule `N` — the image of the `K_univ`-side components — that localizes
to zero away from `f` forces every representative `x` of `N` to satisfy
`algebraMap f^n · x ∈ (e)`.  At a point of the base `D(f)` this inverts `f` in the stalk,
delivering the germ-level `dvd` membership fed to `Scheme.mem_span_singleton_of_forall_germ`
(`Picard/DivisorStalkIdeal.lean:79`).  Pure algebra, certificate-free.

**I-0231 / `k[ε]` guard.** `N` is the *module* image `(J + (e)) ⧸ (e)`, and the
`N ⊗ κ(p) = 0` hypothesis of the assembled form below is the honest module-fibre condition
— it fails for the bad section `e = t+ε` (where `N = (ε)` has `N ⊗_{k[ε]} k ≅ k ≠ 0`), so
the engine correctly refuses it; it is *never* fibrewise vanishing. -/

section IdealForm

open scoped TensorProduct

variable {R : Type u} [CommRing R] {S : Type v} [CommRing S] [Algebra R S]

/-- **Localize-away ⟹ ideal membership up to a power of the base element.** If a submodule
`N` of the colength `S ⧸ (e)` localizes to zero away from `f : R`, then every `x : S` whose
class lies in `N` satisfies `algebraMap R S (f ^ n) * x ∈ (e)` for some `n` — the concrete
Nakayama-neighbourhood form the divisor-first `hdvd` consumes. -/
theorem exists_pow_mul_mem_span_of_subsingleton_localizedAway {f : R} {e : S}
    {N : Submodule R (S ⧸ Ideal.span {e})}
    (hN : Subsingleton (LocalizedModule.Away f N))
    {x : S} (hx : Ideal.Quotient.mk (Ideal.span {e}) x ∈ N) :
    ∃ n : ℕ, algebraMap R S (f ^ n) * x ∈ Ideal.span {e} := by
  obtain ⟨r, hr, hrx⟩ := LocalizedModule.subsingleton_iff.mp hN
    (⟨Ideal.Quotient.mk (Ideal.span {e}) x, hx⟩ : N)
  obtain ⟨n, rfl⟩ := hr
  refine ⟨n, ?_⟩
  have hcoe : (f ^ n) • Ideal.Quotient.mk (Ideal.span {e}) x = 0 := by
    have h := congrArg (Subtype.val) hrx
    simpa using h
  rw [← Ideal.Quotient.eq_zero_iff_mem,
    show algebraMap R S (f ^ n) * x = (f ^ n) • x from (Algebra.smul_def _ _).symm,
    ← Ideal.Quotient.mkₐ_eq_mk R (Ideal.span {e}), map_smul, Ideal.Quotient.mkₐ_eq_mk]
  exact hcoe

/-- **The assembled Nakayama neighbourhood in ideal form.** For a submodule `N` of the
colength `S ⧸ (e)`, finite over the base `R`, whose residue-field fibre at a prime `p`
vanishes, some `f ∉ p` witnesses a basic open `D(f)` on which every representative of `N`
lies in `(e)` after a power multiple.  Composes the landed finite-module engine
`Module.exists_subsingleton_away_of_tmul_residueField` with the ideal-membership form above
— the algebraic heart of the divisor-first `hdvd` at a seed-base prime `p`. -/
theorem exists_notMem_forall_pow_mul_mem_span_of_subsingleton_tmul_residueField {e : S}
    (N : Submodule R (S ⧸ Ideal.span {e})) [Module.Finite R N]
    (p : PrimeSpectrum R)
    (hfib : Subsingleton (↥N ⊗[R] p.asIdeal.ResidueField)) :
    ∃ f ∉ p.asIdeal, ∀ x : S, Ideal.Quotient.mk (Ideal.span {e}) x ∈ N →
      ∃ n : ℕ, algebraMap R S (f ^ n) * x ∈ Ideal.span {e} := by
  obtain ⟨f, hf, hsub⟩ := Module.exists_subsingleton_away_of_tmul_residueField p hfib
  exact ⟨f, hf, fun x hx => exists_pow_mul_mem_span_of_subsingleton_localizedAway hsub hx⟩

end IdealForm
