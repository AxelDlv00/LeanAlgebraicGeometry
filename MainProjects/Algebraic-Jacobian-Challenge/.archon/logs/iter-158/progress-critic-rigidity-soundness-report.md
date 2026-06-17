# Progress Critic Report

## Slug
rigidity-soundness

## Iteration
158

## Routes audited

### Route: genus-0 / abelian-variety rigidity (route (c)) — `AbelianVarietyRigidity.lean`

- **Sorry trajectory (file)**: 4 → 4 across iter-157 → iter-158. Literally net-zero. BUT the
  unit that moved this iter is *soundness*, not count: at iter-157 `rigidity_core` /
  `rigidity_eqOn_dense_open` were **false as stated** (dropped `_hf`; `f := fst` counterexample),
  so the iter-157 "proof" of `rigidity_lemma` was laundering. This iter's `refactor-thread-hf`
  (build GREEN, 8332 jobs) threaded `_hf` through both, making `rigidity_eqOn_dense_open`
  **true as stated** and `rigidity_core` a **genuine, compiling proof** that consumes it. So the
  *gluing layer* (scheme-level rigidity via `ext_of_isDominant_of_isSeparated'`) and the
  *categorical-algebra layer* (`rigidity_snd_lift`, sorryAx-free; `rigidity_lemma`) are now
  honestly closed — verified by `lean_verify` axiom sets (`rigidity_lemma`/`rigidity_core` =
  `{propext, sorryAx, Classical.choice, Quot.sound}`, sorryAx entering only via the one honest
  sorry).
- **Helper accumulation**: NOT a pile-up. iter-155 skeleton fields (real decomposition); iter-157
  added 3 helpers (`rigidity_snd_lift` proven, `rigidity_core` + `rigidity_eqOn_dense_open`
  unsound); iter-158 added ZERO new helpers — it re-signed the existing two and proved one of
  them. This is the opposite of the "13 helpers, 1 sorry closed" signature.
- **Recurring blockers**: none recurring on the *current* framing. The iter-157 "laundered
  hypothesis / false deferred sorry" blocker was the must-fix and is **resolved** this iter (the
  refactor is exactly the prescribed corrective, verified sound). The two Mathlib bridges feeding
  `rigidity_eqOn_dense_open` (monoidal-`snd`-as-pullback closed-map; affine-constancy via
  `isField_of_universallyClosed`) are **located, not yet assembled** — a forward risk, not yet a
  recurring blocker.
- **Prover status pattern**: 155 PARTIAL → 156 INCOMPLETE → 157 "done"-but-UNSOUND → 158
  refactor-COMPLETE (genuine). Only 1 PARTIAL in the window; not the PARTIAL×3 churn signature.
  iter-157 is best read as a regression-by-error (landed unsound) that iter-158 corrected.
- **Throughput**: ON_SCHEDULE. Strategy estimates "rigidity_lemma 1–2"; the AV-rigidity file
  framing was entered iter-157 and `rigidity_lemma` closed iter-158 — within estimate. The
  estimate now **honestly carries** the cumulative burn ("≈8 elapsed + this"), which directly
  addresses iter-157's throughput-honesty must-fix (the phase clock is no longer silently reset).
- **Verdict**: **CONVERGING** (qualified — see below).
- **Why not the strict letter**: the verbatim CONVERGING rule wants "sorry count strictly
  decreasing," and the file count is 4→4. I am reading the **false→true + gluing-proof-closed**
  conversion as this iter's genuine unit of progress, because it is verifiable closed code
  (build GREEN, axiom-clean modulo the single honest sorry), not a relabel. CHURNING does not
  fire (a real structural change occurred; <3 PARTIAL; the plan-phase-only meta-pattern needs ≥3
  consecutive prover-free iters and only iter-157 was prover-free — iter-158 proposes a prover
  lane, breaking the streak). STUCK does not fire (genuine sorry-elimination of the gluing layer
  occurred). This is "managed, directional progress on the last affordable framing," not churn.

#### Answer to the directive's central question

Re-signing the helpers + the proposed prover lane is **genuine forward motion, NOT the same wall
renamed** — with one precise caveat. The refactor was not cosmetic: it closed the categorical and
gluing layers for good (they will not need redoing) and **isolated the entire residual geometric
content into one true-as-stated sorry** with two concretely-named Mathlib entry points. The wall
has been *relocated and made precise* (`rigidity_eqOn_dense_open`), not yet *breached*. The real
test is the prover lane itself: if it returns PARTIAL/INCOMPLETE because the two bridges must be
**built** rather than **found** (the monoidal-`snd`-as-`Limits.pullback.snd` identification +
`IsClosedMap` transport is flagged as the assembly obstruction), the route flips toward STUCK and
the corrective escalates to a **Mathlib-idiom consult** scoped to exactly those two bridges. Until
then, fire the prover — blocking it now would itself manufacture the plan-phase-only stall
(iter-157 + iter-158 both prover-free → 2 of the 3 needed for the meta-pattern).

- **Hard checkpoint (carried from iter-157, still binding)**: iter-158 MUST fire a prover at the
  geometric heart. The proposal does so; greenlit. If iter-159 is *also* prover-free on this
  route, or the iter-158 lane returns PARTIAL/INCOMPLETE on the bridges, escalate to
  Mathlib-idiom consult before another prover round.

## PROGRESS.md dispatch sanity

- **File count**: 1 (`AbelianVarietyRigidity.lean`), single deep lane — well within cap.
- **Verdict**: OK — 1 file, no fan-out, no iter-over-iter growth.
- **Mis-targeting flag (must-fix, dispatch-level)**: `PROGRESS.md` Objective #1 still reads
  "Fill the body of **`rigidity_lemma` ONLY**" — but the iter-158 `refactor-thread-hf` already
  **closed `rigidity_lemma`** (proof compiles, no sorry). Sending a prover at `rigidity_lemma`
  would no-op / waste the lane. The objective text must be updated to name the actual residual,
  **`rigidity_eqOn_dense_open`** (the prose recipe in Objective #1 already describes exactly that
  declaration's closed-map / affine-constancy content — only the target declaration name is
  stale).

## Must-fix-this-iter

- Dispatch: **stale objective target** — `PROGRESS.md` Objective #1 names `rigidity_lemma` (now
  CLOSED). Retarget the single lane to `rigidity_eqOn_dense_open` before dispatching the prover,
  else the lane is mis-aimed.

## Overall verdict

One critical-path route active; it is **CONVERGING (qualified)**, not churning. iter-158 did the
right thing: it converted iter-157's unsound decomposition into a verified-sound one (build GREEN,
axiom-clean), genuinely closing the categorical and gluing layers and isolating *all* remaining
geometric content into a single now-true sorry, `rigidity_eqOn_dense_open`, with two located
Mathlib bridges. This honors iter-157's must-fix exactly. The planner should: (1) **retarget**
the lane from the already-closed `rigidity_lemma` to `rigidity_eqOn_dense_open`, (2) **fire the
prover** (the iter-157 hard checkpoint demands a prover this iter, and the decomposition is now
well-posed), and (3) hold the fallback: if that lane stalls on the monoidal-`snd`-as-pullback /
affine-constancy bridges, escalate to a Mathlib-idiom consult scoped to those two before any
further prover round. The three sibling sorries (`morphism_P1_to_grpScheme_const`,
`genusZero_curve_iso_P1`, headline) are correctly fenced as honestly-deferred and must NOT be
prover-targeted this iter.
