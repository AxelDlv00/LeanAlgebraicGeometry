/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Adelic.SectionBounds

/-!
# Adelic Riemann–Roch — bounded `H¹` vanishing over a single base field

This file assembles the **single-field bounded vanishing** statement of the
campaign's cluster P (P5, primary clause):

`∃ b : ℤ, ∀ D, b ≤ deg_k D → Subsingleton (Ȟ¹(D))`

from three inputs that are named explicitly in every statement:

1. **a base vanishing** `Subsingleton (Ȟ¹(D₀))` at one divisor `D₀`;
2. **the peel input** — surjectivity of the twist `Ȟ¹(D) ↠ Ȟ¹(D')` for `D ≤ D'`,
   in the concrete form `𝒜(D') = 𝒜(D) + B(D')`.  This is exactly the `htwist`
   datum of the χ-ledger (`chi_add`), unwound;
3. **the closed ledger** `χ(D) = χ(0) + deg_k D`, used only to produce an
   effective witness in the class of `D − D₀`.

Nothing here is a `sorry` and nothing here is a new gate class: each theorem is of
the form "given (1)–(3), the bound exists", with `b` computed explicitly as
`b = deg_k D₀ + 1 − χ(0)`.

## Vanishing as `Subsingleton`, not as `h¹ = 0`

Vanishing is stated as `Subsingleton (H1Mod k U₀ U₁ D)` rather than
`h1dim k U₀ U₁ D = 0`.  The two agree when `Ȟ¹(D)` is finite-dimensional, but the
`Subsingleton` form needs **no finiteness instance**, so the vanishing lane stays
independent of the finiteness gates.  `h1dim_eq_zero_of_subsingleton` converts.

## Main declarations

* `subsingleton_h1Mod_iff` — `Ȟ¹(D) = 0 ⟺ 𝒜(D) ⊆ B(D)`: the concrete criterion
  everything below runs on.
* `subsingleton_h1Mod_peel` — the **peel step**: base vanishing at `D` plus the
  peel input transports vanishing to any `D' ≥ D`.
* `subsingleton_h1Mod_of_linearEquivalence` — vanishing is a class invariant
  (from `ClassInvariance.lean`, finiteness-free).
* `exists_bound_subsingleton_h1Mod` — the assembled bound.

## Relation to the sibling project's `UniformVanishing.lean`

`AJCR RiemannRoch/UniformVanishing.lean` proves a statement of exactly this
shape, `∃ b, ∀ D, b ≤ deg D → Subsingleton H¹(𝒪(D))`, and its proof has the same
skeleton: fix a base twist, produce an effective witness of the residual class,
peel it, transport along the class.  **This file is not a port of it.**  AJCR's
version obtains its base vanishing from the FLV-class machine
(`RiemannRoch/FLVClass.lean`, via a finite dominant `π : Y → ℙ¹` and the fiber
divisor) and its peel step from `peel_effective` on `divisorSheaf`; neither the
FLV machinery nor `divisorSheaf` exists in AJC.  So here (1) and (2) are named
hypotheses rather than discharged lemmas, and the file is honest about that: what
is *new* relative to AJC is the assembly and the class-transport, and those are
now proved.

## The three gaps, kept apart

`exists_bound_subsingleton_h1Mod` is **single-field**: `k`, the cover `U₀, U₁` and
the base divisor `D₀` are all fixed.  It is therefore strictly weaker than the two
things downstream consumers eventually want, and neither is proved anywhere in
this project:

* **extension uniformity** — the *same* `b` for every field extension `κ/k`.
  Needs flat base change of the bound along `k → κ`; nothing here quantifies over
  extensions, and note that even the *statement* needs the base-changed cover
  (`RiemannRoch/CurveBaseChange.lean` supplies `C_κ` as an AJC curve, but not the
  transported 2-affine cover data on which `Ȟ¹` here is pinned).
* **global generation** above the bound.  Needs `Ȟ¹(D − x) = 0` at every closed
  point `x`, i.e. the bound raised by the maximal residue degree, plus the
  evaluation-surjectivity argument.  Not addressed.

`ajc-gate` should therefore not read this file as discharging a global-generation
or extension-uniform hypothesis; it discharges the single-field bounded-vanishing
shape only, and only relative to (1)–(3).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits IsDedekindDomain
open scoped WithZero

namespace AlgebraicGeometry
namespace Adelic

section Vanishing

variable (k : Type u) [Field k] {X : Scheme.{u}} [IsIntegral X]
    [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X]
    [Algebra k X.functionField] [IsConstantField k X] (U₀ U₁ : X.Opens)

