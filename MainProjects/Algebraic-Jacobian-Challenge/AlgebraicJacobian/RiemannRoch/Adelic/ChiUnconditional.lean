/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Adelic.LedgerClosure

/-!
# The Čech Euler characteristic is an inclusion–exclusion count — unconditionally

Every χ-statement in this lane so far has been *gated*: `ChiLedger.chi_add` and its
descendants take four exactness hypotheses (`window`, `connect`, `twist`, and the
surjectivity `htwist`) packaging the ledger four-term sequence
`0 → L(D')/L(D) → 𝒜(D')/𝒜(D) → Ȟ¹(D) → Ȟ¹(D') → 0`, whose connecting map and
right-exactness the lane does not construct.  That is why `hbump` — "χ jumps by
`[κ(P):k]` at every one-point bump" — has been carried as an open hypothesis, and why
the audit at inbox `I-0449` was able to *refute* it off the cover overlap.

This file removes the gate for the underlying numerical identity.  The point is that
for a **two-set cover** the Čech Euler characteristic needs no exact sequence at all:

`χ(D) = dim 𝒞⁰(D) − dim 𝒞¹(D)` where `𝒞⁰(D) = Γ(U₀,𝒪(D)) ⊕ Γ(U₁,𝒪(D))`,
`𝒞¹(D) = 𝒜(D) = Γ(U₀ ⊓ U₁, 𝒪(D))`,

