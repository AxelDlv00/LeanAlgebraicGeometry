/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib.RingTheory.LocalRing.Module
import Mathlib.RingTheory.Support

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