/-- **The concrete vanishing criterion.**  `Ȟ¹(D) = 𝒜(D)/B(D)` is trivial exactly
when the overlap sections are already coboundaries: `𝒜(D) ⊆ B(D)`.  (The reverse
inclusion always holds, `coboundarySub_le_overlap`, so the condition really is
equality.) -/
theorem subsingleton_h1Mod_iff (D : X.WeilDivisor) :
    Subsingleton (H1Mod k U₀ U₁ D) ↔
      sectionSub k (U₀ ⊓ U₁) D ≤ coboundarySub k U₀ U₁ D := by
  constructor
  · intro hsub x hx
    have hzero : Submodule.Quotient.mk (p := Submodule.comap
        (sectionSub k (U₀ ⊓ U₁) D).subtype (coboundarySub k U₀ U₁ D))
        (⟨x, hx⟩ : sectionSub k (U₀ ⊓ U₁) D) = 0 := Subsingleton.elim _ _
    rw [Submodule.Quotient.mk_eq_zero, Submodule.mem_comap,
      Submodule.subtype_apply] at hzero
    exact hzero
  · intro hle
    constructor
    intro a b
    obtain ⟨x, rfl⟩ := Submodule.Quotient.mk_surjective _ a
    obtain ⟨y, rfl⟩ := Submodule.Quotient.mk_surjective _ b
    rw [Submodule.Quotient.eq, Submodule.mem_comap, Submodule.subtype_apply]
    exact hle ((sectionSub k (U₀ ⊓ U₁) D).sub_mem x.2 y.2)

/-- **The peel step.**  Suppose `Ȟ¹(D)` vanishes and the twist `Ȟ¹(D) → Ȟ¹(D')`
is surjective — concretely, every overlap section of `𝒪(D')` agrees, modulo the
coboundary `B(D')`, with an overlap section of `𝒪(D)`.  Then `Ȟ¹(D')` vanishes.

