# Progress-critic directive — P4 acyclic-resolution lane trajectory

Assess convergence of the single active prover route. Strict context: signals only below.

## Active route — P4 (abstract acyclic-resolution comparison)

- **File**: `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
- **Mode**: `mathlib-build` (grows project-local Mathlib infrastructure axiom-clean; the
  output metric is **axiom-clean declarations added + remaining-scope collapse**, NOT inline-sorry
  reduction — this file has had 0 inline sorries throughout; a mathlib-build lane never lowers a
  sorry count, it builds infra that a later `prove` lane consumes).
- **STRATEGY current estimate**: P4 row `Iters left: ~2–4`; the route entered its current phase at
  **iter-003**. So elapsed in-phase: iter-003 → iter-005 = 3 iters of which iter-003 was a
  mechanical noop (lane never launched — a tooling filter dropped a zero-sorry objective), leaving
  **2 effective prover iters** (004, 005).

### Last 4 iters' signals (this route)

- **iter-003**: prover lane authored but **0 dispatched** (mechanical noop — `filter_noop_objectives`
  dropped the zero-sorry file because the objective verb didn't match the scaffold regex). No prover
  output. Inline sorry 2→2 (both elsewhere, out of scope).
- **iter-004**: prover ran. **+5 axiom-clean decls.** Built every *consumer* of the horseshoe
  (dimension-shift engine `rightDerivedShiftIsoOfSplitResolutionSES` via Mathlib `δIso`,
  degreewise-splitting machinery, per-stage horseshoe mono). Status: PARTIAL — collapsed the whole
  P4 chain to ONE remaining construction (the horseshoe object). Prover correctly declined the
  monolithic ℕ-recursion (no sorry-free partial fragment). Blocker phrase: "horseshoe monolith /
  `ofShortExact` ℕ-recursion". Inline sorry 2→2.
- **iter-005**: prover ran. **+27 axiom-clean decls.** Built the genuinely novel core of the dual
  Horseshoe Lemma (twisted-biproduct complex, the τ twist recursion with the cocycle identity, the
  degreewise-split SES of complexes, the augmentation). Closed 3 of the 4 decomposed sub-goals
  (`horseshoe_twist`, `_dComp`, `_chainMap`); 1 blocked (`_resolvesMiddle`). Status: PARTIAL —
  collapsed the remaining work to ONE precise Mathlib-absent lemma. Blocker phrase: "`quasiIso_τ₂`
  middle-term quasi-iso transfer absent from Mathlib". Inline sorry 2→2.
- **Helpers added per iter**: 004 → +5; 005 → +27. Each iter the *added* decls are load-bearing and
  the *remaining-scope* strictly shrank (whole-chain → one object → one lemma). No decl was thrown
  away or re-derived across iters (each iter built on the prior, none churned).

### Blocker evolution (is it the SAME wall re-hit, or a shrinking frontier?)

- 004 blocker: "the horseshoe object is a monolith" → resolved iter-005 by decomposition + building
  3 of 4 leaves.
- 005 blocker: "`quasiIso_τ₂` is a Mathlib TODO" → **independently confirmed by the planner**: the
  Mathlib file `HomologySequenceLemmas.lean` docstring literally says only the four `τ₃` lemmas are
  stated and "Eight more similar lemmas for `φ.τ₁` and `φ.τ₂` shall also be obtained (TODO)". The
  prover handed off a concrete recipe (homology five-lemma on a 7-term LES window via `composableArrows₅`
  + `mono_of_epi_of_mono_of_mono`/`epi_of_epi_of_epi_of_mono`, modelled on the present `τ₃` proofs).
  This is a different, narrower wall than iter-004's, not the same one re-hit.

### Planner's proposed iter-006 objective (for dispatch-sanity)

- **1 file**: `AcyclicResolution.lean` (`[prover-mode: mathlib-build]`). Build `quasiIso_τ₂`
  (the middle-term transfer) modelled on Mathlib's `quasiIso_τ₃`, then assemble straight-line off
  already-proven decls: `ofShortExact_resolvesMiddle` → `ofShortExact` →
  `rightDerivedShiftIsoOfAcyclic` → `rightDerivedIsoOfAcyclicResolution`.

## What I need from you

Verdict (CONVERGING / UNCLEAR / CHURNING / STUCK) for this route, given that the progress metric is
axiom-clean-decls-added + scope-collapse, not sorry reduction. Is the +5 → +27 decl trajectory with a
strictly shrinking, ever-more-precise remaining frontier genuine convergence, or is it the
helper-churn anti-pattern (decls accumulate but the residual never closes)? Flag any dispatch-sanity
issue with the single-file iter-006 proposal.
