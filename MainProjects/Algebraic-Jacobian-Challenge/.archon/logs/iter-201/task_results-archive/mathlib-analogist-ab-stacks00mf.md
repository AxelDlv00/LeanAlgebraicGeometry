# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
ab-stacks00mf

## Iteration
201

## Structural problem

Close the body of `RingTheory.auslander_buchsbaum_formula_succ_pd`
(`AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:1517`, residual
sorry at L1574) without building Stacks 00MF
(`pd M > 0 ⟹ depth M < depth R`) as a standalone project-side substrate
first. Specifically, decide between Path A (build Stacks 00MF as
substrate, ~150-200 LOC) and Path B (close `depth(ker f) ≤ depth M + 1`
directly via an Ext LES-injectivity argument on the SES
`0 → ker f → R^n → M → 0` from
`exists_minimalSurjection_finite_localRing`).

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| Project `depth_of_short_exact` + `Ext.covariant_sequence_exact₁/₂/₃` (Mathlib `…Ext.ExactSequences`) | Derived-functor LES in abelian categories — already wired in this file | low | ANALOGUE_FOUND |
| Project `ext_smul_eq_zero_of_mem_annihilator` (Stacks 00LP) at L229 | Annihilator-collapse of `Ext^*(κ, -)` | low | ANALOGUE_FOUND |
| `Ext.bilinearComp` / `bilinearCompOfLinear` + `add_comp` + `smul_comp` (`Mathlib.Algebra.Homology.DerivedCategory.Ext.{Basic,Linear}`) | R-bilinearity of derived-functor composition | low | ANALOGUE_FOUND |
| `Module.free_of_flat_of_isLocalRing` + `Module.Flat.of_projective` (`Mathlib.RingTheory.LocalRing.Module` / `Mathlib.RingTheory.Flat.Basic`) | Finite projectives over local rings are free | low | ANALOGUE_FOUND |

## Verdict: Path B (LES-injectivity) is feasible — recommended over Path A.

Path B reduces the closure to **(a)** an inductive step that uses only
the IH-derived `depth K < depth R` plus the LES of `Ext^*(κ, -)` already
threaded through `depth_of_short_exact`, and **(b)** a base case
`pd M = 1 ⇒ depth M < depth R` that needs **one new ~50-80 LOC helper**
(matrix-with-`𝔪`-entries collapses Ext-postcomposition to zero) wired
together from already-present primitives.

Path B avoids committing to a generic Buchsbaum-Eisenbud / Stacks 00MF
predicate. The project has no other downstream consumer of 00MF: the
`CohenMacaulay R` predicate (this file, §6) is upstream of, not
downstream of, AB.

## Top suggestion

**Adopt Path B.** Split `auslander_buchsbaum_formula_succ_pd` (L1517)
into an inductive step + base case:

1. **Inductive step `pd M = k + 1`, `k ≥ 1` (~50-80 LOC)**: from
   `hasProjectiveDimensionLT_ker_of_surjection` + the contrapositive of
   `hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker`,
   `pd K = k` *exactly*. Strong induction gives
   `k + depth K = depth R`, so `depth K < depth R` (since `k ≥ 1`).
   Lower bound `depth M ≥ depth K - 1`: `depth_of_short_exact` part (2)
   (already exists). Upper bound `depth M ≤ depth K - 1`: by
   contradiction — assume `depth M ≥ depth K`, look at LES at
   `i = depth K`, infer `Ext^{depth K}(κ, R^n) ≠ 0` (so
   `depth R ≤ depth K`), contradicting IH.

2. **Base case `pd M = 1` (~80-120 LOC)**: `K = ker f` is projective
   (since `pd K = 0`), hence free over local Noetherian R
   (`Module.free_of_flat_of_isLocalRing` via `Module.Flat.of_projective`).
   Hence `K ≅ R^m`, with `m ≥ 1` (else M itself free, contradicting
   `pd M = 1`). The inclusion `K ↪ R^n` is an `(n × m)`-matrix `A` with
   entries in `𝔪` (from the existing
   `exists_minimalSurjection_finite_localRing` minimality clause
   `ker f ≤ 𝔪 • ⊤`). Add the **matrix-collapse helper**:

   > For `A : R^m → R^n` (m, n ≥ 1) with every entry in `Ann(κ) = 𝔪`,
   > the postcomposition map
   > `(- ∘ Ext.mk₀ A) : Ext^i(κ, R^m) → Ext^i(κ, R^n)` is zero.

   Proof: `A = ∑_{i,j} A_{ij} • E_{ij}` (basis-matrix sum); by
   `Ext.add_comp` + `Ext.smul_comp` and the bundled
   `Ext.bilinearCompOfLinear`, the postcomp distributes. Each summand
   has a scalar factor `A_{ij} ∈ Ann(κ)` acting on
   `Ext^i(κ, R^n)`, killed by the existing
   `ext_smul_eq_zero_of_mem_annihilator` (L229). The sum collapses to
   zero. ~50-80 LOC.

   With matrix-collapse, the LES at index `i = depth R - 1` yields
   `Ext^{depth R - 1}(κ, M) →^{δ_{-1}} Ext^{depth R}(κ, K) →^{(-∘ A)} Ext^{depth R}(κ, R^n)`
   with the second arrow zero. If `depth M ≥ depth R`, the source is
   zero, hence `Ext^{depth R}(κ, K) = 0` — but
   `Ext^{depth R}(κ, K) ≅ Ext^{depth R}(κ, R^m) ≠ 0` (`m ≥ 1`,
   `depth R^m = depth R`). Contradiction. So `depth M < depth R`.

**Total Path B LOC: ~130-200 LOC**, comparable to Path A but with
better composition: every new lemma reuses existing axiom-clean
primitives, and the matrix-collapse helper is independently useful for
any future "minimal matrix annihilates `Ext^*(κ, -)`" argument.

**First Mathlib file to read**: `Mathlib.Algebra.Homology.DerivedCategory.Ext.Linear`
for the R-bilinear `Ext.comp` API. **First project file to touch**:
extend the `RingTheory.Module` namespace around L1290 of
`AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` with the
matrix-collapse helper, then refactor `auslander_buchsbaum_formula_succ_pd`
(L1517) into inductive + base-case branches and close the sorry at
L1574.

## Discarded

- **`Mathlib.RingTheory.KrullDimension.Regular` (depth-via-KrullDim)**: the
  project's `Module.depth` is Ext-indexed, not KrullDim-indexed; no
  direct interface without a Cohen-Macaulay bridge that is downstream
  of AB.
- **Sheaf / group cohomology LES injectivity (`Mathlib.Topology.Sheaves.*`,
  `Mathlib.RepresentationTheory.GroupCohomology`)**: structurally
  identical but the technique reduces to the same `covariant_sequence_exact`
  shape already in the project's hand — no surplus.
- **Using `[CohenMacaulay R]` as a hypothesis to side-step the closure**:
  circular — the CM predicate is itself downstream of AB in this file.

## Persistent file
- `.archon/analogies/ab-stacks00mf.md` — analogue list captured for
  future iters.

Overall verdict: Path B is feasible at ~130-200 LOC by reusing the
project's existing `ext_smul_eq_zero_of_mem_annihilator` and Mathlib's
`Ext.bilinearCompOfLinear` to collapse the `Ext(κ, A)` postcomposition,
avoiding a standalone Stacks 00MF substrate; the inductive step and
base case each route through existing LES infrastructure in this file.
