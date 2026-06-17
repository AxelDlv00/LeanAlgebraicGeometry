# Progress-Critic Directive — genus-0 rigidity keystone trajectory

## Active route under assessment

**Route (c) AV-rigidity stack — file `AlgebraicJacobian/AbelianVarietyRigidity.lean`.**
The genus-0 keystone. A char-free chain: Rigidity Lemma → `ℙ¹→A` constant → genus-0-curve-to-AV.
The current critical sub-target is the geometric heart `rigidity_eqOn_dense_open`.

This is the ONLY route receiving prover work right now. (Route A / FGA representability is
blueprinted but no prover lane; genus-0 downstream wiring is gated.)

## Last 5 iters — extracted signals (this route only)

| iter | global sorry | route action | prover status | helpers added | recurring blocker phrase |
|---|---|---|---|---|---|
| 154 | 3 | (old differential/chart route) `rigidity_over_kbar` — never closed | — | 0 | "df=0 irreducibly global-sections" |
| 155 | 3 | df=0 refuted; ChartAlgebraS3 deleted (7→3) | — | 0 | "keystone never closed" |
| 156 | 3 | PIVOT to route (c); object trivial `Spec k` | n/a (no lane) | 0 | "route decided, not yet built" |
| 157 | 3→7 | scaffold `AbelianVarietyRigidity.lean` (4 sorries); `rigidity_lemma` landed UNSOUND (dropped `_hf`) | done (over-claimed) | `rigidity_snd_lift` | "false-as-stated, laundered" |
| 158 | 7 | `refactor thread-hf` made chain SOUND; prover on `rigidity_eqOn_dense_open` → PARTIAL | done (PARTIAL) | `snd_left_isClosedMap` (bridge 1, axiom-clean) | "bridges must be BUILT not FOUND" |

Concrete iter-158 outcome: of the geometric heart's residual, **bridge 1 (closed-map) was BUILT
and is axiom-clean**; TWO residual sorries remain inside `rigidity_eqOn_dense_open`:
- `hfib` — fibre of `pullback.snd` over a k̄-rational point = section image (needs a BUILT lemma; Mathlib `carrierEquiv`/`Triplet` located but no off-the-shelf result).
- the agreement equation — relative "proper-into-affine is constant" / Stein-factorization as a scheme-morphism equality (described by the prover as "the hardest residual input of the chain"; shared with Route A's Albanese UP).

Soundness note: the iter-157 UNSOUND-keystone must-fix was CLOSED iter-158 (`_hf` threaded + consumed; verified axiom-clean by two independent review subagents). So the chain is now honest; the question is convergence depth, not soundness.

## Strategy's current estimate for this route (verbatim from STRATEGY.md `## Phases & estimations`)

- Phase: **genus-0 rigidity (route (c))**. Iters left: "cube-dominated: rigidity_lemma 1–2; full arm ~10–18 (cumulative keystone ≈8 elapsed + this)". LOC: "~2500–5000 · 0/it".
- The phase entered its current form (route-(c) pivot) at iter-156; the new file landed iter-157. So ~3 iters elapsed in the current file, ~9 cumulative on the genus-0 keystone across both framings.

## This iter's PROPOSED plan (for your dispatch-sanity check)

Per the iter-158 binding fallback (which YOU bound: "if the lane returns PARTIAL because the
bridges must be BUILT not FOUND, escalate to a mathlib-analogist consult scoped to the two bridges
BEFORE another prover round"), this iter I am dispatching **two scoped mathlib-analogist consults**
(one per residual bridge) and NO blind prover round on `rigidity_eqOn_dense_open`. A prover lane
fires this iter ONLY if a consult returns a concretely portable Mathlib technique that I can
blueprint + clear a scoped re-review on, same-iter.

Files proposed for `## Current Objectives` this iter: possibly **0** (consult-only iter), or at
most **1** (`AbelianVarietyRigidity.lean`, scoped to one bridge sub-lemma the consult makes
buildable + the stale-docstring cleanup the review flagged).

## What I need from you

1. Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) for the genus-0 rigidity route,
   with explicit reasoning about whether iter-158 (bridge 1 built + chain made sound) constitutes
   genuine forward motion or churn.
2. Is the analogist-consult-then-maybe-prover plan the right corrective, or do you see a deeper
   issue (e.g. the two residual bridges are themselves multi-iter sub-builds that warrant a
   different decomposition, or a route-level concern given ~9 cumulative keystone iters)?
3. Any dispatch-sanity flag on the proposed (near-zero) prover load this iter.
