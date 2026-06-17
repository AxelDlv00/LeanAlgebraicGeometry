# Progress Critic Directive

## Slug
iter113

## Iter
113

## Active routes / files under review

### Route: `AlgebraicJacobian/Differentials.lean` — Phase B opening on L122 / helper #1

- **Started at iter**: 110 (blueprint-prep), 112 (first prover dispatch)
- **Iters audited**: 110, 111, 112

#### Sorry counts per iter (file-level Differentials.lean)
- iter-110: 5 (no prover lane; blueprint-prep iter)
- iter-111: 5 (no prover lane; blueprint-prep iter; `\thm:relative_kaehler_isSheaf` proof block rewritten)
- iter-112: 5 → 5 (PARTIAL, Bar B; L122 sorry moved to new helper #1 at L177)

#### Helpers added per iter
- iter-110: 0 (blueprint-only)
- iter-111: 0 (blueprint-only)
- iter-112: **2 helpers added** — `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` (load-bearing, sorry-body, L159) + `relativeDifferentialsPresheaf_isSheaf_type` (derived, fully closed, L188); main theorem body fully closed via Step 1 + delegation

#### Prover statuses
- iter-110: N/A (no prover dispatched)
- iter-111: N/A (no prover dispatched)
- iter-112: **PARTIAL (Bar B acceptable)** — Route (a) chosen; ≥2 named sub-lemmas instantiated; main body closed; residual sorry isolated in helper #1

#### Recurring blocker phrases
- "basis-to-opens descent" (the `[gap]` flagged in `Differentials.tex` L50; not a Mathlib gap per se but expensive sub-lemma work)
- "Step 2 affine identification + Step 3 cofinality refinement" (the iter-113+ closeout shape; ~100–200 LOC total)
- "no off-the-shelf sheaf-on-affine-basis-of-Scheme ⇒ sheaf lemma in Mathlib for `Scheme.PresheafOfModules`" (confirmed iter-111 / iter-112)

#### Iter-113 plan-agent intent on this route
Dispatch a prover lane on **closing helper #1** (Bar A target — file
sorry 5 → 4). Concrete sub-lemma decomposition documented in iter-112
prover report:

- Sub-lemma A: affine restriction of the type-valued presheaf to the
  tilde quasi-coherent sheaf via `KaehlerDifferential.isLocalizedModule_map`
  + `IsAffineOpen.isLocalization_basicOpen` (~40–80 LOC).
- Sub-lemma B: sheaf-on-affine-basis ⇒ sheaf via the cofinality of the
  affine-basis refinement in `OpensLeCover` against
  `isSheaf_iff_isSheafOpensLeCover` (~50–100 LOC).

Combined ~100–200 LOC — fits a single iter's prover budget per the
revised iter-111 LOC estimate.

### Route: 3-signature-mismatch refactor on `Differentials.lean`

- **Started at iter**: 113 (new this iter — iter-112 reviewer surfaced
  pre-existing must-fix mismatches that were never caught by prior
  reviewers because no prover lane on those targets had been opened
  yet)
- **Iters audited**: 113 only (fresh)

#### Pre-existing mismatches (latent, surfaced iter-112 review)
- `smooth_iff_locally_free_omega` (L816): Lean uses dimension-free
  `Smooth f` + free `n : ℕ`; blueprint says `IsSmoothOfRelativeDimension n f`.
  The biconditional as written is structurally unsatisfiable.
- `cotangent_at_section` (L832): identical mismatch (uses
  `(hsmooth : Smooth f)` + free `(n : ℕ)`).
- `serre_duality_genus` (L976): Lean states `H^0(O_C) = H^0(Ω_{C/k})`;
  blueprint asserts `H^0(Ω_{C/k}) = H^1(O_C)`. Mathematically false for
  genus > 1.

This is **NOT** a helper-churn route — it's a fresh refactor dispatch.
Asking you to render a verdict on whether this refactor is the right
move, or whether the plan agent should hold off (e.g. because the
mismatches are off-limits anyway pending later Phase B work).

#### Iter-113 plan-agent intent on this route
Dispatch the `refactor` subagent to align all 3 signatures with the
blueprint prose (re-insert `sorry` on the new statements; no proof
work). Project sorry count unchanged (3 sorries before, 3 sorries
after, just with corrected statements).

## Decision needed

For each route render a verdict (CONVERGING / CHURNING / STUCK /
UNCLEAR). For helper #1, the prior K-iter signal is mostly
blueprint-prep + 1 PARTIAL Bar-B prover round, so UNCLEAR-trending-
CONVERGING is likely correct — but you may flag CHURNING if the
"2 helpers added per iter without closure" pattern looks like it could
recur.

For the refactor route, render whether dispatching the refactor this
iter is sound or whether to defer (e.g. parallel with the prover lane
on helper #1, which would conflict for write access on the same Lean
file).

The plan agent's working assumption is:

1. Refactor subagent runs during plan phase (re-typing the 3 mismatched
   signatures, sorry-bodied).
2. Prover lane runs in prover phase, on the post-refactor file, focused
   on helper #1 closure (independent of the refactored signatures since
   helper #1 is in a different declaration block at L159 ≪ L816).

The two operations are file-internal but operate on disjoint declaration
ranges (L159 vs L816–L982). They should not conflict if sequenced
plan-phase → prover-phase.
