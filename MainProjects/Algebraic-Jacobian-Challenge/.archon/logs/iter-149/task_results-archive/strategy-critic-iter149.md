# Strategy Critic Report

## Slug
iter149

## Iteration
149

## Routes audited

### Route: Route C (M2 critical path) — chart-algebra piece (ii)

- **Goal-alignment**: PASS — closes the `df = 0` derivation chain that
  feeds `rigidity_over_kbar` → `genusZeroWitness` → the genus-stratified
  body of `nonempty_jacobianWitness`. Routing is mechanically right.
- **Mathematical soundness**: PARTIAL — the substep-3 dichotomy is
  sound at the math level (smooth ⇒ geometrically reduced ⇒ Γ separable
  over `k`; geom-irr proper ⇒ residue field purely inseparable; sep ∧
  pi ⇒ trivial), and the chart-Čech-MV computation is a valid stand-in
  for "the cohomological content of Serre duality." But the references
  index itself (line 8 of `references/summary.md`) carries the iter-149
  literature cross-check finding that **path (b)'s "bypass flat base
  change entirely" framing slightly under-states the Mathlib work,
  because the (S3.π.1) content is the *same* content as path (a) step
  (e) just re-packaged**. STRATEGY.md still says verbatim "bypass flat
  base change entirely via..." (line 60–61). Until the framing is
  corrected, the (b) commitment rests on a soundness illusion.
- **Sunk-cost reasoning detected**: no — the merit-based block at
  lines 73–86 is genuinely merit-based (chart-Čech MV is a one-time
  investment that pays for itself across both M2.a and M2.b).
- **Phantom prerequisites**: `Differential.ContainConstants` EXISTS,
  but it lives in `Mathlib.RingTheory.Derivation.DifferentialRing` —
  the differential-algebra (Picard–Vessiot / Liouville) framework,
  *not* the Kähler-differential framework. The typeclass is parameterised
  by `[Differential B]`, an abstract derivation `B → B`, **not** by
  the universal Kähler derivation `D : B → Ω[B⁄A]`. The strategy's
  phrase "char-0 path via `Differential.ContainConstants` typeclass
  bridge (~80–150 LOC)" papers over a non-trivial bridge: someone
  must pick a derivation `B → B` per chart, package it as a `Differential`
  instance, prove `ContainConstants`, *and* translate `D x = 0` (Kähler)
  to `x' = 0` (Picard–Vessiot). The 80–150 LOC estimate looks
  optimistic for that translation layer.
- **Effort honesty**: under-counted on three axes —
  (i) substep 3 path (b) estimate `~150–250 LOC` should widen toward
  the path (a) figure now that the literature cross-check says the
  flat-base-change content is the same;
  (ii) the `Differential.ContainConstants` bridge (above);
  (iii) the cumulative envelope (see Format / Effort Honesty section
  below) — `342 LOC` landed (line 119) is stale; per the directive
  the actual landed figure is **419 LOC** at iter-148 close, so
  `419 + 400–1000 remaining = 819–1419` cumulative, with the upper
  bound **crossing the 1200-LOC rolling trigger**. Either the upper
  bound on remaining LOC must drop to ≤ 781, or the trigger fires
  conditionally.
- **Verdict**: CHALLENGE

### Route: Route A (M3 off-critical-path) — Picard scheme via FGA

- **Goal-alignment**: PASS — Picard scheme + identity-component
  subgroup scheme + Stein factorisation is the textbook construction
  of the Jacobian; matches the protected `Jacobian` signature.
- **Mathematical soundness**: PASS — Hilbert/Quot representability +
  étale/fppf sheafification + Grothendieck flattening is the FGA
  recipe. No mathematical surprises.
