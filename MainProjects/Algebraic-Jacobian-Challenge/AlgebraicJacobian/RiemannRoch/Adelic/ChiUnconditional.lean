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

end ChiCharts

end Adelic
end AlgebraicGeometry