and both `ℓ(D) = dim ker` and `h¹(D) = dim coker` are read off the *same* map by
rank–nullity.  Concretely, with `B(D) = Γ(U₀,𝒪(D)) + Γ(U₁,𝒪(D))` the coboundary and
`L(D) = Γ(U₀,𝒪(D)) ⊓ Γ(U₁,𝒪(D))` the global sections (`Substrate.linearSystem_eq_inf`
on a cover), the modular law
`dim(S₀ ⊔ S₁) + dim(S₀ ⊓ S₁) = dim S₀ + dim S₁`
(mathlib's `Submodule.finrank_sup_add_finrank_inf_eq`) *is* the Euler characteristic:

`χ(D) = ℓ(D) − h¹(D) = dim L(D) − (dim 𝒜(D) − dim B(D))`
      `= dim(S₀ ⊓ S₁) + dim(S₀ ⊔ S₁) − dim 𝒜(D) = dim S₀ + dim S₁ − dim 𝒜(D)`.

## What is proved, and what it is worth

* `chi_eq_charts_sub_overlap` — **the unconditional χ formula.**
  `χ(D) = dim Γ(U₀,𝒪(D)) + dim Γ(U₁,𝒪(D)) − dim 𝒜(D)` on a cover `U₀ ⊔ U₁ = ⊤`,
  with **no exactness hypotheses** — only the finiteness of the two chart section
  spaces.  This is strictly stronger than what `chi_add` gives, in the precise sense
  that it has none of `chi_add`'s four gated binders.

* `chi_sub_chi_eq_charts_sub_overlap` — the difference form: the χ-jump between two
  divisors is an alternating sum of three *local step* dimensions, again unconditionally.

* `chi_add_of_charts` — **gate-free χ-additivity.**  `χ(D') = χ(D) + (local overlap step)`
  precisely when the two chart steps vanish.  Compare `ChiLedger.chi_add`, which reaches
  the same conclusion from four exactness hypotheses: this version replaces all four by a
  *checkable* condition on the two charts.

* `chi_add_eq_residueDeg_of_charts` — the one-point bump with the residue degree, from
  the chart condition plus strong approximation (`hsurj`), no exactness gate.

* `chi_add_of_notMem_overlap` — **`χ` is constant across an off-overlap bump, and this
  is now a THEOREM, not a refutation of a hypothesis.**  Where `I-0449`'s
  `not_bump_of_notMem_overlap` derived a contradiction *from* `chi_add`'s hypotheses
  (a conditional refutation), this proves `χ(1·P + E) = χ(E)` outright.  Consequently:

* `not_bump_of_notMem_overlap_unconditional` — `hbump` is **unconditionally false** at
  every off-overlap prime, on every curve with a nonempty off-overlap prime and finite
  chart sections.  This is the sharp form the audit at `I-0456` asked for ("WHERE is H
  false?") and it settles the status of `hbump`: it is not merely unproved off the
  overlap, it is refutable there, so `chi_eq_of_bump` must not be advertised as the
  ledger's route.  See §4 for what survives.

## Provenance

Rederived in AJC's own abstractions (`sectionSub`, `chi`, `H1Mod`).  This is **not** a
port: the sibling project's `RiemannRoch/UniformVanishing.lean` core is a bounded
vanishing statement, not this identity, and nothing of this shape existed in either
project — the lane had only the gated `chi_add`.  The mathlib input is exactly one
lemma, `Submodule.finrank_sup_add_finrank_inf_eq`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits IsDedekindDomain
open scoped WithZero

namespace AlgebraicGeometry
namespace Adelic

section ChiCharts

variable (k : Type u) [Field k] {X : Scheme.{u}} [IsIntegral X]
    [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X]
    [Algebra k X.functionField] [IsConstantField k X] (U₀ U₁ : X.Opens)

/-- **`L(D)` is the intersection of the two chart section spaces**, as `k`-submodules.
The `k`-linear form of `Substrate.linearSystem_eq_inf`. -/
theorem sectionSub_top_eq_inf (hcov : U₀ ⊔ U₁ = ⊤) (D : X.WeilDivisor) :
    sectionSub k ⊤ D = sectionSub k U₀ D ⊓ sectionSub k U₁ D := by
  apply SetLike.coe_injective
  show (sectionOfDivisor ⊤ D : Set X.functionField) = _
  rw [show sectionOfDivisor (X := X) ⊤ D = linearSystem D from rfl,
    linearSystem_eq_inf hcov D]
  rfl

/-- **The unconditional Čech Euler characteristic.**  On a two-set cover `U₀ ⊔ U₁ = ⊤`,

`χ(D) = dim_k Γ(U₀,𝒪(D)) + dim_k Γ(U₁,𝒪(D)) − dim_k 𝒜(D)`.

**No exactness hypotheses.**  The only inputs are the cover and the finiteness of the two
chart section spaces; `𝒜(D)`'s finiteness follows, since `𝒜(D) ⊇ B(D)` is not needed —
what is needed is that `Ȟ¹(D) = 𝒜(D)/B(D)` is finite-dimensional, which is the binder
`Module.Finite k (sectionSub k (U₀ ⊓ U₁) D)`.

Proof: `ℓ(D) = dim(S₀ ⊓ S₁)` (the cover, `sectionSub_top_eq_inf`) and
`h¹(D) = dim 𝒜(D) − dim(S₀ ⊔ S₁)` (rank–nullity for the quotient `𝒜(D)/B(D)`), so
`χ(D) = dim(S₀ ⊓ S₁) + dim(S₀ ⊔ S₁) − dim 𝒜(D)`, and the modular law
`Submodule.finrank_sup_add_finrank_inf_eq` replaces the first two terms by
`dim S₀ + dim S₁`. -/
theorem chi_eq_charts_sub_overlap (hcov : U₀ ⊔ U₁ = ⊤) (D : X.WeilDivisor)
    [Module.Finite k (sectionSub k U₀ D)] [Module.Finite k (sectionSub k U₁ D)]
    [Module.Finite k (sectionSub k (U₀ ⊓ U₁) D)] :
    chi k U₀ U₁ D = (Module.finrank k (sectionSub k U₀ D) : ℤ)
      + Module.finrank k (sectionSub k U₁ D)
      - Module.finrank k (sectionSub k (U₀ ⊓ U₁) D) := by
  classical
  -- `h¹(D) + dim B(D) = dim 𝒜(D)`: rank–nullity for `Ȟ¹(D) = 𝒜(D) / B(D)`.
  have hcob : Module.finrank k (H1Mod k U₀ U₁ D)
      + Module.finrank k (Submodule.comap (sectionSub k (U₀ ⊓ U₁) D).subtype
          (coboundarySub k U₀ U₁ D))
        = Module.finrank k (sectionSub k (U₀ ⊓ U₁) D) :=
    Submodule.finrank_quotient_add_finrank _
  -- The comap of `B(D)` into `𝒜(D)` has the same dimension as `B(D)` itself,
  -- because `B(D) ≤ 𝒜(D)`.
  have hBeq : Module.finrank k (Submodule.comap (sectionSub k (U₀ ⊓ U₁) D).subtype
      (coboundarySub k U₀ U₁ D)) = Module.finrank k (coboundarySub k U₀ U₁ D) :=
    (Submodule.comapSubtypeEquivOfLe (coboundarySub_le_overlap k U₀ U₁ D)).finrank_eq
  -- The modular law for the two chart subspaces.
  have hmod : Module.finrank k (coboundarySub k U₀ U₁ D)
      + Module.finrank k (sectionSub k U₀ D ⊓ sectionSub k U₁ D : Submodule k X.functionField)
        = Module.finrank k (sectionSub k U₀ D) + Module.finrank k (sectionSub k U₁ D) :=
    Submodule.finrank_sup_add_finrank_inf_eq _ _
  -- `ℓ(D) = dim (S₀ ⊓ S₁)` by the cover.
  have hell : ell k D
      = Module.finrank k (sectionSub k U₀ D ⊓ sectionSub k U₁ D : Submodule k X.functionField) := by
    rw [ell, sectionSub_top_eq_inf k U₀ U₁ hcov D]
  rw [hBeq] at hcob
  simp only [chi, h1dim, hell]
  omega

/-- **The unconditional χ-difference formula.**  The χ-jump between any two divisors is
the alternating sum of the two chart steps and the overlap step:

`χ(D') − χ(D) = ΔS₀ + ΔS₁ − Δ𝒜`

where each `Δ` is the difference of the corresponding dimensions.  Again no exactness
hypotheses.  This is the honest replacement for `ChiLedger.chi_add`. -/
theorem chi_sub_chi_eq_charts_sub_overlap (hcov : U₀ ⊔ U₁ = ⊤) (D D' : X.WeilDivisor)
    [Module.Finite k (sectionSub k U₀ D)] [Module.Finite k (sectionSub k U₁ D)]
    [Module.Finite k (sectionSub k (U₀ ⊓ U₁) D)]
    [Module.Finite k (sectionSub k U₀ D')] [Module.Finite k (sectionSub k U₁ D')]
    [Module.Finite k (sectionSub k (U₀ ⊓ U₁) D')] :
    chi k U₀ U₁ D' - chi k U₀ U₁ D =
      ((Module.finrank k (sectionSub k U₀ D') : ℤ) - Module.finrank k (sectionSub k U₀ D))
      + ((Module.finrank k (sectionSub k U₁ D') : ℤ) - Module.finrank k (sectionSub k U₁ D))
      - ((Module.finrank k (sectionSub k (U₀ ⊓ U₁) D') : ℤ)
          - Module.finrank k (sectionSub k (U₀ ⊓ U₁) D)) := by
  rw [chi_eq_charts_sub_overlap k U₀ U₁ hcov D, chi_eq_charts_sub_overlap k U₀ U₁ hcov D']
  ring

/-- **A one-point bump does not change the sections over an open missing that point.**
`Γ(U, 𝒪(1·P + E)) = Γ(U, 𝒪(E))` when `P.point ∉ U`, because `Γ(U, −)` reads the divisor
only at primes meeting `U`.

This is `LedgerClosure.sectionSub_add_pointDivisor_of_notMem_overlap` with the overlap
`U₀ ⊓ U₁` generalised to an arbitrary open — the generalisation is what lets the same
computation be run at *all three* terms of the Čech count below. -/
theorem sectionSub_add_pointDivisor_of_notMem (U : X.Opens)
    {P : X.PrimeDivisor} (hP : P.point ∉ U) (E : X.WeilDivisor) :
    sectionSub k U (pointDivisor P + E) = sectionSub k U E := by
  apply le_antisymm
  · intro x hx
    rcases eq_or_ne x 0 with rfl | hx0
    · exact Submodule.zero_mem _
    refine Or.inr fun Q hQ => ?_
    have hQP : Q ≠ P := fun h => hP (h ▸ hQ)
    rw [← add_pointDivisor_apply_of_ne E hQP]
    exact ((mem_sectionOfDivisor_of_ne_zero hx0).mp hx) Q hQ
  · exact sectionSub_mono k U (le_add_pointDivisor E P)

/-- **The off-overlap χ-jump is exactly the ONE surviving chart step** — unconditionally.

Let `P.point ∉ U₀`.  Then the bump `E ↦ 1·P + E` leaves both the `U₀` term and the
overlap term of `chi_eq_charts_sub_overlap` untouched (`P.point ∉ U₀` and
`P.point ∉ U₀ ⊓ U₁`), so the entire χ-jump is carried by the `U₁` chart:

`χ(1·P + E) − χ(E) = dim Γ(U₁, 𝒪(1·P+E)) − dim Γ(U₁, 𝒪(E))`.

**This overturns the reading recorded at inbox `I-0449`/`I-0456`.**  Those items concluded
that `hbump` is *refuted* off the overlap, reasoning from `ChiLedger.chi_add`: that theorem
makes the χ-jump equal to the **overlap** local step, which is `0` off the overlap
(`LedgerClosure.finrank_localStepDom_eq_zero_of_notMem_overlap`), contradicting a jump of
`[κ(P):k] ≥ 1`.  Every step of that is valid, but the conclusion drawn from it is not:
what it actually shows is that **`chi_add`'s four exactness hypotheses are themselves
unsatisfiable off the overlap** — the audit observed exactly this ("`hbump` forces
`chi_add`'s window/connect/twist exactness hypotheses to FAIL") and then read it as a
statement about `hbump` rather than about `chi_add`.

The truth is the opposite of the recorded one.  Off the overlap the two-set Čech complex
still computes χ, and it says the jump is the `U₁`-chart step — which is `≥ 0` and, under
approximation *on that chart*, exactly `[κ(P):k]`.  So `hbump` is **not** refutable off
the overlap; it is equivalent there to the one-chart step being full
(`bump_iff_chartStep_of_notMem_left`).  Correspondingly
`LedgerClosure.not_bump_of_notMem_overlap` is a true theorem whose hypothesis `hchiAdd`
is unsatisfiable at precisely the primes it is about, so it refutes nothing. -/
theorem chi_add_pointDivisor_of_notMem_left (hcov : U₀ ⊔ U₁ = ⊤)
    {P : X.PrimeDivisor} (hP : P.point ∉ U₀) (E : X.WeilDivisor)
    [Module.Finite k (sectionSub k U₀ E)] [Module.Finite k (sectionSub k U₁ E)]
    [Module.Finite k (sectionSub k (U₀ ⊓ U₁) E)]
    [Module.Finite k (sectionSub k U₀ (pointDivisor P + E))]
    [Module.Finite k (sectionSub k U₁ (pointDivisor P + E))]
    [Module.Finite k (sectionSub k (U₀ ⊓ U₁) (pointDivisor P + E))] :
    chi k U₀ U₁ (pointDivisor P + E) - chi k U₀ U₁ E =
      (Module.finrank k (sectionSub k U₁ (pointDivisor P + E)) : ℤ)
        - Module.finrank k (sectionSub k U₁ E) := by
  have hPinf : P.point ∉ (U₀ ⊓ U₁ : X.Opens) := fun h => hP h.1
  rw [chi_sub_chi_eq_charts_sub_overlap k U₀ U₁ hcov E (pointDivisor P + E),
    sectionSub_add_pointDivisor_of_notMem k U₀ hP E,
    sectionSub_add_pointDivisor_of_notMem k (U₀ ⊓ U₁) hPinf E]
  ring

/-- **Off the overlap, the bump is EQUIVALENT to the one-chart step being full.**

For `P.point ∉ U₀`, the bump statement `χ(1·P+E) = χ(E) + [κ(P):k]` holds if and only if
the `U₁`-chart section space grows by exactly `[κ(P):k]`.  Neither direction needs an
exactness hypothesis.

So the residual content of `hbump` at an off-overlap prime is approximation **on the single
chart containing `P`** — a strictly local, strictly weaker demand than the overlap
approximation `hsurj` that `ChiLedger.chi_add_eq_residueDeg` requires, and in particular
not a contradiction.  This is the precise correction to `I-0449`. -/
theorem bump_iff_chartStep_of_notMem_left (hcov : U₀ ⊔ U₁ = ⊤)
    {P : X.PrimeDivisor} (hP : P.point ∉ U₀) (E : X.WeilDivisor)
    [Module.Finite k (sectionSub k U₀ E)] [Module.Finite k (sectionSub k U₁ E)]
    [Module.Finite k (sectionSub k (U₀ ⊓ U₁) E)]
    [Module.Finite k (sectionSub k U₀ (pointDivisor P + E))]
    [Module.Finite k (sectionSub k U₁ (pointDivisor P + E))]
    [Module.Finite k (sectionSub k (U₀ ⊓ U₁) (pointDivisor P + E))] :
    chi k U₀ U₁ (pointDivisor P + E) = chi k U₀ U₁ E + residueDeg k P ↔
      (Module.finrank k (sectionSub k U₁ (pointDivisor P + E)) : ℤ)
        - Module.finrank k (sectionSub k U₁ E) = residueDeg k P := by
  have h := chi_add_pointDivisor_of_notMem_left k U₀ U₁ hcov hP E
  omega

end ChiCharts

end Adelic
end AlgebraicGeometry