- **Sunk-cost reasoning detected**: no — Route A is justified on
  merit ("Route B's GIT-quotient... is no closer to existence than
  Hilbert/Quot... Route A's Hilbert/Quot infrastructure has cross-
  utility").
- **Phantom prerequisites**: none surfaced; the LOC midpoint is
  delegated to `analogies/m3-route-a-refresh-iter145.md` which I do
  not have visibility into here. The aggregate ~6070 LOC figure is
  *plausible* for a from-scratch FGA construction.
- **Effort honesty**: reasonable — 50–80 iters left + ~6070 LOC for
  a full Hilbert/Quot + identity-component construction is honest by
  the standards of large pure-Mathlib-build sub-projects. The lower
  bound (50) may be ambitious, but it is not absurd.
- **Verdict**: SOUND

### Route: Alternative — over-$\bar k$ + Galois descent

- **Goal-alignment**: PASS — base-change to $\bar k$, descend to $k$,
  is a standard technique and would close M2.a for genus-0 specifically.
- **Mathematical soundness**: PASS — genus-0 curves over $\bar k$ are
  isomorphic to $\mathbb{P}^1_{\bar k}$ and rigidity for $\mathbb{P}^1_{\bar k}$
  → group scheme is a much smaller fact than the chart-algebra
  envelope. Sound to hold in reserve.
- **Sunk-cost reasoning detected**: no — Route C is *not* defended on
  "we have already invested in chart-algebra"; instead Route C is
  defended on "chart-Čech MV is structurally a one-time investment
  that pays for itself across the M2.a + M2.b chain" (line 113–115),
  which is a forward-looking merit claim.
- **Phantom prerequisites**: "fpqc-descent-of-morphisms infrastructure"
  is named as missing and "would have to be built up alongside this
  route." This is correctly flagged as a cost, not a phantom.
- **Effort honesty**: reasonable — the rolling-trigger threshold (1200
  LOC cumulative chart-algebra) is the right kind of pre-committed
  re-evaluation. But the 1200 figure is in tension with the actual
  current 419 + upper-bound 1000 remaining = 1419 trajectory (see
  Route C above). The planner should reconcile.
- **Verdict**: SOUND in concept, but trigger-arithmetic depends on
  Route C honesty fixes.

## Format compliance

- **Size**: 206 lines / 11960 bytes — within budget.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`,
  `## Open strategic questions`, `## Mathlib gaps & new material`,
  in canonical order. No extra top-level sections.
- **Per-iter narrative detected**: yes — three distinct re-emergences,
  in different phrasing than the iter-148 phrases the planner absorbed:
  - line 46: *"Eventual case-split body. Iter-148+ targets char-0 first."*
  - line 50–51: *"Per iter-148 mathlib-analogist + strategy-critic
    audit, this is a genuine Mathlib infrastructure gap"*
  - line 155–156: *"(no proper-Γ-flat-base-change in upstream; ... —
    per iter-148 mathlib-analogist)"*
  These are exactly the pattern iter-148 challenged: per-iter
  attribution leaks into the document. The planner's earlier absorption
  was lexical, not structural; the same pattern grew back in different
  words. The phrase "next strategic checkpoint" (lines 125, 134) is
  the *correct* abstraction and should be applied uniformly.
- **Accumulation detected**: no — Route B is mentioned briefly in
  line 95–106 as a merit-comparator, not as an excised route still
  taking space. "Closed sub-pieces are summarised in the iter
  sidecar" (line 38) is the right discipline.
- **Table discipline**: PASS — `## Phases & estimations` is a proper
  Markdown table with Phase | Status | Iters left | LOC | Key Mathlib
  needs | Risks columns; cells are short. Row 1's "iters left 4–7"
  flags a separate concern (see "Effort honesty / row 1" below) but
  not a table-shape violation.
