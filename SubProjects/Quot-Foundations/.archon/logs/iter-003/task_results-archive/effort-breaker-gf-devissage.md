# Effort Breaker Report

## Slug
gf-devissage

## Target
thm:generic_flatness_algebraic (`AlgebraicGeometry.genericFlatnessAlgebraic`)

## Status
COMPLETE — the surviving finite-type-`B` residue is re-expressed as a `\uses`-linked
chain of 8 sub-lemmas (5 provable blocks + 3 verified Mathlib anchors). The primary
finite-`A`-module branch (already closed in Lean) was NOT re-broken; the chain bottoms
out at it via `lem:gf_finite_module`.

## Effort before → after
- target `effort_local`: 3894 → **2938** (residual = documentation of the already-closed
  primary route + thin assembly of the chain).
- target `dep_count`: 0 → **6**; `effort_total` (cone) = 6589.
- sub-lemmas added: **8** (cone of target = all 8, no broken `\uses`).

## Chain added (target ← chain)
All in `chapters/Picard_FlatteningStratification.tex`, new subsection
`sec:gf_devissage_chain`. Target `\uses{}` placed in the **statement** block (this
project's convention — proof-level `\uses` is NOT counted by leandag; confirmed
empirically).

- `\label{lem:gf_finite_module}` `\lean{…GenericFreeness.exists_free_localizationAway_of_finite}`
  — finite-`A`-module leaf (`d=0`). **Already proven axiom-clean in Lean.** (effort 0, `\uses{lem:fp_free_descent}`)
- `\label{lem:fp_free_descent}` `\lean{Module.FinitePresentation.exists_free_localizedModule_powers}`
  `\mathlibok` — FP free-descent across a localization. (Mathlib, verified)
- **L1** `\label{lem:gf_torsion_base}` `\lean{…GenericFreeness.exists_free_localizationAway_of_torsion}`
  — `M_K=0 ⟹ ∃ f≠0, fM=0`, so `M_f=0` free. (effort 591, deps 0)
- **L2** `\label{lem:noeth_prime_filtration}` `\lean{IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime}`
  `\mathlibok` — prime-filtration induction principle for finite modules over a
  noetherian ring (bundles the filtration→`B/𝔭` reduction *and* the SES case).
  (Mathlib `RingTheory.Ideal.AssociatedPrime.Finiteness`, verified)
- **L3** `\label{lem:gf_splice_shortExact}` `\lean{…GenericFreeness.exists_free_localizationAway_of_shortExact}`
  — splicing fact: `M'_{f'}` free + `M''_{f''}` free ⟹ `M_{f'f''}` free (via exact
  localization + split SES). (effort 611, deps 0)
- **L4 anchor** `\label{lem:noether_normalization_fg}` `\lean{exists_finite_inj_algHom_of_fg}`
  `\mathlibok` — Noether normalisation over a field. (Mathlib `RingTheory.NoetherNormalization`, verified)
- **L4** `\label{lem:gf_noether_clear_denominators}` `\lean{…GenericFreeness.exists_localizationAway_finite_mvPolynomial}`
  — `B` domain finite-type over `A` ⟹ `∃ g≠0`, `B_g` finite over `A_g[b_1,…,b_n]`.
  (effort 1000, `\uses{lem:noether_normalization_fg}`)
- **L5** `\label{lem:gf_polynomial_core}` `\lean{…GenericFreeness.exists_free_localizationAway_polynomial}`
  — **THE genuine Mathlib-absent core**: finite module over `A[X_1,…,X_d]` becomes free
  after one inversion; internal `d`-induction via the SES
  `0 → A_g[X]^m → N_g → T → 0`, base `d=0` = `lem:gf_finite_module`.
  (effort 1449, `\uses{lem:gf_finite_module, lem:gf_splice_shortExact, lem:gf_torsion_base}`)

Target `thm:generic_flatness_algebraic` proof rewritten: primary route unchanged
(closed in Lean), fallback compressed to a chain assembly; `\uses{lem:gf_torsion_base,
lem:noeth_prime_filtration, lem:gf_splice_shortExact, lem:gf_noether_clear_denominators,
lem:gf_polynomial_core, lem:gf_finite_module}` in the statement block.

## Still hard (re-break candidates)
- `lem:gf_polynomial_core` (L5, effort 1449) — the irreducible novel build. Its internal
  structure IS the `d`-induction (already spelled out in its proof). If the prover stalls,
  re-dispatch the breaker at fine granularity to split out: (a) the generic-rank /
  basis-clearing step producing the SES, (b) the "torsion ⟹ smaller support dimension"
  estimate, (c) the `d`-step localization of the free middle term. These are the three
  internal seams.
- `lem:gf_noether_clear_denominators` (L4, effort 1000) — the clearing-denominators
  bookkeeping over `exists_finite_inj_algHom_of_fg` is fiddly but mechanical; fine-break
  only if the prover stalls on the `A_g`-vs-`K` descent of the integrality relations.

## Could not decompose (strategy items)
- `lem:gf_polynomial_core` is the genuine Mathlib-absent residue that gates the whole
  finite-type case (verified absent: no polynomial-ring generic-freeness lemma in Mathlib).
  Its `d`-induction is its internal structure, not a further `\uses` chain — the leaves it
  bottoms into (`lem:gf_finite_module`, `lem:gf_splice_shortExact`, `lem:gf_torsion_base`)
  are already in the chain. This is the one true hand-built block.

## References consulted
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`, §4 "Lemma on Generic
  Flatness", L1711–L1772 (read locally). The single long `% SOURCE QUOTE PROOF` was split
  across the sub-lemmas per the citation rule: base case (L1719–L1726) → L1; splicing
  remark (L1737–L1745) → L3; Noether-normalisation step (L1747–L1758) → L4; inductive
  step / generic-rank SES (L1760–L1772) → L5. Each derived block carries `% SOURCE:`,
  verbatim `% SOURCE QUOTE PROOF:`, and a `\textit{Source: [Nitsure], §4 …}` first line.

## Notes for dispatcher
- **`\lean{}` names assigned by convention (need scaffolding as `sorry` stubs in
  `AlgebraicJacobian/Picard/FlatteningStratification.lean`, `GenericFreeness` namespace):**
  - `exists_free_localizationAway_of_torsion` (L1)
  - `exists_free_localizationAway_of_shortExact` (L3)
  - `exists_localizationAway_finite_mvPolynomial` (L4)
  - `exists_free_localizationAway_polynomial` (L5)
- **Already exists in Lean (no scaffold):** `exists_free_localizationAway_of_finite`
  (leaf, proven axiom-clean).
- **Mathlib anchors (no scaffold, `\mathlibok`, decl names verified via loogle/hover):**
  `Module.FinitePresentation.exists_free_localizedModule_powers`,
  `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime`,
  `exists_finite_inj_algHom_of_fg`.
- Target statement and `\lean{}` pin unchanged. No new macros needed. blueprint-doctor
  clean (no broken `\ref`/`\uses`, no new axioms). leandag cone of the target now contains
  all 8 new nodes.
- Suggested prover order (leaves first): L1 → L3 → L4 → L5 (uses L1/L3/leaf) → target
  assembly. L2/L4-anchor/leaf/fp-descent are `\mathlibok`/done.