`D'` is typically `D + E` with `E ≥ 0`: this is "peel off an effective divisor",
the step that turns one base vanishing into vanishing on a whole cone.  The
`hpeel` hypothesis is the ledger's surjectivity datum `htwist`, unwound; it is
supplied here as a hypothesis because AJC has no unconditional source for it. -/
theorem subsingleton_h1Mod_peel {D D' : X.WeilDivisor}
    (hbase : Subsingleton (H1Mod k U₀ U₁ D))
    (hpeel : ∀ x ∈ sectionSub k (U₀ ⊓ U₁) D', ∃ y ∈ sectionSub k (U₀ ⊓ U₁) D,
      x - y ∈ coboundarySub k U₀ U₁ D')
    (hle : ∀ P : X.PrimeDivisor, (show X.PrimeDivisor →₀ ℤ from D) P ≤
      (show X.PrimeDivisor →₀ ℤ from D') P) :
    Subsingleton (H1Mod k U₀ U₁ D') := by
  rw [subsingleton_h1Mod_iff] at hbase ⊢
  intro x hx
  obtain ⟨y, hy, hxy⟩ := hpeel x hx
  have hyB : y ∈ coboundarySub k U₀ U₁ D' := by
    have : y ∈ coboundarySub k U₀ U₁ D := hbase hy
    exact coboundarySub_mono k U₀ U₁ hle this
  have : x = (x - y) + y := by abel
  rw [this]
  exact (coboundarySub k U₀ U₁ D').add_mem hxy hyB

/-- **Vanishing is a linear-equivalence invariant** (finiteness-free).  The
multiplication isomorphism of `ClassInvariance.lean` is a `k`-linear isomorphism
`Ȟ¹(D) ≃ₗ[k] Ȟ¹(D')` whenever `D' = D − div g`, and `Subsingleton` transports
along any equivalence. -/
theorem subsingleton_h1Mod_of_shift {D D' : X.WeilDivisor} {g : X.functionField}
    (hg : g ≠ 0)
    (hD' : ∀ P : X.PrimeDivisor, (show X.PrimeDivisor →₀ ℤ from D') P =
      (show X.PrimeDivisor →₀ ℤ from D) P - Scheme.RationalMap.order P g)
    (h : Subsingleton (H1Mod k U₀ U₁ D)) :
    Subsingleton (H1Mod k U₀ U₁ D') :=
  (h1ModMulEquiv k U₀ U₁ hg hD').symm.toEquiv.subsingleton

/-- **`h¹ = 0` from vanishing**, for consumers phrased on the numerical
invariant. -/
theorem h1dim_eq_zero_of_subsingleton {D : X.WeilDivisor}
    (h : Subsingleton (H1Mod k U₀ U₁ D)) : h1dim k U₀ U₁ D = 0 := by
  rw [h1dim]
  exact Module.finrank_zero_of_subsingleton

end Vanishing

/-! ## §2. The assembled single-field bound

The assembly.  Fix a base divisor `D₀` with `Ȟ¹(D₀) = 0`.  For `D` of large
weighted degree the residual class `D − D₀` has `χ ≥ 1`, hence a nonzero global
section, hence an **effective** representative `E ~ D − D₀` (the effective-witness
dictionary of `ClassInvariance.lean`).  Then `D₀ + E ≥ D₀`, so peeling `E` off the
base vanishing kills `Ȟ¹(D₀ + E)`, and `D₀ + E ~ D` transports it to `Ȟ¹(D)`.

The threshold that makes the residual class have a section is
`b := deg_k D₀ + 1 − χ(0)`: for `deg_k D ≥ b` the ledger gives
`χ(D − D₀) = χ(0) + deg_k D − deg_k D₀ ≥ 1`, and `χ ≤ ℓ` does the rest.
-/

section Bound

variable (k : Type u) [Field k] {X : Scheme.{u}} [IsIntegral X]
    [IsNoetherian X] [Scheme.IsRegularInCodimensionOne X]
    [Algebra k X.functionField] [IsConstantField k X] (U₀ U₁ : X.Opens)

/-- **A class of positive `χ` has a nonzero global section.**  From `χ ≤ ℓ`
(`chi_le_ell`, i.e. `h¹ ≥ 0`): if `1 ≤ χ(D)` then `1 ≤ ℓ(D)`, so
`Γ(⊤, 𝒪(D)) ≠ 0`. -/
theorem exists_ne_zero_mem_of_one_le_chi {D : X.WeilDivisor}
    (hchi : 1 ≤ chi k U₀ U₁ D) :
    ∃ f : X.functionField, f ∈ sectionSub k ⊤ D ∧ f ≠ 0 := by
  have hell : 1 ≤ (ell k D : ℤ) := le_trans hchi (chi_le_ell k U₀ U₁ D)
  by_contra hno
  have hbot : sectionSub k ⊤ D = ⊥ := by
    apply le_antisymm _ bot_le
    intro x hx
    rcases eq_or_ne x 0 with rfl | hx0
    · exact Submodule.zero_mem _
    · exact absurd ⟨x, hx, hx0⟩ hno
  rw [ell, hbot] at hell
  simp at hell

/-- **An effective representative of a class of large weighted degree.**  Given
the closed ledger, if `deg_k D ≥ 1 − χ(0)` then `D` is linearly equivalent to an
effective divisor.  This is the adelic counterpart of AJCR's
`exists_effective_of_picClass`, proved here from `χ ≤ ℓ` plus the effective-witness
dictionary. -/
theorem exists_effective_linearEquiv_of_le_degK
    (hledger : ∀ D : X.WeilDivisor, chi k U₀ U₁ D = chi k U₀ U₁ 0 + degK k D)
    {D : X.WeilDivisor} (hdeg : 1 - chi k U₀ U₁ 0 ≤ degK k D) :
    ∃ E : X.WeilDivisor,
      (∀ P : X.PrimeDivisor, 0 ≤ (show X.PrimeDivisor →₀ ℤ from E) P) ∧
        Scheme.WeilDivisor.LinearEquivalence E D := by
  have hchi : 1 ≤ chi k U₀ U₁ D := by rw [hledger D]; omega
  obtain ⟨f, hfmem, hfne⟩ := exists_ne_zero_mem_of_one_le_chi k U₀ U₁ hchi
  exact exists_effective_linearEquiv_of_ne_zero_mem hfne hfmem

/-- **Single-field bounded `H¹` vanishing** (campaign P5, primary clause; the
strongest form reachable in AJC today).

Given
* a base divisor `D₀` with `Ȟ¹(D₀) = 0`,
* the **peel input** at `D₀`: for every `D' ≥ D₀`, each overlap section of
  `𝒪(D')` agrees modulo `B(D')` with an overlap section of `𝒪(D₀)` — i.e. the
  twist `Ȟ¹(D₀) → Ȟ¹(D')` is surjective (the ledger's `htwist` datum, unwound),
* the closed ledger,

there is a single threshold `b = deg_k D₀ + 1 − χ(0)` past which `Ȟ¹(D)` vanishes
for **every** Weil divisor `D` of weighted degree `≥ b`.

The bound depends only on `(k, U₀, U₁, D₀)`.  It is **not** uniform over field
extensions and says **nothing** about global generation — see the module
docstring. -/
theorem exists_bound_subsingleton_h1Mod
    (hledger : ∀ D : X.WeilDivisor, chi k U₀ U₁ D = chi k U₀ U₁ 0 + degK k D)
    (D₀ : X.WeilDivisor) (hbase : Subsingleton (H1Mod k U₀ U₁ D₀))
    (hpeel : ∀ D' : X.WeilDivisor,
      (∀ P : X.PrimeDivisor, (show X.PrimeDivisor →₀ ℤ from D₀) P ≤
        (show X.PrimeDivisor →₀ ℤ from D') P) →
      ∀ x ∈ sectionSub k (U₀ ⊓ U₁) D', ∃ y ∈ sectionSub k (U₀ ⊓ U₁) D₀,
        x - y ∈ coboundarySub k U₀ U₁ D') :
    ∃ b : ℤ, ∀ D : X.WeilDivisor, b ≤ degK k D →
      Subsingleton (H1Mod k U₀ U₁ D) := by
  refine ⟨degK k D₀ + 1 - chi k U₀ U₁ 0, fun D hD => ?_⟩
  -- the residual class `D - D₀` has weighted degree ≥ 1 - χ(0), so it is effective
  obtain ⟨E, hEnonneg, hEclass⟩ :=
    exists_effective_linearEquiv_of_le_degK k U₀ U₁ hledger
      (D := D - D₀) (by rw [degK_sub]; omega)
  -- `D₀ + E ≥ D₀`, so peeling `E` off the base vanishing kills `Ȟ¹(D₀ + E)`
  have hmono : ∀ P : X.PrimeDivisor, (show X.PrimeDivisor →₀ ℤ from D₀) P ≤
      (show X.PrimeDivisor →₀ ℤ from D₀ + E) P := by
    intro P
    rw [show (show X.PrimeDivisor →₀ ℤ from D₀ + E) P =
          (show X.PrimeDivisor →₀ ℤ from D₀) P +
            (show X.PrimeDivisor →₀ ℤ from E) P from Finsupp.add_apply _ _ _]
    have := hEnonneg P
    linarith
  have hpeeled : Subsingleton (H1Mod k U₀ U₁ (D₀ + E)) :=
    subsingleton_h1Mod_peel k U₀ U₁ hbase (hpeel (D₀ + E) hmono) hmono
  -- `D₀ + E ~ D₀ + (D - D₀) = D`, so transport along the class
  obtain ⟨g, hg, hgE⟩ := hEclass
  have hshift : ∀ P : X.PrimeDivisor, (show X.PrimeDivisor →₀ ℤ from D) P =
      (show X.PrimeDivisor →₀ ℤ from D₀ + E) P - Scheme.RationalMap.order P g := by
    intro P
    have hDsub : D = (D₀ + E) - Scheme.WeilDivisor.principal g hg := by
      have : E = (D - D₀) + Scheme.WeilDivisor.principal g hg := by
        rw [← hgE]; abel
      rw [this]; abel
    rw [hDsub]
    exact sub_principal_apply hg P
  exact subsingleton_h1Mod_of_shift k U₀ U₁ hg hshift hpeeled

/-- **The bound in numerical form.**  Same statement with the conclusion read on
`h¹` rather than on `Subsingleton`; `h1dim` is `0` for a subsingleton without any
finiteness input (`Module.finrank_zero_of_subsingleton`). -/
theorem exists_bound_h1dim_eq_zero
    (hledger : ∀ D : X.WeilDivisor, chi k U₀ U₁ D = chi k U₀ U₁ 0 + degK k D)
    (D₀ : X.WeilDivisor) (hbase : Subsingleton (H1Mod k U₀ U₁ D₀))
    (hpeel : ∀ D' : X.WeilDivisor,
      (∀ P : X.PrimeDivisor, (show X.PrimeDivisor →₀ ℤ from D₀) P ≤
        (show X.PrimeDivisor →₀ ℤ from D') P) →
      ∀ x ∈ sectionSub k (U₀ ⊓ U₁) D', ∃ y ∈ sectionSub k (U₀ ⊓ U₁) D₀,
        x - y ∈ coboundarySub k U₀ U₁ D') :
    ∃ b : ℤ, ∀ D : X.WeilDivisor, b ≤ degK k D → h1dim k U₀ U₁ D = 0 := by
  obtain ⟨b, hb⟩ :=
    exists_bound_subsingleton_h1Mod k U₀ U₁ hledger D₀ hbase hpeel
  exact ⟨b, fun D hD => h1dim_eq_zero_of_subsingleton k U₀ U₁ (hb D hD)⟩

/-- **Above the bound, `ℓ` is computed exactly by the ledger:**
`ℓ(D) = χ(0) + deg_k D`.  This is the Riemann–Roch conclusion in the vanishing
range — the shape a Grassmannian-embedding or rank-counting consumer wants, since
it turns `ℓ` from an inequality into a formula. -/
theorem ell_eq_of_bound
    (hledger : ∀ D : X.WeilDivisor, chi k U₀ U₁ D = chi k U₀ U₁ 0 + degK k D)
    {D : X.WeilDivisor} (hvan : Subsingleton (H1Mod k U₀ U₁ D)) :
    (ell k D : ℤ) = chi k U₀ U₁ 0 + degK k D := by
  have hh1 := h1dim_eq_zero_of_subsingleton k U₀ U₁ hvan
  have := hledger D
  rw [chi, hh1] at this
  omega

end Bound

end Adelic
end AlgebraicGeometry