- **Appendix sections**: none.
- **Format verdict**: DRIFTED — per-iter narrative crept back in
  different phrasing; the planner must do a *structural* sweep this
  iter (write "the prior strategic-critic audit" or "the prior mathlib-
  analogist verdict" — i.e. drop the iter tag), not another lexical
  one. Lift the same fix to the `Open strategic questions` block: the
  Mathlib-gap & New-material sections currently absorb the same
  per-iter attribution. Use STRATEGY.md to say *what is true now*,
  not *when it became true*.

## Effort honesty / row 1 (Chart-algebra envelope)

Row 1: *iters left 4–7* with status *3 closed, 1 partial, 1 open*.

- Phase elapsed: iter-145 → iter-148 = 4 iters.
- Iter-148 closed neither remaining sorry. Iter-148 *did* land a
  framework decomposition of the consolidated `IsPurelyInseparable ∧
  Algebra.IsSeparable` claim into 4 named sub-claims — that is
  decomposition progress, not closure progress.
- The 4–7 *iters left* range was set against a remaining envelope
  that the iter-148 mathlib-analogist independently confirmed is a
  genuine Mathlib gap (no proper-Γ-flat-base-change; no `IsBaseChange`
  namespace; no `R^iπ_*`). The references-index literature cross-check
  (line 8 of `references/summary.md`) sharpened this further: path
  (b)'s framing under-states the work.
- Net: 4 iters elapsed with **decomposition-only** progress, against
  a hard Mathlib-gap envelope that just grew (literature cross-check).
  The 4–7 range is at the **optimistic end** of honest. A widening
  to **5–9** would match the gap-depth evidence; staying at 4–7
  requires explicit justification of why iter-149's prover lane is
  expected to close at least one sorry.

## Sunk-cost flags

None detected. The strategy's merit-based justifications for Route C
(lines 73–86) and Route A (lines 99–107) are forward-looking, not
"we already invested in X so we keep going." This was a real
improvement from iter-148.

## Prerequisite verification

- `KaehlerDifferential.D`: VERIFIED (Mathlib has the universal D).
- `Algebra.IsStandardSmooth.free_kaehlerDifferential`: VERIFIED —
  `Mathlib.RingTheory.Smooth.StandardSmoothCotangent`.
- `RingHom.iterateFrobenius_comm`: VERIFIED —
  `Mathlib.Algebra.CharP.Frobenius`.
- `Algebra.IsGeometricallyReduced`: VERIFIED —
  `Mathlib.RingTheory.Nilpotent.GeometricallyReduced`; comes with
  `Algebra.isReduced_of_isGeometricallyReduced` for the smooth ⇒
  geom-reduced direction (which is what path (b) needs).
- `Differential.ContainConstants`: EXISTS but in the **differential-
  algebra (Picard–Vessiot)** framework
  (`Mathlib.RingTheory.Derivation.DifferentialRing`), parameterised by
  an abstract derivation `B → B` not by the Kähler derivation
  `B → Ω[B⁄A]`. The "bridge" from KDM to `ContainConstants` is
  non-trivial and the 80–150 LOC estimate is likely under-counted.
  Treat this as a **soft phantom** — the name exists but the implied
  typeclass-bridge is project-built infra, not Mathlib infra.
- `Algebra.H1Cotangent` + `Subsingleton (Algebra.H1Cotangent A B)`:
  VERIFIED — `Mathlib.RingTheory.Extension.Cotangent.Basic` +
  `Algebra.FormallySmooth.subsingleton_h1Cotangent`.
- `Scheme.Over.ext_of_eqOnOpen`: in-tree (named in
  `Rigidity.lean` per the strategy and the blueprint summary). Not a
  Mathlib name; project-internal closure.
- `AlgebraicGeometry.IsBaseChange` / `R^iπ_* for proper π`: confirmed
  MISSING by the strategy itself; no contradiction.

## Alternative routes (suggested)

### Alternative: Substep 3 via **Mathlib's `Algebra.FormallySmooth.subsingleton_h1Cotangent` + abstract module-of-derivations argument**

- **What it looks like**: instead of proving `Γ(X, O_X) ≅ k` directly,
  prove the equivalent statement that for a smooth proper geom-irr
  `X/k`, the module of `k`-derivations `Der_k(Γ, Γ)` is zero, then
  use that to close the rigidity step without ever needing the
  `Γ ≅ k` identification. Mathlib already has the smooth ⇒ projective
  Ω and `Subsingleton H1Cotangent` infrastructure, so a derivation-
  based reformulation may bypass the `Γ` identification entirely.
- **Why it might be cheaper or sounder**: the chain "smooth ⇒
  formally smooth ⇒ Subsingleton H1Cotangent" is already in Mathlib
  end-to-end. Re-routing the rigidity argument to consume the
  H1Cotangent vanishing directly (rather than the constants-extraction
  consequence) skips the full `Γ ≅ k` rigamarole.
- **What the current strategy may have rejected**: unclear from prose
  — STRATEGY.md frames substep 3 as a `Γ ≅ k` problem, which may be
  a leftover framing from the original blueprint chapter rather than
  the **cheapest cotangent-side statement that closes rigidity**.
  Planner should clarify whether the substep-3 statement is the
  load-bearing one or whether a weaker derivation-level statement
  suffices for `rigidity_over_kbar`.
- **Severity of the omission**: major — if the rigidity body can
  consume H1Cotangent vanishing instead of `Γ ≅ k`, the entire
  substep-3 lane (150–500 LOC) could be replaced with a much
  thinner adapter.

### Alternative: Skip path (b) framing; commit to path (a) BUILD with explicit re-packaging

- **What it looks like**: drop the "smart proof bypass" framing
  entirely (now that the literature cross-check says it's the same
  content as (a)) and commit to path (a) BUILD with the geometric-
  reducedness + purely-inseparable apparatus exposed as the
  ergonomic interface on top.
- **Why it might be cheaper or sounder**: (b) was selected on the
  premise that it "bypasses" flat base change. If that premise is
  false (per the literature cross-check), then path (b) is just
  path (a) with worse naming. Calling it path (a) is more honest and
  yields a reusable `proper-Γ-flat-base-change` lemma that downstream
  consumers can hit by name.
- **What the current strategy may have rejected**: nothing
  substantive; the rejection is by inertia (iter-148 commitment).
- **Severity of the omission**: minor in math impact, major in
  honesty — the framing change is mostly cosmetic but stops the
  strategy from carrying a known-mis-stated commitment.

## Must-fix-this-iter

- **Route C: CHALLENGE** — three sub-items:
  1. Reconcile *342 LOC landed* (line 119) with the actual *419 LOC*
     iter-148 close. Decide whether the rolling-trigger envelope
     (line 116–117) stays at "400–1000 remaining" — if so,
     acknowledge that `419 + 1000 = 1419` exceeds the 1200 trigger
     and pre-commit to the trigger-firing branch; or tighten upper
     remaining to ≤ 781.
  2. Update path (b) framing in lines 60–67 to reflect the
     `references/summary.md` line 8 finding ("same content as path
     (a) step (e), just re-packaged"). Either rename the path or
     widen its LOC bracket to overlap with (a).
  3. Disambiguate `Differential.ContainConstants` bridge: name
     explicitly that this requires a project-internal adapter from
     `KaehlerDifferential.D` to a `Differential B` instance, and
     widen the ~80–150 LOC estimate accordingly (or commit to which
     direction of the bridge is built first).
- **Row 1 (Chart-algebra envelope) effort honesty: CHALLENGE** —
  iters-left bracket 4–7 should widen to 5–9 given iter-148's
  decomposition-only progress and the literature cross-check's gap-
  depth confirmation. Alternatively: write one explicit sentence on
  why iter-149's prover lane should close ≥1 sorry to keep the
  4–7 honest.
- **Format DRIFT: CHALLENGE** — three per-iter narrative phrases re-
  emerged in different words (lines 46, 50–51, 155–156). Apply a
  structural sweep, not a lexical one: any "per iter-NNN <agent>"
  becomes "per the prior <agent> audit" (no iter tag).
- **Alternative — substep-3-via-H1Cotangent-vanishing: major** —
  planner should clarify whether substep 3's `Γ ≅ k` framing is
  load-bearing for `rigidity_over_kbar`, or whether a derivation-
  level / H1Cotangent-level statement suffices. If the latter,
  substep 3's whole envelope could shrink.

## Overall verdict

A fresh mathematician would say: **the strategic content is mostly
sound, but the document is materially under-committed on three
specifics** — (i) the LOC envelope is internally inconsistent now
that iter-148's 419-LOC close-figure crosses the 1200 trigger at its
upper bound, (ii) path (b)'s "bypass" framing was de-credited by the
project's own literature cross-check and STRATEGY.md still carries
the de-credited framing verbatim, and (iii) per-iter narrative
attribution grew back in three places after iter-148 absorbed the
prior version. Routes A and the Alternative are sound to hold as
stated. Route C is sound in *destination* but the *path (b)
commitment*, the *envelope arithmetic*, and the `Differential.
ContainConstants` *typeclass bridge* are each one fixable misalignment
short of being honest. The planner must address all three this iter
either by patching STRATEGY.md in place or by writing an explicit
rebuttal in `iter/iter-149/plan.md`. No REJECT verdicts; nothing
fundamentally broken.
