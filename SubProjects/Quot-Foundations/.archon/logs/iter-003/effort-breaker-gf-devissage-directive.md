# Effort Breaker Directive

## Slug
gf-devissage

## Target
thm:generic_flatness_algebraic
(in `blueprint/src/chapters/Picard_FlatteningStratification.tex`, label at line ~48;
Lean pin `AlgebraicGeometry.genericFlatnessAlgebraic`)

## Granularity
one level — split the Nitsure §4 dévissage proof into a `\uses`-linked chain of
sub-lemmas. The primary route (M module-finite over A) is ALREADY closed in Lean via
`GenericFreeness.exists_free_localizationAway_of_finite`; do NOT re-break that branch.
Decompose ONLY the surviving residue: M finite over a finite-type (not module-finite)
A-algebra B.

## Proof structure (cut along the existing proof's seams — chapter lines ~94–153)

The residue is the classical Nitsure §4 induction. Cut into these sub-lemmas, each with
its own statement, informal proof, `\uses{}`, and a `\lean{}` name assigned by convention
(note all assigned names for the dispatcher). Where Mathlib provides the ingredient, write
a `\mathlibok` anchor (verify the exact decl name first):

- **L1 — base case `M_K = 0` (torsion case).** If `K ⊗_A M = 0` (`K = Frac A`), then each
  generator of M is annihilated by some non-zero `a ∈ A`; the product `f` of finitely many
  annihilators satisfies `f·M = 0`, so `M_f = 0` is free. State and prove this directly
  (no induction). Candidate APIs to name: finite generation of M as B-module, `Submonoid`
  / torsion annihilator. (`A`-module finiteness not assumed here — M is B-finite.)
- **L2 — prime filtration reduces to `M = B/𝔭`.** A finite module over the noetherian ring
  B admits a finite filtration `0 = M_0 ⊂ … ⊂ M_r = M` with `M_i/M_{i-1} ≅ B/𝔭_i`.
  Mathlib provides the induction principle
  `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` — write this as a
  `\mathlibok` anchor if its statement matches, OR as a sub-lemma that invokes it. State
  the reduction: it suffices to prove generic freeness for each `B/𝔭`.
- **L3 — splicing fact.** If `M'_{f'}` is `A_{f'}`-free and `M''_{f''}` is `A_{f''}`-free
  (M', M'' the ends of a short exact sequence with middle M), then `M_{f'f''}` is
  `A_{f'f''}`-free. This is what makes the filtration induction go through. State as its
  own lemma (free + free over a localization ⟹ free over the common localization, via the
  split SES after inverting). Name candidate Mathlib pieces (`Module.Free` of an extension
  of free modules; localization exactness).
- **L4 — Noether normalisation + clearing denominators.** For B a domain finite-type over
  A with fraction field K, Noether normalisation of `B_K/K` gives algebraically independent
  `b_1,…,b_n ∈ B` with `B_K` finite over `K[b_1,…,b_n]`; clearing finitely many
  denominators of the integrality relations gives `g ≠ 0` with `B_g` finite over
  `A_g[b_1,…,b_n]`. Mathlib: `exists_finite_inj_algHom_of_fg` /
  `exists_integral_inj_algHom_of_fg` (`Mathlib.RingTheory.NoetherNormalization`) — anchor
  or invoke. State the conclusion as a sub-lemma.
- **L5 — polynomial-ring core (THE genuine Mathlib-absent residue; make it its own block).**
  A finite module over the polynomial ring `A[X_1,…,X_d]` (A a noetherian domain) becomes
  free over `A_f` after inverting a single `f ≠ 0`. This is the bottom of the induction and
  is verified ABSENT from Mathlib. State it precisely as a standalone lemma with a `\lean{}`
  name (e.g. `AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_polynomial`).
  Give the informal proof (induction on d via the SES `0 → A[X]^m → B_g → T → 0` with T of
  smaller support dimension, reducing to the finite-A-module primary case at d=0). This is
  the hand-built core; flag it under "Could not decompose / strategy items" as the genuine
  novel build that gates the residue, with d-induction as its internal structure.
- **Target rewrite.** `genericFlatnessAlgebraic`'s residue branch = induction on
  `n = dim supp_{Spec B_K} M_K`, base case L1, step via L2 (filtration) + L4 (normalisation)
  + L5 (polynomial core) + L3 (splicing), bottoming out at the already-closed finite-A
  primary branch. Keep the target statement and `\lean{}` unchanged.

## Strategy context
GF route. The algebraic core's primary case is a thin Mathlib wrapper (DONE). Only the
finite-type-B residue is hand-built; it is genuinely Mathlib-absent at the polynomial-ring
core (L5). Decomposing exposes L1 (base case), L2/L4 (Mathlib-anchored), and L3 (splicing)
as tractable pieces, isolating L5 as the one true novel build. Do not weaken the target.

## References
- `references/nitsure-hilbert-quot.md` → `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`,
  §4 "Lemma on Generic Flatness", full induction proof at L1711–L1772. The target block
  already embeds the verbatim `% SOURCE QUOTE` and `% SOURCE QUOTE PROOF` from this range;
  reuse them, and split the proof quote across the sub-lemmas (per the citation rule: when a
  source proof is long, give each sub-statement its own `% SOURCE QUOTE PROOF:` of the
  corresponding fragment). If you need a fragment you cannot read locally, spawn a
  reference-retriever (write-domain includes `references/**`), wait, read, then write.
