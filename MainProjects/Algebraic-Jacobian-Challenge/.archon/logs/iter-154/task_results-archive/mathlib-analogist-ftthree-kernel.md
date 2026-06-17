# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
ftthree-kernel

## Iteration
154

## Structural problem

For a separably-generated (here char-0) field extension `K/k`, the kernel of the
universal Kähler derivation `d : K → Ω_{K/k}` equals the relative algebraic
closure of `k` in `K` (the field of constants). Need: `d x = 0 ⟹ x algebraic
over k`; combined with `k` algebraically closed in `K` (`[IsAlgClosed k] +
[IsDomain B]`, `K = Frac B`), this gives `x ∈ k`. The content is in the
transcendental layer (`Ω_{K/k} ≠ 0`). Lean residual = the `sorry` at
`AlgebraicJacobian/Cotangent/ChartAlgebra.lean:427`
(`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`).

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `Algebra.H1Cotangent.exact_δ_mapBaseChange` + `FormallySmooth.of_perfectField` | cotangent complex / formal smoothness | low–medium | ANALOGUE_FOUND |
| `KaehlerDifferential.isLocalizedModule_map` + `polynomialEquiv_D` | localization / essentially-étale Kähler | low | ANALOGUE_FOUND |
| separating-transcendence-basis freeness of `Ω` (directive steps 1–2) | transcendence theory | n/a | discarded (unnecessary) |

## Headline: the iter-153 "genuine Mathlib gap / bright-line STOP" verdict is OVERTURNED

FT.3 has no single shipped kernel-of-`d` lemma, but **every structural
ingredient is in Mathlib `b80f227`** and assembles into a complete proof. I
verified the entire chain by compilation (`lean_run_code`, project toolchain):
the 4 deep structural lemmas, the EssFiniteType/`mapBaseChange`/`D` glue, the
**fully-closed transcendental base case**, and the algebraic-closure closer all
type-check and compose. FT.3 is **assemblable project material (~100–150 LOC)**,
not a Mathlib theory gap. The PROGRESS.md/STRATEGY.md bright-line on KDM should
be lifted and a prover re-dispatched with the route below.

A **cleaner route than the directive's 4-step separating-transcendence-basis
assembly** exists and is the top suggestion: it avoids choosing a transcendence
basis, the freeness-of-`Ω`-on-a-basis step, and the "all partials vanish"
combinatorics. The existing `_mvPoly_*` free-case helpers (built for the
abandoned joint-pderiv route) become dead code.

## Top suggestion

**Single-element / perfect-field route.** The missing piece the project framed
as "ker d description" is really the **left-exactness (injectivity) of the
cotangent base-change** `K ⊗_F Ω_{F/k} → Ω_{K/k}`, which Mathlib delivers via the
**Jacobi–Zariski `H1Cotangent` exact sequence**
(`Algebra.H1Cotangent.exact_δ_mapBaseChange`, `Mathlib.RingTheory.Kaehler.CotangentComplex`)
once `H¹(L_{K/F})` is `Subsingleton`
(`instSubsingletonH1CotangentOfFormallySmooth`, `Mathlib.RingTheory.Smooth.Basic`).
Take `F = k(b)`: in char 0 it is a **perfect field**
(`PerfectField.ofCharZero`) and `K` is `EssFiniteType` over it
(`Algebra.EssFiniteType.of_comp`), so `Algebra.FormallySmooth.of_perfectField`
(`Mathlib.RingTheory.Smooth.Field`) gives `FormallySmooth F K` with **no
transcendence basis**.

Concrete edit to `ChartAlgebra.lean:427`:

1. **New helper `_ratfunc_D_X_ne_zero`** (≈20 LOC, FULLY VERIFIED): `D_{Frac k[X]}(X) ≠ 0`
   via `KaehlerDifferential.isLocalizedModule_map` + `IsLocalizedModule.eq_zero_iff`
   + the `k[X]`-linear iso `polynomialEquiv` (`polynomialEquiv_D : polynomialEquiv (D X) = derivative X = 1`).
2. **Main reduction `D_B b = 0 ⟹ IsAlgebraic k b`** (≈60–90 LOC): push to `K = Frac B`
   (`map_D`, already present as `_hFunct`); `by_contra` ⟹ `Transcendental k b` ⟹
   `k[X] → K` (`X↦b`) injective ⟹ `IsFractionRing.lift` embeds `F := RatFunc k` into `K`;
   register `Algebra F K`/`IsScalarTower k F K`; `FormallySmooth F K` ⟹ `mapBaseChange k F K`
   injective; `D_K b = mapBaseChange (1 ⊗ D_F X_F)` ⟹ `1 ⊗ D_F X_F = 0` ⟹
   (`FaithfullyFlat F K`, `Module.FaithfullyFlat.one_tmul_eq_zero_iff`) `D_F X_F = 0`,
   contradicting step 1.
3. **Closer `IsAlgebraic k b ⟹ b ∈ range(algebraMap k B)`** (≈10 LOC, VERIFIED):
   `IntermediateField.adjoin.finiteDimensional` + `IsAlgClosed.algebraMap_bijective_of_isIntegral`
   (the project already uses the latter in `constants_integral_over_base_field`).

The signature is unchanged and sufficient; note `n` / standard-smoothness are not
actually needed for the kernel argument (only `IsDomain B` + `FiniteType k B` to
build `K` and `EssFiniteType k K`) — they remain harmless. The full
verified-compiling skeleton (8 `example` blocks) is in
`analogies/ftthree-kernel-iter154.md`.

## Discarded

- **Separating-transcendence-basis freeness of `Ω` (directive steps 1–2).**
  Mathlib has `SubmersivePresentation.rank_kaehlerDifferential` /
  `IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential (= n)` and
  `Algebra.trdeg`, but **no `IsTranscendenceBasis`-keyed freeness-of-`Ω` lemma**
  and **no general `rank Ω_{K/k} = trdeg`**. The `H1Cotangent` route makes a
  transcendence basis unnecessary, so this is not worth building.
- **`tensorKaehlerEquivOfFormallyEtale` for the *top* layer.** It needs
  `FormallyEtale` (algebraic), so it applies to `K/k(t)` but not to `K/k(b)`;
  the `FormallySmooth` + `Subsingleton H1` injectivity argument is what handles
  the non-algebraic top layer. (It IS used, separately, inside the base case for
  the localization `k[X] → Frac k[X]`.)

## Persistent file
- `analogies/ftthree-kernel-iter154.md` — analogue list, top suggestion, full
  verified-compiling skeleton, and citation table captured for future iters.

Overall verdict: FT.3 is fully assemblable from existing Mathlib `b80f227` via
the Jacobi–Zariski/`H1Cotangent` left-exactness + perfect-field formal smoothness
+ a localization base case (all verified by compilation) — the iter-153 Mathlib
gap / bright-line STOP is overturned; re-dispatch a prover on the single-element
route, ~100–150 LOC.
