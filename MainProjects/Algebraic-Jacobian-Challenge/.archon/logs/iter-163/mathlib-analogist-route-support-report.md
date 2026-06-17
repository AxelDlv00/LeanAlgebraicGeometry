# Mathlib Analogist Report

## Mode
api-alignment (api-availability survey)

## Slug
route-support

## Iteration
163

## Question
For Route R (rigidity / rational-map extension, Milne §I.3) and Route H (differential /
cotangent + Frobenius hybrid), report per-piece what Mathlib ALREADY provides vs. genuine
GAP; conclude which route is less blocked. API availability only — no correctness judgement.

## Route R — per-piece table

| Piece | Status | Key Mathlib decls / modules |
|---|---|---|
| R1. Valuative criterion of properness | **EXISTS** | `AlgebraicGeometry/ValuativeCriterion.lean`: `ValuativeCriterion` (`.Existence`/`.Uniqueness`, L78-88), `.existence`/`.uniqueness` (L103/106), `IsProper.eq_valuativeCriterion` (L328), `IsProper.of_valuativeCriterion` (L339, needs `[QuasiCompact][QuasiSeparated][LocallyOfFiniteType]`), `IsSeparated.valuativeCriterion` (L273). Rational-map layer: `AlgebraicGeometry/RationalMap.lean` (`Scheme.PartialMap`, `Scheme.RationalMap`/`X ⤏ Y`, `RationalMap.domain`/`dense_domain`, `equivFunctionFieldOver` L473, `toPartialMap` L517). |
| R1-bridge. codim-1 stalk of normal var = DVR | **PARTIAL** (ring side exists) | `RingTheory/DiscreteValuationRing/TFAE.lean`: `tfae_of_isNoetherianRing_of_isLocalRing_of_isDomain` (L168, integrally-closed + dim 1 ⟺ DVR). `RingTheory/DedekindDomain/Dvr.lean`: `IsLocalization.AtPrime.isDiscreteValuationRing_of_dedekind_domain` (L131), `Ring.DimensionLEOne.localization` (L68). **[gap]**: scheme-side "X normal ⟹ stalk integrally closed" + "codim-1 ⟹ dim 1" not assembled. |
| R2. Weil divisor / pure-codim-1 indeterminacy locus | **[gap]** (likely avoidable) | No algebraic divisor theory in `AlgebraicGeometry`; only `Analysis/Meromorphic/Divisor.lean` (analytic). No `div(f)`, prime divisors, indeterminacy-locus theory. Krull height at ring level only (`RingTheory/KrullDimension/`). Pointwise valuative extension may bypass this. |
| R3. 𝔾_a / 𝔾_m + Hom(𝔾_a,A)=0 | **PARTIAL→[gap]** | Underlying scheme EXISTS: `AlgebraicGeometry/AffineSpace.lean` `𝔸(n;S)` (L46) with full functorial API. Group-object machinery EXISTS (`GrpObj`, used in `Group/Abelian.lean`). **[gap]**: no group structure on 𝔸¹, no 𝔾_m, no `Hom(𝔾_a,A)=0` theorem. `Group/` = `Abelian.lean`, `Smooth.lean` only. |

## Route H — per-piece table

| Piece | Status | Key Mathlib decls / modules |
|---|---|---|
| H1. Sheaf of differentials Ω (quasi-coh.), pullback, Ω_A≅O^g | **[gap] at scheme level** (ring RICH) | Ring level extensive: `RingTheory/Kaehler/Basic.lean` (`Ω[S⁄R]`, `KaehlerDifferential.D` L197, `endEquiv`, `ideal_fg`), `Kaehler/Polynomial.lean` (`mvPolynomialEquiv` L31 — free, the Ω≅O^g ingredient), `JacobiZariski.lean`, `TensorProduct.lean`. **[gap]**: NO Ω as quasi-coherent sheaf, no cotangent sheaf, no pullback-of-differentials. `Modules/{Presheaf,Sheaf,Tilde}` gives `M~` to build it, but unbuilt. Only AG consumer: `Morphisms/FormallyUnramified.lean` (abstract, not a sheaf). |
| H2. H⁰(ℙ¹,O(n)) line-bundle cohomology | **[gap], SEVERE** | Mathlib has NO coherent/quasi-coherent sheaf cohomology — no `H^i`, no higher direct images, no `RΓ`, no `ℙⁿ` scheme, no Serre twist O(n), no scheme Picard group. Only abstract `CategoryTheory/Sites/SheafCohomology/*` and `AlgebraicGeometry/Sites/ElladicCohomology.lean` (neither gives Serre's H⁰). Proj exists & proper (`ProjectiveSpectrum/Proper.lean` `IsProper (Proj.toSpecZero 𝒜)` L366) but its cohomology does not. |
| H3. Relative Frobenius of schemes + factorization | **[gap], from scratch** | No scheme Frobenius (grep empty in `AlgebraicGeometry/`). Ring/field only: `Algebra/CharP/Frobenius.lean` (`frobenius`, `iterateFrobenius`), `RingTheory/Frobenius.lean`, `FieldTheory/PerfectClosure.lean` (`PerfectClosure`). No "zero differential ⟹ factors through relative Frobenius". |

## Verdicts (summary)

| Piece | Verdict |
|---|---|
| R1 valuative criterion | EXISTS — no build |
| R1-bridge codim-1 DVR | PARTIAL — ring side present, scheme glue needed |
| R2 Weil divisors | NEEDS_MATHLIB_GAP_FILL — likely avoidable |
| R3 𝔾_a/𝔾_m + Hom triviality | NEEDS_MATHLIB_GAP_FILL — one lemma over existing API |
| H1 Ω sheaf | NEEDS_MATHLIB_GAP_FILL — ring rich, sheaf absent |
| H2 line-bundle cohomology | NEEDS_MATHLIB_GAP_FILL — foundational, zero starting point |
| H3 scheme Frobenius | NEEDS_MATHLIB_GAP_FILL — from scratch |

## Bottom line

**Route R is materially less blocked and is the recommended completion path.** Its
load-bearing keystone — the valuative criterion of properness — is fully present in Mathlib,
battle-tested, and exactly typed for a proper target (`IsProper.of_valuativeCriterion`), and is
backed by a complete `RationalMap`/`PartialMap` layer plus the ring-level DVR-at-height-1
bridge (`tfae_of_isNoetherianRing_of_isLocalRing_of_isDomain`). Route R's two genuine gaps are
contained: R2 (Weil divisors) is plausibly side-steppable via pointwise valuative extension at
each codim-1 point, and R3 reduces to one homomorphism-triviality lemma layered over the
already-present `AffineSpace` + `GrpObj` group-object API. By contrast Route H requires THREE
independent from-scratch foundational builds: scheme-level Kähler differentials (H1; the ring
theory is rich but the quasi-coherent sheaf, its pullback, and Ω_A≅O^g are absent), a complete
coherent-sheaf cohomology theory together with O(n) and Serre's H⁰ computation (H2 — the single
largest gap in this survey: Mathlib has no quasi-coherent sheaf cohomology of any kind), and a
scheme-level relative Frobenius plus its factorization theorem (H3). On Mathlib-infrastructure
grounds, prefer Route R.

## Persistent file
- `analogies/route-support.md` — full per-piece rationale with module:line citations for future iters.
