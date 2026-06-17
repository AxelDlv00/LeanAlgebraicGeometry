# Strategy Critic Report

## Slug
rigidity-activation

## Iteration
155

## Routes audited

### Route: C (M2 critical path — chart-algebra rigidity over `[IsAlgClosed kbar]`)

- **Goal-alignment**: PARTIAL — proves the genus-0 universal property only over an
  algebraically-closed `k̄` **and** only in characteristic 0, but the protected
  signature is `variable {k : Type u} [Field k]` with **no** `[CharZero k]` and
  **no** `[IsAlgClosed k]` (verified in `challenge.lean.ref:42`). Two distinct
  generalisations stand between this route and the protected theorem: (a) the
  `k̄ → k` descent (flagged, see below), and (b) char-0 → char-p. The char-p step
  is buried as a one-line open question ("char-p parked", "Frobenius-iteration
  patch not yet scaffolded") rather than a phase row, yet it is mandatory: KDM
  carries `[CharZero k]`, so the entire chart-algebra "df=0 ⟹ constant" chain is
  char-0-only. **If every row of the Phases table is completed exactly as
  written, the protected genus-0 universal property is still open in positive
  characteristic.** A roadmap whose phases don't sum to the goal is a real
  goal-alignment gap, not an "open question."
- **Mathematical soundness**: PARTIAL — the route's *load-bearing input* is
  unresolved by the strategy's own admission. The closed chart-algebra envelope
  (KDM + `constants` + `df_zero_factors`) supplies only "`df = 0` ⟹ `f`
  constant" — the **downstream half** of the rigidity bridge. Producing `df = 0`
  for `f : C → A` requires piece (i) (Ω_{A/k} trivialised by invariant
  differentials) + the genus-0 vanishing `H^0(ℙ¹, Ω) = 0`. Piece (i) was
  **descoped** during the chart-algebra pivot, and the strategy now (Open
  Question 1) cannot say which of "(1) re-introduce piece (i)" or "(2) chart-
  algebra route to df=0 directly" it will take. Until that is decided, the
  `rigidity_over_kbar` "2–4 iters / 150–400 LOC" estimate has no basis: it
  budgets the assembly of an argument whose principal premise is not yet known
  to be obtainable.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags. The chart-algebra
  envelope is framed as the critical accomplishment ("DONE", row "retained one
  iter for context"), but it is the *back* half of the bridge; the actual
  blocker (piece (i) / df=0 production) was descoped to *get* to that envelope
  and only resurfaces now.
- **Phantom prerequisites**: none assumed for active work — the descent and the
  df=0 input are honestly flagged as gaps, not assumed. `FormallySmooth.of_perfectField`
  (KDM, closed) verified.
- **Effort honesty**: under-counted — the `rigidity_over_kbar` row's LOC/iters
  presupposes a resolved df=0 route; with piece (i) re-introduction unscoped and
  char-p unscoped, the true remaining cost on the critical path is larger than
  the table shows.
- **Verdict**: CHALLENGE

### Route: A (M3 off-critical-path — Picard scheme via FGA)

- **Goal-alignment**: PARTIAL — `positiveGenusWitness` returns a `JacobianWitness C`
  whose `isAlbaneseFor : ∀ P, IsAlbanese C P J` field (verified `Jacobian.lean:174,219`)
  is, for a *pointed positive-genus* curve, the genuine Albanese **universal
  property** (every `f : C → A` with `f(P)=0` factors uniquely through `Pic⁰`).
  This is non-vacuous and is a substantial theorem *beyond* representability. The
  ~5100 LOC budget is itemised entirely as **object** construction (Quot/Hilbert
  representability, identity-component subgroup scheme, fppf/étale sheafification,
  flattening) — the Abel-Jacobi universal property is not enumerated. Either it
  is silently folded in (then the estimate is under-counted) or it is missing
  from the roadmap (then the goal is not covered for pointed `g ≥ 1`).
- **Mathematical soundness**: PASS — FGA Quot/Hilbert → `th:main` → `Pic⁰` is the
  standard construction; the Kleiman re-scope reasoning is coherent.
- **Effort honesty**: under-counted — see goal-alignment; the universal-property
  theorem is not visible in the 5100-LOC line items, and full Quot/Hilbert
  representability in current Mathlib is itself an optimistic 5100.
- **Verdict**: CHALLENGE (lower urgency — off-critical-path, but the missing
  positive-genus Albanese universal property is goal-required, not optional).

## Format compliance

- **Size**: 197 lines / 13280 bytes — **over budget** (13280 > ~12 KB / 12288). Lines within the 250 budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — verbatim: "**(NEW iter-155, load-bearing)**", "iter-154 review carry-forward #1", "KDM closed iter-154 (axiom-clean)", "Closed sub-pieces are summarised in the iter sidecars", "row retained one iter for context; drop next edit". This is the **same live finding from iter-152** (format DRIFTED / per-iter narrative) — it has not been cleaned.
- **Accumulation detected**: yes — the "Chart-algebra ring/chart envelope" phase row is `DONE` and self-admittedly retained ("row retained one iter for context; drop next edit"). Drop it this iter.
- **Table discipline**: PASS structurally. Minor: the LOC velocity figure carries `· new` / `· gated` / `· gated-on-blueprint` instead of a realized `/it` number on the active rows — a minor discipline gap.
- **Format verdict**: DRIFTED — core skeleton intact, but per-iter narrative (a repeat of the iter-152 live item), the over-byte size, and an admitted-stale accumulation row must be cleaned in-place this iter.

## Alternative routes (suggested)

### Alternative: Re-introduce piece (i) using the *already-built* `cotangentSpaceAtIdentity` infra

- **What it looks like**: Open Question 1 frames re-introducing piece (i) (group-scheme Ω triviality) as fresh, unscoped work. But `Cotangent/GrpObj.lean` already ships the `cotangentSpaceAtIdentity` trio (definition + acceptance lemma + rank lemma) — exactly the invariant-differential / cotangent-at-identity machinery that trivialises `Ω_{A/k}`. Route (1) is therefore closer than the strategy admits: the remaining content is "global invariant differential ↦ pulled-back differential on `C`, which lands in `H^0(C, Ω_C) = 0` (already reached via chart-Čech MV)".
- **Why it might be cheaper or sounder**: it reuses existing in-tree material and gives a *definite* df=0 production rather than the open "(1) or (2)". It also makes the genus-0 vanishing (`H^0(Ω)=0`, already in scope) the only analytic input.
- **What the current strategy may have rejected**: piece (i) was descoped wholesale during the chart-algebra pivot; the strategy appears not to have re-checked that `GrpObj.lean` already supplies its (i.a) component.
- **Severity of the omission**: major — it directly de-risks the load-bearing open question on the critical path.

### Alternative: genus-0 rigidity via "no nonconstant map ℙ¹ → abelian variety" / Albanese-dimension

- **What it looks like**: over `k̄` a pointed genus-0 curve is `≅ ℙ¹`. Instead of the scheme-level `df = dg ⟹ f = g` chart-algebra assembly, prove the universal property from "`Alb(C)` has dimension `= genus = 0`, hence `Alb(C) = Spec k`, hence any map to an abelian variety killing `P` factors through `Spec k` (is constant)", or directly from a rigidity/`no rational curves on abelian varieties` lemma.
- **Why it might be cheaper or sounder**: it could sidestep both the `ext_of_diff_zero` β-chain refinement and the unresolved df=0 production, collapsing two active phase rows.
- **What the current strategy may have rejected**: the Albanese-dimension route arguably routes through Route A's general construction, which the strategy keeps off the genus-0 path deliberately; the "no rational curves" lemma may not exist in Mathlib. Worth a brief explicit rebuttal rather than silence.
- **Severity of the omission**: minor-to-major — at minimum the planner should record why the chart-algebra scheme-assembly is preferred over a rigidity-lemma route now that df=0 is the binding constraint.

## Sunk-cost flags

- `Chart-algebra ring/chart envelope ... **DONE** ... — (row retained one iter for context; drop next edit)` and the Route C framing that treats the KDM/`constants`/`df_zero_factors` envelope as the critical milestone — Why this is sunk-cost: the envelope is only the "df=0 ⟹ constant" *consumer*; its load-bearing *input* (piece (i)/df=0) was descoped to reach it and is now the binding blocker. Celebrating the envelope as DONE obscures that the critical path's premise is still open. Recommendation: re-rank the remaining critical path by the df=0 production decision, not by the envelope's completion; decide route (1) vs (2) on its merits this iter.

## Prerequisite verification

- `Algebra.FormallySmooth.of_perfectField`: VERIFIED — `Mathlib.RingTheory.Smooth.Field`, signature `[Field L] [Field K] [Algebra K L] [PerfectField K] [Algebra.EssFiniteType K L] : FormallySmooth K L`, exactly as the strategy describes for the (closed) KDM route.

## Must-fix-this-iter

- Route C: CHALLENGE — (1) resolve the df=0-production open question to a
  blueprint-ready decision (route (1) re-introduce piece (i) vs (2) direct
  chart-algebra), not leave it as "(1) or (2)"; the existing `cotangentSpaceAtIdentity`
  trio in `GrpObj.lean` makes route (1) concrete. (2) Promote char-p from a
  parenthetical open question to an explicit phase row (or state a rebuttal in
  `plan.md` for why the protected `[Field k]` goal is being deferred to a later
  milestone) — the current Phases table does not sum to the protected goal in
  positive characteristic.
- Route A: CHALLENGE — state explicitly whether the positive-genus *pointed*
  Albanese universal property (`isAlbaneseFor` for `g ≥ 1`) is inside the ~5100
  LOC budget; if so, itemise it; if not, add it to the roadmap. It is goal-
  required, not vacuous.
- Format: DRIFTED — strip per-iter narrative ("(NEW iter-155...)", "iter-154
  carry-forward #1", "KDM closed iter-154", "summarised in the iter sidecars",
  "retained one iter for context") to `iter/iter-155/plan.md`; drop the DONE
  chart-algebra accumulation row; trim back under ~12 KB. This is the unresolved
  iter-152 live finding — clean it this iter rather than carrying it a fourth time.

## Overall verdict

A fresh mathematician would not approve as-is. The strategy is admirably honest
about its two named gaps (the `k̄ → k` descent and the new df=0 question), and
the `[IsAlgClosed]` pivot is now validated by the closed KDM/constants pieces.
But three material concerns remain. First, the critical path's load-bearing
premise — producing `df = 0` for `f : C → A` — is descoped and undecided, so the
`rigidity_over_kbar` estimates are ungrounded; the good news the strategy missed
is that `GrpObj.lean`'s `cotangentSpaceAtIdentity` infra already makes the
re-introduction route concrete. Second, the protected signature is over an
*arbitrary* `[Field k]`, yet the whole rigidity chain is char-0-and-`k̄`-only and
char-p has no phase — the roadmap as written does not close the protected goal in
positive characteristic. Third, the positive-genus pointed Albanese universal
property is goal-required but absent from Route A's itemised budget. Plus the
iter-152 per-iter-narrative format drift is still live. None of these is a REJECT
— the routes are mathematically sound in their intended regimes — but each is a
must-fix CHALLENGE before the iter's plan is committed.
